$(document).ready(function() {

  $('ul#menu > li').mouseover(function() {
    $('ul#menu > li > ul').addClass('hidden');
    $(this).children().each(function() {
      $(this).removeClass('hidden');
    });
  });

  $('ul#menu > li').mouseout(function() {
    $('ul#menu > li > ul').addClass('hidden');
    $('ul#menu > li.active > ul').removeClass('hidden');
  });

});