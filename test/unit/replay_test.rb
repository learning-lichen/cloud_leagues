require 'test_helper'

class ReplayTest < ActiveSupport::TestCase
  test "validity of fixtures" do
    assert replays(:all_match_replay_one).valid?
    assert replays(:all_match_replay_two).valid?
    assert replays(:grand_master_match_replay_one).valid?
    assert replays(:grand_master_match_replay_two).valid?
  end

  test "match id validations" do
    replay = replays(:all_match_replay_one)
    replay.match_id = nil

    assert !replay.valid?
  end

  test "replay url validations" do
    replay = replays(:all_match_replay_one)
    replay.replay_url = nil

    assert !replay.valid?
  end
  
  test "uploader id validations" do
    replay = replays(:all_match_replay_one)
    replay.uploader_id = nil
    
    assert !replay.valid?
  end

  test "game number validations" do
    all_replay = replays :all_match_replay_one
    gm_replay_one = replays :grand_master_match_replay_one
    gm_replay_two = replays :grand_master_match_replay_two

    all_replay.game_number = nil
    gm_replay_two.game_number = gm_replay_one.game_number

    assert !all_replay.valid?
    assert !gm_replay_two.valid?
  end
end
