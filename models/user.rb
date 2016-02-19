class User
  include DataMapper::Resource

  property :id, Serial
  property :email, String
  property :password_digest, String
  property :created_at, DateTime
  property :updated_at, DateTime
end
