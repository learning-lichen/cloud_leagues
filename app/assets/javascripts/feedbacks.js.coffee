$ ->
    closed = true

    $('#showFeedbackForm').click ->
        if closed
            $(this).addClass('formOpen')
            $(this).text('X')
            $('#feedbackFormContainer').css('display', 'block')
            closed = false
        else
            $(this).removeClass('formOpen')
            $(this).text('Submit Feedback')
            $('#feedbackFormContainer').css('display', 'none')
            closed = true

    $('#feedbackForm').bind('ajax:beforeSend', (evt, xhr, settings) ->
        $('#feedbackLoader').css('visibility', 'visible')
    ).bind('ajax:success', (evt, data, status, xhr) ->
        if data.id == null
            $('#feedbackErrors').css('display', 'block')
            $('#feedbackErrors').html('Could not save feedback. <br /> Make sure your chose a category.')
        else
            $('#feedbackErrors').css('display', 'block')
            $('#feedbackErrors').html('Feedback submitted. <br /> Thank you.')
    ).bind('ajax:complete', (evt, xhr, status) ->
        $('#feedbackLoader').css('visibility', 'hidden')
    ).bind('ajax:error', (evt, xhr, status, error) ->
        $('#feedbackErrors').css('display', 'block')
        $('#feedbackErrors').html('There was an error. <br /> Please try again later.')
    )