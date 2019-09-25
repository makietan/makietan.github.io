namespace :image do
  require 'uri'
  require 'open-uri'
  require "nokogiri"

  desc 'Image適用'
  task :apply do
    filename = File.basename(ARGV[3]).gsub('.md', '')
    open(ARGV[3], "r+") {|f|
      f.flock(File::LOCK_EX)
      body = f.read
      body = body.gsub(/\[image:(.*):(.*)\]/) do |tmp|
        get_image(filename, $1, $2)
      end
      body = body.gsub(/\[image:(.*)\]/) do |tmp|
        get_image(filename, $1)
      end
      f.rewind
      f.puts body
      f.truncate(f.tell)
    }
    puts "Image 処理: #{ARGV[3]}"
    ARGV.slice(1,ARGV.size).each{|v| task v.to_sym do; end}
  end

  # bundle exec rake -f ./lib/tasks/embed.rake embed:create
  desc 'Image作成'
  task :create do
    puts "#{get_embed(get_meta(ARGV[3]))}"
    ARGV.slice(1,ARGV.size).each{|v| task v.to_sym do; end}
  end

  def get_image(filename, image, alt=nil)
    alt_html = " alt=\"#{alt}\"" unless alt.nil?
    """
<div class=\"trim\">
  <div class=\"trim__item\">
    <a href=\"{{ site.url }}/assets/images/#{filename}/#{image}\">
      <img class=\"one\" src=\"{{ site.url }}/assets/thumbnail/#{filename}/#{image}\"#{alt_html}>
    </a>
  </div>
</div>
"""
  end
end
