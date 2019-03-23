require 'redcarpet'
require 'rouge'
require 'rouge/plugins/redcarpet'

class HomeController < ApplicationController
  include Rouge::Plugins::Redcarpet
  
  def index
    #puts JSON.pretty_generate({ message: 'Rails Demo', env: ENV })
    #render text: JSON.pretty_generate({ message: 'Rails Demo', env: ENV })
   
    obj = { message: 'Rails Demo', env: ENV.to_hash }
    render json: JSON.pretty_generate(obj.as_json)
  end
end
