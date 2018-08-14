require "sinatra"
require "sinatra/activerecord"
require 'sinatra/flash'
require './models/post.rb'
require './models/user.rb'

enable :sessions
set :database, {adapter:"postgresql", database:"rumblr"}

get "/" do


    if session[:user_id]
        @user = User.find_by(id: session[:user_id])
        @user_posts= Post.where(user_id: session[:user_id])
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
    session[:user_id] = nil;
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
    firstname: params[:firstname],
    lastname: params[:lastname],
    birthday: params[:birthday],
    email: params[:email]
    )

    session[:user_id] = @user.id

    flash[:info] = "Thank you for signing up!"

    redirect '/'
end


get "/create-post" do
 erb :create_post
end


post "/create-post" do
@user = User.find_by(id: session[:user_id])

 @post = Post.create(
     date: params[:date],
     title: params[:title],
     photo_url: params[:photourl],
     content: params[:content],
      user_id: @user.id
 )
#  @user_posts= Post.where(user_id: session[:user_id])

end


get'/user/:id' do

 @user_posts= Post.where(user_id: session[:user_id])

 erb :user_posts

end

get'/posts' do
    @allposts = Post.all

    erb :all_posts
end


def get_current_user 
    User.find(session[:user_id])
end

def get_specific_post(id)
    Post.find(id)
end
#also delete posts

