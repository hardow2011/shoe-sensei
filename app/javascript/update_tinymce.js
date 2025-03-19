// This is necessary to tinymce after turbo does its thing

// tinymce.remove();

window.updateTinymceFields = function updateTinymceFields() {
    const tinymceFields = document.querySelectorAll('.tinymce');

    tinymceFields.forEach((field, index) => {
        fieldName = field.getAttribute('name');
        parentForm = field.closest("form")
        hiddenInput = parentForm.querySelector(`input[name="${fieldName}"][type="hidden"]`);
        hiddenInput.value = field.innerHTML;
    });
}
