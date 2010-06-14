// Common JavaScript code across your application goes here.

$(document).ready(function() {
  if ($('#flash').html() != null) {
    showFlash();
  }

  $('#flash').click(function() {
    $(this).slideUp("fast");
  });

  $("form#question-form").submit(function () {
    $.ajax({
      url: $(this).attr("action"),
      type: 'POST',
      data: $(this).serialize(),
      success: function(question, textStatus) {
        $("#questions").append(question);
        toggleQuestions();
      },
      error: function(XMLHttpRequest, textStatus){
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
