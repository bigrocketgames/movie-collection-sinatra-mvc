class MoviesController < ApplicationController

  get '/movies/:id' do
    @movie = Movie.find(params[:id])
    erb :'movies/show'
  end

  get '/movies/:id/edit' do
    @movie = Movie.find(params[:id])
    if current_user.id == @movie.user_id
      erb :'movies/edit'
    else
      flash[:message] = "You are not authorized to edit movies in others collections."
      redirect back
    end
  end

  patch '/movies/:id/edit' do
    @movie = Movie.find(params[:id])
    @movie.update(params[:movie])
    flash[:message] = "#{@movie.name} has been successfully edited."
    redirect "/users/#{current_user.slug}/movies"
  end

  get '/movies/:id/delete' do
    @movie = Movie.find(params[:id])
    if current_user.id == @movie.user_id
      @movie.destroy
      flash[:message] = "#{@movie.name} successfully removed from collection."
      redirect "/users/#{current_user.slug}/movies"
    else
      flash[:message] = "You are not authorized to edit this collection."
      redirect "/users/#{@movie.user.slug}/movies"
    end
  end


    get '/users/:slug/movies' do
      if logged_in?
        @user = User.find_by_slug(params[:slug])
        erb :'movies/index'
      else
        flash[:message] = "You can only view collections if you are logged in."
        redirect '/login'
      end
    end

    post '/users/:slug/movies' do
      @movie = current_user.movies.create(params[:movie])
      flash[:message] = "#{@movie.name} successfully added to collection."
      redirect "/users/#{current_user.slug}/movies"
    end

end
