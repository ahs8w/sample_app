include ApplicationHelper

# place to add custom test methods and RSpec matchers #

def page_info(title)                          # static_pages
  let(:heading)    { title }
  let(:page_title) { title }
end

def valid_signin(user)                        # authentication_pages
  fill_in "Email",    with: user.email
  fill_in "Password", with: user.password
  click_button "Sign In"
end

RSpec::Matchers.define :have_error_message do |message|
  match do |page|
    expect(page).to have_selector('div.alert.alert-error', text: message)
  end
end
