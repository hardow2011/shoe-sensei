    // This is necessary to tinymce after turbo does its thing

tinymce.remove();

function updateTinymceFields() {
    const tinymceFields = document.querySelectorAll('.tinymce');

    tinymceFields.forEach((field, index) => {
        fieldName = field.getAttribute('name');
        hiddenInput = document.querySelector(`input[name="${fieldName}"][type="hidden"]`);
        hiddenInput.value = field.innerHTML;
        console.log(hiddenInput);
    });
}

console.log('ola k ase');