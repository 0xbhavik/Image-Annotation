$(document).ready(function() {
    $('.image-link').click(function() {
         var clickedImageId = $(this).data('image-id');
         $('#imageCarouselModal .carousel-inner .carousel-item').removeClass('active');
         $('#imageCarouselModal .carousel-inner .carousel-item[data-image-id="' + clickedImageId + '"]').addClass('active');
         $('#imageCarouselModal').modal('show');
       });

     $('.annotate-image-button').click(function() {
       var imageId = $(this).data('image-id');
       console.log("clicked")

       $.ajax({
         url: '/annotated_images/' + imageId + '/edit_annotation',
         method: 'GET',
         dataType: 'html',
         success: function(formHtml) {
           console.log("inside ajax")
           $('#annotateModal .modal-body').html(formHtml);
           $('#annotateModal').modal('show');
         }
       });
     });

     $('#reset-button').click(function(){
      const imageId = $(this).data('image-id');
      console.log("reset-clicked")
      $.ajax({
        url: '/annotated_images/' + imageId + '/edit_annotation',
        method: 'GET',
        dataType: 'html',
        success: function(formHtml) {
          console.log("inside ajax")
          $('#annotateModal .modal-body').html(formHtml);
          $('#annotateModal').modal('show');
        }
      });
     })
 
   });