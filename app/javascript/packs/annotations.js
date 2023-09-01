$(document).ready(function () {

  toggleAddButtonVisibility()

  function toggleAddButtonVisibility() {
    var keyValuePairElements = $('.key-value-pair');
    var addButton = $('#extra-add-button');
    
    if (keyValuePairElements.length === 0) {
      addButton.show();
    } else {
      addButton.hide();
    }
  }
  toggleAddButtonVisibility()

  var keyValueTemplate = `
  <div class="key-value-pair form-row">
    <div class="col">
      <input type="text" name="custom_keys[]" class="form-control key" placeholder="Key">
    </div>
    <div class="col">
      <input type="text" name="custom_values[]" class="form-control value" placeholder="Value">
    </div>
    <div class="col-auto">
      <button type="button" class="btn btn-sm btn-info add-key-value">Add</button>
    </div>
    <div class="col-auto">
      <button type="button" class="btn btn-sm btn-danger remove-key-value">Remove</button>
    </div>
  </div>
`;
 $(document).on("click", "#extra-add-button button", function () {
  if ($('.key-value-pair').length === 0) {
    $('.key-value-pairs').append(keyValueTemplate);
    toggleAddButtonVisibility()
  }
});

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
    toggleAddButtonVisibility()
  });


})