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
    it { should_not have_title('| Home') }    # replaces:
  end                                         # it "should not have a custom page title" do
                                              # expect(page).not_to have_title('| Home')
  describe "Help page" do                     # end
    before { visit help_path }

    let(:heading)    { 'Help' }
    let(:page_title) { 'Help' }
    it_should_behave_like "all static pages"
  end

  describe "About page" do
    before { visit about_path }

    let(:heading)    { 'About' }
    let(:page_title) { 'About' }
    it_should_behave_like "all static pages"
  end

  describe "Contact page" do
    before { visit contact_path }

    let(:heading)    { 'Contact' }
    let(:page_title) { 'Contact' }
    it_should_behave_like "all static pages"
  end

  it "should have the right links on the layout" do
    visit root_path
    click_link "About"
    expect(page).to have_title(full_title('About'))
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
