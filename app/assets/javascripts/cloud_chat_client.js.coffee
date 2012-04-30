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
            message_text = $('<pre>').text(message.message).html()
            $('#matchChat').append('<p class="chatMessage"><b>' + message.cloud_login + ':</b> ' + message_text + '</p>')
            $('#matchChat').prop({ scrollTop: $('#matchChat').prop('scrollHeight') })

        socket.on 'message_failure', (error) ->
            alert(error);

        socket.on 'disconnect', ->
            $('#chatMessageForm > input[name=message]').attr('disabled', 'disabled')
            $('#chatMessageForm > input[name=message]').val('Disconnected')

    $('#chatMessageForm').submit ->
        recipient_id = $('input[name=recipient_id]')
        message = $('input[name=message]')

        if message.val() != ''
            message_text = $('<pre>').text(message.val()).html()
            my_socket.emit('send_message', {recipient_id: recipient_id.val(), message: message.val()})
            $('#matchChat').append('<p class="chatMessage"><b>You:</b> ' + message_text + '</p>')
            $('#chatMessageForm > input[name=message]').val('')
            $('#matchChat').prop({ scrollTop: $('#matchChat').prop('scrollHeight') })
