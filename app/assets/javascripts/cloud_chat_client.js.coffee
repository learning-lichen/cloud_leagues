$ ->
    my_socket = undefined
    $('#chatMessageForm > input[name=message]').attr('disabled', 'disabled')
    $('#chatMessageForm > input[name=message]').val('Connecting.')

    animateConnect = ->
        num_dots = $('#chatMessageForm > input[name=message]').val()
        dots = 'Connecting.' if num_dots == 'Connecting...'
        dots = 'Connecting..' if num_dots == 'Connecting.'
        dots = 'Connecting...' if num_dots == 'Connecting..'
        $('#chatMessageForm > input[name=message]').val(dots)

    connect_interval = setInterval(animateConnect, 1000)

    $.getScript('http://localhost:8080/socket.io/socket.io.js')
    .done (script, textStatus) ->
        socket = io.connect('http://localhost:8080')
        setupSocket(socket)

    setupSocket = (socket) ->
        my_socket = socket

        socket.on 'connect', ->
            $('#chatMessageForm > input[name=message]').removeAttr('disabled')
            $('#chatMessageForm > input[name=message]').val('')
            clearInterval(connect_interval)

        socket.on 'get_credentials', ->
            user_cred_cookie = $.cookie('user_credentials').split('::')
            socket.emit('authenticate', { persistence_token: user_cred_cookie[0], id: user_cred_cookie[1] })

        socket.on 'new_message', (message) ->
            if message.sender_id == $('input[name=recipient_id]').val()
                message_text = $('<pre>').text(message.message).html()
                $('#matchChat').append('<p class="chatMessage"><b>' + message.cloud_login + ':</b> ' + message_text + '</p>')
                $('#matchChat').prop({ scrollTop: $('#matchChat').prop('scrollHeight') })
                window.unread_message = true

        socket.on 'message_failure', (error) ->
            alert(error);

        socket.on 'disconnect', ->
            $('#chatMessageForm > input[name=message]').attr('disabled', 'disabled')
            $('#chatMessageForm > input[name=message]').val('Disconnected')

        socket.on 'refresh_page', ->
            setTimeout( ->
                window.location.reload()
            , 2000)

    $('#chatMessageForm').submit ->
        recipient_id = $('input[name=recipient_id]')
        message = $('input[name=message]')

        if message.val() != ''
            message_text = $('<pre>').text(message.val()).html()
            my_socket.emit('send_message', {recipient_id: recipient_id.val(), message: message.val()})
            $('#matchChat').append('<p class="chatMessage"><b>You:</b> ' + message_text + '</p>')
            $('#chatMessageForm > input[name=message]').val('')
            $('#matchChat').prop({ scrollTop: $('#matchChat').prop('scrollHeight') })
        false

    $('#winGameForm').submit ->
        opponent = $('#chatMessageForm > input[name=recipient_id]')
        my_socket.emit('match_won', { opponent: opponent.val() })
        true

    $('#acceptMatchForm').submit ->
        opponent = $('#chatMessageForm > input[name=recipient_id]')
        my_socket.emit('player_accepted', { opponent: opponent.val() })
        true

    $(document).click ->
        sender = $('#chatMessageForm > input[name=recipient_id]')

        if window.unread_message
            my_socket.emit('read_messages', { sender: sender.val() })
            window.undread_message = false
        true

    $('#matchChat').prop({ scrollTop: $('#matchChat').prop('scrollHeight') })
