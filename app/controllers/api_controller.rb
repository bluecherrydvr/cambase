class ApiController < ApplicationController
  def index
    render :inline => "No rule matched"
  end

end
