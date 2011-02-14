// Common JavaScript code across your application goes here.

$(document).ready(function() {
  if ($('#flash').html() != null) {
    showFlash();
  }

  $('#flash').click(function() {
    $(this).slideUp("fast");
  });

  $("form#new-question-form").live('submit', function () {
    var data = $(this).serialize();
    var position = $('ul#questions li').size()+1;
    data += '&position=' + position;
    
    $.ajax({
      url: $(this).attr("action"),
      type: 'POST',
      data: data,
      success: function(html, textStatus) {
        $('span.validation.error').remove();
        if (!html.match('Treść pytania')) {
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

  $('.sortable').sortable({
    update: function(event, ui) {
      var i = 1;
      var positions = {};
      var poll_id = $('ul#questions').attr('data-poll-id');
      $('ul#questions li').each(function() {
        var id = $(this).recordId();
        positions[id] = i;
        i++;
      });
      $.ajax({
        type: 'GET',
        url: '/questions/update_positions',
        data: {
          poll_id: poll_id,
          positions: positions
        }
      });
    }
  });


  $('form#generate-tokens-form #valid_until').datepicker({
    dateFormat: 'yy-mm-dd'
  });
  $('form#generate-tokens-form #value').blur(function() {
    var count = $('form#generate-tokens-form #count');
    if ($(this).attr("value") != "") {
      count.attr("value", 1);
      count.attr("disabled", "disabled");
    }
    else {
      count.removeAttr("disabled");
    }
  })
});

function toggleQuestions() {
  if($("ul.custom").children().size()<1) {
    $(".custom-headers").hide();
  }
  else {
    $(".custom-headers").show();
  }
}

function showFlash() {
  $('#flash').slideDown("fast", function() {
    setTimeout(function() {
      $('#flash').slideUp("fast")
    }, 2000);
  });
}
