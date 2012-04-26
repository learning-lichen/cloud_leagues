require 'test_helper'

class MatchPlayerRelationTest < ActiveSupport::TestCase
  test "validity of fixtures" do
    assert match_player_relations(:default_all_match_one).valid?
    assert match_player_relations(:admin_all_match_one).valid?
    assert match_player_relations(:admin_grand_master_match_one).valid?
    assert match_player_relations(:default_grand_master_match_one).valid?
    assert match_player_relations(:mod_all_match_two).valid?
    assert match_player_relations(:other_mod_all_match_two).valid?
    assert match_player_relations(:mod_master_match_one).valid?
  end

  test "waiting player id validations" do
    default_all_match_one = match_player_relations(:default_all_match_one)
    default_all_match_one.waiting_player_id = nil

    assert !default_all_match_one.valid?
  end

  test "match id validations" do    
    default_all_match_one = match_player_relations(:default_all_match_one)
    default_all_match_one.match_id = nil

    assert !default_all_match_one.valid?
  end

  test "associated match validations" do
    default_all_match_one = match_player_relations(:default_all_match_one)
    all_match_one = default_all_match_one.match
    new_relation = all_match_one.match_player_relations.build

    assert !all_match_one.valid?
    assert !new_relation.valid?
  end

  test "guest accessible attributes" do
    match_relation_params = {
      match_id: 1,
      waiting_player_id: 1,
      accepted: true,
      contested: true
    }

    new_relation = MatchPlayerRelation.new match_relation_params, as: :guest

    assert_nil new_relation.match_id
    assert_nil new_relation.waiting_player_id
    assert !new_relation.accepted
    assert !new_relation.contested
  end

  test "member accessible attributes" do
    match_relation_params = {
      match_id: 1,
      waiting_player_id: 1,
      accepted: true,
      contested: true
    }

    new_relation = MatchPlayerRelation.new match_relation_params, as: :member

    assert_nil new_relation.match_id
    assert_nil new_relation.waiting_player_id
    assert new_relation.accepted
    assert new_relation.contested
  end

  test "moderator accessible attributes" do
    match_relation_params = {
      match_id: 1,
      waiting_player_id: 1,
      accepted: true,
      contested: true
    }

    new_relation = MatchPlayerRelation.new match_relation_params, as: :moderator

    assert_nil new_relation.match_id
    assert_equal 1, new_relation.waiting_player_id
    assert new_relation.accepted
    assert new_relation.contested
  end

  test "admin accessible attributes" do
    match_relation_params = {
      match_id: 1,
      waiting_player_id: 1,
      accepted: true,
      contested: true
    }

    new_relation = MatchPlayerRelation.new match_relation_params, as: :admin

    assert_nil new_relation.match_id
    assert_equal 1, new_relation.waiting_player_id
    assert new_relation.accepted
    assert new_relation.contested
  end
end
