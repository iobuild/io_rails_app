require_relative "ui_helpers"
require_relative "string_helpers"
require_relative "config_values"
require_relative "file_helpers"



class BuildApp

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
    Errors.display_error("Something went wrong and Rails ConfigValues.rails_version", true)
    abort

  end


  def create_app
    system "rails new #{ConfigValues.app_name} --skip-bundle"
  end


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

end