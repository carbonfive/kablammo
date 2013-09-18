$(document).ready(function() {
  if ($('#create-battle').length > 0) {
    $('#create-battle .random').on('click', function() {
      var selects = $('#create-battle select:visible');
      var indexesToSelectFrom = [];
      for (var i = 0; i < selects.eq(0).find('option').length; i++) {
        indexesToSelectFrom[i] = i;
      }
      indexesToSelectFrom.splice(0, 1); // remove the blank option
      selects.each(function() {
        var select = $(this);
        var indexToSelect = Math.floor(Math.random() * indexesToSelectFrom.length);
        var selectedIndex = indexesToSelectFrom[indexToSelect];
        select.find('option').eq(selectedIndex).attr('selected', 'selected');
        indexesToSelectFrom.splice(indexToSelect, 1);
      });
      return true;
    });

    $('.add-robot').on('click', function() {
      var button = $(this);
      var hidden = $('.form-group:hidden');
      if (hidden.length > 0) {
        hidden.eq(0).removeClass('hidden');
        if (hidden.length == 1) {
          button.hide();
        }
      }
      return false;
    });

    if ($('body').hasClass('autoplay')) {
      var hidden = $('.form-group:hidden');
      hidden.each(function() {
        var field = $(this);
        if (Math.random() > .5) {
          field.removeClass('hidden');
        }
      });
      $('#create-battle .random').trigger('click');
    }
  }

  if ($('.leaderboard').length > 0 && $('body').hasClass('autoplay')) {
    setTimeout(function() {
      window.location = '/battles/new';
    }, 5000);
  }

});