var File = {
  init: function() {
    this.addListeners();
  },

  addListeners: function() {
    var self = this;
    $('#upload').on('click', function(e) {
      e.preventDefault();
      self.openFilePicker();
    });
  },

  openFilePicker: function(e) {
    this.setFileKey();
    this.pickMultipleImages();
  },

  setFileKey: function() {
    filepicker.setKey('ASvEK6hqxQRaRuAqhSMz9z');
  },

  pickMultipleImages: function() {
    var self = this;
    filepicker.pickMultiple({
      mimetypes: ['image/*', 'text/plain'],
      container: 'window',
      services:['COMPUTER', 'FACEBOOK', 'GMAIL']
      }, self.fileUploadSuccess, self.fileUploadError);
  },

  fileUploadSuccess: function(FPFiles) {
    $.each(FPFiles, function(index, FPFile){
      $.post('/memes', FPFile).always(function(data) {
        $('div.gallery div.row').prepend(data.responseText);
        location.reload();
      });
    });
  },

  fileUploadError: function(FPError){
    console.log(FPError.toString());
  }
}

$(document).ready(function() {
  File.init();
});
