import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="tinymce"
export default class extends Controller {
  static targets = ['form', 'field']

  connect() {
    console.log('ola k ase');
    
  }

  fieldTargetConnected() {
    // The random ID every time is necessary because TinyMCERails.initialize won't...
    // initialize the same ID more than once
    this.fieldTargets.forEach((field, _) => {
      const fieldId = 'time-mce-field-' + crypto.randomUUID();
      const config = field.dataset.tinymceConfig;
  
      field.id = fieldId;

      console.log(field);
      
      
      TinyMCERails.initialize(config, {
        selector: `#${fieldId}`
      });
    })
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
