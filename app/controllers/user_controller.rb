class UserController < ApplicationController

  get '/user/:slug/collection' do
    @logged = logged_in?

    if @logged
      @logged_in_user = current_user
      @user = User.find_by_slug(params[:slug])
      erb :'user/collection'
    else
      redirect '/login'
    end
  end

  post '/user/:slug/collection' do
    @movie = Movie.create(name: params[:movie][:name], summary: params[:movie][:summary], user_id: session[:user_id])
    flash[:message] = "Movie successfully added to collection."
    redirect "/user/#{current_user.slug}/collection"
  end

end
