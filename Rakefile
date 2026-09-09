require "date"

task :default => :tomorrow

desc "すべてのツールを適用する"
task :b => ["utils:build"]

desc "develop ブランチとの差分に対してすべてのツールを適用する"
task :b_d => ['utils:build_diff']

desc "git diff --name-only origin/develop を実行する"
task :d do
  sh "git diff --name-only origin/develop | grep \"_posts\""
end

desc "git add & git commit -m '日報'"
task :s do
  sh "git add -u"
  sh "git commit -m '日報'"
  sh "git pull --rebase origin develop"
end

desc "校閲する"
task :t => ["utils:lint:build"]

desc "校閲する(develop)"
task :t_d => ["utils:link:build_diff"]

desc "校閲する(最近のファイル)"
task :t_l => ["utils:link:build_latest"]

desc "全部やる"
task :bsp do
  Rake::Task["b"].invoke()
  Rake::Task["s"].invoke()
  sh "git push"
end

desc "全部やる（develop差分版）"
task :dsp do
  Rake::Task["utils:pullrequest"].invoke()
  sh "git commit -m '日報'"
  sh "git push"
end

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

desc "tomorrowを実行し、作成されたファイルと指定された日付のファイルを入れ替える"
task :swap, ['target_date', "type"] do |task, args|
  if args.target_date.nil? || args.target_date.empty?
    puts "日付を指定してください (例: rake swap_date[2026-10-01])"
    next
  end

  task_type = (args.type && !args.type.empty?) ? args.type : "tomorrow"

  Rake::Task[task_type].invoke()

  # 2. tomorrow によって作成された最新のファイルを特定する
  day = Date.today
  path = "_posts/#{day.strftime('%F')}-report.md"
  while File.exist?(path)
    day = day + 1
    path = "_posts/#{day.strftime('%F')}-report.md"
  end
  # tomorrow 実行後なので、whileを抜けた1日前の日付が作成されたファイル
  tomorrow_day = day - 1
  tomorrow_path = "_posts/#{tomorrow_day.strftime('%F')}-report.md"

  # 3. 指定された入れ替え対象の日付
  target_day = Date.parse(args.target_date)
  target_path = "_posts/#{target_day.strftime('%F')}-report.md"

  if File.exist?(target_path)
    tomorrow_content = File.read(tomorrow_path)
    target_content = File.read(target_path)

    # 互いのフロントマター等の日付文字列を置換
    tomorrow_content.gsub!(tomorrow_day.strftime('%F'), target_day.strftime('%F'))
    target_content.gsub!(target_day.strftime('%F'), tomorrow_day.strftime('%F'))

    # パスをクロスさせて上書き保存（スワップ）
    File.write(tomorrow_path, target_content)
    File.write(target_path, tomorrow_content)

    puts "🔄 #{tomorrow_path} と #{target_path} の中身と日付を完全に入れ替えました！"
  else
    # 対象ファイルがない場合は、単にリネームして日付を書き換える
    tomorrow_content = File.read(tomorrow_path)
    tomorrow_content.gsub!(tomorrow_day.strftime('%F'), target_day.strftime('%F'))
    File.write(tomorrow_path, tomorrow_content)
    File.rename(tomorrow_path, target_path)

    puts "➡️ 指定された日付のファイルがなかったため、#{tomorrow_path} を #{target_path} に変更しました。"
  end
end

desc "指定した 2 つの日付の記事を入れ替える"
task :reorder, ['first_date', 'second_date'] do |task, args|
  first_date = args.first_date.to_s.strip
  second_date = args.second_date.to_s.strip

  if first_date.empty? || second_date.empty?
    puts "2 つの日付を指定してください (例: rake reorder[2026-10-01,2026-10-02])"
    next
  end

  first_day = Date.parse(first_date)
  second_day = Date.parse(second_date)
  first_path = "_posts/#{first_day.strftime('%F')}-report.md"
  second_path = "_posts/#{second_day.strftime('%F')}-report.md"

  if !File.exist?(first_path) || !File.exist?(second_path)
    puts "両方のファイルが存在する場合のみ入れ替えます。#{first_path} と #{second_path} のどちらかが見つからないため、処理は行いません。"
    next
  end

  first_content = File.read(first_path)
  second_content = File.read(second_path)

  first_content.gsub!(first_day.strftime('%F'), second_day.strftime('%F'))
  second_content.gsub!(second_day.strftime('%F'), first_day.strftime('%F'))

  File.write(first_path, second_content)
  File.write(second_path, first_content)

  puts "🔄 #{first_path} と #{second_path} の中身と日付を完全に入れ替えました！"
end

