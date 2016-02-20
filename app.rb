require 'rubygems'
require 'data_mapper'
require 'sinatra'
require 'dm-migrations'
require 'dm-timestamps'
require 'digest/sha1'
require 'sinatra/partial'
require 'carrierwave'
require 'carrierwave/datamapper'
require 'rack-flash'
require 'sinatra/redirect_with_flash'
require 'bcrypt'
require 'digest/sha1'
require 'sinatra-authentication'

enable :sessions
use Rack::Flash, :sweep => true
use Rack::Session::Cookie, :secret => 'A1 sauce 1s so good you should use 1t on a11 yr st34ksssss'

set :root, File.join(File.dirname(__FILE__))
set :sinatra_authentication_view_path, Pathname(__FILE__).dirname.expand_path + "views/user"

DataMapper.setup(:default, 'sqlite:db/database.db')

get '/' do
  @sources = Source.all
  output = ""
  output << partial(:_header)
  output << partial(:_messages)
  output << partial(:index)
end

get '/show/:id' do
  @source = Source.get(params['id'])
  output = ""
  output << partial(:_header)
  output << partial(:_messages)
  output << partial(:show) 
end

get '/new' do
  output = ""
  output << partial(:_header)
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

get '/login' do
  output = ""
  output << partial(:_header)
  output << partial(:_messages)
  output << partial(:login)
end

get '/signup' do
  output = ""
  output << partial(:_header)
  output << partial(:_messages)
  output << partial(:signup)
end

get %r{.*/css/style.css} do
  redirect('css/style.css')
end

require_relative 'helpers/app_helper.rb'

# Model classes
require_relative 'models/source.rb'
#require_relative 'models/user.rb'

DataMapper.finalize
#DataMapper.auto_migrate!   #need to reset db
DataMapper.auto_upgrade!

