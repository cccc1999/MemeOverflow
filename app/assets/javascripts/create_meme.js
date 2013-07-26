$(document).ready(function() {
	$('#meme_picture').change(function() {
      $('#meme_select_pic').attr("src", '/assets/meme_image/'+$(this).val() + '.jpg');
	});

});
