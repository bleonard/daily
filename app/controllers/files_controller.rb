class FilesController < ApplicationController
  def show
    send_file Rails.root.join("files/#{params[:path]}")
  end
end