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
    <<~HTML
    <div class="card">
      <a href="#{meta[:url]}"></a>
      <div class="card__header">
        <a href="#{meta[:url]}">#{meta[:host]}</a>
      </div>
      <% if meta[:image] %>
      <div class="card__image">
        <img src="#{meta[:image]}">
      </div>
      <% end %>
      <% if meta[:title] %>
      <div class="card__title">
        <p>#{meta[:title]}</p>
      </div>
      <% end %>
      <% if meta[:description] %>
      <div class="card__description">
        <p>#{meta[:description]}</p>
      </div>
      <% end %>
    </div>
    HTML
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
        
        utf8_html = html.encode('UTF-8', invalid: :replace, undef: :replace)
        doc = Nokogiri::HTML(utf8_html, nil, 'utf-8')
        # Title
        title = doc.at('meta[property="og:title"]')&.[]('content') ||
                doc.at('meta[name="twitter:title"]')&.[]('content') ||
                doc.at('title')&.text
        meta[:title] = title.to_s.strip unless title.nil? || title.to_s.strip.empty?

        # Description
        description = doc.at('meta[name="description"]')&.[]('content') ||
                      doc.at('meta[property="og:description"]')&.[]('content') ||
                      doc.at('meta[name="twitter:description"]')&.[]('content')
        meta[:description] = description.to_s.strip unless description.nil? || description.to_s.strip.empty?

        # URL (prefer og:url, canonical, twitter:url)
        url = doc.at('meta[property="og:url"]')&.[]('content') ||
              doc.at('link[rel="canonical"]')&.[]('href') ||
              doc.at('meta[name="twitter:url"]')&.[]('content') ||
              uri
        meta[:url] = url.to_s
        begin; meta[:host] = URI.parse(meta[:url]).host; rescue; meta[:host] = nil; end

        # Image (handle protocol-relative and root-relative URLs)
        image = doc.at('meta[property="og:image"]')&.[]('content') ||
                doc.at('meta[name="twitter:image"]')&.[]('content') ||
                doc.at('link[rel="apple-touch-icon"]')&.[]('href')
        unless image.nil? || image.to_s.strip.empty?
          image_str = image.to_s.strip
          if image_str.start_with?('//')
            scheme = URI.parse(uri).scheme || 'https'
            image_str = "#{scheme}:#{image_str}"
          elsif image_str.start_with?('/')
            image_str = URI.join(uri, image_str).to_s
          end
          meta[:image] = image_str
        end

        puts "#{meta[:title]} (#{meta[:url]}) #{meta[:description]} #{meta[:image]}"
      rescue => e
        puts "URL: " + uri
        puts e
      end
    else
      meta[:url] = uri
    end
    meta
  end
end
