require "mini_magick"

THUMBNAIL_WIDTH = 800
THUMBNAIL_HEIGHT = 420

namespace :thumbnail do
  desc 'assets/images にある画像のサムネイルを作る'
  task :create do
    force = ENV["FORCE"] == "1"

    Dir.glob('./assets/images/**/').each do |f|
      outdir = File.absolute_path(f).gsub(/assets\/images/, 'assets/thumbnail/')
      FileUtils.mkdir_p(outdir) unless FileTest.exist?(outdir)
    end

    file_pattern = ['./assets/images/**/*.png', './assets/images/**/*.jpg', './assets/images/**/*.jpeg', './assets/images/**/*.PNG', './assets/images/**/*.JPG', './assets/images/**/*.JPEG']

    Dir.glob(file_pattern).each do |f|
      source_path = File.absolute_path(f)
      output = thumbnail_output_path(source_path)

      if force || !File.exist?(output)
        create_thumbnail(source_path, output)
      end
    end
  end

  def create_thumbnail(source_path, output_path)
    original = MiniMagick::Image.open(source_path)
    original.auto_orient

    thumbnail = original.clone
    thumbnail.resize "#{THUMBNAIL_WIDTH}x#{THUMBNAIL_HEIGHT}>"

    thumbnail.combine_options do |config|
      config.background transparent_background?(output_path) ? "none" : "white"
      config.gravity "center"
      config.extent "#{THUMBNAIL_WIDTH}x#{THUMBNAIL_HEIGHT}"
    end

    thumbnail.strip
    thumbnail.write output_path
  end

  def thumbnail_output_path(source_path)
    source_output_path(source_path)
  end

  def source_output_path(source_path)
    source_path.gsub(/assets\/images/, 'assets/thumbnail/')
  end

  def transparent_background?(output_path)
    File.extname(output_path).downcase == ".png"
  end
end
