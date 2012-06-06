$ ->
    updateMessages = ->
        $.ajax({
            url: $('#linkToChatMessages').prop('href') + ".json"
        }).done((data) ->
            if data.unread_messages
                $('#refreshMessageIndex').css('display', 'block')
                $('#dropMenuArrow').addClass('displayMessageIcon')
            else
                setTimeout(updateMessages, 60000)
        )

    if $('#linkToChatMessages').length > 0
        setTimeout(updateMessages, 60000)
