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

    $('#hideShowQuickInfo').click ->
        if $('#quickInfoContainer').css('display') == 'none'
            $('#hideShowQuickInfo').text('Hide')
            $('#quickInfoContainer').slideDown(750)
        else
            $('#hideShowQuickInfo').text('Show')
            $('#quickInfoContainer').slideUp(750)

    $('#hideShowPlayerList').click ->
        if $('#playerListContainer').css('display') == 'none'
            $('#hideShowPlayerList').text('Hide')
            $('#playerListContainer').slideDown(750)
        else
            $('#hideShowPlayerList').text('Show')
            $('#playerListContainer').slideUp(750)

    $('#roundSelector #round1').addClass('roundSelected')
    $('#partialBracketDisplay #round1Content').addClass('roundContentSelected')
    $('.roundSelectionNumber').click ->
        $('.roundSelectionNumber').removeClass('roundSelected')

        $(this).addClass('roundSelected')
        $('.roundContentSelected').toggleClass('roundContentSelected')
        $('#' + this.id + 'Content').toggleClass('roundContentSelected')
