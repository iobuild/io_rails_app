module AppHelpers
  module InstanceMethods


    def wputs(text, highlight = :none)
      StringHelpers.wputs(text, highlight)
    end


    def new_line(lines=1)
      StringHelpers.new_line(lines)
    end

    def answer(choices="Your choice (1-2):", is_downcase = true)
      print "#{choices} "
      if is_downcase
        STDIN.gets.chomp.downcase.strip
      else
        STDIN.gets.chomp.strip
      end
    end


    def define_gemfile
      # Replace gem source path
      key_text = "source 'https://rubygems.org'"
      new_gem_source = "# source 'https://rubygems.org' \nsource 'http://ruby.taobao.org'"
      origin_file = "#{ConfigValues.app_name}/Gemfile"
      FileHelpers.replace_string(key_text, new_gem_source, origin_file)

      # Add basic gem

      basic_gem = <<-EOM

# gem 'mysql2'
gem "kaminari"
gem 'devise'

gem 'bootstrap-sass'
gem 'autoprefixer-rails'
gem 'font-awesome-sass'

gem 'social-share-button'


group :development, :test do
  gem 'rspec-rails'
  gem 'database_cleaner'
  gem 'factory_girl_rails'
  gem 'timecop'
end

      EOM

      FileHelpers.add_to_file(origin_file, basic_gem)
    end
    

  end
end