require "sinatra"
require "sinatra/activerecord"
# require 'sinatra/flash'
require './models/post.rb'
require './models/user.rb'

enable :sessions
set :database, {adapter:"postgresql", database:"rumblr"}

get "/" do

    if session[:user_id]
        @user = User.find_by(id: session[:user_id])
        #below is getting only users posts
        # @user_posts= Post.where(user_id: session[:user_id]).order('id ASC').reorder('date DESC')
        @user_posts= Post.where(user_id: session[:user_id]).order("created_at")
        @allposts = Post.where('user_id != ?', session[:user_id])
        @allusers = User.all
        @random_user = User.order('RANDOM()').limit(4)
      
        
        erb :signed_in_homepage
    else
        erb :signed_out_homepage, :layout=> :signout_layout
       
    end

end


# sign in

get "/sign-in" do
    erb :sign_in, :layout=> :signout_layout
end


post "/sign-in" do
    @user = User.find_by(username: params[:username])
    if @user && @user.password == params[:password]
        session[:user_id]= @user.id

        redirect'/'
    else 
        redirect'/sign-in'
    end
end

# logout

get "/sign-out" do
    session[:user_id] = nil;
    # flash[:info] = "You have been signed out"
    redirect '/'
end






#sign up

get "/sign-up" do
    erb :sign_up, :layout=> :signout_layout
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

    # flash[:info] = "Thank you for signing up!"

    redirect '/'
end




get "/create-post" do
    @random_user = User.order('RANDOM()').limit(4)
    @user = User.find_by(id: session[:user_id])
 erb :create_post
end


post "/create-post" do
@random_user = User.order('RANDOM()').limit(4)
@user = User.find_by(id: session[:user_id])
@user_posts = @user.posts.order('id ASC').reorder('date DESC')
# @user = User.find_by(id: session[:user_id])
#below is getting only users posts
#  @user_posts= Post.where(user_id: session[:user_id]).order('id ASC').reorder('date DESC')
# @user_posts= Post.where(user_id: session[:user_id]).order('created_at DESC')
@current_post = @post


@allusers = User.all

 @post = Post.create(
     date: params[:date],
     title: params[:title],
     photo_url: params[:photourl],
     content: params[:content],
      user_id: @user.id
 )

#  @user_posts= Post.where(user_id: session[:user_id])
redirect"/post/#{@post.id}"

end




# GET POSTS BY ID
get'/user/:id' do
    @user = User.find_by(id: session[:user_id])
    @current_user = User.find(params[:id])
    @current_user_posts = @current_user.posts
    @user_posts = @current_user.posts.order('id ASC').reorder('date DESC')
    @allusers = User.all
    @random_user = User.order('RANDOM()').limit(4)
#  @user_posts= Post.where(user_id: session[:user_id])

erb :user_posts
end


# GET ALL POSTS
get'/posts' do
    @user = User.find_by(id: session[:user_id])
    #below shows all other peoples posts
    @allposts = Post.where('user_id != ?', session[:user_id]).order('id ASC').reorder('date DESC')
    @random_user = User.order('RANDOM()').limit(4)
   
    erb :all_posts
end


get '/post/:id' do
    @current_post = Post.find(params[:id])
    @user = User.find_by(id: session[:user_id])
    @random_user = User.order('RANDOM()').limit(4)
  
   erb :view_post
  
end

#EDIT THE POSTS

get '/posts/:id/edit' do
    @current_post = Post.find(params[:id])
    erb :edit_post
end


put '/posts/:id' do
    @current_post = Post.find(params[:id])
    @current_post.update(date: params[:date],
    title: params[:title],
    photo_url: params[:photourl],
    content: params[:content])
    

   erb :view_edited
  
end

delete '/posts/:id' do
    @current_post = Post.find(params[:id])
    @current_post.destroy
    redirect '/'
end