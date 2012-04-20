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
      name: 'New Tournament',
      league: Tournament::ALL,
      default_best_of: 3,
      map_lists_attributes: [{map_order: 1, map_id: 1}]
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
      name: 'New Tournament',
      league: Tournament::ALL,
      default_best_of: 3,
      map_lists_attributes: [{map_order: 1, map_id: 1}]
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

  test "prize validations" do
    all_tournament = tournaments(:all_tournament)
    gm_tournament = tournaments(:grand_master_tournament)
    master_tournament = tournaments(:master_tournament)

    all_tournament.prize = nil
    gm_tournament.prize = -1
    master_tournament.prize = 5000

    assert !all_tournament.valid?
    assert !gm_tournament.valid?
    assert !master_tournament.valid?
  end

  test "default best of validations" do
    all_t = tournaments :all_tournament
    gm_t = tournaments :grand_master_tournament

    all_t.default_best_of = nil
    gm_t.default_best_of = 2

    assert !all_t.valid?
    assert !gm_t.valid?
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

  test "cannot assign map lists across tournaments" do
    map = maps :shattered_temple
    all_tournament = tournaments :all_tournament
    master_tournament = tournaments :master_tournament
    old_map_num = all_tournament.map_lists.length

    new_map_lists = {
      map_lists_attributes: [{map_id: 1, map_order: old_map_num + 1, tournament_id: all_tournament.id}]
    }
    master_tournament.update_attributes new_map_lists, as: :admin
    all_tournament.reload

    assert_equal old_map_num, all_tournament.map_lists.length
  end

  test "map list validations" do
    all_tournament = tournaments(:all_tournament)
    all_tournament.map_lists.where(map_order: 1).first.destroy

    assert !all_tournament.valid?
  end

  test "guest accessible attributes" do
    tournament_params = {
      league: -1,
      type: 'FakeTournament',
      start_time: Time.now,
      registration_time: 1.hours.ago,
      max_players: 100,
      prize: 123,
      default_best_of: 3,
      map_lists_attributes: [{ map_order: 1, map_id: 1 }]
    }

    new_tournament = Tournament.new tournament_params, as: :guest

    assert_equal 0, new_tournament.league
    assert_nil new_tournament.type
    assert_nil new_tournament.start_time
    assert_nil new_tournament.registration_time
    assert_equal 20, new_tournament.max_players
    assert_equal 0, new_tournament.prize
    assert_nil new_tournament.default_best_of
    assert new_tournament.map_lists.empty?
  end

  test "member accessible attributes" do
    tournament_params = {
      league: -1,
      type: 'FakeTournament',
      start_time: Time.now,
      registration_time: 1.hours.ago,
      max_players: 100,
      prize: 123,
      default_best_of: 3,
      map_lists_attributes: [{ map_order: 1, map_id: 1 }]
    }

    new_tournament = Tournament.new tournament_params, as: :member

    assert_equal 0, new_tournament.league
    assert_nil new_tournament.type
    assert_nil new_tournament.start_time
    assert_nil new_tournament.registration_time
    assert_equal 20, new_tournament.max_players
    assert_equal 0, new_tournament.prize
    assert_nil new_tournament.default_best_of
    assert new_tournament.map_lists.empty?
  end

  test "moderator accessible attributes" do
    start_time = Time.now
    registration_time = 1.hours.ago
    tournament_params = {
      league: -1,
      type: 'TournamentType',
      start_time: start_time,
      registration_time: registration_time,
      max_players: 100,
      prize: 123,
      default_best_of: 3,
      map_lists_attributes: [{ map_order: 1, map_id: 1 }]
    }
    
    new_tournament = Tournament.new tournament_params, as: :moderator

    assert_equal -1, new_tournament.league
    assert_equal 'TournamentType', new_tournament.type
    assert_equal start_time, new_tournament.start_time
    assert_equal registration_time, new_tournament.registration_time
    assert_equal 100, new_tournament.max_players
    assert_equal 0, new_tournament.prize
    assert_equal 3, new_tournament.default_best_of
    assert_equal 1, new_tournament.map_lists.length
  end

  test "admin accessible attributes" do
    start_time = Time.now
    registration_time = 1.hours.ago
    tournament_params = {
      league: -1,
      type: 'TournamentType',
      start_time: start_time,
      registration_time: registration_time,
      max_players: 100,
      prize: 123,
      default_best_of: 3,
      map_lists_attributes: [{ map_order: 1, map_id: 1 }]
    }
    
    new_tournament = Tournament.new tournament_params, as: :admin

    assert_equal -1, new_tournament.league
    assert_equal 'TournamentType', new_tournament.type
    assert_equal start_time, new_tournament.start_time
    assert_equal registration_time, new_tournament.registration_time
    assert_equal 100, new_tournament.max_players
    assert_equal 123, new_tournament.prize
    assert_equal 3, new_tournament.default_best_of
    assert_equal 1, new_tournament.map_lists.length
  end

  test "map list rejected if map id is blank" do
    start_time = Time.now
    registration_time = 1.hours.ago
    tournament_params = {
      league: -1,
      type: 'TournamentType',
      start_time: start_time,
      registration_time: registration_time,
      max_players: 100,
      prize: 123,
      map_lists_attributes: [{ map_order: 1 }]
    }
    
    new_tournament = Tournament.new tournament_params, as: :admin

    assert new_tournament.map_lists.empty?
  end

  test "started method" do
    all_tournament = tournaments(:all_tournament)
    gm_tournament = tournaments(:grand_master_tournament)

    all_tournament.start_time = 5.minutes.ago
    gm_tournament.start_time = 5.minutes.from_now

    assert all_tournament.started?
    assert !gm_tournament.started?
  end

  test "open spots" do
    all_tournament = tournaments(:all_tournament)
    full_tournament = tournaments(:full_tournament)

    all_open_spots = all_tournament.max_players
    all_tournament.waiting_players.each do |player|
      all_open_spots = all_open_spots - 1 if player.player_accepted
    end

    assert_equal all_open_spots, all_tournament.open_spots
    assert_equal 0, full_tournament.open_spots
  end

  test "strip inputs" do
    tournament = tournaments :grand_master_tournament
    tournament.name = '   Names   '
    tournament.save
    tournament.reload

    assert_equal 'Names', tournament.name
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

  test "starting matches" do
    all_tournament = tournaments(:all_tournament)
    gm_tournament = tournaments(:grand_master_tournament)
    empty_tournament = tournaments(:empty_tournament)
    
    first_all_match = matches(:all_match_one)

    assert_equal 2, all_tournament.starting_matches.length
    assert_equal 1, gm_tournament.starting_matches.length
    assert_equal 0, empty_tournament.starting_matches.length
  end
end
