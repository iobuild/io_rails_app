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

gem 'decorators', '~> 1.0.2'
# gem 'mysql2'
gem "kaminari"
gem 'devise'

gem 'simple_form'

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


    def define_database_yml
      origin_file = "#{ConfigValues.app_name}/config/database.yml"

      mysql_config = <<-EOM

# development:
#   adapter: mysql2
#   encoding: utf8
#   database: hispanohora_development
#   username: root
#   password: root
#   pool: 5
#   timeout: 5000
#   reconnect: true

# test:
#   adapter: mysql2
#   encoding: utf8
#   database: hispanohora_test
#   username: root
#   password: root
#   pool: 5
#   timeout: 5000
  
# production:
#   adapter: mysql2
#   encoding: utf8
#   database: hispanohora_production
#   username: root
#   password: root
#   pool: 5
#   timeout: 5000
#   reconnect: true

      EOM

      FileHelpers.add_to_file(origin_file, mysql_config)
    end


    def define_application_config
      source_file = "#{@root_dir}/base/config/application.rb"
      target_dir = "#{@app_dir}/config/application.rb"
      FileHelpers.override_file(source_file, target_dir)
      FileHelpers.replace_string(/YourAppName/, 
                                ConfigValues.app_name.capitalize, 
                                @app_dir + "/config/application.rb")
    end


    def add_test_admin_user
      Dir.chdir "#{ConfigValues.app_name}" do
        system "rails g migration AddAdminToUsers admin:boolean"
      end

      migration_file = Dir[@app_dir + "/db/migrate/*_add_admin_to_users.rb"].first
      key_text = "add_column :users, :admin, :boolean"
      new_text = "add_column :users, :admin, :boolean, :default => false"
      FileHelpers.replace_string(key_text, new_text, migration_file)


      Dir.chdir "#{ConfigValues.app_name}" do
        system "rake db:migrate"
      end



      test_user = <<-EOM
  u = User.new(
      email: "admin@example.com",
      username: 'Iamadmin',
      password: "11111111",
      password_confirmation: "11111111",
      admin: true
  )
  u.save!
      EOM

      FileHelpers.add_to_file(@app_dir + "/db/seeds.rb", test_user)

      Dir.chdir "#{ConfigValues.app_name}" do
        system "rake db:seed"
      end

      
    end


    def add_user_decorator
      source_file = "#{@root_dir}/base/app/decorators"
      target_dir = "#{@app_dir}/app"
      FileHelpers.copy_dir(source_file, target_dir)
    end


  end
end