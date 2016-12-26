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
    
    redirect '/collection'
  end

  get '/signup' do
    erb :'new'
  end

  get '/login' do

  end

  get '/collection' do

  end

  post '/collection' do

    redirect '/collection'
  end

  get '/movie/:id' do

  end

end
