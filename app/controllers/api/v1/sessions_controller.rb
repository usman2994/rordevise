module Api::V1
  class SessionsController < ApplicationController

    before_action :authenticate

    #for sign in
    def create

      sign_in(@current_user)
      render json: @current_user, status: :created#, location: @user
    end

    #  render json: @user.errors, status: :unprocessable_entity
    def destroy
      sign_out
    end


    private

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

    def set_user
      @user = User.find(params[:id])
    end

    # Only allow a trusted parameter "white list" through.
    def user_params
      params.require(:user).permit(:username, :email, :password)
    end


  end
end