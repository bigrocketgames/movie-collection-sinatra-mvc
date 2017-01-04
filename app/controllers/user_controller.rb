class UserController < ApplicationController

  post '/user' do
    @user_found = User.find_by(username: params[:user][:username]) ? true : false
    binding.pry
    if @user_found
      flash[:message] = "This username already exists.  Please select a new one."
      redirect back
    else
      @user = User.new(params[:user])
      if @user.save
        session[:user_id] = @user.id
        flash[:message] = "You have successfully created an account.  Here is you new collection page.  You can now add movies to your collection."
        redirect "/user/#{@user.slug}/collection"
      else
        flash[:message] = "Failed to signup new user.  Please make sure all fields are filled in."
        redirect "/user/new"
      end
    end
  end

  get '/user/new' do
    logged_in? ? (redirect "/user/#{current_user.slug}/collection") : (erb :'user/new')
  end

  get '/user/:slug/collection' do
    @logged = logged_in?

    if @logged
      @logged_in_user = current_user
      @user = User.find_by_slug(params[:slug])
      erb :'user/collection'
    else
      flash[:message] = "You can only view collections if you are logged in."
      redirect '/login'
    end
  end

  post '/user/:slug/collection' do
    @movie = current_user.movies.create(params[:movie])
    flash[:message] = "#{@movie.name} successfully added to collection."
    redirect "/user/#{current_user.slug}/collection"
  end

end
