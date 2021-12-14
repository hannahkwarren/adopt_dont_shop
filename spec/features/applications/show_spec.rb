require 'rails_helper'

RSpec.describe 'Application show page', type: :feature do 

    before(:each) do

        @helping_hounds = Shelter.create!(name: 'Helping Hounds', city: 'Syracuse, NY', foster_program: false, rank: 2)

        @max = Pet.create!(name: 'Max', age: 1, breed: 'Great Dane', adoptable: true, shelter_id: @helping_hounds.id)

        @josie = Pet.create!(name: 'Josie', age: 5, breed: 'Great Pyrenees', adoptable: true, shelter_id: @helping_hounds.id)

        @rambo = Pet.create!(name: 'Rambo', age: 1, breed: 'Chihuahua', adoptable: true, shelter_id: @helping_hounds.id)

        @application1 = @max.applications.create!(name: "John Doe", address: "123 Main Street", city: "Brooklyn", state: "NY", zip: "11205", reason: "I grew up with large dogs and want to bring the same joy into my home.", status: "in progress")

        @application1.pets << @josie
        
        @application2 = @josie.applications.create!(name: "Jeff Daniels", address: "456 Orderly Way", city: "Seattle", state: "WA", zip: "65412", reason: "I want to help as many innocent animals as I can.", status: "pending")

    end

    it 'displays applicant information for an application with each pet as a link to the pet show page' do
        visit "/applications/#{@application1.id}"

        expect(page).to have_content(@application1.name)
        expect(page).to have_content(@application1.address)
        expect(page).to have_content(@application1.city)
        expect(page).to have_content(@application1.state)
        expect(page).to have_content(@application1.zip)
        expect(page).to have_content(@application1.reason)
        expect(page).to have_content(@josie.name)
        expect(page).to have_content(@max.name)
        expect(page).to have_content(@application1.status)

        click_link "Max"
        expect(current_path).to eq("/pets/#{@max.id}")

        expect(page).to_not have_content(@application2.name)
        expect(page).to_not have_content(@application2.address)
        expect(page).to_not have_content(@application2.city)
        expect(page).to_not have_content(@application2.state)
        expect(page).to_not have_content(@application2.zip)
        expect(page).to_not have_content(@application2.reason)
        expect(page).to_not have_content(@rambo.name)
        expect(page).to_not have_content(@application2.status)
    end

    it 'only displays search when application statatus is in progress' do
        application3 = Application.create(name: "Jeff Daniels", address: "456 Orderly Way", city: "Seattle", state: "WA", zip: "65412", reason: "I want to help as many innocent animals as I can.", status: "in progress")
        application4 = Application.create(name: "James Young", address: "647 Freeport Road", city: "Seattle", state: "WA", zip: "65412", reason: "I have a big fenced in yard and no children.", status: "undefined")

        visit "/applications/#{application3.id}"
        expect(page).to have_content("Search")

        visit "/applications/#{application4.id}"
        expect(page).to_not have_content("Search")
    end
    
    it 'lists partial matches as search results' do
        shelter = Shelter.create(name: 'Aurora shelter', city: 'Aurora, CO', foster_program: false, rank: 9)
        pet_1 = Pet.create(adoptable: true, age: 7, breed: 'sphynx', name: 'Bare-y Manilow', shelter_id: shelter.id)
        pet_2 = Pet.create(adoptable: true, age: 3, breed: 'domestic pig', name: 'Babe', shelter_id: shelter.id)
        pet_3 = Pet.create(adoptable: true, age: 4, breed: 'chihuahua', name: 'Elle', shelter_id: shelter.id)
        application3 = Application.create(name: "Jeff Daniels", address: "456 Orderly Way", city: "Seattle", state: "WA", zip: "65412", reason: "I want to help as many innocent animals as I can.", status: "in progress")
    
        visit "/applications/#{application3.id}"
        expect(page).to have_content("Add A Pet to this Application")

        fill_in :search, with: "Ba"
        click_on("Search")

        expect(page).to have_content(pet_1.name)
        expect(page).to have_content(pet_2.name)
        expect(page).to_not have_content(pet_3.name)
    end

    it "search is not case-sensitive" do 
