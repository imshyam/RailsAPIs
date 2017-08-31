class V1Controller < ApplicationController
  def index
  end

  def current
  	@name = "Shyam"
  	@hello = "Hello #{params[:id]} bro"
  end
end
