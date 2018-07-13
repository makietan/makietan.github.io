require "date"

task :default => :tomorrow

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
