$(document).ready(function() {
  var play_button
  play_button = $('#play_game');
  $('#all').on('change', function(){
  $('#hdnall').val(this.checked ? 1 : 0);
    });
  $(play_button).click(function(e) {
    e.preventDefault();
    var player = $("#player_name").val();
    var bid = $("#bid_amount").val();
    var games = $("#number_games").val();
    var all = $("#hdnall").val();
    $.ajax("/lookup?players=" + player + "&bid=" + bid + "&games=" + games + "&all=" + all);
  });
});



