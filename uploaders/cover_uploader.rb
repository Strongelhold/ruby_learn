class CoverUploader < CarrierWave::Uploader::Base
  include CarrierWave::MiniMagick

  storage :file

  def store_dir
    "images/sources/#{model.id}/"
  end

  version :medium do
    process :resize_to_fit => [200, 200]
  end

  def extension_white_list
    %w(jpg jpeg bmp png gif)
  end
end
