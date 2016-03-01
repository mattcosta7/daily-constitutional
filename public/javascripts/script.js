$(document).ready(function(){
  $('#map-select').on('change',function(){
    console.log($('#map-select').val())
    $.ajax({
      url: '/stats'+"/"+$('#map-select').val(),
      method: 'post'
    })
  })
})