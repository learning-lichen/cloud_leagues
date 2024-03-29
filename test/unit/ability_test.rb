require 'test_helper'

class AbilityTest < ActiveSupport::TestCase
  ##############################################################################
  # User Modification Abilities                                                #
  ##############################################################################
  test "guest can read users" do
    ability = Ability.new(nil)

    assert ability.can?(:read, users(:default_user))
    assert ability.can?(:read, users(:admin_user))
    assert ability.can?(:read, users(:moderator_user))
  end

  test "guest can create user" do
    ability = Ability.new(nil)

    assert ability.can?(:create, User.new)
  end

  test "guest cannot update users" do
    ability = Ability.new(nil)

    assert ability.cannot?(:update, users(:default_user))
    assert ability.cannot?(:update, users(:admin_user))
    assert ability.cannot?(:update, users(:moderator_user))
  end

  test "guest cannot destroy users" do
    ability = Ability.new(nil)

    assert ability.cannot?(:destroy, users(:default_user))
    assert ability.cannot?(:destroy, users(:admin_user))
    assert ability.cannot?(:destroy, users(:moderator_user))
  end

  test "member can read users" do
    ability = Ability.new(users(:default_user))

    assert ability.can?(:read, users(:default_user))
    assert ability.can?(:read, users(:other_user))
    assert ability.can?(:read, users(:admin_user))
    assert ability.can?(:read, users(:moderator_user))
  end

  test "member cannot create user" do
    ability = Ability.new(users(:default_user))

    assert ability.cannot?(:create, User.new)
  end

  test "member can only update self" do
    ability = Ability.new(users(:default_user))

    assert ability.can?(:update, users(:default_user))
    assert ability.cannot?(:update, users(:other_user))
    assert ability.cannot?(:update, users(:admin_user))
    assert ability.cannot?(:update, users(:moderator_user))
  end

  test "member can only destroy self" do
    ability = Ability.new(users(:default_user))

    assert ability.can?(:destroy, users(:default_user))
    assert ability.cannot?(:destroy, users(:other_user))
    assert ability.cannot?(:destroy, users(:admin_user))
    assert ability.cannot?(:destroy, users(:moderator_user))
  end

  test "moderator can read users" do
    ability = Ability.new(users(:moderator_user))

    assert ability.can?(:read, users(:default_user))
    assert ability.can?(:read, users(:admin_user))
    assert ability.can?(:read, users(:moderator_user))
  end

  test "moderator cannot create user" do
    ability = Ability.new(users(:moderator_user))

    assert ability.cannot?(:create, User.new)
  end

  test "moderator can update members" do
    ability = Ability.new(users(:moderator_user))

    assert ability.can?(:update, users(:default_user))
    assert ability.can?(:update, users(:moderator_user))
    assert ability.cannot?(:update, users(:other_moderator_user))
    assert ability.cannot?(:update, users(:admin_user))
  end

  test "moderator can only destroy self" do
    ability = Ability.new(users(:moderator_user))

    assert ability.cannot?(:destroy, users(:default_user))
    assert ability.can?(:destroy, users(:moderator_user))
    assert ability.cannot?(:destroy, users(:other_moderator_user))
    assert ability.cannot?(:destroy, users(:admin_user))
  end

  test "admin can read users" do
    ability = Ability.new(users(:admin_user))

    assert ability.can?(:read, users(:default_user))
    assert ability.can?(:read, users(:admin_user))
    assert ability.can?(:read, users(:moderator_user))
  end

  test "admin can create user" do
    ability = Ability.new(users(:admin_user))

    ability.can?(:create, User.new)
  end

  test "admin can update all users" do
    ability = Ability.new(users(:admin_user))

    assert ability.can?(:update, users(:default_user))
    assert ability.can?(:update, users(:moderator_user))
    assert ability.can?(:update, users(:admin_user))
  end

  test "admin can destroy all users" do
    ability = Ability.new(users(:admin_user))
    
    assert ability.can?(:destroy, users(:default_user))
    assert ability.can?(:destroy, users(:moderator_user))
    assert ability.can?(:destroy, users(:admin_user))
  end

  ##############################################################################
  # Account Information Modification Abilities                                 #
  ##############################################################################
  test "guests can read account information" do
    ability = Ability.new(nil)

    assert ability.can?(:read, account_informations(:default_information))
    assert ability.can?(:read, account_informations(:mod_information))
    assert ability.can?(:read, account_informations(:admin_information))
  end

  test "guests cannot create account information" do
    ability = Ability.new(nil)

    assert ability.cannot?(:create, AccountInformation.new)
  end

  test "guests cannot update account information" do
    ability = Ability.new(nil)

    assert ability.cannot?(:update, account_informations(:default_information))
    assert ability.cannot?(:update, account_informations(:mod_information))
    assert ability.cannot?(:update, account_informations(:admin_information))
  end

  test "guests cannot destroy account information" do
    ability = Ability.new(nil)
    
    assert ability.cannot?(:destroy, account_informations(:default_information))
    assert ability.cannot?(:destroy, account_informations(:mod_information))
    assert ability.cannot?(:destroy, account_informations(:admin_information))
  end

  test "members can read accout information" do
    ability = Ability.new(users(:default_user))

    assert ability.can?(:read, account_informations(:default_information))
    assert ability.can?(:read, account_informations(:mod_information))
    assert ability.can?(:read, account_informations(:admin_information))
  end

  test "members can create one account information" do
    default_ability = Ability.new(users(:default_user))
    other_ability = Ability.new(users(:other_user))

    default_ability.cannot?(:create, AccountInformation.new)
    other_ability.can?(:create, AccountInformation.new)
  end

  test "members can update their account information" do
    ability = Ability.new(users(:default_user))

    assert ability.can?(:update, account_informations(:default_information))
    assert ability.cannot?(:update, account_informations(:mod_information))
    assert ability.cannot?(:update, account_informations(:admin_information))
  end

  test "members cannot destroy account information" do
    ability = Ability.new(users(:default_user))

    assert ability.cannot?(:destroy, account_informations(:default_information))
    assert ability.cannot?(:destroy, account_informations(:mod_information))
    assert ability.cannot?(:destroy, account_informations(:admin_information))
  end

  test "moderators can read account information" do
    ability = Ability.new(users(:moderator_user))

    assert ability.can?(:read, account_informations(:default_information))
    assert ability.can?(:read, account_informations(:mod_information))
    assert ability.can?(:read, account_informations(:admin_information))
  end

  test "moderators can create account information for members" do
    ability = Ability.new(users(:moderator_user))
    other_user = users(:other_user)

    assert ability.can?(:create, other_user.build_account_information)
  end

  test "moderators can update account information for members" do
    ability = Ability.new(users(:moderator_user))

    assert ability.can?(:update, account_informations(:default_information))
    assert ability.can?(:update, account_informations(:mod_information))
    assert ability.cannot?(:update, account_informations(:other_mod_information))
    assert ability.cannot?(:update, account_informations(:admin_information))
  end

  test "moderators can destroy account information for members" do
    ability = Ability.new(users(:moderator_user))

    assert ability.can?(:destroy, account_informations(:default_information))
    assert ability.can?(:destroy, account_informations(:mod_information))
    assert ability.cannot?(:destroy, account_informations(:other_mod_information))
    assert ability.cannot?(:destroy, account_informations(:admin_information))
  end

  test "admin can read account information" do
    ability = Ability.new(users(:admin_user))

    assert ability.can?(:read, account_informations(:default_information))
    assert ability.can?(:read, account_informations(:mod_information))
    assert ability.can?(:read, account_informations(:admin_information))
  end

  test "admins can create account information for users" do
    ability = Ability.new(users(:admin_user))
    default_id = users(:default_user).id
    admin_id = users(:admin_user).id
    mod_id = users(:moderator_user).id
    o_mod_id = users(:other_moderator_user).id
    
    assert ability.can?(:create, AccountInformation.new(:user_id => default_id))
    assert ability.can?(:create, AccountInformation.new(:user_id => mod_id))
    assert ability.can?(:create, AccountInformation.new(:user_id => admin_id))
    assert ability.can?(:create, AccountInformation.new(:user_id => o_mod_id))
  end

  test "admins can update account information for users" do
    ability = Ability.new(users(:admin_user))

    assert ability.can?(:update, account_informations(:default_information))
    assert ability.can?(:update, account_informations(:mod_information))
    assert ability.can?(:update, account_informations(:other_mod_information))
    assert ability.can?(:update, account_informations(:admin_information))
  end

  test "admins can destroy account information for users" do
    ability = Ability.new(users(:admin_user))

    assert ability.can?(:destroy, account_informations(:default_information))
    assert ability.can?(:destroy, account_informations(:mod_information))
    assert ability.can?(:destroy, account_informations(:other_mod_information))
    assert ability.can?(:destroy, account_informations(:admin_information))
  end

  ##############################################################################
  # Chat Message Modification Abilities                                        #
  ##############################################################################
  test "guest cannot read messages" do
    ability = Ability.new nil

    assert ability.cannot?(:read, ChatMessage)
  end

  test "guest cannot create messages" do
    ability = Ability.new nil

    assert ability.cannot?(:create, ChatMessage)
  end

  test "guest cannot destroy messages" do
    ability = Ability.new nil

    assert ability.cannot?(:destroy, ChatMessage)
  end

  test "members without account info cannot interact with messages" do
    ability = Ability.new users(:other_user)

    assert ability.cannot?(:index, ChatMessage)
    assert ability.cannot?(:show, ChatMessage)
    assert ability.cannot?(:create, ChatMessage)
    assert ability.cannot?(:destroy, ChatMessage)
  end

  test "members can index messages" do
    ability = Ability.new users(:default_user)

    assert ability.can?(:index, ChatMessage)
  end

  test "members can show their recieved messages " do
    ability = Ability.new users(:default_user)
    message = chat_messages(:admin_to_default)

    assert ability.can?(:show, message)
  end

  test "members can read their sent messages" do
    ability = Ability.new users(:default_user)
    message = chat_messages(:default_to_admin)

    assert ability.can?(:show, message)
  end

  test "members cannot show others messages" do
    ability = Ability.new users(:default_user)
    message = chat_messages(:admin_to_mod)
    
    assert ability.cannot?(:show, message)
  end

  test "members can create messages with their sender id" do
    user = users(:default_user)
    ability = Ability.new user
    message = ChatMessage.new({ sender_id: user.chat_profile.chat_id })

    assert ability.can?(:create, message)
  end

  test "members cannot create messages with other sender_id" do
    admin = users(:admin_user)
    ability = Ability.new users(:default_user)
    message = ChatMessage.new({ sender_id: admin.chat_profile.chat_id })

    assert ability.cannot?(:create, message)
  end

  test "members can destroy messages they've recieved" do
    ability = Ability.new users(:default_user)
    message = chat_messages(:admin_to_default)

    assert ability.can?(:destroy, message)
  end

  test "members cannot destroy messages they have not recieved" do
    ability = Ability.new users(:default_user)
    message = chat_messages(:default_to_admin)

    assert ability.cannot?(:destroy, message)
  end

  test "moderators can manage messages" do
    ability = Ability.new users(:moderator_user)

    assert ability.can?(:manage, ChatMessage)
  end

  test "admins can manage messages" do
    ability = Ability.new users(:admin_user)

    assert ability.can?(:manage, ChatMessage)
  end
 
  ##############################################################################
  # Tournament Modification Abilities                                          #
  ##############################################################################
  test "guest can read tournaments" do
    ability = Ability.new(nil)

    assert ability.can?(:read, tournaments(:all_tournament))
    assert ability.can?(:read, tournaments(:grand_master_tournament))
  end

  test "guest cannot create tournaments" do
    ability = Ability.new(nil)

    assert ability.cannot?(:create, Tournament)
  end
  
  test "guest cannot update tournaments" do
    ability = Ability.new(nil)

    assert ability.cannot?(:update, tournaments(:all_tournament))
    assert ability.cannot?(:update, tournaments(:grand_master_tournament))
  end

  test "guest cannot destroy tournaments" do
    ability = Ability.new(nil)
    
    assert ability.cannot?(:destroy, tournaments(:all_tournament))
    assert ability.cannot?(:destroy, tournaments(:grand_master_tournament))
  end

  test "members can read tournaments" do
    ability = Ability.new(users(:default_user))

    assert ability.can?(:read, tournaments(:all_tournament))
    assert ability.can?(:read, tournaments(:grand_master_tournament))
  end

  test "members cannot create tournaments" do
    ability = Ability.new(users(:default_user))

    assert ability.cannot?(:create, Tournament)
  end
  
  test "members cannot update tournaments" do
    ability = Ability.new(users(:default_user))

    assert ability.cannot?(:update, tournaments(:all_tournament))
    assert ability.cannot?(:update, tournaments(:grand_master_tournament))
  end

  test "members cannot destroy tournaments" do
    ability = Ability.new(users(:default_user))
    
    assert ability.cannot?(:destroy, tournaments(:all_tournament))
    assert ability.cannot?(:destroy, tournaments(:grand_master_tournament))
  end

  test "moderator can read tournaments" do
    ability = Ability.new(users(:moderator_user))

    assert ability.can?(:read, tournaments(:all_tournament))
    assert ability.can?(:read, tournaments(:grand_master_tournament))
  end

  test "moderator cannot create tournaments" do
    ability = Ability.new(users(:moderator_user))

    assert ability.cannot?(:create, Tournament)
  end
  
  test "moderator can update tournaments" do
    ability = Ability.new(users(:moderator_user))

    assert ability.can?(:update, tournaments(:all_tournament))
    assert ability.can?(:update, tournaments(:grand_master_tournament))
  end

  test "moderator cannot destroy tournaments" do
    ability = Ability.new(users(:moderator_user))
    
    assert ability.cannot?(:destroy, tournaments(:all_tournament))
    assert ability.cannot?(:destroy, tournaments(:grand_master_tournament))
  end

  test "admin can read tournaments" do
    ability = Ability.new(users(:admin_user))

    assert ability.can?(:read, tournaments(:all_tournament))
    assert ability.can?(:read, tournaments(:grand_master_tournament))
  end

  test "admin can create tournaments" do
    ability = Ability.new(users(:admin_user))

    assert ability.can?(:create, Tournament)
  end
  
  test "admin can update tournaments" do
    ability = Ability.new(users(:admin_user))

    assert ability.can?(:update, tournaments(:all_tournament))
    assert ability.can?(:update, tournaments(:grand_master_tournament))
  end

  test "admin can destroy tournaments" do
    ability = Ability.new(users(:admin_user))
    
    assert ability.can?(:destroy, tournaments(:all_tournament))
    assert ability.can?(:destroy, tournaments(:grand_master_tournament))
  end

  ##############################################################################
  # Waiting Player Modification Abilities                                      #
  ##############################################################################
  test "guest cannot create waiting player" do
    ability = Ability.new(nil)

    assert ability.cannot?(:create, WaitingPlayer)
  end

  test "guest cannot update waiting player" do
    ability = Ability.new(nil)

    assert ability.cannot?(:update, waiting_players(:default_waiting_all))
  end

  test "guest cannot destroy waiting player" do
    ability = Ability.new(nil)

    assert ability.cannot?(:destroy, waiting_players(:default_waiting_all))
  end

  test "member can create waiting player" do
    default_user = users(:default_user)
    ability = Ability.new(default_user)
    waiting_players(:default_waiting_all).destroy
    
    all_tournament = tournaments(:all_tournament)
    new_player = all_tournament.waiting_players.build
    new_player.user_id = default_user.id

    assert ability.can?(:create, new_player)
  end

  test "member cannot create waiting player if already waiting" do
    default_user = users(:default_user)
    ability = Ability.new(default_user)
    
    all_tournament = tournaments(:all_tournament)
    new_player = all_tournament.waiting_players.build
    new_player.user_id = default_user.id

    assert ability.cannot?(:create, new_player)
  end

  test "member cannot create waiting player without account information" do
    other_user = users(:other_user)
    ability = Ability.new(other_user)

    all_tournament = tournaments(:all_tournament)
    new_player = all_tournament.waiting_players.build
    new_player.user_id = other_user.id

    assert ability.cannot?(:create, new_player)
  end

  test "member cannot create waiting player for started tournament" do
    default_user = users(:default_user)
    ability = Ability.new(default_user)

    started_tournament = tournaments(:started_tournament)
    new_player = started_tournament.waiting_players.build
    new_player.user_id = default_user.id

    assert started_tournament.valid?
    assert started_tournament.started?
    assert ability.cannot?(:create, new_player)
  end

  test "memeber cannot update waiting player" do
    ability = Ability.new(users(:default_user))

    assert ability.cannot?(:update, waiting_players(:default_waiting_all))
  end

  test "member can destroy their waiting player" do
    ability = Ability.new(users(:default_user))

    assert ability.can?(:destroy, waiting_players(:default_waiting_all))
    assert ability.cannot?(:destroy, waiting_players(:admin_waiting_all))
  end

  test "moderators can create waiting player" do
    moderator_user = users(:moderator_user)
    ability = Ability.new(moderator_user)

    master_tournament = tournaments(:master_tournament)
    master_tournament.waiting_players.each { |wp| wp.destroy }
    new_player = master_tournament.waiting_players.build
    new_player.user_id = moderator_user.id

    all_tournament = tournaments(:all_tournament)
    bad_player = all_tournament.waiting_players.build
    bad_player.user_id = moderator_user.id

    assert ability.can?(:create, new_player)
    assert ability.cannot?(:create, bad_player)
  end

  test "moderators can update waiting player" do
    ability = Ability.new(users(:moderator_user))

    mod_waiting_all = waiting_players(:mod_waiting_all)
    default_waiting_all = waiting_players(:default_waiting_all)

    assert ability.can?(:update, mod_waiting_all)
    assert ability.can?(:update, default_waiting_all)
  end

  test "moderators can destroy waiting player" do
    ability = Ability.new(users(:moderator_user))

    mod_waiting_all = waiting_players(:mod_waiting_all)
    default_waiting_all = waiting_players(:default_waiting_all)

    assert ability.can?(:destroy, mod_waiting_all)
    assert ability.can?(:destroy, default_waiting_all)
  end

  test "admins can create waiting player" do
    ability = Ability.new(users(:admin_user))

    assert ability.can?(:create, WaitingPlayer)
  end

  test "admins can update waiting player" do
    ability = Ability.new(users(:admin_user))

    assert ability.can?(:update, WaitingPlayer)
  end

  test "admins can destroy waiting player" do
    ability = Ability.new(users(:admin_user))

    assert ability.can?(:destroy, WaitingPlayer)
  end

  ##############################################################################
  # Map Modification Abilities                                                 #
  ##############################################################################
  test "guest can read maps" do
    ability = Ability.new(nil)

    assert ability.can?(:read, Map)
  end

  test "guest cannot create maps" do
    ability = Ability.new(nil)

    assert ability.cannot?(:create, Map)
  end

  test "guest cannot update maps" do
    ability = Ability.new nil

    assert ability.cannot?(:update, Map)
  end

  test "guest cannot destroy maps" do
    ability = Ability.new nil

    assert ability.cannot?(:destroy, Map)
  end

  test "member can read maps" do
    ability = Ability.new users(:default_user)

    assert ability.can?(:read, Map)
  end

  test "member cannot create maps" do
    ability = Ability.new users(:default_user)

    assert ability.cannot?(:create, Map)
  end

  test "member cannot update maps" do
    ability = Ability.new users(:default_user)

    assert ability.cannot?(:update, Map)
  end

  test "member cannot destroy maps" do
    ability = Ability.new users(:default_user)

    assert ability.cannot?(:destroy, Map)
  end

  test "moderator can read maps" do
    ability = Ability.new users(:moderator_user)

    assert ability.can?(:read, Map)
  end

  test "moderator cannot create maps" do
    ability = Ability.new users(:moderator_user)

    assert ability.cannot?(:create, Map)
  end

  test "moderator cannot update maps" do
    ability = Ability.new users(:moderator_user)

    assert ability.cannot?(:update, Map)
  end

  test "moderator cannot destroy maps" do
    ability = Ability.new users(:moderator_user)

    assert ability.cannot?(:destroy, Map)
  end

  test "admin can read maps" do
    ability = Ability.new users(:admin_user)

    assert ability.can?(:read, Map)
  end

  test "admin cannot create maps" do
    ability = Ability.new users(:admin_user)

    assert ability.can?(:create, Map)
  end

  test "admin cannot update maps" do
    ability = Ability.new users(:admin_user)

    assert ability.can?(:update, Map)
  end

  test "admin cannot destroy maps" do
    ability = Ability.new users(:admin_user)

    assert ability.can?(:destroy, Map)
  end

  ##############################################################################
  # Match Modification Abilities                                               #
  ##############################################################################
  test "guests can read matches" do
    ability = Ability.new nil

    assert ability.can?(:read, Match)
  end

  test "guest cannot update matches" do
    ability = Ability.new nil

    assert ability.cannot?(:update, Match)
  end

  test "members can read matches" do
    ability = Ability.new users(:default_user)

    assert ability.can?(:read, Match)
  end

  test "members can update their matches" do
    ability = Ability.new users(:default_user)
    match = matches :all_match_one
    
    admin_all_m1 = match_player_relations :admin_all_match_one
    admin_all_m1.accepted = true
    admin_all_m1.save

    assert ability.can? :update, match
  end

  test "members cannot update matches if both players have not accepted" do
    ability = Ability.new users(:default_user)
    match = matches :all_match_one

    assert ability.cannot? :update, match
  end

  test "members cannot update others matches" do
    ability = Ability.new users(:default_user)
    match = matches :all_match_two

    assert ability.cannot? :update, match
  end

  test "members cannot update contested matches" do
    ability = Ability.new users :default_user
    match = matches :all_match_one
    
    player_rel = match.match_player_relations.first
    player_rel.contested = true
    
    assert player_rel.save
    assert ability.cannot :update, match
  end

  test "members cannot update won matches" do
    ability = Ability.new users(:default_user)
    match = matches :all_match_one
    match.winner_id = users(:default_user).id
    
    assert match.save
    assert ability.cannot? :update, match
  end

  test "moderators can read matches" do
    ability = Ability.new users(:moderator_user)

    assert ability.can? :read, Match
  end

  test "moderators can update matches" do
    ability = Ability.new users(:moderator_user)

    assert ability.can? :update, Match
  end

  test "admins can read matches" do
    ability = Ability.new users(:admin_user)

    assert ability.can? :read, Match
  end

  test "admins can update matches" do
    ability = Ability.new users(:admin_user)

    assert ability.can? :update, Match
  end

  ##############################################################################
  # Match Player Relation Modification Abilities                               #
  ##############################################################################
  test "guest cannot update match player relations" do
    ability = Ability.new nil

    assert ability.cannot? :update, MatchPlayerRelation
  end

  test "members can update their match player relations" do
    ability = Ability.new users(:default_user)
    mpr = match_player_relations :default_all_match_one

    assert ability.can? :update, mpr
  end

  test "members cannot update other match player relations" do
    ability = Ability.new users(:default_user)
    mpr = match_player_relations :admin_all_match_one    
    
    assert ability.cannot? :update, mpr
  end

  test "moderators can update match player relations" do
    ability = Ability.new users(:moderator_user)

    assert ability.can? :update, MatchPlayerRelation
  end

  test "admins can update match player relations" do
    ability = Ability.new users(:admin_user)

    assert ability.can? :update, MatchPlayerRelation
  end

  ##############################################################################
  # Feedback Modification Abilities                                            #
  ##############################################################################
  test "guest can create anonamous feedback" do
    ability = Ability.new nil
    
    good_feedback = Feedback.new
    bad_feedback = Feedback.new
    bad_feedback.user_id = 1

    assert ability.can?(:create, good_feedback)
    assert ability.cannot?(:create, bad_feedback)
  end

  test "member can create feedback for themselves" do
    user = users :default_user
    ability = Ability.new user

    good_feedback = Feedback.new({ user_id: user.id }, as: :member)
    bad_feedback = Feedback.new({ user_id: user.id + 1 }, as: :member)

    assert ability.can?(:create, good_feedback)
    assert ability.cannot?(:create, bad_feedback)
  end

  test "moderator can create feedback for themselves" do
    user = users :moderator_user
    ability = Ability.new user

    good_feedback = Feedback.new({ user_id: user.id }, as: :moderator)
    bad_feedback = Feedback.new({ user_id: user.id + 1 }, as: :moderator)

    puts good_feedback.user_id

    assert ability.can?(:create, good_feedback)
    assert ability.cannot?(:create, bad_feedback)
  end

  test "admin can create feedback" do
    ability = Ability.new users(:admin_user)

    assert ability.can?(:create, Feedback)
  end
end