desc "すずろ庵へ遷移するためのリダイレクトページを作成する"
task :suzuro do
  title = ""
  day = Date.today
  path = "_posts/#{day.strftime('%F')}-report.md"
  path, day = checkFilename2(path, day)
  File.open(path, "w") do |f|
    f.puts "---"
    f.puts "layout: redirect"
    f.puts "title:  \"\""
    f.puts "categories: gourmet"
    f.puts "date: \"#{day.strftime('%F %T')}\""
    f.puts "redirect_to: "
    f.puts "sitemap: false"
    f.puts "description: \"ご飯感想ブログ「すずろ庵」へ遷移します\""
    f.puts "---"
    f.puts ""
    f.puts ""
  end
  sh "code #{path}"
end

desc "X「@makietanX」へ遷移するためのリダイレクトページを作成する"
task :twitter do
  title = ""
  day = Date.today
  path = "_posts/#{day.strftime('%F')}-report.md"
  path, day = checkFilename2(path, day)
  File.open(path, "w") do |f|
    f.puts "---"
    f.puts "layout: redirect"
    f.puts "title:  \"\""
    f.puts "categories: unknown"
    f.puts "date: \"#{day.strftime('%F %T')}\""
    f.puts "redirect_to: "
    f.puts "sitemap: false"
    f.puts "description: \"X「@makietanX」のしょーもない投稿へ遷移します\""
    f.puts "---"
    f.puts ""
    f.puts ""
  end
  sh "code #{path}"
end

desc "雑記ブログ「役に立ちそうで役に立たないブログ」へ遷移するためのリダイレクトページを作成する"
task :yakuni do
  title = ""
  day = Date.today
  path = "_posts/#{day.strftime('%F')}-report.md"
  path, day = checkFilename2(path, day)
  File.open(path, "w") do |f|
    f.puts "---"
    f.puts "layout: redirect"
    f.puts "title:  \"\""
    f.puts "categories: unknown"
    f.puts "date: \"#{day.strftime('%F %T')}\""
    f.puts "redirect_to: "
    f.puts "sitemap: false"
    f.puts "description: \"雑記ブログ「役に立ちそうで役に立たないブログ」へ遷移します\""
    f.puts "---"
    f.puts ""
    f.puts ""
  end
  sh "code #{path}"
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

desc "create new post in empty date"
task :fill do
  title = ""
  day = Date.today
  path = "_posts/#{day.strftime('%F')}-report.md"
  path, day = checkFilename3(path, day)
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

desc "create target date post"
task :target, ['date'] do |task, args|
  title = ""
  day = Date.today
  unless args.date.empty?
    day = Date.parse(args.date)
  end
  puts day
  path = "_posts/#{day.strftime('%F')}-report.md"
  path = checkFilename(path)
  createReport(path, day)
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

desc "check duplicate filename"
def checkFilename3(filename, day)
  while File.exist?(filename)
    day = day - 1
    filename = "_posts/#{day.strftime('%F')}-report.md"
  end
  return filename, day
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
    result = filename.match(/(.*?)(\d+)?.md/)
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
    sh "bundle exec jekyll serve --incremental --livereload"
  end

  # desc 'setup'
  # task :setup do
  #   sh "bundle exec rake -f ./lib/tasks/category.rake category:create"
  #   sh "bundle exec rake -f ./lib/tasks/thumbnail.rake thumbnail:create"
  # end
end

