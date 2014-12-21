class UsersController < Devise::RegistrationsController

  before_filter :find_user, only: [:show]

  def user_params
    params.require(:user).permit(:avatar)
  end

  def index
  end

  def show
    # @user = current_user
  end


  protected
    def find_user
      @user = User.where(username: params[:username].downcase).first

      render_404 if @user.nil?
    end


  

  
end