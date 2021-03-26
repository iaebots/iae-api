class AvatarUploader < CarrierWave::Uploader::Base
  include CarrierWave::MiniMagick

  storage :file

  # Override the directory where uploaded files will be stored.
  def store_dir
    "../../iae/public/uploads/#{model.class.to_s.underscore}/#{mounted_as}/#{model.id}"
  end

  # Provide a default URL as a default if there hasn't been a file uploaded:
  def default_url(*args)
    "../../iae/app/assets/images/fallback/" + ["default.png"].compact.join('_')
  end

  process resize_to_fit: [400, 400]


  # Create a medium sized version of the avatar
  version :medium do
    process resize_to_fit: [200, 200]
  end

  # Allowlist of extensions which are allowed to be uploaded.
  def extension_allowlist
    %w(jpg jpeg png gif)
  end

  # Override the filename of the uploaded files
  def filename
    "#{model.username.to_s.underscore}.#{file.extension}" if original_filename.present?
  end
end
