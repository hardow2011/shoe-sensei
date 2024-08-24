window.previewImage = function(event) {
  let targetId = event.target.dataset.previewtagid;
  let output = document.getElementById(targetId);
  output.src = URL.createObjectURL(event.target.files[0]);
  output.onload = function() {
    URL.revokeObjectURL(output.src) // free memory
  }
}