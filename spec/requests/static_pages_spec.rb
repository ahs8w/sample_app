require 'spec_helper'

describe "StaticPages" do

  subject { page }         # tells RSpec the subject is page ( subj should... ) -> variable from Capybara
  # let(:base_title) { "Ruby on Rails Tutorial Sample App" }  --> moved to spec/support/utilities.rb

  describe "Home page" do
    before { visit root_path }                # visit: Capybara function

    it { should have_content('Sample App') }  # should automatically uses page variable
    it { should have_title(full_title('')) }
    it { should_not have_title('| Home') }    # replaces:
  end                                         # it "should not have a custom page title" do
                                              # expect(page).not_to have_title('| Home')
  describe "Help page" do                     # end
    before { visit help_path }

    it { should have_content('Help') }
    it { should have_title(full_title('Help')) }
  end

  describe "About page" do
    before { visit about_path }

    it { should have_content('About') }
    it { should have_title(full_title('About')) }
  end

  describe "Contact page" do
    before { visit contact_path }

    it { should have_content('Contact') }
    it { should have_title(full_title('Contact')) }
  end
end
