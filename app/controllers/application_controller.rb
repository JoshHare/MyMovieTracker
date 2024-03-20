class ApplicationController < ActionController::Base
  before_action :set_user

  private

  def set_user
    @current_user = User.find_by(userid: session[:user_id]) if session[:user_id].present?
    puts @current_user
  end
end
