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

    if $('.activeMapListRow').length == 1
        $('.removeMapList').css('display', 'none')

    $('.removeMapList').click ->
        $(this).prev('input[type=hidden]').val('1')
        $(this).closest('tr').fadeOut(250)
        $(this).closest('tr').removeClass('activeMapListRow')
        $(this).closest('tr').addClass('removedMapListRow')

        if $('.activeMapListRow').length == 1
            $('.activeMapListRow .removeMapList').fadeOut(250)

        # Rename / reorder all of the active maps.
        counter = 1
        $('.activeMapListRow').each ->
            label_column = $(this).children('.labelColumn')
            label_column.children('input[type=hidden]').val(counter)
            label_column.children('label').text('Map ' + counter)
            counter += 1

        if $('.activeMapListRow').length < 20
            $('#addMapListRow').fadeIn(250)

    if $('.activeMapListRow').length == 20
        $('#addMapListRow').css('display', 'none')

    $('#addMapList').click ->
        $('.activeMapListRow .removeMapList').first().fadeIn()
        row_num = $('.mapListRow').length
        active_num = $('.activeMapListRow').length + 1
        row = $('.activeMapListRow').first().clone(true)

        label_column = row.children('.labelColumn')
        select_column = row.children('.selectColumn')
        select_column.children('.removeMapList').css('display', 'inline')
        select_column.children('.removeMapList').css('opacity', '100')

        label = label_column.children('label')
        label.text('Map ' + active_num)
        label.attr('for', label.attr('for').replace(/_[0-9]*_/, '_' + row_num + '_'))

        map_order = label_column.children('input[type=hidden]')
        map_order.val(active_num)
        map_order.attr('id', map_order.attr('id').replace(/_[0-9]*_/, '_' + row_num + '_'))
        map_order.attr('name', map_order.attr('name').replace(/\[[0-9]*\]/, '[' + row_num + ']'))

        select_menu = select_column.children('select')
        select_menu.attr('id', select_menu.attr('id').replace(/_[0-9]*_/, '_' + row_num + '_'))
        select_menu.attr('name', select_menu.attr('name').replace(/\[[0-9]*\]/, '[' + row_num + ']'))

        del_field = select_column.children('input[type=hidden]')
        del_field.val(active_num)
        del_field.attr('id', del_field.attr('id').replace(/_[0-9]*_/, '_' + row_num + '_'))
        del_field.attr('name', del_field.attr('name').replace(/\[[0-9]*\]/, '[' + row_num + ']'))

        row.css('display', 'none')
        $(row).insertBefore($('#addMapListRow'))
        row.fadeIn(250)

        if $('.activeMapListRow').length == 20
            $('#addMapListRow').css('display', 'none')

    $('#callModForm').bind('ajax:beforeSend', (evt, xhr, settings) ->
        submitButton = $(this).find('input[name="commit"]')
        submitButton.attr('disabled', 'disabled')
        submitButton.removeClass('activeAction')
        submitButton.addClass('disabledAction')
        submitButton.attr('value', 'Submitting...')
    ).bind('ajax:success', (evt, data, status, xhr) ->
        submitButton = $(this).find('input[name="commit"]')
        contested_field = $(this).find('#match_player_relation_contested')

        if data.contested
            submitButton.attr('value', 'Dismiss Mod Call')
            contested_field.attr('value', 0)
            alert('You have contested this match. A moderator will message you soon.\nPlease pay attention to your inbox.')
        else
            submitButton.attr('value', 'Call Mod')
            contested_field.attr('value', 1)
    ).bind('ajax:complete', (evt, xhr, status) ->
        submitButton = $(this).find('input[name="commit"]')
        submitButton.removeAttr('disabled')
        submitButton.removeClass('disabledAction')
        submitButton.addClass('activeAction')
    ).bind('ajax:error', (evt, xhr, status, error) ->
        alert('There was an error. Please refresh, or report the error if the problem persists.')
    )
