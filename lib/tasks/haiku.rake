namespace :haiku do
  desc 'Haiku適用'
  task :apply do
    open(ARGV[3], "r+") {|f|
      f.flock(File::LOCK_EX)
      body = f.read
      body = body.gsub(/\[haiku:(.*?) (.*?) (.*?)\]/) do |tmp|
        get_haiku([
          $1,
          $2,
          $3
        ])
      end
      f.rewind
      f.puts body
      f.truncate(f.tell)
    }
    puts "Haiku 処理: #{ARGV[3]}"
    ARGV.slice(1,ARGV.size).each{|v| task v.to_sym do; end}
  end

  # bundle exec rake -f ./lib/tasks/haiku.rake haiku:create
  desc 'Haiku作成'
  task :create do
    puts "#{get_haiku([
      ARGV[3],
      ARGV[4],
      ARGV[5]
    ])}"
    ARGV.slice(1,ARGV.size).each{|v| task v.to_sym do; end}
  end

  def get_haiku(meta)
    """
<div class='haiku'>
  <p>#{meta[0]}</p>
  <p>#{meta[1]}</p>
  <p>#{meta[2]}</p>
</div>
<div class='haiku-button'>
  <script>
    function speak() {
      var speech = new SpeechSynthesisUtterance();
      speech.text = document.querySelector('.haiku').innerText.replace('\\n', '、');
      speech.lang = 'ja-JP';
      speech.rate = 0.8;
      var voices = [...window.speechSynthesis.getVoices()].filter((e) => e.lang === 'ja-JP');
      if (voices.length > 0) {
        speech.voice = voices.pop();
      }
      speechSynthesis.speak(speech);
    }
  </script>
  <button class='btn btn-gray' onclick='speak();'>話す</button>
</div>
"""
  end
end
