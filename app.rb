require 'rubygems'
require 'data_mapper'
require 'sinatra'
require 'dm-migrations'
require 'dm-timestamps'
require 'sinatra/partial'
require 'carrierwave'
require 'carrierwave/datamapper'
require 'rack-flash'
require 'sinatra/redirect_with_flash'

enable :sessions
use Rack::Flash#, :sweep => true

set :root, File.join(File.dirname(__FILE__))

DataMapper.setup(:default, 'sqlite:db/database.db')

get '/' do
 "Hello, World!"
 if Source.any?
   flash.now[:notice] = 'Sources are existing!'
 end
end

get '/home' do
  @sources = Source.all
  output = ""
  output << partial(:_messages)
  output << partial(:show) 
end
get '/new' do
  output = ""
  output << partial(:_messages)
  output << partial(:new)
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
    redirect '/home', notice: 'Created successfuly'
  else
    redirect '/new', error: 'Something wrong...'
  end
end

# Model classes
require_relative 'models/source.rb'

DataMapper.finalize
#DataMapper.auto_migrate!   #need to reset db
DataMapper.auto_upgrade!

