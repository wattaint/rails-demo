class HomeController < ApplicationController
  def index
    render json: { message: 'Rails Demo', env: ENV }
  end
end
