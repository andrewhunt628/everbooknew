jQuery ->
  unless localStorage.getItem('onboarding')
    $('body').addClass('image-wall')
    cover = $('.cover').fadeIn()

    $('.cover').click ->
      localStorage.setItem('onboarding', true)
      $('body').removeClass('image-wall')
      $(this).fadeOut()
