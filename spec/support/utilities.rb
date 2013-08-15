include ApplicationHelper

# place to add custom test methods and RSpec matchers #

def page_info(title)                          # static_pages
  let(:heading)    { title }
  let(:page_title) { title }
end

def sign_in(user, options={})
  if options[:no_capybara]                # pass in no_capybara: true -> to override default signin method 
    #Sign in when not using Capybara        necessary when using one of the HTTP methods directly in the tests
    remember_token = User.new_remember_token
    cookies[:remember_token] = remember_token
    user.update_attribute(:remember_token, User.encrypt(remember_token))
  else
    visit signin_path
    fill_in "Email",    with: user.email
    fill_in "Password", with: user.password
    click_button "Sign In"
  end
end

RSpec::Matchers.define :have_error_message do |message|
  match do |page|
    expect(page).to have_selector('div.alert.alert-error', text: message)
  end
end
