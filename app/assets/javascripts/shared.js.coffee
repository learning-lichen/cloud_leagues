$ ->
        $('.dropMenu dt a').click ->
                toggleId = '#' + this.id.replace(/^link/, 'ul');
                $('dropMenu dd ul').not(toggleId).hide()
                $(toggleId).toggle()

                if $(toggleId).css('display') == 'none'
                        $(this).removeClass('selected')
                else
                        $(this).addClass('selected')


        $(document).bind 'click', (e) ->
                $clicked = $(e.target)
                if !$clicked.parents().hasClass('dropMenu')
                        $('.dropMenu dd ul').hide()
                        $('.dropMenu dt a').removeClass('selected')
