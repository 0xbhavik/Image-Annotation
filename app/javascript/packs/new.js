$(document).ready(function () {

    var imageUpload = $('#image_upload');
    var annotationSection = $('.annotation-section');
  
    imageUpload.change(function() {
      if (imageUpload[0].files.length > 0) {
        annotationSection.show();
      } else {
        annotationSection.hide();
      }
    });
  
  });
  