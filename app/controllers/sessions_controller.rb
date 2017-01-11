class SessionsController < ApplicationController

  get '/login' do
    if logged_in?
      redirect "/"
    else
      erb :'sessions/login'
    end
  end

  post '/login' do
    @user = User.find_by(username: params[:username])
    if @user && @user.authenticate(params[:password])
      session[:user_id] = @user.id
      redirect "/users/#{@user.slug}/movies"
    else
      flash[:message] = "Invalid username/password.  Please try again."
      redirect '/login'
    end
  end

  get '/logout' do
    session.clear
    redirect '/'
  end

end
