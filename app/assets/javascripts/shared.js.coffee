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

$ ->
  $('#biggestPrizePools #gmContent').css('display', 'block')
  $('#biggestPrizePools #gmTab').css('border-bottom', 0)

  $('#biggestPrizePools .biggestPrizePoolsTab').click ->
    content_id = '#' + this.id.replace('Tab', 'Content')

    $('#biggestPrizePools .biggestPrizePoolsContent').css('display', 'none')
    $('#biggestPrizePools .biggestPrizePoolsTab').css('border-bottom', '1px solid #797470')

    $(this).css('border-bottom', 0)
    $(content_id).css('display', 'block')
