# Filters added to this controller apply to all controllers in the application.
# Likewise, all the methods added will be available for all controllers.

class ApplicationController < ActionController::Base
  helper :all # include all helpers, all the time
#   before_filter :get_sort
#   session :session_key => '_depot_session_id'

  # See ActionController::RequestForgeryProtection for details
  # Uncomment the :secret if you're not using the cookie session store
  protect_from_forgery # :secret => '309d3be9c43d008206425d3a427456f1'
  
  # See ActionController::Base for details 
  # Uncomment this to filter the contents of submitted sensitive data parameters
  # from your application log (in this case, all fields with names like "password"). 
  # filter_parameter_logging :password

  # Auto-geocode the user's ip address and store in the session.
#   geocode_ip_address
# 
#   def geokit
#     @location = session[:geo_location]  # @location is a GeoLoc instance.
#   end

end
