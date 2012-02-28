require 'test_helper'

class TournamentTest < ActiveSupport::TestCase
  test "validity of fixtures" do
    assert tournaments(:all_tournament).valid?
    assert tournaments(:grand_master_tournament).valid?
    assert tournaments(:master_tournament).valid?
    assert tournaments(:empty_tournament).valid?
    assert tournaments(:full_tournament).valid?
  end

  test "league validations" do
    all_tournament = tournaments(:all_tournament)
    gm_tournament = tournaments(:grand_master_tournament)

    all_tournament.league = nil
    gm_tournament.league = -1

    assert !all_tournament.valid?
    assert !gm_tournament.valid?
  end

  test "type validations" do
    all_tournament = tournaments(:all_tournament)
    gm_tournament = tournaments(:grand_master_tournament)
    master_tournament = tournaments(:master_tournament)

    all_tournament.type = nil
    gm_tournament.type = 'FakeTournament'
    master_tournament.type = 'DoubleEliminationTournament'
    
    assert !all_tournament.valid?
    assert !gm_tournament.valid?
    assert !master_tournament.valid?
  end

  test "start time validations" do
    all_tournament = tournaments(:all_tournament)
    master_tournament = tournaments(:master_tournament)
    new_tournament_params = {
      start_time: 1.hours.from_now,
      registration_time: Time.now,
      type: 'SingleEliminationTournament',
      name: 'New Tournament'
    }
    new_tournament = Tournament.new new_tournament_params, as: :admin
    control_tournament = Tournament.new new_tournament_params, as: :admin

    all_tournament.start_time = nil
    master_tournament.start_time = 1.hours.ago
    new_tournament.start_time = 1.hours.ago

    assert !all_tournament.valid?
    assert master_tournament.valid?
    assert control_tournament.valid?
    assert !new_tournament.valid?
  end

  test "registration time validations" do
    all_tournament = tournaments(:all_tournament)
    new_tournament_params = {
      start_time: 1.hours.from_now,
      registration_time: Time.now,
      type: 'SingleEliminationTournament',
      name: 'New Tournament'
    }
    new_tournament = Tournament.new new_tournament_params, as: :admin
    control_tournament = Tournament.new new_tournament_params, as: :admin

    all_tournament.registration_time = nil
    new_tournament.registration_time = 5.hours.from_now

    assert !all_tournament.valid?
    assert control_tournament.valid?
    assert !new_tournament.valid?
  end

  test "max players validations" do
    all_tournament = tournaments(:all_tournament)
    empty_tournament = tournaments(:empty_tournament)
    gm_tournament = tournaments(:grand_master_tournament)

    all_tournament.max_players = nil
    empty_tournament.max_players = 0
    gm_tournament.max_players = 65

    assert !all_tournament.valid?
    assert !empty_tournament.valid?
    assert !gm_tournament.valid?
  end

  test "name validations" do
    all_tournament = tournaments(:all_tournament)
    gm_tournament = tournaments(:grand_master_tournament)
    master_tournament = tournaments(:master_tournament)
    empty_tournament = tournaments(:empty_tournament)

    all_tournament.name = nil
    gm_tournament.name = master_tournament.name
    master_tournament.name = '123'
    empty_tournament.name = '123456789012345678901234567890'
    
    assert !all_tournament.valid?
    assert !gm_tournament.valid?
    assert !master_tournament.valid?
    assert !empty_tournament.valid?
  end

  test "waiting players validations" do
    all_tournament = tournaments(:all_tournament)    
    gm_tournament = tournaments(:grand_master_tournament)

    all_tournament.max_players = all_tournament.waiting_players.size - 1
    all_tournament.waiting_players.each do |player|
      player.player_accepted = true
    end

    gm_tournament.league = Tournament::MASTER

    assert !all_tournament.valid?
    assert !gm_tournament.valid?
  end

  test "guest accessible attributes" do
    tournament_params = {
      league: -1,
      type: 'FakeTournament',
      start_time: Time.now,
      registration_time: 1.hours.ago,
      max_players: 100
    }

    new_tournament = Tournament.new tournament_params, as: :guest

    assert_equal 0, new_tournament.league
    assert_nil new_tournament.type
    assert_nil new_tournament.start_time
    assert_nil new_tournament.registration_time
    assert_equal 20, new_tournament.max_players
  end

  test "member accessible attributes" do
    tournament_params = {
      league: -1,
      type: 'FakeTournament',
      start_time: Time.now,
      registration_time: 1.hours.ago,
      max_players: 100
    }

    new_tournament = Tournament.new tournament_params, as: :member

    assert_equal 0, new_tournament.league
    assert_nil new_tournament.type
    assert_nil new_tournament.start_time
    assert_nil new_tournament.registration_time
    assert_equal 20, new_tournament.max_players
  end

  test "moderator accessible attributes" do
    start_time = Time.now
    registration_time = 1.hours.ago
    tournament_params = {
      league: -1,
      type: 'TournamentType',
      start_time: start_time,
      registration_time: registration_time,
      max_players: 100
    }
    
    new_tournament = Tournament.new tournament_params, as: :moderator

    assert_equal -1, new_tournament.league
    assert_equal 'TournamentType', new_tournament.type
    assert_equal start_time, new_tournament.start_time
    assert_equal registration_time, new_tournament.registration_time
    assert_equal 100, new_tournament.max_players
  end

  test "admin accessible attributes" do
    start_time = Time.now
    registration_time = 1.hours.ago
    tournament_params = {
      league: -1,
      type: 'TournamentType',
      start_time: start_time,
      registration_time: registration_time,
      max_players: 100
    }
    
    new_tournament = Tournament.new tournament_params, as: :admin

    assert_equal -1, new_tournament.league
    assert_equal 'TournamentType', new_tournament.type
    assert_equal start_time, new_tournament.start_time
    assert_equal registration_time, new_tournament.registration_time
    assert_equal 100, new_tournament.max_players
  end

  test "started method" do
    all_tournament = tournaments(:all_tournament)
    gm_tournament = tournaments(:grand_master_tournament)

    all_tournament.start_time = 5.minutes.ago
    gm_tournament.start_time = 5.minutes.from_now

    assert all_tournament.started?
    assert !gm_tournament.started?
  end

  test "structure not created on arbitrary save" do
    empty_tournament = tournaments(:empty_tournament)
    empty_tournament.start_time = 100.hours.from_now

    assert_no_difference 'Match.count' do
      empty_tournament.save
    end
  end

  test "update should recreate structure tournament" do
    gm_tournament = tournaments(:grand_master_tournament)
    gm_tournament.max_players = 8
    num_old_matches = gm_tournament.matches.length

    assert_difference 'Match.count', 7 - num_old_matches do
      gm_tournament.save
    end
  end

  test "should not update structure if max players unchanged" do
    gm_tournament = tournaments(:grand_master_tournament)
    gm_tournament.locked = true

    assert_no_difference 'Match.count' do
      gm_tournament.save
    end
  end
end
