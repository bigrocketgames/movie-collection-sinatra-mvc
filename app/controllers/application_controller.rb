require 'rack-flash'

class ApplicationController < Sinatra::Base

  configure do
    enable :sessions
    use Rack::Flash
    set :session_secret, "secret"
    set :views, 'app/views'
  end

  get '/' do
    @logged = logged_in?
    @user = current_user if @logged
    erb :'index'
  end

  post '/' do
    @user = User.new(params[:user])
    if @user.save
      session[:user_id] = @user.id
      redirect "/user/#{@user.slug}/collection"
    else
      flash[:message] = "Failed to signup new user.  Please make sure all fields are filled in."
      redirect "/signup"
    end
  end

  get '/signup' do
    logged_in? ? (redirect "/user/#{current_user.slug}/collection") : (erb :'new')
  end

  get '/login' do
    erb :'login'
  end

  post '/login' do
    @user = User.find_by(username: params[:username])
    if @user && @user.authenticate(params[:password])
      session[:user_id] = @user.id
      redirect "/user/#{@user.slug}/collection"
    else
      flash[:message] = "Invalid username/password.  Please try again."
      redirect '/login'
    end
  end

  get '/logout' do
    session.clear
    redirect '/'
  end

  helpers do
    def logged_in?
      !!session[:user_id]
    end

    def current_user
      @current_user ||= User.find(session[:user_id]) if session[:user_id]
    end
  end

end
