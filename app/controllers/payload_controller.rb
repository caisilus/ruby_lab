class PayloadController < ApplicationController
  protect_from_forgery with: :null_session

  def create
    puts params
  end
end
