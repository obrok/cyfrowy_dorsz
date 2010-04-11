// Common JavaScript code across your application goes here.

$(document).ready(function() {
  if ($('#flash').html() != null) {
    $('#flash').slideDown("fast",function() {
      setTimeout(function() { $('#flash').slideUp("fast") }, 2000);
    });
  }

  $('#flash').click(function() {
    $(this).slideUp("fast");
  });
});