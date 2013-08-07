require 'spec_helper'

describe "Contacts" do

  before :each do
    @user = create :active_user
    visit "/en/user_sessions/new"
    within('form#new_user_session') do
      fill_in 'user_session_email', with: @user.email
      fill_in 'user_session_password', with: 'password'
      click_button('Login')
    end
    @c1 = create :contact, user: @user
    @c2 = create :contact, user: @user
  end

  describe "GET /contacts" do
    it "shows the list of entries" do
      visit '/contacts'
      current_path.should == "/contacts"
      page.should have_content(@c1.first_name)
      page.should have_content(@c1.middle_name)
      page.should have_content(@c1.last_name)
      page.should have_content(@c2.first_name)
      page.should have_content(@c2.middle_name)
      page.should have_content(@c2.last_name)
    end

    it 'updates the entry', js: true do
      visit '/contacts'
      find("a[href='/en/contacts/#{@c1.id}/edit']").click
      fill_in 'contact_first_name', with: 'New_first_name'
      click_button 'Update Contact'
      page.should have_content 'New_first_name'
    end

    it 'deletes the entry', js: true do
      visit '/contacts'
      find("a[href='/en/contacts/#{@c1.id}'].destroy").click
      page.should_not have_content @c1.first_name
    end

    it 'creates new entry', js: true do
      visit '/contacts'
      find("a[href='/en/contacts/new']").click
      fill_in 'contact_first_name', with: 'New_first_name'
      click_button 'Create Contact'
      page.should have_content 'New_first_name'
      Contact.count.should == 3
    end
  end
end
