require 'rubygems'
require 'json'
# require 'net/https'
require 'httpclient'

class CanvasController < ApplicationController
  
  layout nil
  
  def index
  end
  
  def page_tab
  end  
  
#   def setup_facebook_user
#     @current_facebook_user = facebook_session.user
#     return @current_facebook_user
#   end
#   
#   def get_facebook_friends
#     @friends = user.friends
#     return @friends
#   end 
#   
#   def facebook_friend_data
#   end     
#   
#   def get_facebook_friend_data    
#     array = Array.new
#     user = setup_facebook_user
#     
#     if user.nil?
#     else
#       friends = user.friends 
#       # friends.each do |f|
#       # 10.times { |n| array.push(friends[n]) }  
#       for friend in user.friends[0..10]
#         name = friend.name
#         array.push(name)
#       end            
#     end
#     render :json => array.to_json        
#   end  
#   
#   def invite
#     @connection_request_id = params[:connection_request_id]
#     @button_label = params[:button_label]
#     @excludeIDs = params[:excludeIDs]
#     fb_req_choice_tag = '<fb:req-choice url="http://apps.facebook.com/play-music/index.html?next=http://apps.facebook.com/play-music/index.html&connection_request_id=' + @connection_request_id.to_s() + '" label="' + @button_label + '" />'
#     @fb_req_choice_content = 'Hey, come check out my band! ' + fb_req_choice_tag
#   end
#   
#   def fbrequest
#     @connection_request_id = params[:connection_request_id]
#     @button_label = params[:button_label]
#     @content = params[:content]
#     fb_req_choice_tag = '<fb:req-choice url="http://apps.facebook.com/play-music/index.html?next=http://apps.facebook.com/play-music/index.html&connection_request_id=' + @connection_request_id.to_s() + '" label="' + @button_label + '" />'
#     @fb_req_choice_content = @content + ' ' + fb_req_choice_tag  
#     
# #    @fb_req_choice_content = @content + ' ' + '&lt;fb:req-choice url=\&quot;http://apps.facebook.com/play-music?connection_request_id=' + @connection_request_id.to_s() + '\&quot; label=\&quot;' + @button_label + '\&quot; /&gt;'  
# #    @fb_req_choice_content = @content + ' ' + '<fb:req-choice url="http://apps.facebook.com/play-music?connection_request_id=1" label="test"/>'
#   end
  
end
