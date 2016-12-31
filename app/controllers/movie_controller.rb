class MovieController < ApplicationController

  get '/movie/:slug' do
    @movie = Movie.find_by_slug(params[:slug])
    erb :'movie/single'
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

end
