ENV["RAILS_ENV"] = "test"
require File.expand_path('../../config/environment', __FILE__)
require 'rails/test_help'
require 'authlogic/test_case'

class ActiveSupport::TestCase
  fixtures :all
  setup :activate_authlogic

  def login(user_login)
    UserSession.create users(user_login)
    users(user_login)
  end
end
