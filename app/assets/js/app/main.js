$(document).ready(function() {
  $('.markdown').each(function() {
    var markedDown = $(this);
    markedDown.html(markdown.toHTML(markedDown.html()));
  });

  if ($('#create-battle').length > 0) {
    $('#create-battle .random').on('click', function() {
      var selects = $('#create-battle select');
      selects.each(function(i) {
        var select = $(this);
        var options = select.find('option');
        if (i > 0) {
          var previousSelection = selects.eq(i - 1).find(':selected').val();
          randomizeOptions(options, previousSelection);
        } else {
          randomizeOptions(options, null);
        }
      });
      return true;
    });

    function randomizeOptions(options, forbiddenValue) {
      if (options.length > 1) {
        options.removeAttr('selected');
        options.eq(Math.floor(Math.random() *  options.length)).attr('selected', 'selected');
        if (forbiddenValue && options.parent().find(':selected').val() == forbiddenValue) {
          randomizeOptions(options, forbiddenValue);
        }
      }
    }

    if ($('body').hasClass('autoplay')) {
      $('#create-battle .random').trigger('click');
    }
  }

  if ($('.leaderboard').length > 0 && $('body').hasClass('autoplay')) {
    setTimeout(function() {
      window.location = '/battles/new';
    }, 5000);
  }

});