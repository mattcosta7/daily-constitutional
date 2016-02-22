$(document).ready(function(){
  $('#signin-swap-2').hide();

  $('.train-delay-status').hide();

  $('.swap-signin').on('click',function(){
    $('#signin-swap-2').toggle();
    $('#signin-swap-1').toggle();
  });

})