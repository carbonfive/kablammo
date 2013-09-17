$(document).ready(function() {
  $('.markdown').each(function() {
    var markedDown = $(this);
    markedDown.html(markdown.toHTML(markedDown.html()));
  });
});