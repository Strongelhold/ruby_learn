require_relative '../uploaders/cover_uploader.rb'

class Source
  include DataMapper::Resource

  property :id, Serial
  property :name, String
  property :website, String, required: true, format: /^\w*\.(([a-z]{2,3}$)|([a-z]{2,3}\.[a-z]{2,3}))/ #don't know how to delete underscore from \w
  property :description, String
  property :created_at, DateTime
  property :updated_at, DateTime
  property :image, String, :auto_validation => false
  mount_uploader :image, CoverUploader
end
