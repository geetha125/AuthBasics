class ApplicationController < ActionController::Base  
     
  def current_user  
    @current_user ||= authenticate_user_from_session
  end 
   helper_method :current_user


  def authenticate_user_from_session  
    User.find_by(id: session[:user_id])   
  end  
  helper_method :authenticate_user_from_session  


  def user_signed_in? 
    current_user.present?
  end  
  helper_method :user_signed_in?  


  def login(user)
    @current_user = user   

    reset_session 
    session[:user_id] = user.id # Use user.id to store the user's ID in the session
  end 


  def logout(user)
    @current_user = nil 
    reset_session 
  end  
  

end  
  


