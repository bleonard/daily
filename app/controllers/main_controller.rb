class MainController < ApplicationController
  def home
    redirect_to root_url unless current_user
  end
end