$(document).ready(function(){
 $('#upload').on('click', function(e){
  e.preventDefault();
  openFilePicker();
});

 if ($("#sign-out").length === 0){
  $("form").on("submit" ,function(e){
    e.preventDefault();
    window.location = "/auth/google_oauth2";
  });
}

$('div.row.meme-container').infinitescroll({
  navSelector  : "div.pagination",
  // selector for the paged navigation (it will be hidden)
  nextSelector : "div.pagination a.next_page",
  // selector for the NEXT link (to page 2)
  itemSelector : ".row.meme-container .meme-box"
  // selector for all items you'll retrieve
  });
});

function openFilePicker() {
  filepicker.setKey('ASvEK6hqxQRaRuAqhSMz9z');
  filepicker.pickMultiple({
    mimetypes: ['image/*', 'text/plain'],
    container: 'window',
    services:['COMPUTER', 'FACEBOOK', 'GMAIL', 'INSTAGRAM']
  },
  function(FPFiles){
    $.each(FPFiles, function(index, FPFile){
      $.post('memes', FPFile).always(function(data) {
        $('div.gallery div.row').prepend(data.responseText);
      });
    });
  },
  function(FPError){
    console.log(FPError.toString());
  }
  );
}
