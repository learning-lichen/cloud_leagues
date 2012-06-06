require 'test_helper'

class ReplayTest < ActiveSupport::TestCase
  test "validity of fixtures" do
    assert replays(:all_match_replay_one).valid?
    assert replays(:all_match_replay_two).valid?
    assert replays(:grand_master_match_replay_one).valid?
  end

  test "game id validations" do
    replay = replays(:all_match_replay_one)
    replay.game_id = nil

    assert !replay.valid?
  end
  
  test "uploader id validations" do
    all_replay1 = replays(:all_match_replay_one)
    all_replay2 = replays(:all_match_replay_two)
    gm_replay = replays(:grand_master_match_replay_one)
    
    all_replay1.uploader_id = all_replay2.uploader_id
    all_replay1.game_id = all_replay2.game_id
    gm_replay.uploader_id = nil
    
    assert !all_replay1.valid?
    assert !gm_replay.valid?
  end
end
