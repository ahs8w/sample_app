require 'spec_helper'

describe "StaticPages" do

  subject { page }         # sets variable 'page' as RSpec subject ( subj should... ) -> from Capybara
  # let(:base_title) { "Ruby on Rails Tutorial Sample App" }  --> moved to spec/support/utilities.rb
 
  shared_examples_for "all static pages" do     # RSpec shared example -> it_should_behave_like "shared example"
  # it { should have_content(heading) }                   # too vague, may result in false positive
    it { should have_selector('h1', text: heading) }      # more specific test for exact presence
    it { should have_title(full_title(page_title)) }
  end

  describe "Home page" do
    before { visit root_path }                # visit: Capybara function

    let(:heading)    { 'Sample App' }         # replaces: it { should have_content('Sample App') }
    let(:page_title) { '' }                   # replaces: it { should have_title(full_title('')) }
    it_should_behave_like "all static pages" 
    it { should_not have_title('| Home') }    

    describe "for signed-in users" do
      let(:user) { FactoryGirl.create(:user) }
      before do
        FactoryGirl.create(:micropost, user: user, content: "Lorem ipsum")
        FactoryGirl.create(:micropost, user: user, content: "Dolor sit amet")
        sign_in user
        visit root_path
      end

      it "should render the user's feed" do
        user.feed.each do |item|
          expect(page).to have_selector("li##{item.id}", text: item.content)
        end
      end

      describe "the sidebar" do

        it "micropost counts should pluralize correctly" do
          expect(page).to have_content("2 microposts")
          first(:link, "delete").click
          expect(page).to have_content("micropost")
        end

        describe "micropost pagination" do
          before do
            50.times { FactoryGirl.create(:micropost, user: user, content: "whatever") }
            visit root_path
          end
          after(:all) { Micropost.delete_all }

          it { should have_selector('div.pagination') }
        end
      end
    end
  end

  describe "Help page" do
    before { visit help_path }

    page_info("Help")                         # helper method defined in utilities.rb
    it_should_behave_like "all static pages"
  end

  describe "About page" do
    before { visit about_path }

    page_info("About")
    it_should_behave_like "all static pages"
  end

  describe "Contact page" do
    before { visit contact_path }

    page_info("Contact")
    it_should_behave_like "all static pages"
  end

  it "should have the right links on the layout" do
    visit root_path
    click_link "About"
    expect(page).to have_title(full_title("About"))
    click_link "Help"
    expect(page).to have_title(full_title('Help'))
    click_link "Contact"
    expect(page).to have_title(full_title('Contact'))
    click_link "Home"
    expect(page).to have_title(full_title(''))
    click_link "Sign up now!"
    expect(page).to have_title(full_title('Sign Up'))
    click_link "sample app"
    expect(page).to have_title(full_title(''))
  end
end
