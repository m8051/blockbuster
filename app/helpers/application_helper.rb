module ApplicationHelper
  
  # Method moved from this helper to the Application Controller and also declared in there as helper method so views and controllers can access to it.
  #def current_user
    # The find method will raise an exception if passed a value of nil. 
    # So it's important to check that the session actually has a user id before calling find.
    # Doing this also ensures that the user id in the session corresponds to an actual user record in the database.
    # User.find(session[:user_id]) if session[:user_id]

    # We can optimize the current_user method by storing the result of calling User.find in an instance variable, 
    # and only running the query again if that instance variable doesn't already have a value.
    # To do that, change the current_user method to set a @current_user instance variable using the ||= operator, like so:
    
    # You'll often hear this idiom referred to as memoization. It's a fancy word for a simple concept. 
    # The upshot is that User.find will only be called once per request, the first time the current_user method is called.
  #  @current_user ||= User.find(session[:user_id]) if session[:user_id]
  #end

end
