task :default => :new

desc "create new post"
task :new do
  title = ""
  now = Time.now
  path = "_posts/#{now.strftime('%F')}-report.md"

  path = checkFilename(path)

  File.open(path, "w") do |f|
    f.puts "---"
    f.puts "layout: post"
    f.puts "title:  \"\""
    f.puts "categories: unknown"
    f.puts "date: \"#{now.strftime('%F %T')}\""
    f.puts "---"
    f.puts ""
    f.puts ""
  end
  sh "atom #{path}"
end


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
