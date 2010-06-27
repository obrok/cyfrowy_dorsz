// Common JavaScript code across your application goes here.

$(document).ready(function() {
  if ($('#flash').html() != null) {
    showFlash();
  }

  $('#flash').click(function() {
    $(this).slideUp("fast");
  });

  $("form#new-question-form").submit(function () {
    $.ajax({
      url: $(this).attr("action"),
      type: 'POST',
      data: $(this).serialize(),
      success: function(html, textStatus) {
        if (!html.match('form')) {
          $("#questions").append(html);
          toggleQuestions();
        }
        else {
          $("form#new-question-form").replaceWith(html);
        }
      },
      error: function(form, textStatus){
        $('#flash').html('<div class="error">Przepraszamy, wystąpił błąd podczas dodawania pytania.</div>');
        showFlash();
      }
    });
    return false;
  });

  toggleQuestions();
});

function toggleQuestions() {
  if($("#questions tbody").children().size()<2) {
    $("#questions").hide();
  }
  else {
    $("#questions").show();
  }
}

function showFlash() {
  $('#flash').slideDown("fast", function() {
    setTimeout(function() { $('#flash').slideUp("fast") }, 2000);
  });
}
