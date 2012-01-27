class Ability
  include CanCan::Ability

  def initialize(user)
    user ||= User.new
    
    if user.role? :guest
      can :create, User
      
      can :create, UserSession

    elsif user.role? :member
      cannot :create, User
      
      can :destroy, UserSession

      can :create, AccountInformation, user: { id: user.id }

      # Certain features require account information.
      if user.account_information
        can :create, WaitingPlayer, valid?: true
        can :destroy, WaitingPlayer, user_id: user.id
      end
      
    elsif user.role? :moderator
      # Moderators can manage users, but cannot destroy them.
      can :update, User do |user|
        user.role? :member
      end
      cannot :create, User
      
      can :destroy, UserSession
      
      can [:create, :update, :destroy], AccountInformation, user: { role: :member }
      can [:create, :update, :destroy], AccountInformation, user: { id: user.id }

      can [:create, :update, :destroy], WaitingPlayer

      can :update, Tournament

    elsif user.role? :admin
      # Admins can manage all resources.
      can :manage, :all
    end

    can :read, User
    can :manage, User, id: user.id
    
    can :read, AccountInformation

    can :read, Tournament
  end
end
