require "sinatra"
require "sinatra/activerecord"
require "sinatra/flash"
require './models/post.rb'
require './models/user.rb'

enable :sessions
set :database, {adapter:"postgresql", database:"rumblr"}

get "/" do
   erb :home
end

get "/sign-in" do
end

get "/sign-up" do
    erb :sign_up
end

# post "/signup" do
#     User.create (
    #     t.string :username
    #   t.string :password
    #   t.string :name
    #   t.string :lastname
    #   t.date :birthday
    #   t.string :email

    # username: params[:username],
    # password: params[:password];
    # name: params[:name]
    # )
# end