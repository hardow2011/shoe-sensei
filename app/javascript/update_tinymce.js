// This is necessary to tinymce after turbo does its thing

// tinymce.remove();

window.updateTinymceFields = function updateTinymceFields() {
    const tinymceFields = document.querySelectorAll('.tinymce');

    tinymceFields.forEach((field, index) => {
        fieldName = field.getAttribute('name');
        parentForm = field.closest("form")
        hiddenTextAreaInput = parentForm.querySelector(`textarea[name="${fieldName}"]`);
        hiddenTextAreaInput.innerHTML = field.innerHTML;
    });
}
