require 'test_helper'

class TournamentTest < ActiveSupport::TestCase
  test "validity of fixtures" do
    assert tournaments(:all_tournament).valid?
    assert tournaments(:grand_master_tournament).valid?
  end

  test "league validations" do
    all_tournament = tournaments(:all_tournament)
    gm_tournament = tournaments(:grand_master_tournament)

    all_tournament.league = nil
    gm_tournament.league = -1

    assert !all_tournament.valid?
    assert !gm_tournament.valid?
  end

  test "format validations" do
    all_tournament = tournaments(:all_tournament)
    gm_tournament = tournaments(:grand_master_tournament)

    all_tournament.format = nil
    gm_tournament.format = -1

    assert !all_tournament.valid?
    assert !gm_tournament.valid?
  end

  test "start time validations" do
    all_tournament = tournaments(:all_tournament)
    all_tournament.start_time = nil

    assert !all_tournament.valid?
  end
end
