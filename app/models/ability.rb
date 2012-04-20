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

      can [:create, :update], AccountInformation, user: { id: user.id }

      # Certain features require account information.
      if user.account_information
        can :create, WaitingPlayer, valid?: true, user_id: user.id, tournament: { started?: false }
        can :destroy, WaitingPlayer, user_id: user.id
      end

      can :update, Match do |match|
        !(match.waiting_players & user.waiting_players).empty?
      end

      can :update, MatchPlayerRelation do |mpr|
        user.waiting_players.include? mpr.waiting_player
      end
      
    elsif user.role? :moderator
      can :update, User do |user|
        user.role? :member
      end
      cannot :create, User
      
      can :destroy, UserSession
      
      can [:create, :update, :destroy], AccountInformation, user: { role: :member }
      can [:create, :update, :destroy], AccountInformation, user: { id: user.id }

      can :create, WaitingPlayer, valid?: true
      can [:update, :destroy], WaitingPlayer

      can :update, Tournament

      can :update, Match

      can :update, MatchPlayerRelation

    elsif user.role? :admin
      can :manage, :all
    end

    can :read, User
    can :manage, User, id: user.id
    
    can :read, AccountInformation

    can :read, Tournament

    can :read, Match

    can :read, Map
  end
end
