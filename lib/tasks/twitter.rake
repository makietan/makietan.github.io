namespace :twitter do
  desc 'Embed適用'
  task :apply do
    open(ARGV[3], "r+") {|f|
      f.flock(File::LOCK_EX)
      body = f.read
      body = body.gsub(/class=\"twitter-tweet\"/) do |tmp|
        'class="twitter-tweet tw-align-center"'
      end
      f.rewind
      f.puts body
      f.truncate(f.tell)
    }
    puts "Finish!"
    ARGV.slice(1,ARGV.size).each{|v| task v.to_sym do; end}
  end
end
