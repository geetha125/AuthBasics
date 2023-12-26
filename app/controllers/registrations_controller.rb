class RegistrationsController < ApplicationController   

	def new   
		@user = User.new  # create new in memory object without saving it in table
	end 
    
	def create
		@user = User.new(registration_params) 

	    if @user.save   

	    	login @user
	    	redirect_to new_auth_path  
	    else 
	    	render :new , status: :unprocessable_entity 
	    end  
	end    


	def new_authentication   
   
	   @user = User.find_by(email: params[:email])   

	   Rails.logger.info("................user for :)))................")
	   if @user.present?  

	     if params[:auth_type] == 'password' && params[:password].present?  
	        if @user.authenticate(params[:password])
	            session[:user_id] = @user.id  
	            current_user = session[:user_id]
	            Rails.logger.info("Successfully logged in using password")
	            # redirect_to root_path
	        else
	            flash[:alert] = "Invalid email or password"
	        end

	     elsif params[:auth_type] == 'otp' && params[:otp].present?
	        Rails.logger.info("-------------You chose OTP login--------------------")
	          if @user.otp == params[:otp]
	             session[:user_id] = @user.id
	             Rails.logger.info("Successfully logged in using OTP") 
	            
	            
	          else
	            Rails.logger.info("Sorry, not logged in")
	            flash[:alert] = "Invalid OTP"
	          end
	       else
	        flash[:alert] = "Invalid authentication parameters"
	       end

	    else
	      flash[:alert] = 'User not found'
	    end
	    redirect_to root_path

  	end    



	private 
	def registration_params  
		params.require(:user).permit(:email,:password,:password_confirmation,:is_admin)
	end
end
