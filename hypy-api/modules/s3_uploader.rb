module S3_Uploader
  # AWS bucket setup
  @@bucket_name = ENV['AWS_BUCKET']
  
  def upload_file input
    file_name = generate_file_name input
    s3 = get_s3_service()
    # create new resource file
    s3_new = Aws::S3::Resource.new(region: ENV['AWS_REGION'])
    bucket = s3_new.bucket(@@bucket_name)
    obj = bucket.object(file_name)

    # handle image orientation before upload
    puts "Upload=" + input[:tempfile].path
    if ['.jpg','.jpeg'].include?(File.extname(input[:tempfile].path).downcase)
      file_ext = File.extname(input[:tempfile].path)
      tmp_file = Tempfile.new("MyFile.jpg")
      puts tmp_file.path
      puts file_ext

      image = MiniMagick::Image.open(input[:tempfile].path)
      puts "EXIF:Orientation=" + image["EXIF:Orientation"]

      image.auto_orient
      image.write tmp_file
      tmp_file.close

      #upload the file:
      obj.put(
        acl: "public-read",
        body: tmp_file
        )
    else
      #upload the file:
      obj.put(
        acl: "public-read",
        body: input[:tempfile]
        )     
    end

    # send public URL of file
    obj.public_url
  end

  def self.upload_thumb input_thumb, file_name
    s3_1 = S3_Uploader.get_s3_service_thumb()
    # create new resource file
    s3_new1 = Aws::S3::Resource.new(region: ENV['AWS_REGION'])
    bucket = s3_new1.bucket(@@bucket_name)
    # obj = bucket.object(input)
    obj = bucket.object(file_name)
    obj.put(
      acl: "public-read",
      body: input_thumb
      )
    # send public URL of file
    obj.public_url
  end

  def get_s3_service
    require 'aws-sdk'

    Aws.config.update({
      region: ENV['AWS_REGION'],
      credentials: Aws::Credentials.new(ENV['AWS_IAM_KEY'], ENV['AWS_IAM_SECRET'])
    })
    
    Aws::S3::Client.new
  end

  def self.get_s3_service_thumb
    require 'aws-sdk'

    Aws.config.update({
      region: ENV['AWS_REGION'],
      credentials: Aws::Credentials.new(ENV['AWS_IAM_KEY'], ENV['AWS_IAM_SECRET'])
    })
    
    Aws::S3::Client.new
  end

  def generate_s3_link file_name
    ['https://s3.amazonaws.com', @@bucket_name, file_name].join '/'
  end
  
  def generate_file_name file
    extension = File.extname(file[:filename]).downcase
    hash = Digest::SHA2.hexdigest [Time.now, rand].join
    [hash, extension].join
  end
  
  def type_to_extension type
    map = {
      'image/jpeg; charset=binary' => 'jpg',
      'image/png; charset=binary' => 'png'
    }
    map[type]
  end

end
