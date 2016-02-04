require 'rubygems'
require 'data_mapper'
require 'sinatra'
require 'dm-migrations'
require 'dm-timestamps'

DataMapper.setup(:default, 'sqlite:db/database.db')

get '/' do
  "Hello, World!" 
end

get '/home' do
  @R = Source.all
  erb :show 
end

# Model classes
require_relative 'models/source.rb'

DataMapper.finalize
DataMapper.auto_upgrade!

#@R = Res.all
#@res = Source.new(:name => "Olo22", :website => "weeeeeebsite", :description => "desc")
#@res.save
#@res2 = Res.create(:name => "Aga", :website => "weeeeeeby", :description => "olo")
#@res3 = Res.create(:name => "Aga2", :website => "weeeeeeby2", :description => "olo2")
# @res3.save
#@res = Res.new(:name => "Abdula", :website => "Web", :description => "descript")
#@res.save
#Res.all.save
