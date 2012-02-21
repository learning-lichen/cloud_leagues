module HomeHelper
  def tournaments_for_current_user
    all_tournaments = Tournament.where 'league = :league OR league = #{Tournament::ALL} AND registration_time < #{Time.now} AND start_time > #{Time.now}', league: current_user.account_information.league
  end
end
