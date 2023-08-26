$(document).on('turbolinks:load', function() {
    $(".add-key-value").click(function() {
      var keyValue = '<div class="key-value-pair form-row">' +
                     '<div class="col">' +
                     '<input type="text" name="custom_keys[]" class="form-control" placeholder="Key">' +
                     '</div>' +
                     '<div class="col">' +
                     '<input type="text" name="custom_values[]" class="form-control" placeholder="Value">' +
                     '</div>' +
                     '<div class="col-auto">' +
                     '<button type="button" class="btn btn-sm btn-danger remove-key-value">Remove</button>' +
                     '</div>' +
                     '</div>';
      $(".key-value-pairs").append(keyValue);
    });
    $(document).on("click", ".remove-key-value", function() {
      console.log('clicked');
      var parentDiv = $(this).closest('.key-value-pair');
      parentDiv.remove();
    });
  });