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
      output = File.absolute_path(f).gsub(/assets\/images/, 'assets/thumbnail/')
      if force || !File.exist?(output)
        create_thumbnail(File.absolute_path(f), output)
      end
    end
  end

  def create_thumbnail(source_path, output_path)
    source = MiniMagick::Image.open(source_path)
    source.auto_orient

    background = source.clone
    background.resize "#{THUMBNAIL_WIDTH}x#{THUMBNAIL_HEIGHT}^"
    background.gravity "center"
    background.extent "#{THUMBNAIL_WIDTH}x#{THUMBNAIL_HEIGHT}"
    background.blur "0x12"

    foreground = source.clone
    foreground.resize "#{THUMBNAIL_WIDTH}x#{THUMBNAIL_HEIGHT}>"

    result = background.composite(foreground) do |composite|
      composite.gravity "center"
    end

    result.strip
    result.write output_path
  end
end
