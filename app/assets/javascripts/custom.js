$(document).ready(function(){
  $('#signin-swap-2').hide();

  $('.train-delay-status').hide();

  $('.blog-entry-content').hide();

  $('.entry-unhider').on('click',function(){
    $(this).parent().find('.blog-entry-content').toggle();
  })


  $('.swap-signin').on('click',function(){
    $('#signin-swap-2').toggle();
    $('#signin-swap-1').toggle();
  });

})