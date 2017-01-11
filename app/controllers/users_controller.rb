class UsersController < ApplicationController

  post '/users' do
      @user = User.new(params[:user])
      if @user.save
        session[:user_id] = @user.id
        flash[:message] = "You have successfully created an account.  Here is you new collection page.  You can now add movies to your collection."
        redirect "/users/#{@user.slug}/movies"
      else
        flash[:message] = "Failed to signup new user."
        redirect "/users/new"
      end
    # end
  end

  get '/users/new' do
    logged_in? ? (redirect "/users/#{current_user.slug}/movies") : (erb :'users/new')
  end


end
