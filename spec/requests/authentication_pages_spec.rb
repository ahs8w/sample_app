require 'spec_helper'

describe "AuthenticationPages : " do
  
  subject { page }

  describe "signin page" do
    before { visit signin_path }

    it { should have_content("Sign In") }
    it { should have_title("Sign In") }

  end

  describe "sign in" do
    before { visit signin_path }

    describe "with invalid information" do
      before { click_button "Sign In" }

      it { should have_title("Sign In") }
      it { should have_error_message('Invalid') }  
        # uses custom RSpec matcher in support/utilities.rb and replaces:
        # it { should have_selector('div.alert.alert-error', text: 'Invalid') }

      describe "after visiting another page" do
        before { click_link "Home" }
        it { should_not have_selector('div.alert.alert-error') }
      end
    end

    describe "with valid information" do
      let(:user) { FactoryGirl.create(:user) }
      before { sign_in user }

      it { should have_title(user.name) }
      it { should have_link('Users',       href: users_path) }
      it { should have_link('Profile',     href: user_path(user)) }
      it { should have_link('Settings',    href: edit_user_path(user)) }
      it { should have_link('Sign Out',    href: signout_path) }
      it { should_not have_link('Sign In', href: signin_path) }

      describe "followed by signout" do
        before { click_link "Sign Out" }
        it { should have_link('Sign In') }
        it { should_not have_link('Profile',   href: user_path(user)) }
        it { should_not have_link('Settings',  href: edit_user_path(user)) }
        it { should_not have_link('Sign Out',  href: signout_path) }
      end
    end
  end

  describe "Authorization" do

    describe "for non-signed-in users" do
      let(:user) { FactoryGirl.create(:user) }

      describe "when attempting to visit a protected page" do
        before { visit edit_user_path(user) }

        describe "after signing in" do
          before { sign_in user }

          it "should render the desired page" do    # friendly forwarding
            expect(page).to have_title('Edit user')
          end

          describe "the second time" do
            before do
              click_link 'Sign Out'
              sign_in user
            end

            it { should have_title(user.name) }
          end
        end
      end

      describe "in the Users controller" do

        describe "visiting the user index" do
          before { visit users_path }
          it { should have_title('Sign In') }
        end

        describe "visiting the edit page" do
          before { visit edit_user_path(user) }
          it { should have_title('Sign In') }
        end

        describe "submitting to the update action" do
          before { patch user_path(user) }                # 'visit' a controller action using the HTTP request
          specify { expect(response).to redirect_to(signin_path) }  # HTTP request allows access to server 'response'
        end
      end
    end

    describe "as wrong user" do
      let(:user) { FactoryGirl.create(:user) }
      let(:wrong_user) { FactoryGirl.create(:user, email: "wrong@example.com") }
      before { sign_in user, no_capybara: true }

      describe "visit Users#edit page" do
        before { visit edit_user_path(wrong_user) }
        it { should_not have_title(full_title('Edit user')) }
      end

      describe "submitting a PATCH request to the User#update action" do
        before { patch user_path(wrong_user) }
        specify { expect(response).to redirect_to(root_url) }
      end
    end

    describe "as non-admin user" do
      let(:user) { FactoryGirl.create(:user) }
      let(:non_admin) { FactoryGirl.create(:user) }

      before { sign_in non_admin, no_capybara: true }

      describe "submitting a DELETE request to the User#destroy action" do
        before { delete user_path(user) }
        specify { expect(response).to redirect_to(root_url) }
      end
    end

    describe "as an admin user" do
      let(:admin) { FactoryGirl.create(:admin) }
      before { sign_in admin, no_capybara: true }

      describe "deleting himself via DELETE request" do
        before { delete user_path(admin) }
        specify { expect(response).to redirect_to(root_url) }
      end
    end

    describe "as a signed-in user" do         # signed in user should not be able to access users#new, users#create
      let(:user) { FactoryGirl.create(:user) }
      
      describe "visiting the new user page" do
        before do
          sign_in user
          visit root_url
          click_link "Sign up now!"
        end

        it { should_not have_title("Sign Up") }
      end

      describe "submitting to the create action" do
        before do
          sign_in user, no_capybara: true
          post users_path
        end

        specify { expect(response).to redirect_to(root_url) }
      end
    end
  end
end
