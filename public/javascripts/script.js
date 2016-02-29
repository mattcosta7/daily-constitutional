$(document).ready(function(){
  $('#map-select').on('change',function(){
    console.log($('#map-select').val())
    $.getScript('/stats'+"&category="+$('#map-select').val())
  })
})