class UserController < ApplicationController

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
