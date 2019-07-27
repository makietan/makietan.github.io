require "date"

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
   sh "code #{path}"
end

desc "create new post"
task :new do
  title = ""
  now = Time.now
  path = "_posts/#{now.strftime('%F')}-report.md"

  path = checkFilename(path)

  createReport(path, now)
  # sh "atom #{path}"
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
    sh "bundle exec jekyll serve --trace"
  end

  # desc 'setup'
  # task :setup do
  #   sh "bundle exec rake -f ./lib/tasks/category.rake category:create"
  #   sh "bundle exec rake -f ./lib/tasks/thumbnail.rake thumbnail:create"
  # end
end

namespace :utils do
  namespace :twitter do
    desc "変更ファイルに適用する"
    task :build do
      system "git status --porcelain | sed s/^...// | xargs -n 1 sh -c 'rake utils:twitter:apply $0'"
    end

    desc "中央寄せにする"
    task :apply do
      file_path = "#{ARGV.last}"
      if !file_path.empty?
        system "bundle exec rake -f lib/tasks/twitter.rake twitter:apply #{file_path}"
        sleep 3
      end
      ARGV.slice(1, ARGV.size).each{ |v|
        task v.to_sym do;
        end
      }
    end
  end

  namespace :embed do
    desc "embed を作成する"
    task :create do
      url = "#{ARGV.last}"
      if !url.empty?
        system "bundle exec rake -f lib/tasks/embed.rake embed:create #{url}"
        sleep 3
      end
      ARGV.slice(1, ARGV.size).each{ |v|
        task v.to_sym do;
        end
      }
    end

    desc "embed を自動適用する"
    task :build do
      system "git status --porcelain | sed s/^...// | xargs -n 1 sh -c 'rake utils:embed:apply $0'"
    end

    desc "embed を適用する"
    task :apply do
      file_path = "#{ARGV.last}"
      if !file_path.empty?
        system "bundle exec rake -f lib/tasks/embed.rake embed:apply #{file_path}"
        sleep 3
      end
      ARGV.slice(1, ARGV.size).each{ |v|
        task v.to_sym do;
        end
      }
    end
  end
end
