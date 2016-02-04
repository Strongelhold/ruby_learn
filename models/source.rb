class Source
  include DataMapper::Resource

  property :id, Serial
  property :name, String
  property :website, String
  property :description, String
  property :created_at, DateTime
  property :updated_at, DateTime
end
