require_relative "io_rails_app/version"
require_relative "io_rails_app/build_app"




module IoRailsApp



  def self.main(args)

    # @options[:rails_version] = '4.1.8'
    build_app = BuildApp.new

    build_app.update_basic

    build_app.install_rails
    
  end


  
  
end