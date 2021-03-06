require_relative "ui_helpers"
require_relative "string_helpers"
require_relative "config_values"
require_relative "file_helpers"
require_relative "app_helpers"



class BuildApp

  include AppHelpers::InstanceMethods

  def initialize()
    @app_dir = Dir.pwd + "/#{ConfigValues.app_name}"
    @root_dir = File.dirname(__FILE__)
  end

  def update_basic

    wputs "- Do you need update the basic?"
    wputs "1. No, not now (default)", :info
    wputs "2. Do it! ", :info


    return if answer() != '2'
      
    new_line
    wputs "----> Updating Rake & Bundler ... ", :info
    system "gem install rake --no-rdoc --no-ri"
    system "gem update rake"
    system "gem install bundler --no-rdoc --no-ri"
    system "gem update bundler"
    new_line
    wputs "----> Rake & Bundler updated to their latest versions.", :info

    
  end

  def install_rails

    wputs "- Do you need install rails?"
    wputs "1. No, not now (default)", :info
    wputs "2. Do it! ", :info


    return if answer() != '2'


    new_line(2)
    wputs "----> Installing Rails #{ConfigValues.rails_version} ...", :info
    system "gem install rails -v #{ConfigValues.rails_version} --no-rdoc --no-ri"
    new_line
    wputs "----> Rails ConfigValues.rails_version installed.", :info

  rescue
    Errors.display_error("Something wrong with Rails ConfigValues.rails_version", true)
    abort

  end



  def create_app
    system "rails new #{ConfigValues.app_name} --skip-bundle"

    define_gemfile

    define_database_yml

    define_application_config

    define_locale_files
  end


  def bundle_install
    wputs "- Do you need run bundle install?"
    wputs "1. No, not now (default)", :info
    wputs "2. Do it! ", :info


    return if answer() != '2'


    new_line(2)
    wputs "----> Installing gems  ...", :info
    Dir.chdir "#{ConfigValues.app_name}" do
      system "bundle install"
      system "rails generate simple_form:install --bootstrap"
    end
    new_line
    wputs "----> Gems installed.", :info
  end


  def install_simple_form
    new_line(2)
    wputs "----> Installing simple_form  ...", :info
    Dir.chdir "#{ConfigValues.app_name}" do
      system "rails generate simple_form:install --bootstrap"
    end

    FileUtils.rm(ConfigValues.app_name + "/config/initializers/simple_form.rb")
    new_line
    wputs "----> simple_form installed.", :info
  end


  def install_awesome_nested_set
    wputs "- Do you need install awesome_nested_set?"
    wputs "1. No, not now (default)", :info
    wputs "2. Do it! ", :info


    return if answer() != '2'


    new_line(2)
    wputs "----> Installing awesome_nested_set  ...", :info

    source_file = "#{@root_dir}/base/app/models/category.rb"
    target_dir = "#{@app_dir}/app/models"
    FileHelpers.copy_file(source_file, target_dir)

    add_categories_migration


    new_line
    wputs "----> awesome_nested_set installed.", :info
  end


  def install_home
    new_line(2)
    wputs "----> Installing home  ...", :info

    source_file = "#{@root_dir}/base/app/controllers/home_controller.rb"
    target_dir = "#{@app_dir}/app/controllers"
    FileHelpers.copy_file(source_file, target_dir)


    source_file = "#{@root_dir}/base/app/views/home"
    target_dir = "#{@app_dir}/app/views"
    # Dir.mkdir(File.join(target_dir, "home"), 0700)
    target_dir = "#{@app_dir}/app/views"
    FileHelpers.copy_dir(source_file, target_dir)


    source_file = "#{@root_dir}/base/config/routes.rb"
    target_dir = "#{@app_dir}/config/routes.rb"
    FileHelpers.override_file(source_file, target_dir)

    new_line
    wputs "----> home installed.", :info
  end


  def install_simple_layout
    new_line(2)
    wputs "----> Installing simple layout  ...", :info


    FileHelpers.replace_string(/'default'/, 
                              '\'simple\'', 
                              @app_dir + "/app/controllers/application_controller.rb")

    target_file = @app_dir + "/config/initializers/assets.rb"
    text = 'Rails.application.config.assets.precompile += %w( custom_as_simple.css )'
    FileHelpers.add_to_file(target_file, text)

    text = 'Rails.application.config.assets.precompile += %w( custom_as_default.css )'
    FileHelpers.add_to_file(target_file, text)


    new_line
    wputs "----> layout installed.", :info
  end

  def install_default_layout
    new_line(2)
    wputs "----> Installing default layout  ...", :info

    
    target_file = @app_dir + "/config/initializers/assets.rb"
    text = 'Rails.application.config.assets.precompile += %w( custom_as_default.css )'
    FileHelpers.add_to_file(target_file, text)

    new_line
    wputs "----> layout installed.", :info
  end


  def install_layout
    wputs "- Please select layout style?"
    wputs "1. default bootstrap3", :info
    wputs "2. simple which compatible with mobile", :info



    source_file = "#{@root_dir}/base/app/helpers"
    target_dir = "#{@app_dir}/app"
    FileHelpers.copy_dir(source_file, target_dir)


    source_file = "#{@root_dir}/base/app/views/layouts"
    target_dir = "#{@app_dir}/app/views"
    FileHelpers.copy_dir(source_file, target_dir)


    source_file = "#{@root_dir}/base/app/assets"
    target_dir = "#{@app_dir}/app"
    FileHelpers.copy_dir(source_file, target_dir)
    FileUtils.rm(target_dir + "/assets/stylesheets/application.css")


    source_file = "#{@root_dir}/base/app/controllers/application_controller.rb"
    target_dir = "#{@app_dir}/app/controllers/application_controller.rb"
    FileHelpers.override_file(source_file, target_dir)


    case answer()
    when '1'
      install_default_layout
    when '2'
      install_simple_layout
    else
      install_default_layout
    end




    
  end


  def install_devise
    new_line(2)
    wputs "----> Installing devise  ...", :info
    Dir.chdir "#{ConfigValues.app_name}" do
      system "rails generate devise:install"
      system "rails generate devise User"
      system "rails g migration AddUsernameToUsers username:string"
      system "rake db:migrate"
    end

    source_file = "#{@root_dir}/base/app/views/devise"
    target_dir = "#{@app_dir}/app/views"
    FileHelpers.copy_dir(source_file, target_dir)

    add_user_decorators

    add_user_page

    new_line
    wputs "----> devise installed.", :info
  end


  def install_admin
    new_line(2)
    wputs "----> Installing admin  ...", :info

    add_test_admin_user


    # admin controllers
    source_file = "#{@root_dir}/base/app/controllers/admin"
    target_dir = "#{@app_dir}/app/controllers"
    FileHelpers.copy_dir(source_file, target_dir)

    method_text = <<-EOM
    # Only permits admin users
    def require_admin!
      authenticate_user!
      
      if current_user && !current_user.admin?
        redirect_to root_path
      end
    end
    helper_method :require_admin!
    EOM

    FileHelpers.replace_string(/io_require_admin/, 
                              method_text, 
                              @app_dir + "/app/controllers/application_controller.rb")


    # admin views
    source_file = "#{@root_dir}/base/app/views/admin"
    target_dir = "#{@app_dir}/app/views"
    FileHelpers.copy_dir(source_file, target_dir)

    new_line
    wputs "----> admin installed.", :info
  end



end