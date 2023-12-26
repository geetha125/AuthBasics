class SessionsController < ApplicationController   
  
  def new 
  end   

  # def create   

  #   @user = User.find_by(email: params[:email])  
  #   if @user    
  #       if params[:otp].present? && @user.otp == params[:otp].to_i
  #         login(@user)  
  #         redirect_to list_users_path
  #       elsif @user.authenticate(params[:password])
  #          flash[:notice] = "Please enter OTP to complete login"
  #          redirect_to root_path
  #       else
  #          flash[:alert] = "Invalid email or password"
  #          render :new, status: :unprocessable_entity
  #       end
  #   else 
  #      flash[:alert] = "Invalid email or password"
  #      render :new, status: :unprocessable_entity
  #   end  
  #   new_otp = rand(100000-999999)  
  #   @user.update(otp: new_otp)  
  #   logger.info(new_otp)

  # end   


  def check_users  
  	 @user = User.find_by(email: params[:email])  
  	 Rails.logger.info "--------- test user #{@user} ----> #{params}"
    if @user
      redirect_to render_password_path(email: @user.email)
    else
      flash[:alert] = 'User not found.'
     
    end
  end  
  
   def render_password  
  	  render :authenticate_with_password 
   end  

  

  def authenticate_with_password
  	Rails.logger.info "----dssdd email params == #{params[:email]}"
    
     Rails.logger.info "----dssdd email params == #{params[:email]} -----> password  === #{params[:password]}"   
  	 @user = User.find_by(email: params[:email])   
  	 if @user.authenticate(params[:password]) 
  	    login(@user) 
        redirect_to list_users_path 
     else  
     	flash[:alert] = "Invalid email or password"
    end
  end   


 

  def authenticate_with_otp         
  	 @user = User.find_by(email: params[:email])    
  	 Rails.logger.info "------- Changes made #{@user}"  
     if @user    
     	 new_otp = rand(100000-999999)  
         @user.update(otp: new_otp)    
         Rails.logger.info("*****************#{new_otp}*************************")
        if params[:otp].present? && @user.otp == params[:otp] 
        	login(@user)  
            redirect_to list_users_path  
        else
           flash[:alert] = "Invalid otp"
        end  
     else  
       flash[:alert] = 'User not found.'
       
     end
  end    
  
  



  def welcome   
  end
  

  def generate_and_set_otp
    Rails.logger.info("the email.............................;;;;;;;;;;;;;;;;;;;;#{params[:email]}")
    user = User.find_by(email: params[:email])     
    user.update(otp: generate_otp)    
    Rails.logger.info("this is ***********************************#{user[:otp]}")
    if user.save
      render json: { message: 'OTP generated and updated successfully' }, status: :ok
    else
      render json: { error: 'Failed to generate and set OTP' }, status: :unprocessable_entity
    end
  end





  def generate_otp
    require 'securerandom'
    random_string = SecureRandom.hex(3)
    random_string = random_string[0, 6] 
    random_string

  end  



  def new_auth   
   
   @user = User.find_by(email: params[:email])   

   Rails.logger.info("user for :)))................")
   if @user.present?  

     if params[:auth_type] == 'password' && params[:password].present?  
        if @user.authenticate(params[:password])
            session[:user_id] = @user.id  
            current_user = session[:user_id]
            Rails.logger.info("Successfully logged in using password")
            redirect_to root_path
         else
            flash[:alert] = "Invalid email or password"
         end

      elsif params[:auth_type] == 'otp' && params[:otp].present?
         Rails.logger.info("-------------You chose OTP login--------------------")
          if @user.otp == params[:otp]
             session[:user_id] = @user.id
             Rails.logger.info("Successfully logged in using OTP") 
             redirect_to root_path
            
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

  end    
 


  def list_users     
    if session[:user_id]&.is_admin?    
       Rails.logger.info("/helloooooo............................................................")   
        @users = User.all

    else
    	#@users = []  
    	Rails.logger.info("#######################################welcome to mah page*****************************")
    	redirect_to root_path,notice: "You don't have access to this page!"
    end
  end    


  def destroy  
	   logout session[:user_id]
	   redirect_to root_path,notice: "You have logged out!"
  end    
end