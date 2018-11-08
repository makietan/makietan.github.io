namespace :embed do
  require 'uri'
  require 'open-uri'
  require "nokogiri"

  # bundle exec rake -f ./lib/tasks/embed.rake embed:create
  desc 'Embed作成'
  task :create do
    puts "#{get_embed(get_meta())}"
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

  def get_meta()
    meta = {}
    uri = ARGV[3]
    if uri =~ URI::regexp
      html = open(uri).read
      doc = Nokogiri::HTML.parse(html)

      title = doc.title
      title = doc.xpath('//meta[@property="og:title"]/@content') if title.nil? or title.empty?
      title = doc.xpath('//meta[@name="twitter:title"]/@content') if title.nil? or title.empty?
      meta[:title] = title unless title.nil? or title.empty?

      description = doc.xpath('//meta[@name="description"]/@content')
      description = doc.xpath('//meta[@property="og:description"]/@content') if description.nil? or description.empty?
      description = doc.xpath('//meta[@name="twitter:description"]/@content') if description.nil? or description.empty?
      meta[:description] = description.to_s unless description.nil? or description.empty?

      url = uri
      url = doc.xpath('//meta[@property="og:description"]/@content')  if url.nil? or url.empty?
      url = doc.xpath('//meta[@name="twitter:description"]/@content') if url.nil? or url.empty?
      meta[:url] = url.to_s unless url.nil? or url.empty?
      meta[:host] = URI.parse(url).host unless URI.parse(url)&.host.nil?

      image = doc.xpath('//meta[@property="og:image"]/@content')
      image = doc.xpath('//meta[@name="twitter:image"]/@content') if image.nil? or image.empty?
      image = doc.xpath('//link[@rel="apple-touch-icon"]/@href') if image.nil? or image.empty?
      meta[:image] = image.to_s unless image.nil? or image.empty?
    end
    meta
  end
end
