require "date"
require "mini_magick"

task :default => :tomorrow

desc "create new category page"
task :category do
  title = "#{ARGV.last}"
  day = Date.today
  path = "category/#{ARGV.last}.md"
  File.open(path, "w") do |f|
    f.puts "---"
    f.puts "layout: category"
    f.puts "permalink: /category/#{ARGV.last}"
    f.puts "category: #{ARGV.last}"
    f.puts "---"
    f.puts ""
    f.puts ""
  end
  ARGV.slice(1, ARGV.size).each{ |v|
    task v.to_sym do;
    end
  }
end

desc "create new post tomorrow"
task :tomorrow do
  title = ""
  day = Date.today
  path = "_posts/#{day.strftime('%F')}-report.md"
  path, day = checkFilename2(path, day)
  createReport(path, day)
  sh "atom #{path}"
end

desc "create new post"
task :new do
  title = ""
  now = Time.now
  path = "_posts/#{now.strftime('%F')}-report.md"

  path = checkFilename(path)

  createReport(path, now)
  sh "atom #{path}"
end

desc "create file"
def createReport(path, day)
  File.open(path, "w") do |f|
    f.puts "---"
    f.puts "layout: post"
    f.puts "title:  \"\""
    f.puts "categories: unknown"
    f.puts "date: \"#{day.strftime('%F %T')}\""
    f.puts "---"
    f.puts ""
    f.puts ""
  end
end

desc "cehck duplicate filename"
def checkFilename2(filename, day)
  while File.exist?(filename)
    day = day + 1
    filename = "_posts/#{day.strftime('%F')}-report.md"
  end
  return filename, day
end

desc "check duplicate filename"
def checkFilename(filename)
  while File.exist?(filename)
    result = filename.match(/(.*)(\d+)?.md/)
    unless result[2].nil?
      filename = "#{result[1]}#{(result[2].to_i + 1).to_s}.md"
    else
      filename = "#{result[1]}2.md"
    end
  end
  return filename
end

namespace :jekyll do
  desc 'serve'
  task :serve do
    sh "bundle install --path vendor/bundle"
    sh "bundle exec jekyll serve"
  end
end

namespace :thumbnail do
  desc 'assets/images にある画像のサムネイルを作る'
  task :create do
    Dir.glob('./assets/images/**/').each do |f|
      outdir = File.absolute_path(f).gsub(/assets\/images/, 'assets/thumbnail/')
      FileUtils.mkdir_p(outdir) unless FileTest.exist?(outdir)
    end

    file_pattern = ['./assets/images/**/*.png', './assets/images/**/*.jpg', './assets/images/**/*.jpeg', './assets/images/**/*.PNG', './assets/images/**/*.JPG', './assets/images/**/*.JPEG']

    Dir.glob(file_pattern).each do |f|
      image = MiniMagick::Image.open(File.absolute_path(f))
      image.resize "1200x630>"
      output = File.absolute_path(f).gsub(/assets\/images/, 'assets/thumbnail/')
      image.write output
    end
  end
end
