String.prototype.hashCode = function(){
  var hash = 0;
  for (var i = 0; i < this.length; i++) {
    var code = this.charCodeAt(i);
    hash = ((hash<<5)-hash)+code;
    hash = hash & hash; // Convert to 32bit integer
  }
  return hash;
}
