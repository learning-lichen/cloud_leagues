class UserSession < Authlogic::Session::Base
  def to_key
    [session_key]
  end
  
  def to_partial_path
    "user_sessions/#{self.class.name.underscore}"
  end
end
