class User
  include DataMapper::Resource
  include BCrypt

  property :id,         Serial, :key => true
  property :email,      String
  property :password,   BCryptHash
  property :salt,       String
  property :created_at, DateTime
  property :updated_at, DateTime

end
