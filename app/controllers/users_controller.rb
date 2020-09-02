class UsersController < ApplicationController
  
  # Gatekeeper to validate a user has signed in
  before_action :require_signin, except: [:new, :create]

  # Gatekeeper to validate that the user signed in is the same as user that can delete or edite its actions
  before_action :require_correct_user, only: [:edit, :update] 

  # Gatekeeper to allow only admin users to delete account users
  before_action :require_admin, only: [:destroy]

  def index
    # @users = User.all
    @users = User.not_admins
  end
  def show
    # @user = User.find(params[:id])
    @user = User.find_by!(username: params[:id])
    @reviews = @user.reviews
    @favorite_movies = @user.favorite_movies
  end

  def new
    @user = User.new()
  end
  
  def create
    @user = User.new(user_params)
    if @user.save
      session[:user_id] = @user.id
      # These 2 redirects both work and are valid, the first uses the helper route users_path(@user), no need to be @user.id,
      # as rails is smart enough to detect the id,
      # The one that works redirect_to @user is a shortcut that rails has and tipucally called syntactic sugar
      # redirect_to users_path(@user), notice: "Thanks for signing up!"
      redirect_to @user, notice: "Thanks for signing up!"
    else
      render :new
    end
  end

  def edit
    # the require_correct_user is being called before edit,update and destroy actions.
    #@user = User.find(params[:id])
  end

  def update
    # the require_correct_user is being called before edit,update and destroy actions.
    #@user = User.find(params[:id])
    if @user.update(user_params)
      redirect_to @user, notice: "Profile successfully updated!"
    else
      render :edit
    end
  end
  
  def destroy
    # the require_correct_user is being called before edit,update and destroy actions.
    # @user = User.find(params[:id])

    # as it stands now, the destroy action does not belong to require_correct_user,
    # therefore the require_admin needs to find the user
    @user = User.find(params[:id])
    @user.destroy
    # session[:user_id] = nil
    redirect_to movies_url, alert: "Account successfully deleted!"
  end
  
  private
    def user_params
      params.require(:user).permit(:username, :name, :email, :password, :password_confirmation)
    end

    def require_correct_user
      @user = User.find(params[:id])
      
      redirect_to root_url unless current_user?(@user)
      
      # This code does the same the line above but all on one line and using the current_user?
      # unless current_user == @user
      #   redirect_to root_url
      # end
    end

    def username
      @user = Movie.find_by!(username: params[:id])
    end

end
