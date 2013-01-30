class UsersController < ApplicationController
	before_filter :not_signed_in_user, only: [:edit, :update, :index, :destroy]
	before_filter :not_correct_user, only: [:edit, :update]
	before_filter :not_admin_user, only: [:destroy]
	before_filter :signed_in_user, only: [:new, :create]
	
	def index
		@users = User.paginate(page: params[:page])
	end
	
	def show 
		@user = User.find(params[:id])
	end
	
	def new
		@user = User.new
	end
	
	def create
		@user = User.new(params[:user])
		if @user.save 
			sign_in @user
			flash[:success] = "Welcome to the Sample App"
			redirect_to @user
		else
			render 'new'
		end
	end
	
	def edit
	end
	
	def update
		if @user.update_attributes(params[:user])
			flash[:success] = "Profile updated"
			sign_in @user
			redirect_to @user
		else
			render 'edit'
		end
	end
  
	def destroy 
		@user = User.find(params[:id])
		if !correct_user?(@user)
			User.find(params[:id]).destroy
			flash[:success] = "User destroyed."
			redirect_to users_path
		else
			redirect_to @user		
		end
	end
	
	private
		def not_signed_in_user
			unless signed_in?
				store_location
				redirect_to signin_path, notice: "Please sign in." 
			end
		end
		def not_correct_user
			@user = User.find(params[:id])
			redirect_to root_path unless correct_user?(@user)
		end
		def not_admin_user 
			redirect_to root_path unless current_user.admin?
		end
		def signed_in_user
			redirect_to root_path unless !signed_in?
		end
end
