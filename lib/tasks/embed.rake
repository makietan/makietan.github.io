require 'kconv'

namespace :embed do
  require 'uri'
  require 'open-uri'
  require "nokogiri"

  desc 'Embed適用'
  task :apply do
    open(ARGV[3], "r+") {|f|
      f.flock(File::LOCK_EX)
      body = f.read
      body = body.force_encoding(Encoding::UTF_8).gsub(/\[embed:(.*)\]/) do |tmp|
        get_embed(get_meta($1))
      end
      f.rewind
      f.puts body
      f.truncate(f.tell)
    }
    puts "Embed 処理: #{ARGV[3]}"
    ARGV.slice(1,ARGV.size).each{|v| task v.to_sym do; end}
  end

  # bundle exec rake -f ./lib/tasks/embed.rake embed:create
  desc 'Embed作成'
  task :create do
    puts "#{get_embed(get_meta(ARGV[3]))}"
    ARGV.slice(1,ARGV.size).each{|v| task v.to_sym do; end}
  end

  def get_embed(meta)
    """
<div class=\"card\">
  <a href=\"#{meta[:url]}\"></a>
  <div class=\"card__header\">
    <a href=\"#{meta[:url]}\">#{meta[:host]}</a>
  </div>
  <div class=\"card__image\">
    <img src=\"#{meta[:image]}\">
  </div>
  <div class=\"card__title\">
    <p>#{meta[:title]}</p>
  </div>
  <div class=\"card__description\">
    <p>#{meta[:description]}</p>
  </div>
</div>
"""
  end

  def get_meta(uri)
    meta = {}
    if uri =~ URI::regexp
      begin 
        opt = {}
        opt['User-Agent'] = 'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/95.0.4638.69 Safari/537.36'
        opt['Accept'] = 'text/html,application/xhtml+xml,application/xml;q=0.9,image/avif,image/webp,image/apng,*/*;q=0.8,application/signed-exchange;v=b3;q=0.9'
        opt['Accept-Language'] = 'ja,en;q=0.9,en-US;q=0.8'
        html = URI.open(uri, opt).read
        
        doc = Nokogiri::HTML(html.toutf8, nil, 'utf-8')

        title = doc.title
        title = doc.xpath('//meta[@property="og:title"]/@content') if title.nil? || title.empty?
        title = doc.xpath('//meta[@name="twitter:title"]/@content') if title.nil? || title.empty?
        meta[:title] = title unless title.nil? or title.empty?

        description = doc.xpath('//meta[@name="description"]/@content')
        description = doc.xpath('//meta[@property="og:description"]/@content') if description.nil? || description.empty?
        description = doc.xpath('//meta[@name="twitter:description"]/@content') if description.nil? || description.empty?
        meta[:description] = description.to_s unless description.nil? || description.empty?

        url = uri
        url = doc.xpath('//meta[@property="og:description"]/@content')  if url.nil? || url.empty?
        url = doc.xpath('//meta[@name="twitter:description"]/@content') if url.nil? || url.empty?
        url = uri unless url.nil? or url.empty?
        meta[:url] = url.to_s
        meta[:host] = URI.parse(url).host unless URI.parse(url)&.host.nil?

        image = doc.xpath('//meta[@property="og:image"]/@content')
        image = doc.xpath('//meta[@name="twitter:image"]/@content') if image.nil? || image.empty?
        image = doc.xpath('//link[@rel="apple-touch-icon"]/@href') if image.nil? || image.empty?
        if image.to_s =~ %r{^\/(.*)}
          meta[:image] = URI.join(uri, image.to_s).to_s unless image.nil? || image.empty?
        else
          meta[:image] = image.to_s unless image.nil? || image.empty?
        end
      rescue => e
        puts "URL: " + uri
        puts e
      end
    end
    meta
  end
end
