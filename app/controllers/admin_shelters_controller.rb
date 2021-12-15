class AdminSheltersController < ApplicationController

  def index
    @shelters = Shelter.list_desc
    @pending_shelters = Shelter.pending_apps
  end
end
