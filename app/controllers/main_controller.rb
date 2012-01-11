class MainController < ApplicationController
  def home
    redirect_to root_path unless current_user
  end
end