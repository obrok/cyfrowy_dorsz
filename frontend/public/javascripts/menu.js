$(document).ready(function() {
  $('ul#menu > li').each(function() {
    $(this).removeClass('active');
    var activeUrl = window.location.pathname.match(/\w+/).toString();
    var url = $(this).find('a').first().attr('href').match(/\w+/).toString();
    if(url == activeUrl) {
      $(this).addClass('active');

      $('ul#menu > li > ul').addClass('hidden');
      $(this).children().each(function() {
        $(this).removeClass('hidden');
      });
    }
  });
});