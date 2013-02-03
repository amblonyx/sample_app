class RelationshipsController < ApplicationController
	before_filter :not_signed_in_user
	
	def create
		@user = User.find(params[:relationship][:followed_id])
		current_user.follow!(@user)
		# if html request then redirect to user page, otherwise (ajax) call create.js.erb
		respond_to do |format|
			format.html { redirect_to @user }
			format.js
		end
	end

	def destroy 
		@user = Relationship.find(params[:id]).followed
		current_user.unfollow!(@user)
		# if ajax, call destroy.js.erb
		respond_to do |format|
			format.html { redirect_to @user }
			format.js
		end
	end
end