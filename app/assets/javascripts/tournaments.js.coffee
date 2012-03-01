$ ->
        all_check_box = '#tournament_league_127'
        $(all_check_box).change ->
                $('.leagueCheckBox').prop("checked", $(this).is(":checked"))

        $('.leagueCheckBox').change ->
                all_checked = true

                if !$(this).is(":checked")
                        $(all_check_box).prop("checked", false)

                $('.leagueCheckBox').not(all_check_box).each ->
                        all_checked = all_checked && $(this).is(":checked")

                if all_checked
                        $(all_check_box).prop("checked", true)