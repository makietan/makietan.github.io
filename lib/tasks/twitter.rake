namespace :twitter do
  desc 'Embed適用'
  task :apply do
    open(ARGV[3], "r+") {|f|
      f.flock(File::LOCK_EX)
      body = f.read
      body = body.force_encoding("utf8").gsub(/class=\"twitter-tweet\"/) do |tmp|
        'class="twitter-tweet tw-align-center"'
      end
      f.rewind
      f.puts body
      f.truncate(f.tell)
    }
    puts "Twitter 処理: #{ARGV[3]}"
    ARGV.slice(1,ARGV.size).each{|v| task v.to_sym do; end}
  end
end
