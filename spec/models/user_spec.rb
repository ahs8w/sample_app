require 'spec_helper'

describe User do
  before do
    @user = User.new(name: "Example User", email: "user@example.com", 
                     password: "foobar", password_confirmation: "foobar")
  end

  subject { @user }                 # allows use of one-line style tests w/ should...

  it { should respond_to(:name) }   # uses respond_to?: accepts a symbol; >'true' if object responds to attribute
                                    # tests for existence in the db
        # it "should respond to 'name'" do
        #   expect(@user).to respond_to(:name)
        # end

  it { should respond_to(:email) }                # 'it' method applies subsequent test to subject(@user)
  it { should respond_to(:password_digest) }   
  it { should respond_to(:password) }
  it { should respond_to(:password_confirmation) }
  it { should respond_to(:remember_token) }
  it { should respond_to(:authenticate) }

  it { should be_valid }                       # mostly just a sanity check

  describe "when name is not present" do
    before { @user.name = "" }
    it { should_not be_valid }      # valid? ruby method
  end

  describe "when email is not present" do
    before { @user.email = "" }
    it { should_not be_valid  }
  end

  describe "when name is too long" do
    before { @user.name = "a" * 51 }
    it { should_not be_valid }
  end

  describe "when email format is invalid" do
    it "should be invalid" do
      addresses = %w[user@foo,com user_at_foo.org example.user@foo. foo@bar_bas.com foo@bar+baz.com foo@bar..com]
      addresses.each do |invalid_address|
        @user.email = invalid_address
        expect(@user).not_to be_valid
      end
    end
  end

  describe "when email format is valid" do
    it "should be valid" do
      addresses = %w[user@foo.COM A_US-ER@f.b.org frst.lst@foo.jp a+b@baz.cn]
      addresses.each do |valid_address|
        @user.email = valid_address
        expect(@user).to be_valid
      end
    end
  end

  describe "email address with mixed case" do
    let(:mixed_case_email) { "Foo@ExamPLe.CoM" }

    it "should be saved as all lower-case" do
      @user.email = mixed_case_email
      @user.save
      expect(@user.reload.email).to eq mixed_case_email.downcase
    end
  end

  describe "when email address is already taken" do
    before do
      user_with_same_email = @user.dup                  # .dup creates a duplicate object w/ the same attributes
      user_with_same_email.email = @user.email.upcase   # test for case-insensitivity  .valid? is case-sensitive
      user_with_same_email.save
    end

    it { should_not be_valid }
  end

  describe "when password is not present" do
    before do
      @user = User.new(name: "Example User", email: "user@example.com", 
                       password: " ", password_confirmation: " ")
    end
    it { should_not be_valid }
  end

  describe "when password doesn't match the confirmation" do
    before { @user.password_confirmation = "mismatch" }
    it { should_not be_valid }
  end

  describe "with a password that's too short" do
    before { @user.password = @user.password_confirmation = "a" * 5 }
    it { should_not be_valid }
  end

## Authentication ##
  # comparison of @user and :found_user (by email)

  describe "return value of authenticate method" do
    before { @user.save }
    let(:found_user) { User.find_by(email: @user.email) }
      # let: convenient way to create local variables for testing, 'memoized' from one invocation to the next
    describe "with valid password" do
      it { should eq found_user.authenticate(@user.password) }    # eq uses '==' to test equality
    end

    describe "with invalid password" do
      let(:user_for_invalid_password) { found_user.authenticate("invalid") }

      it { should_not eq user_for_invalid_password }
      specify { expect(user_for_invalid_password).to be_false }   # specify: same as 'it', used for linguistic sense
    end
  end

  describe "remember token" do
    before { @user.save }
    its(:remember_token) { should_not be_blank }   # 'its': similar to 'it' but tests a given attribute of subject
        # equivalent to:   it { expect(@user.remember_token).not_to be_blank }
  end
end
