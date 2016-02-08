require 'rubygems'
require 'data_mapper'
require 'sinatra'
require 'dm-migrations'
require 'dm-timestamps'
require 'sinatra/partial'
require 'carrierwave'
require 'carrierwave/datamapper'

set :root, File.join(File.dirname(__FILE__))

DataMapper.setup(:default, 'sqlite:db/database.db')

get '/' do
 "Hello, World!"
end

get '/home' do
  @R = Source.all
  output = ""
  output << partial(:show) 
end
get '/new' do
  haml :new
end
post '/new' do
  s = Source.new
  s.name = params[:name]
  s.website = params[:website].downcase
  s.description = params[:description]
  s.created_at = Time.now
  s.updated_at = Time.now
  s.image = params[:image]
  if s.save
    redirect '/home'
  else
    redirect '/new'
  end
end

# Model classes
require_relative 'models/source.rb'

DataMapper.finalize
#DataMapper.auto_migrate!   #need to reset db
DataMapper.auto_upgrade!

#@R = Res.all
#@res = Source.create(:name => "Olo22", :website => "www.google.com", :description => "desc")
#@res2 = Source.create(:name => "Aga", :website => "weeeeeeby", :description => "olo")
#@res3 = Res.create(:name => "Aga2", :website => "weeeeeeby2", :description => "olo2")
# @res3.save
#@res = Res.new(:name => "Abdula", :website => "Web", :description => "descript")
#@res.save
#Res.all.save
