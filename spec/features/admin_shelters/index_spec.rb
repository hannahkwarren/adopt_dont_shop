require 'rails_helper'

RSpec.describe "Admin Shelters Index" do
  
#   As a visitor
# When I visit the admin shelter index ('/admin/shelters')
# Then I see all Shelters in the system listed in reverse alphabetical order by name
  it "lists all Shelters in the system in reverse alpha order by name" do
    
    helping_hounds = Shelter.create(name: 'Helping Hounds Shelter', city: 'Aurora, CO', foster_program: false, rank: 9)

    sato_project = Shelter.create(name: 'The Sato Project', city: 'Yabucoa, PR', foster_program: false, rank: 1)

    muddy_paws = Shelter.create(name: 'Muddy Paws Pack', city: "New York, NY", foster_program: true, rank: 2)
    
    visit "/admin/shelters"

    expect(page).to have_content(helping_hounds.name)
    expect(page).to have_content(muddy_paws.name)
    expect(page).to have_content(sato_project.name)
    
    expect(sato_project.name).to appear_before(muddy_paws.name)
    expect(muddy_paws.name).to appear_before(helping_hounds.name)
  end
end
