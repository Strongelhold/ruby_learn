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

enable :sessions
use Rack::Flash, :sweep => true

set :root, File.join(File.dirname(__FILE__))

DataMapper.setup(:default, 'sqlite:db/database.db')

get '/' do
  @sources = Source.all
  @user = User.first(email: session[:email])
  output = ""
  output << partial(:_header)
  output << partial(:_messages)
  output << partial(:index)
end

get '/subs' do
  @user = User.first(email: session[:email])
  if login?
    if @user.tags.empty?
      redirect '/subscription', error: "You must add tags"
    else
      @sources = Source.all
      output = ""
      output << partial(:_header)
      output << partial(:_messages)
      output << partial(:user_index)
    end
  end
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
  source = Source.new
  source.name = params[:name]
  source.website = params[:website].downcase
  source.description = params[:description]
  source.image = params[:image]
  if source.save
    source.tag_parser(params[:tags].to_s)
    redirect '/', notice: 'Created successfuly'
  else
    redirect '/new', error: 'Something wrong...'
  end
end

get '/signup' do
  if login?
    redirect '/'
  else
    output = ""
    output << partial(:_header)
    output << partial(:_messages)
    output << partial(:signup)
  end
end

post '/signup' do
  password_salt = BCrypt::Engine.generate_salt
  if params[:password].size < 5
    flash[:error] = "Password to short"
    redirect '/signup'
  else
    password_hash = BCrypt::Engine.hash_secret(params[:password], password_salt)
  end

  user = User.new
  user.email = params['email'].downcase
  user.salt = password_salt
  user.password = password_hash
  if user.save
    session[:email] = params[:email]
    redirect '/', notice: "Signup successfuly!"
  else
    redirect '/signup', error: "Something wrong..."
  end
end

get '/login' do
  if login?
    redirect '/'
  else
    output = ""
    output << partial(:_header)
    output << partial(:_messages)
    output << partial(:login)
  end
end

post '/login' do
  user = User.first(email: params[:email])

  if user.nil?
    redirect '/login', error: "We don't know about this email"
  else
    if user.password.to_s == BCrypt::Engine.hash_secret(params[:password], user.salt).to_s
      session[:email] = params[:email]
      redirect '/', notice: "Logged in successfuly"
    else
      redirect '/login', error: "Password not correct"
    end
  end
end

get '/subscription' do
  if login?
    output = ""
    output << partial(:_header)
    output << partial(:_messages)
    output << partial(:subscription)
  else
    redirect '/'
  end
end

post '/subscription' do
  if login?
    user = User.first(email: session[:email])
    tags = params[:tags].to_s.split(',')
    tags.each do |tag|
      user.tags << TagHelper.exist_or_create(tag)
    end
    if user.save
      redirect '/subs', notice: "Successufuly saved!"
    else
      redirect '/subscription', error: "Something wrong..."
    end
  else
    redirect '/'
  end
end

get '/logout' do
  session[:email] = nil
  redirect '/', notice: "Exit was successfull"
end

get %r{.*/css/style.css} do
  redirect('css/style.css')
end

#Helpers
require_relative 'helpers/user_helper.rb'
require_relative 'helpers/tag_helper.rb'

# Model classes
require_relative 'models/source.rb'
require_relative 'models/user.rb'
require_relative 'models/tag.rb'

DataMapper.finalize
#DataMapper.auto_migrate!   #need to reset db
DataMapper.auto_upgrade!

