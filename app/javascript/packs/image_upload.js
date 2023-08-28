$(document).ready(function () {


  $(document).on('click', "#save-keys", function(){
    $('#annotateModal').modal('hide');
  })

  
  $(document).on("click", ".add-key-value", function () {
    var canAdd = true;

    $(".key-value-pair").each(function () {
      var keyInput = $(this).find(".key");
      var valueInput = $(this).find(".value");

      if (keyInput.val() === "" || valueInput.val() === "") {
        canAdd = false;
        return false; 
      }
    });

    if (canAdd) {
      var keyValuePair = $(this).closest(".key-value-pair");
      var newKeyValuePair = keyValuePair.clone();

      newKeyValuePair.find(".key").val("");
      newKeyValuePair.find(".value").val("");

      keyValuePair.after(newKeyValuePair);
    }
  });

  $(document).on("click", ".remove-key-value", function () {
    $(this).closest(".key-value-pair").remove();
  });

});
