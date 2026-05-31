namespace :youtube do
  desc 'YouTube Embed適用'
  task :apply do
    File.open(ARGV[3], 'r+') do |f|
      f.flock(File::LOCK_EX)
      body = f.read
      body = wrap_youtube_embed(body.force_encoding(Encoding::UTF_8))
      f.rewind
      f.write(body)
      f.truncate(f.tell)
    end
    puts "YouTube 処理: #{ARGV[3]}"
    ARGV.slice(1,ARGV.size).each{|v| task v.to_sym do; end}
  end

  def wrap_youtube_embed(body)
    lines = body.lines
    wrapped_lines = []
    google_depth = 0

    lines.each do |line|
      if google_wrapper_line?(line)
        wrapped_lines << line
        google_depth += div_depth_delta(line)
        next
      end

      if youtube_embed_line?(line) && google_depth.zero?
        indent = line[/^\s*/]
        wrapped_lines << %(#{indent}<div class="google">\n)
        wrapped_lines << line
        wrapped_lines << %(#{indent}</div>\n)
        next
      end

      wrapped_lines << line
      google_depth += div_depth_delta(line) unless google_depth.zero?
    end

    wrapped_lines.join
  end

  def youtube_embed_line?(line)
    line.match?(%r{<iframe\b[^>]*src="https?:\/\/(?:www\.)?(?:youtube(?:-nocookie)?\.com)\/embed\/[^\"]+"[^>]*><\/iframe>})
  end

  def google_wrapper_line?(line)
    line.match?(%r{<div class="[^"]*\bgoogle\b[^"]*">})
  end

  def div_depth_delta(line)
    line.scan(/<div\b/).size - line.scan(%r{<\/div>}).size
  end
end