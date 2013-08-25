var animateFires = function(fires) {

  var highlight = function(squares) {
    if (squares.length == 0) return;
    var square = squares.shift();
    var el = "#square-" + square[0] + "-" + square[1]
    console.log("fire at: " + el);
    $(el).addClass('fire');
    setTimeout(function() {
      $(el).removeClass('fire');
      highlight(squares);
    }, 100)
  }

  for (i = 0; i < fires.length; i++) {
    var fire = fires[i];
    highlight(fire);
  }
}
