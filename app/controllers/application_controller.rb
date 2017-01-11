require 'rack-flash'

class ApplicationController < Sinatra::Base

  configure do
    enable :sessions
    use Rack::Flash
    set :session_secret, "secret"
    set :views, 'app/views'
  end

  get '/' do
    erb :'index'
  end

  helpers do
    def logged_in?
      !!current_user
    end

    def current_user
      @current_user ||= User.find(session[:user_id]) if session[:user_id]
    end
  end

end
