$(document).ready(function() {
  $('.markdown').each(function() {
    var markedDown = $(this);
    markedDown.html(markdown.toHTML(markedDown.html()));
  });

  $('#create-battle .random').on('click', function() {
    $('#create-battle select').each(function() {
      var options = $(this).find('option');
      if (options.length > 1) {
        options.removeAttr('selected');
        options.eq(Math.floor(Math.random() *  options.length)).attr('selected', 'selected');
      }
    });
    return true;
  });
});