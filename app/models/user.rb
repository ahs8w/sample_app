class User < ActiveRecord::Base
  before_save { email.downcase! }             
      # callback method: reformats email before saving user -> mitigates risk of case-sensitivity in databases
      # same as ->  before_save { self.email = email.downcase }
  before_create :create_remember_token 
      # method reference: Rails looks for a method called 'create_remember_token' and runs before saving the user
      # passing a method reference to a callback is preferred to passing an explicit block (like w/ before_save ...)

  validates :name,  presence: true, length: { maximum: 50 }
    # same as validates(:name, presence: true)  ->  method
    # can test in console with user.valid?
  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-]+(\.[a-z]+)*\.[a-z]+\z/i
    # regex constant(starts w/ capital letter): value cannot change
  validates :email, presence: true, 
                    format: { with: VALID_EMAIL_REGEX },
                    uniqueness: { case_sensitive: false }  # default is case-sensitive we want case-insensitive -> false
                                                           # rails infers that :uniqueness should be true
    # caveat w/ uniqueness!!!! user clicks on submit twice in quick succession > both get saved despite validation
    # enforce uniqueness at db level -> create an index on email column and require index be unique
  validates :password, length: { minimum: 6 }
  has_secure_password   # links w/ password_digest column in db and allows secure authentication
                        # auto validates password/confirmation: presence, matching
                        # adds an authenticate method to compare encrypted password to password_digest
                        # console >> user.authenticate("correct_password") => returns user object

  def User.new_remember_token
    SecureRandom.urlsafe_base64
  end

  def User.encrypt(token)
    Digest::SHA1.hexdigest(token.to_s) # call .to_s is to handle nil tokens.  primarily for testing.
  end

  private  # methods defined in 'private' are hidden.  Can't even be used in console => NoMethodError
    
    def create_remember_token
      self.remember_token = User.encrypt(User.new_remember_token)
        # assignment w/out 'self' would create a local variable.  'self' insures it sets the user's 'remember_token'
    end
end                                     






# VALID_EMAIL_REGEX (simple)            www.rubular.org

# /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i  full regex
# /                                     start of regex
# \A                                    match start of a string
# [\w+\-.]+                             at least one word character, plus, hyphen, or dot
# @                                     literal “at sign”
# [a-z\d\-.]+                           at least one letter, digit, hyphen, or dot
# \.                                    literal dot
# [a-z]+                                at least one letter
# \z                                    match end of a string
# /                                     end of regex
# i                                     case insensitive

# VALID_EMAIL_REGEX (stronger)
# /\A[\w+\-.]+@[a-z\d\-]+(\.[a-z]+)*\.[a-z]+\z/i
# [a-z\d\-]+                            at least one letter, digit, hyphen -> no dot)
# (\.[a-z]+)*                           dot + at least one character -> allows dot in domain name but not ..com
# \.                                    literal dot after domain name
# [a-z]+                                at least one letter                            