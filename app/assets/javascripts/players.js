$(document).ready(function() {
  var play_button
  play_button = $('#play_game');

  $(play_button).click(function(e) {
    e.preventDefault();
    var player = $("#player_name").val();
    var bid = $("#bid_amount").val();
    $.getJSON("/lookup?players=" + player + "&bid=" + bid, {
      "alt": "json",
      "max-results": 100
    }, function(data) {
    });
  });
});



