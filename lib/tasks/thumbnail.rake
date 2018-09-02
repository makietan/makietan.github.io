require "mini_magick"

namespace :thumbnail do
  desc 'assets/images にある画像のサムネイルを作る'
  task :create do
    Dir.glob('./assets/images/**/').each do |f|
      outdir = File.absolute_path(f).gsub(/assets\/images/, 'assets/thumbnail/')
      FileUtils.mkdir_p(outdir) unless FileTest.exist?(outdir)
    end

    file_pattern = ['./assets/images/**/*.png', './assets/images/**/*.jpg', './assets/images/**/*.jpeg', './assets/images/**/*.PNG', './assets/images/**/*.JPG', './assets/images/**/*.JPEG']

    Dir.glob(file_pattern).each do |f|
      output = File.absolute_path(f).gsub(/assets\/images/, 'assets/thumbnail/')
      unless File.exists?(output) then
        image = MiniMagick::Image.open(File.absolute_path(f))
        image.resize "1200x630>"
        image.write output
      end
    end
  end
end
