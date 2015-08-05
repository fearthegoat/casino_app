$(document).ready(function() {
  var play_button
  play_button = $('#play_game');

  $(play_button).click(function(e) {
    e.preventDefault();
    var player = $("#player_name").val();
    $.getJSON("/lookup?players=" + player, {
      "alt": "json",
      "max-results": 100
    }, function(data) {
    });
  });
});



