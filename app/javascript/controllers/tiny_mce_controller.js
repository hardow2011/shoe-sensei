import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="tiny-mce"
export default class extends Controller {
  static targets = ['form']

  connect() {
  }

  get tinymceFields() {
    return this.element.querySelectorAll('.tinymce');
  }

  setHiddenField() {
    this.tinymceFields.forEach((field, index) => {
      const fieldName = field.getAttribute('name');
      
      let hiddenTextAreaInput = document.createElement('textarea');
      hiddenTextAreaInput.style.display = 'none';
      hiddenTextAreaInput.setAttribute('name', fieldName)
      hiddenTextAreaInput.innerHTML = field.innerHTML;

      field.after(hiddenTextAreaInput);
    });
  }
}