#         As a visitor
# When I visit an application show page
# And I search for Pets by name
# Then my search is case insensitive
# For example, if I search for "fluff", my search would match pets with names "Fluffy", "FLUFF", and "Mr. FlUfF"
        shelter = Shelter.create(name: 'Aurora shelter', city: 'Aurora, CO', foster_program: false, rank: 9)
        pet_1 = Pet.create(adoptable: true, age: 7, breed: 'sphynx', name: 'Bare-y Manilow', shelter_id: shelter.id)
        pet_2 = Pet.create(adoptable: true, age: 3, breed: 'domestic pig', name: 'Babe', shelter_id: shelter.id)
        pet_3 = Pet.create(adoptable: true, age: 4, breed: 'chihuahua', name: 'Elle', shelter_id: shelter.id)
        application3 = Application.create(name: "Jeff Daniels", address: "456 Orderly Way", city: "Seattle", state: "WA", zip: "65412", reason: "I want to help as many innocent animals as I can.", status: "in progress")

        visit "/applications/#{application3.id}"

        fill_in :search, with: "BA"
        click_on("Search")
        expect(page).to have_content("Bare-y Manilow")

        fill_in :search, with: "bArE"
        click_on("Search")
        expect(page).to have_content("Bare-y Manilow")

        fill_in :search, with: "manilow"
        click_on("Search")
        expect(page).to have_content("Bare-y Manilow")
    end

    it "adds a pet from search results to an application" do 
        shelter = Shelter.create(name: 'Aurora shelter', city: 'Aurora, CO', foster_program: false, rank: 9)
        pet_1 = Pet.create(adoptable: true, age: 7, breed: 'sphynx', name: 'Bare-y Manilow', shelter_id: shelter.id)
        pet_2 = Pet.create(adoptable: true, age: 3, breed: 'domestic pig', name: 'Babe', shelter_id: shelter.id)
        pet_3 = Pet.create(adoptable: true, age: 4, breed: 'chihuahua', name: 'Elle', shelter_id: shelter.id)
        application10 = Application.create(name: "Jeff Daniels", address: "456 Orderly Way", city: "Seattle", state: "WA", zip: "65412", reason: "I want to help as many innocent animals as I can.", status: "in progress")

        visit "/applications/#{application10.id}"

        fill_in :search, with: "Ba"
        click_on("Search")

        click_button("Adopt Bare-y Manilow") 

        expect(current_path).to eq("/applications/#{application10.id}")
        expect(application10.pets).to match_array([pet_1])

        expect(page).to have_content("Bare-y Manilow")
        expect(page).to_not have_content("Babe")
        expect(page).to_not have_content("Elle")
    end

    it "submits the application after one or more pets is added" do
        shelter = Shelter.create(name: 'Aurora shelter', city: 'Aurora, CO', foster_program: false, rank: 9)
        pet_1 = Pet.create(adoptable: true, age: 7, breed: 'sphynx', name: 'Bare-y Manilow', shelter_id: shelter.id)
        pet_2 = Pet.create(adoptable: true, age: 3, breed: 'domestic pig', name: 'Babe', shelter_id: shelter.id)
        pet_3 = Pet.create(adoptable: true, age: 4, breed: 'chihuahua', name: 'Elle', shelter_id: shelter.id)
        application10 = Application.create(name: "Jeff Daniels", address: "456 Orderly Way", city: "Seattle", state: "WA", zip: "65412", reason: "I want to help as many innocent animals as I can.",status: "in progress")

        visit "/applications/#{application10.id}"

        fill_in :search, with: "Ba"
        click_on("Search")

        click_button("Adopt Bare-y Manilow") 

        fill_in :reason, with: "I want to help as many innocent animals as I can."
        click_button("Submit Application")

        expect(current_path).to eq("/applications/#{application10.id}")
        expect(page).to have_content("Bare-y Manilow")
        application10.reload
        expect(page).to have_content("I want to help as many innocent animals as I can.")
        expect(page).to have_content("pending")
        expect(page).to_not have_content("in progress")
    end

    it "if there are no pets, the submit section does not appear" do
        shelter = Shelter.create(name: 'Aurora shelter', city: 'Aurora, CO', foster_program: false, rank: 9)

        application10 = Application.create(name: "Jeff Daniels", address: "456 Orderly Way", city: "Seattle", state: "WA", zip: "65412", reason: "I want to help as many innocent animals as I can.", status: "in progress")

        visit "/applications/#{application10.id}"

        expect(page).to_not have_content("Tell us why you want to adopt:")
        expect(page).to_not have_content("Submit Application")
    end

end
