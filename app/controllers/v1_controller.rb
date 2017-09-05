class V1Controller < ApplicationController
  def index
  end

  def current
  	@name = "Shyam"
  	@hello = "Hello #{params[:id]} bro"
  end
  def create
  	render plain: params[:v1].inspect
  end
end
