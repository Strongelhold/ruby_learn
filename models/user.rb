class User
  include DataMapper::Resource
  include BCrypt

  property :id,         Serial, :key => true
  property :email,      String, :format => /^[-\w.]+@([A-z0-9][-A-z0-9]+\.)+[A-z]{2,4}$/
  property :password,   BCryptHash
  property :salt,       String
  property :created_at, DateTime
  property :updated_at, DateTime

  has n, :tags, :through => Resource

  validates_presence_of :email

end
