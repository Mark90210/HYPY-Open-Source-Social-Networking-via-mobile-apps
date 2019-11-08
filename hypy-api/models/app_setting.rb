class AppSetting < ActiveRecord::Base
  include S3_Uploader
  include Image_Resizer

  @@keys = [
    :name,
    :value
  ]

  def self.create params
    app = super() do |user|
      @@keys.each do |key|
        user[key] = params[key] if params.has_key?(key.to_s) || params.has_key?(key)
      end
    end
    app.value = app.upload_file params[:value]
    app.save
  end

  def update! params
    if params["file"].present?
      self.value = self.upload_file params["file"]
    else
      self.value = self.upload_file params["eul_file"]  
    end
    self.save
  end


end