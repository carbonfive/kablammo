var animateFires = function(fires, callback) {

  var highlight = function(squares, callback) {
    if (squares.length == 0) {
      if (callback) callback();
      return;
    }
    var square = squares.shift();
    var el = "#square-" + square[0] + "-" + square[1]
    console.log("fire at: " + el);
    $(el).addClass('fire');
    setTimeout(function() {
      $(el).removeClass('fire');
      highlight(squares, callback);
    }, 100)
  }

  count = 0;
  var finish = function() {
    count += 1;
    console.log("finish? " + count + " == " + fires.length);
    if (count == fires.length) {
      if (callback) callback();
    }
  }

  if (fires.length > 0) {
    for (i = 0; i < fires.length; i++) {
      var fire = fires[i];
      highlight(fire, finish);
    }
  }
  else {
    if (callback) callback()
  }
}
