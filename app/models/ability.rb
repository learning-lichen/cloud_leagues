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
        can :index, ChatMessage
        can :show, ChatMessage, recipient_id: user.chat_profile.chat_id
        can :show, ChatMessage, sender_id: user.chat_profile.chat_id
        can :create, ChatMessage, sender_id: user.chat_profile.chat_id
        can :destroy, ChatMessage, recipient_id: user.chat_profile.chat_id

        can :create, WaitingPlayer, valid?: true, user_id: user.id, tournament: { started?: false }
        can :destroy, WaitingPlayer, user_id: user.id
      end

      can :update, Match do |match|
        player_belongs = !(match.waiting_players & user.waiting_players).empty?
        match_contested = match.contested?

        both_players_ready = (match.match_player_relations.where(accepted: true).count == match.match_player_relations.count)

        player_belongs && !match_contested && match.winner_id.blank? && (both_players_ready || match.bye?)
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

      can :manage, ChatMessage

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
