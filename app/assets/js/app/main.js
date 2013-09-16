$(document).ready(function() {
  $('.markdown').each(function() {
    console.log('yoyo');
    var markedDown = $(this);
    markedDown.html(markdown.toHTML(markedDown.html()));
  });
});