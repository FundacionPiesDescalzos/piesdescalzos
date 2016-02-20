class PublicController < ApplicationController
  before_filter :authenticate_user!, only: [:index]
  def index
    render :file => 'public/index.html'
  end
  
  protected
    def authenticate_user!
      if user_signed_in?
        redirect_to visitors_path
      end
    end
end