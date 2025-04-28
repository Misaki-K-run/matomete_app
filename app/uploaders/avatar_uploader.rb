class AvatarUploader < CarrierWave::Uploader::Base
  include CarrierWave::MiniMagick

  # Choose what kind of storage to use for this uploader:
  # storage :file

  # aws s3
  storage :fog

  def store_dir
    "uploads/#{model.class.to_s.underscore}/#{mounted_as}/#{model.id}"
  end

  def default_url
    "user-icon.png"
  end

  process convert: :webp
  process resize_to_fill: [ 100, 100 ]

  def extension_allowlist
    %w[jpg jpeg gif png webp]
  end

  # WebP 形式に変換した際、ファイル名の拡張子も変更する
  def filename
    super.chomp(File.extname(super)) + ".webp" if original_filename.present?
  end
end
