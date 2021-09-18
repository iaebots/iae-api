# frozen_string_literal: true

require 'image_processing/mini_magick'

# MediaUploader is a polymorphic uploader that accpets images and videos
class MediaUploader < Shrine
  Shrine.plugin :restore_cached_data

  # Contants with permitted image and video mime types
  IMAGE_TYPES = %w[image/jpeg image/png image/webp image/gif].freeze
  VIDEO_TYPES = %w[video/mp4].freeze

  plugin :determine_mime_type, analyzer: :marcel
  plugin :validation_helpers
  plugin :remove_invalid # remove invalid cached files
  plugin :store_dimensions
  plugin :remove_attachment

  Attacher.validate do
    validate_mime_type IMAGE_TYPES + VIDEO_TYPES

    if IMAGE_TYPES.include?(file.mime_type)
      validate_min_size 1 * 1024 # 1 KB
      validate_max_size 15 * 1024 * 1024 # 15MB
      validate_max_dimensions [5000, 5000]
    elsif VIDEO_TYPES.include?(file.mime_type)
      validate_max_size 5.megabytes # max video size
    end
  end

  Attacher.derivatives do |original|
    process_derivatives(:image, original) if IMAGE_TYPES.include?(file.mime_type)
  end

  Attacher.derivatives :image do |original|
    magick = ImageProcessing::MiniMagick.source(original)

    {
      desktop: magick.resize_to_limit!(1200, 670)
    }
  end
end
