require "sinatra"
require "sinatra/activerecord"
require 'sinatra/flash'
require './models/post.rb'
require './models/user.rb'

enable :sessions
set :database, {adapter:"postgresql", database:"rumblr"}

get "/" do

    if session[:user_id]
        erb :signed_in_homepage
    else
        erb :signed_out_homepage
    end

end


# sign in

get "/sign-in" do
    erb :sign_in
end


post "/sign-in" do
    @user = User.find_by(username: params[:username])

    if @user && @user.password == params[:password]
        session[:user_id]= @user.id

        flash[:info] = "You have been signed in."
        redirect'/'
    else 

        flash[:warning] = "username or password is incorrect"
        redirect'/sign-in'
    end
end

# logout

get "/sign-out" do
    session[:use-id] = nil;
    flash[:info] = "You have been signed out"
    redirect '/'
end






#sign up

get "/sign-up" do
    erb :sign_up
end


post "/sign-up" do
    @user = User.create(
    username: params[:username],
    password: params[:password],
    firstname: params[:first-name],
    lastname: params[:last-name],
    birthday: params[:birthday],
    email: params[:email]
    )

    session[:user_id] = @user.id

    flash[:info] = "Thank you for signing up!"
end
