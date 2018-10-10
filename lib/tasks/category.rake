namespace :category do
  require 'time'
  require "safe_yaml/load"

  YAML_FRONT_MATTER_REGEXP = %r!\A(---\s*\n.*?\n?)^((---|\.\.\.)\s*$\n?)!m

  # bundle exec rake -f ./lib/tasks/category.rake category:create
  desc 'カテゴリーページ作成'
  task :create do
    FileUtils.mkdir_p('./category') unless FileTest.exist?('./category')
    get_categories().each do |category|
      output = File.absolute_path("./category") + "/#{category}.md"
      unless File.exists?(output)
        content = "---\nlayout: category\npermalink: /category/#{category}\ncategory: #{category}\n---"
        File.open(output, "w") do |file|
          file.puts content
        end
      end
    end
  end

  def get_categories()
    categories = []
    Dir.glob('./_posts/*.md').each do |f|
      content = File.read(f)
      if content =~ YAML_FRONT_MATTER_REGEXP
        data_file = SafeYAML.load(Regexp.last_match(1))
        if data_file["categories"].kind_of?(Array)
          data_file["categories"].each do |category|
            categories << category unless category.nil?
          end
        else
          categories << data_file["categories"] unless data_file["categories"].nil?
        end
      end
    end
    categories.uniq
  end
end
