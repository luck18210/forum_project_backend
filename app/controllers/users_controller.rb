class UsersController < ApplicationController  
    before_action :authorized, only: [:auto_login, :update]

    def show
      @user = User.find(params[:id])
      if @user.nil?
        render error: {error: "User not found"}, status: :bad_request
      else
        render json: @user
      end
    end

    def update
      @user = User.find(params[:id])
      
      # checks for the existence of the username and validity of password
      if @user && @user.authenticate(params[:password])
        if @user.update(user_params)
          render json: @user
        else
          render error: @user.errors, status: :unprocessable_entity
        end
      else
        render error: {error: "Invalid credentials"}, status: :unauthorized
      end
    end

    #   if @user.id != User.find_by(id: params[:id])
    #     render error: { error: 'Unauthorized. You are not the owner of this account' }, status: :unauthorized
    #   elsif @user.update(user_params)
    #     render json: @user
    #   else
    #     render error: @user.errors, status: :unprocessable_entity
    #   end
    # end

    # REGISTER
    def create
      @user = User.create(user_params)
      if @user.valid?
        token = encode_token({user_id: @user.id})
        render json: {user: @user, token: token}
      else
        render error: {error: "Username is taken or invalid inputs"}, status: :unprocessable_entity
      end
    end
  
    # LOGGING IN
    def login
      @user = User.find_by(username: params[:username])
  
      if @user && @user.authenticate(params[:password])
        token = encode_token({user_id: @user.id})
        render json: {user: @user, token: token}
      else
        render error: {error: "Invalid username or password"}, status: :unauthorized
      end
    end
  
  
    def auto_login
      render json: @user
    end
  
    private
  
    def user_params
      params.permit(:username, :password, :bio)
    end
  
end
