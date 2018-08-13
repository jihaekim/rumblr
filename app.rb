require "sinatra"
require "sinatra/activerecord"
require "sinatra/flash"
require './models/post.rb'
require './models/user.rb'
set :database, {adapter:"postgresql", database:"rumblr"}
