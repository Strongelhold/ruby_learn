require_relative '../uploaders/cover_uploader.rb'

class Source
  include DataMapper::Resource
  #include Paperclip::Resource

  property :id, Serial
  property :name, String
  property :website, String
  property :description, String
  property :created_at, DateTime
  property :updated_at, DateTime
  property :image, String, :auto_validation => false
  mount_uploader :image, CoverUploader
  #has_attached_file :cover,
  #                  :path => "#{:root}/public/Images/:attachment/:id/:style/:basename.:extension",
   #                 :url => "/Images/:attachment/:id/:style/:basename.:extension",
   #                 :styles => { :medium => "300x300",
   #                              :thumb => "100x100" }
end
