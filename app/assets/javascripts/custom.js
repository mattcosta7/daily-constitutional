$(document).ready(function(){
  
  $('#flash').fadeOut(500);

  $('#signin-swap-2').hide();

  $('.service-status').on('click',function(){
    $('#modal-content').html($(this).parent().parent().find('.train-delay-status').html())
        $('#modal').show();
        $('#close-icon').on('click',function(){
          $('#modal').hide();
        })
  })

  $('#modal').hide();
  $('#loading-modal').hide();
  $('#loader').hide();

  $('.entry-unhider').parent().on('click',function(e){
    if($(e.target).is('i')){
      return;
    }
    $('#modal-content').html($(this).parent().find('.blog-entry-content').html())
    $('#modal').show();
    $('#close-icon').on('click',function(){
      $('#modal').hide();
    })
    $('#close-icon-left').on('click',function(){
      $('#modal').hide();
    })
  })

  $('.sign-in-button').on('click',function(){
    $('#loader').show();
    $('#loading-modal').show();
  })

  $('#new-feed-button').on('click',function(){
    $('#loader').show();
    $('#loading-modal').show();
  })


  $('.swap-signin').on('click',function(){
    $('#signin-swap-2').toggle();
    $('#signin-swap-1').toggle();
  });

  $('.main-content').on('ajax:success', '.un-star-button-link',function(){
    $(this).replaceWith("<a data-idNum='"+$(this).attr('data-idNum')+"'class='star-button-link' data-remote='true' rel='nofollow' data-method='post' href='/star/"+$(this).attr('data-idNum')+"'><i class='material-icons star-icon'>star_border</i></a>");
  })

  $('.main-content').on('ajax:success', '.star-button-link',function(){
    $(this).replaceWith("<a data-idNum='"+$(this).attr('data-idNum')+"'class='un-star-button-link' data-remote='true' rel='nofollow' data-method='post' href='/unstar/"+$(this).attr('data-idNum')+"'><i class='material-icons star-icon'>star</i></a>");
  })

  $('.drawer-cell-todo').on('ajax:success', '.complete-button', function(){
    $(this).parent('li').toggleClass('cross-out')
    $(this).replaceWith("<a data-idnum='"+$(this).attr('data-idNum')+"' class='un-complete-button' data-remote='true' rel='nofollow' data-method='post' href='/todos/"+$(this).attr('data-idNum')+"/uncomplete'><i class='material-icons circle'>radio_button_unchecked</i></a>");
  })

  $('.drawer-cell-todo').on('ajax:success', '.un-complete-button', function(){
    $(this).parent('li').toggleClass('cross-out')
    $(this).replaceWith("<a data-idnum='"+$(this).attr('data-idNum')+"' class='complete-button' data-remote='true' rel='nofollow' data-method='post' href='/todos/"+$(this).attr('data-idNum')+"/complete'><i class='material-icons circle'>radio_button_unchecked</i></a>");
  })
    

})