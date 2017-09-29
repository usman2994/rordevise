module Api::V1
  class UsersController < ApplicationController
  before_action :authenticate, only: [:show, :update, :destroy]

  # GET /users
  def index
    @users = User.all

    render json: @users
  end

  # GET /users/1
  def show
    render json: @current_user
  end

  # # POST /signup
  # def signup
  #   create
  #
  # end

  # POST /users
  def create
    @user = User.new(user_params)

    if @user.save
      render json: @user, status: :created
    else
      render json: @user.errors, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /users/1
  def update
    if @user.update(user_params)
      render json: @user
    else
      render json: @user.errors, status: :unprocessable_entity
    end
  end

  # DELETE /users/1
  def destroy
    @user.destroy
  end

  private
  # Use callbacks to share common setup or constraints between actions.
  def set_user
    @user = User.find(params[:id])
  end

  # Only allow a trusted parameter "white list" through.
  def user_params
    params.require(:user).permit(:name, :email)
  end

  def authenticate
    token = request.headers['token']

    if token.present?
      puts 'ss'
      @current_user = User.find_by_access_token(token)
      #binding.pry
      if @current_user.present?
        puts 'sss2'
        @current_user
      else

        render_unauthorized
      end
    else
      puts'tokk'
      render_unauthorized
    end
  end

  def render_unauthorized(realm = "Application")
    self.headers["WWW-Authenticate"] = %(Token realm="#{realm.gsub(/"/, "")}")
    render json: 'Bad credentials', status: :unauthorized
  end

  def user_params
    params.require(:user).permit(:name, :email, :password)
  end

  end
end