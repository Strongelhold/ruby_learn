class Tag
  include DataMapper::Resource

  property :id,   Serial
  property :name, String, :unique => true

  has n, :sources, :through => Resource
  has n, :users,   :through => Resource

  validates_presence_of :name
end
