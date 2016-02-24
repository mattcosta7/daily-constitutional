$(document).ready(function(){
  $('#signin-swap-2').hide();

  $('.train-delay-status').hide();
  $('.service-status').on('click',function(){
    $('#modal-content').html($(this).parent().parent().find('.train-delay-status').html())
        $('#modal').show();
        $('#close-icon').on('click',function(){
          $('#modal').hide();
        })
  })

  $('#modal').hide();

  $('.blog-entry-content').hide();

  $('.entry-unhider').on('click',function(){
    $('#modal-content').html($(this).parent().find('.blog-entry-content').html())
    $('#modal').show();
    $('#close-icon').on('click',function(){
      $('#modal').hide();
    })
  })


  $('.swap-signin').on('click',function(){
    $('#signin-swap-2').toggle();
    $('#signin-swap-1').toggle();
  });

})