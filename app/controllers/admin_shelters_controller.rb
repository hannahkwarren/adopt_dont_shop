class AdminSheltersController < ApplicationController

  def index
    @shelters = Shelter.list_desc
  end
end
