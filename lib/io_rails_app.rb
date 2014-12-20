require 'active_support/all'

require_relative "io_rails_app/version"
require_relative "io_rails_app/build_app"




module IoRailsApp



  def self.main(args)

    ConfigValues.app_name = args[0]



    build_app = BuildApp.new

    build_app.update_basic

    build_app.install_rails

    build_app.create_app

    build_app.bundle_install

    build_app.install_devise
    
  end


  
  
end