namespace :utils do
  desc "git add の前にやりたいことをやる"
  task :add do
    Rake::Task['utils:build'].invoke()
    sh("git add .")
  end

  desc "pullrequest の前にやりたいことをやる"
  task :pullrequest do
    Rake::Task['utils:build_diff'].invoke()
    sh("git add .")
  end

  desc "すべてのツールを適用する"
  task :build do
    threads = []
    threads << Thread.new do
      Rake::Task["utils:lint:build"].invoke()
    end
    threads << Thread.new do
      Rake::Task["utils:twitter:build"].invoke()
    end
    threads << Thread.new do
      Rake::Task["utils:youtube:build"].invoke()
    end
    threads << Thread.new do
      Rake::Task["utils:image:build"].invoke()
    end
    threads << Thread.new do
      Rake::Task["utils:embed:build"].invoke()
    end
    threads << Thread.new do
      Rake::Task["utils:haiku:build"].invoke()
    end
    threads.each { |t| t.join }
  end

  desc "すべてのツールを適用する"
  task :build_diff do
    threads = []
    threads << Thread.new do
      Rake::Task["utils:lint:build_diff"].invoke()
    end
    threads << Thread.new do
      Rake::Task["utils:twitter:build_diff"].invoke()
    end
    threads << Thread.new do
      Rake::Task["utils:youtube:build_diff"].invoke()
    end
    threads << Thread.new do
      Rake::Task["utils:image:build_diff"].invoke()
    end
    threads << Thread.new do
      Rake::Task["utils:embed:build_diff"].invoke()
    end
    threads << Thread.new do
      Rake::Task["utils:haiku:build_diff"].invoke()
    end
    threads.each { |t| t.join }
  end

  desc "categories: unknown な記事を見つける"
  task :find_unknown do
    Dir.glob('_posts/**/*.md').each do |f|
      puts f if File.readlines(f).any?{|line| line.include?("categories: unknown")}
    end
  end

  namespace :lint do
    desc "日本語校閲する"
    task :build do
      system "git diff --name-only develop | grep \"_posts\" | xargs -n 1 sh -c 'npx textlint $0'"
    end

    desc "日本語校閲する(develop)"
    task :build_diff do
      system "git diff --name-only develop | grep \"_posts\" | xargs -n 1 sh -c 'npx textlint $0'"
    end

    desc "日本語校閲する(latest)"
    task :build_latest do
      Dir.glob('_posts/*.md').each do |f|
        system "npx textlint #{f}"
      end
    end

    desc "日本語校閲して修正する(latest)"
    task :fix_latest do
      Dir.glob('_posts/*.md').each do |f|
        system "npx textlint --fix #{f}"
      end
    end

    desc "日本語校閲する"
    task :apply do
      file_path = "#{ARGV.last}"
      if !file_path.empty?
        system "npx textlint #{file_path}"
      end
      ARGV.slice(1, ARGV.size).each{ |v|
        task v.to_sym do;
        end
      }
    end
  end

  namespace :haiku do
    desc "変更ファイルに適用する"
    task :build do
      system "git diff --name-only develop | grep \"_posts\" | xargs -n 1 sh -c 'rake utils:haiku:apply $0'"
    end

    task :build_diff do
      system "git diff --name-only develop | grep \"_posts\" | xargs -n 1 sh -c 'rake utils:haiku:apply $0'"
    end

    desc "川柳の表示にする"
    task :apply do
      file_path = "#{ARGV.last}"
      if !file_path.empty?
        system "bundle exec rake -f lib/tasks/haiku.rake haiku:apply #{file_path}"
        sleep 3
      end
      ARGV.slice(1, ARGV.size).each{ |v|
        task v.to_sym do;
        end
      }
    end
  end

  namespace :twitter do
    desc "変更ファイルに適用する"
    task :build do
      system "git diff --name-only develop | grep \"_posts\" | xargs -n 1 sh -c 'rake utils:twitter:apply $0'"
    end

    task :build_diff do
      system "git diff --name-only develop | grep \"_posts\" | xargs -n 1 sh -c 'rake utils:twitter:apply $0'"
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

  namespace :youtube do
    desc "変更ファイルに適用する"
    task :build do
      system "git diff --name-only develop | grep \"_posts\" | xargs -n 1 sh -c 'rake utils:youtube:apply $0'"
    end

    task :build_diff do
      system "git diff --name-only develop | grep \"_posts\" | xargs -n 1 sh -c 'rake utils:youtube:apply $0'"
    end

    desc "YouTube embed を google で囲む"
    task :apply do
      file_path = "#{ARGV.last}"
      if !file_path.empty?
        system "bundle exec rake -f lib/tasks/youtube.rake youtube:apply #{file_path}"
        sleep 3
      end
      ARGV.slice(1, ARGV.size).each{ |v|
        task v.to_sym do;
        end
      }
    end
  end

  namespace :image do
    desc "image を作成する"
    task :create do
      file_path = "#{ARGV.last}"
      if !file_path.empty?
        system "bundle exec rake -f lib/tasks/image.rake image:create #{file_path}"
        sleep 3
      end
      ARGV.slice(1, ARGV.size).each{ |v|
        task v.to_sym do;
        end
      }
    end

    desc "image を自動適用する"
    task :build do
      system "git diff --name-only develop | grep \"_posts\" | xargs -n 1 sh -c 'rake utils:image:apply $0'"
    end

    task :build_diff do
      system "git diff --name-only develop | grep \"_posts\" | xargs -n 1 sh -c 'rake utils:image:apply $0'"
    end

    desc "image を適用する"
    task :apply do
      file_path = "#{ARGV.last}"
      if !file_path.empty?
        system "bundle exec rake -f lib/tasks/image.rake image:apply #{file_path}"
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
      system "git diff --name-only develop | grep \"_posts\" | xargs -n 1 sh -c 'rake utils:embed:apply $0'"
    end

    task :build_diff do
      system "git diff --name-only develop | grep \"_posts\" | xargs -n 1 sh -c 'rake utils:embed:apply $0'"
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
