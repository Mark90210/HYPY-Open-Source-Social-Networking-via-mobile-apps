class Admin < User

  @access_level = 3
  
  def name
    [first_name, last_name].join ' '
  end

  def self.create params
    user = super(params) do |user|
      params.each do |(key, val)|
        user[key] = params[key]
      end
    end
    user.is_admin = true
    user.set_password params[:password]
    user.save
    user
  end

end