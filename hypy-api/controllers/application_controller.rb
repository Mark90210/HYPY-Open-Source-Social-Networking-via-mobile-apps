require 'sinatra'
require 'sinatra/flash'

get '/' do
	redirect to '/docs'
end

get '/docs' do
	content_type 'text/html'
	markdown :'../README'
end

post '/session' do
  user = Admin.authenticate(params[:email], params[:password])
  
  if !user.authorized
    flash[:error] = "Wrong email or password"
    redirect to '/login'  
  end 
  session[:user] = user[:id]
  redirect to '/dashboard'
    
end

get '/session/logout' do
  session[:user] = nil

  redirect to '/admin'
end

get '/login' do
  content_type 'text/html'

  redirect to '/admin' if current_user.access_level >= Admin.access_level

  haml :login, layout: :login_layout
end
get '/settings' do
  content_type 'text/html'

  redirect to '/login' unless session[:user]
  splash_setting = AppSetting.find_by(name: 'splash_image')
  eul_setting = AppSetting.find_by(name: 'eul')
  haml :settings,  locals: { user: current_user, splash_setting: splash_setting, eul_setting: eul_setting } 
end

post '/settings/:user_id' do
  redirect to '/login' unless session[:user]
  if params["file"].present? 
    splash_image = AppSetting.find_by(name: 'splash_image')
    if splash_image.present?
      splash_image.update! params
      flash[:success] = 'Splash image updated successfully'
    else
      AppSetting.create(name: 'splash_image', value: params["file"])
      flash[:success] = 'Splash image added successfully'
    end
  end
  if params["eul_file"].present?
    if File.extname(params["eul_file"]["filename"]).include?(".pdf")
      eul_pdf = AppSetting.find_by(name: 'eul')
      if eul_pdf.present?
        eul_pdf.update! params
        flash[:success] = 'EULA Document updated successfully'
      else
        AppSetting.create(name: 'eul', value: params["eul_file"])
        flash[:success] = 'EULA Document added successfully'
      end
    else
      flash[:error] = "EULA file must be pdf"
    end
  end  
  
  redirect to '/settings'
end

get '/policy.html' do
	content_type 'text/html'

	File.read('policy.html')
end
