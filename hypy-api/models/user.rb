class User < ActiveRecord::Base
  include S3_Uploader
  include Image_Resizer

  has_many :comments, dependent: :destroy
  has_many :likes, dependent: :destroy
  has_many :photo_flags, dependent: :destroy
  has_many :photos, dependent: :destroy

  @@keys = [
    :first_name,
    :last_name,
    :bio,
    :email,
    :device_identifier
  ]

  @access_level = 1
  @type = :user

  def authorized
    true
  end

  def check_active
    self.is_active
  end

  def access_level
    self.class.access_level
  end

  def self.access_level
    @access_level
  end

  def self.find_by_token token
    return DummyUser.new if token == 'abctest123'
  
    users = self.where token: token
    return NoUser.new unless users.length > 0

    return users.first
  end

  def self.find_by_phone phone
    phone_number = PhoneNumber.new phone
    return false unless phone_number.is_valid?

    users = self.where phone: phone_number.to_s
    return false unless users.length > 0

    return users.first
  end

  def self.authenticate identifier, password
    user = self.where('phone = ? or email = ?', identifier, identifier).first

    return user if user && user.test_password(password)

    return NoUser.new
  end

  def self.create params
    user = super() do |user|
      @@keys.each do |key|
        user[key] = params[key] if params.has_key?(key.to_s) || params.has_key?(key)
      end
    end
    user.set_phone(params[:phone]) if params.has_key?('phone')
    user.set_password params[:password] if params.has_key?('password')
    user.set_token self.generate_token
    user.set_verification_code self.generate_verification_code
    if params.has_key?('photo')
      file = params[:photo]
      self.profile_image = self.upload_file file 
    end
    user.save
    user
  end

  def self.hash_password password, salt
    Digest::SHA2.hexdigest [password, salt].join
  end

  def self.generate_token
    Digest::SHA2.hexdigest [Time.now, rand].join
  end

  def self.generate_salt
    self.generate_token[0..16]
  end

  def self.generate_verification_code
    [rand(10), rand(10), rand(10), rand(10), rand(10), rand(10)].join
  end

  def self.type
    @type
  end


  def name
    [first_name, last_name].join ' '
  end

  def as_json(options = {})
    json = {
      id: id,
      first_name: first_name,
      last_name: last_name,
      bio: bio,
      email: email,
      phone: phone,
      profile_image: profile_image,
      created_at: created_at,
      device_identifier: device_identifier
    }
    json[:id] = id if options[:include_id]
    json
  end 

  def update! params
    @@keys.each do |key|
      self[key] = params[key] if params.has_key?(key.to_s) || params.has_key?(key)
    end
    set_password params[:password] if params.has_key?('password') || params.has_key?(:password)

    if params.has_key?('photo')
      file = params[:photo]
      self.profile_image = self.upload_file file 
    end
    self.save
    self
  end

  def confirm!
    self.confirmed = true
    self.save
  end

  def type
    self.class.type
  end

  def set_token token
    self[:token] = token
  end

  def set_verification_code verification_code
    self[:verification_code] = verification_code
  end

  def set_phone phone
    # self[:phone] = Messenger.normalize_phone_number phone
    self[:phone] = phone
  end

  def set_password password
    salt = User.generate_salt
    self[:salt] = salt
    self[:password_hash] = User.hash_password password, salt
  end

  def test_password password
    self.password_hash && self.class.hash_password(password, self.salt) == self.password_hash
  end

  def send_verification_code
    messenger = Messenger.new self.phone
    messenger.message = 'Welcome to Perspective, your verification code is '+self.verification_code.to_s
    messenger.send
  end

end

class NoUser < User
  @access_level = 0
  
  def authorized
    false
  end
end

class DummyUser < User
  @access_level = 0
  
  def authorized
    false
  end

  def as_json(options = {})
    json = {
      first_name: 'Dummy',
      last_name: 'User',
      bio: 'I am not a real user',
      email: 'address@example.com',
      phone: '555 123 4567',
      profile_image: nil,
      created_at: nil
    }
    json[:id] = '0' if options[:include_id]
    json
  end  
end