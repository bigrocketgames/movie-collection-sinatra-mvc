require 'rack-flash'

class ApplicationController < Sinatra::Base
  # register Sinatra::ActiveRecordExtension
    enable :sessions
    use Rack::Flash
    set :session_secret, "secret"
    set :views, 'app/views'

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

  get '/user/:slug/collection' do
    if logged_in?
      @user = User.find_by_slug(params[:slug])
      erb :'collection'
    else
      redirect '/login'
    end
  end

  post '/user/:slug/collection' do
    @movie = Movie.create(name: params[:movie][:name], summary: params[:movie][:summary], user_id: session[:user_id])
    flash[:message] = "Movie successfully added to collection."
    redirect "/user/#{current_user.slug}/collection"
  end

  get '/movie/:slug' do
    @movie = Movie.find_by_slug(params[:slug])
    erb :'single'
  end

  get '/movie/:slug/delete' do
    @movie = Movie.find_by_slug(params[:slug])
    if current_user.id == @movie.user_id
      @movie.destroy
      flash[:message] = "Movie successfully removed from collection."
      redirect "/user/#{current_user.slug}/collection"
    else
      flash[:message] = "You are not authorized to edit this collection."
      redirect "/user/#{@movie.user.slug}/collection"
    end
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
