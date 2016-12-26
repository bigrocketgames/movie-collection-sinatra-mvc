class ApplicationController < Sinatra::Base
  # register Sinatra::ActiveRecordExtension

  configure do
    enable :sessions
    set :session_secret, "secret"
    set :views, 'app/views'
  end

  get '/' do
    erb :'index'
  end

  post '/' do
    @user = User.new(params[:user])
    @user.save ? (redirect '/collection') : (redirect '/signup')
  end

  get '/signup' do
    erb :'new'
  end

  get '/login' do

  end

  get '/collection' do
    puts "we are in the collection"
  end

  post '/collection' do

    redirect '/collection'
  end

  get '/movie/:id' do

  end

end
