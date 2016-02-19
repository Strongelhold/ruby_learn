class User
  include DataMapper::Resource
  include BCrypt

  property :id, Serial, :key => true
  property :email, String
  property :password, BCryptHash
  property :created_at, DateTime
  property :updated_at, DateTime

  def authenticate(attempted_password)
    if self.password == attempted_password
      true
    else
      false
    end
  end

end
