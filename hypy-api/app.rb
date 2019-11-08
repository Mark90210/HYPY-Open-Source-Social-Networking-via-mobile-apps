$:.unshift __FILE__, '.'

require 'sinatra'
require 'sinatra/activerecord'
require 'kramdown'
require 'haml'
require 'dimensions'
require 'dotenv'
require 'tempfile'
Dotenv.load

require "better_errors"
require 'streamio-ffmpeg'

configure :development do
  use BetterErrors::Middleware
  BetterErrors.application_root = __dir__
end

require_relative 'helpers/application_helpers.rb'

require_relative 'modules/s3_uploader.rb'
require_relative 'modules/api_resource.rb'
require_relative 'modules/find_or_create.rb'
require_relative 'modules/image_resizer.rb'

require_relative 'models/acl.rb'
  
require_relative 'models/messenger.rb'
require_relative 'models/phone_number.rb'
require_relative 'models/log.rb'
require_relative 'models/user.rb'
require_relative 'models/admin.rb'
require_relative 'models/invitation.rb'
require_relative 'models/like.rb'
require_relative 'models/comment.rb'
require_relative 'models/comment_flag.rb'
require_relative 'models/photo.rb'
require_relative 'models/photo_flag.rb'
require_relative 'models/gallery.rb'
require_relative 'models/gallery_photo_collection.rb'
require_relative 'models/sponsor.rb'
require_relative 'models/app_setting.rb'

require_relative 'controllers/application_controller.rb'
require_relative 'controllers/admin_controller.rb'
require_relative 'controllers/events_controller.rb'
require_relative 'controllers/user_controller.rb'
require_relative 'controllers/invitation_controller.rb'
require_relative 'controllers/photo_controller.rb'
require_relative 'controllers/gallery_controller.rb'

class Perspective < Sinatra::Application

  enable :sessions
  set :sessions, secret: ENV['SECRET']

  helpers ApplicationHelpers

  register Sinatra::ActiveRecordExtension
  if self.development?
    set :database_file, 'config/database.yml'
  else
    puts 'DB URL:', ENV['DATABASE_URL']
    puts ActiveRecord::Base.establish_connection(ENV['DATABASE_URL'])
  end

  set :root, File.dirname(__FILE__)
  set :views, File.expand_path('views')

  before do
    content_type 'application/json'
  end
  
end
