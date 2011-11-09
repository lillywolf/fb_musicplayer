# Filters added to this controller apply to all controllers in the application.
# Likewise, all the methods added will be available for all controllers.

class ApplicationController < ActionController::Base

# Set the test variable to false when deploying!
  test = false
###################

  $APP_DATA = { 'HOST' => 'http://pure-rain-5889.heroku.com', 'APP_ID' => '107796503671', 'CANVAS_URL' => 'thebandapp', 'APP_SECRET' => '10cc0163136a373aa6192f6ceafda96e' }  
  
  helper :all # include all helpers, all the time
  protect_from_forgery # See ActionController::RequestForgeryProtection for details

  # Scrub sensitive parameters from your log
  filter_parameter_logging $APP_DATA
end
