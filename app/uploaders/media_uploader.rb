class MediaUploader < CarrierWave::Uploader::Base
  # include CarrierWave::MiniMagick

  storage :file

  # Override the directory where uploaded files will be stored.
  def store_dir
    "../../iae/public/uploads/#{model.class.to_s.underscore}/#{mounted_as}/#{model.id}"
  end

  # Add an allowlist of extensions which are allowed to be uploaded.
  def extension_allowlist
    %w(jpg jpeg gif png mp4 mkv)
  end

  # Override the filename of the uploaded files.
  def filename
    "#{model.id}.#{file.extension}" if original_filename.present?
  end
end
