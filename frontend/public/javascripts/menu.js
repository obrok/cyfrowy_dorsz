$(document).ready(function() {
  $('ul#menu > li').each(function() {
    $(this).removeClass('active');
    var activeUrl = window.location.pathname.match(/\w+/);
    if (activeUrl) {
      activeUrl = activeUrl.toString();
    } else {
      activeUrl = '/';
    }

    var url = $(this).find('a').first().attr('href').match(/\w+/);
    if (url) {
      url = url.toString();
    } else {
      url = '/';
    }

    if(url == activeUrl) {
      $(this).addClass('active');

      $('ul#menu > li > ul').addClass('hidden');
      $(this).children().each(function() {
        $(this).removeClass('hidden');
      });
    }
  });
});