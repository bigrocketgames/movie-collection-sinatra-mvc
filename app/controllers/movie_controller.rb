class MovieController < ApplicationController

  get '/movie/:id' do
    @logged = logged_in?
    @user = current_user if @logged
    @movie = Movie.find(params[:id])
    erb :'movie/single'
  end

  get '/movie/:id/edit' do
    @logged = logged_in?
    @user = current_user if @logged
    @movie = Movie.find(params[:id])
    if current_user.id == @movie.user_id
      erb :'movie/edit'
    else
      flash[:message] = "You are not authorized to edit movies in others collections."
      redirect back
    end
  end

  patch '/movie/:id/edit' do
    @movie = Movie.find(params[:id])
    @movie.update(params[:movie])
    flash[:message] = "#{@movie.name} has been successfully edited."
    redirect "/user/#{current_user.slug}/collection"
  end

  get '/movie/:id/delete' do
    @movie = Movie.find(params[:id])
    if current_user.id == @movie.user_id
      @movie.destroy
      flash[:message] = "#{@movie.name} successfully removed from collection."
      redirect "/user/#{current_user.slug}/collection"
    else
      flash[:message] = "You are not authorized to edit this collection."
      redirect "/user/#{@movie.user.slug}/collection"
    end
  end

end
