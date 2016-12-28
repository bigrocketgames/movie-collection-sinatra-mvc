require 'rack-flash'

class ApplicationController < Sinatra::Base
  # register Sinatra::ActiveRecordExtension
    enable :sessions
    use Rack::Flash
    set :session_secret, "secret"
    set :views, 'app/views'

  get '/' do
    erb :'index'
  end

  post '/' do
    @user = User.new(params[:user])
    if @user.save
      session[:user_id] = @user.id
      redirect '/collection'
    else
      flash[:message] = "Failed to signup new user.  Please make sure all fields are filled in."
      redirect "/signup"
    end
  end

  get '/signup' do
    erb :'new'
  end

  get '/login' do
    erb :'login'
  end

  post '/login' do
    @user = User.find_by(username: params[:username])
    if @user && @user.authenticate(params[:password])
      session[:user_id] = @user.id
      redirect '/collection'
    else
      flash[:message] = "Invalid username/password.  Please try again."
      redirect '/login'
    end
  end

  get '/collection' do
    if logged_in?
      @user = current_user
      erb :'collection'
    else
      redirect '/login'
    end
  end

  post '/collection' do
    @movie = Movie.create(name: params[:movie][:name], summary: params[:movie][:summary], user_id: session[:user_id])
    redirect '/collection'
  end

  get '/movie/:id' do

  end

  helpers do
    def logged_in?
      !!session[:user_id]
    end

    def current_user
      User.find(session[:user_id])
    end
  end

end
