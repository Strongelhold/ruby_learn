module TagHelper
  def self.exist_or_create(name)
    if Tag.first(name: name).nil?
      return tag = Tag.create(name: name)
    else
      return tag = Tag.first(name: name)
    end
  end
end

helpers TagHelper
