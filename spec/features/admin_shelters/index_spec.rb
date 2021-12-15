require 'rails_helper'

RSpec.describe "Admin Shelters Index" do
  
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

  it "section for shelters with pending applications" do

    sato_project = Shelter.create!(name: "The Sato Project", city: "Yabucoa, PR", foster_program: false, rank: 1)

    helping_hounds = Shelter.create!(name: 'Helping Hounds', city: 'Syracuse, NY', foster_program: false, rank: 2)

    muddy_paws = Shelter.create!(name: "Muddy Paws Pack", city: "New York", foster_program: true, rank: 3)

    buster = Pet.create!(name: "Buster", age: 2, breed: "Daschund", adoptable: true, shelter_id: helping_hounds.id)

    pickles = Pet.create!(name: "Pickles", age: 1, breed: "Black Labrador", adoptable: true, shelter_id: helping_hounds.id)

    chase = Pet.create!(name: "Chase", age: 1, breed: "Mix", adoptable: true, shelter_id: sato_project.id)

    app1 = pickles.applications.create!(name: "Zachary Werheim", address: "187 Worthington Way", city: "Brooklyn", state: "NY", zip: "11205", reason: "I've always loved labradors and now that I work from home I'll be able to spend a lot of time with him!", status: "pending")

    app2 = pickles.applications.create!(name: "Jonathan Adler", address: "173 Main Street", city: "London", state: "Maine", zip: "12498", reason: "I love labradors!", status: "in progress")

    app3 = chase.applications.create!(name: "Derry Barker", address: "209 Ralston Road", city: "Sarver", state: "PA", zip: "16055", reason: "He'd be a great addition to my family.", status: "pending")

    visit "/admin/shelters"

    within("#pending-shelters") do 
      expect(page).to have_content("Helping Hounds")
      expect(page).to have_content("The Sato Project")
    end
  end
end
