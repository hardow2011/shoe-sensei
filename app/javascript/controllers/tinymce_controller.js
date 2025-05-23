import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="tinymce"
export default class extends Controller {
  // The form target will be the form element surrounding the tinyMCE field
  // The field target will be the tinyMCE field itself
  static targets = ['field']

  connect() {
  }

  // Every time a fieldTarget (i.e. a tinyMCE field) is added to the page,
  // the fieldTargetConnected will run.
  // This funtion is used to initialize a tinyMCE using a specific selector and configuration.
  fieldTargetConnected(field) {
    // The random ID every time is necessary because it is the selector that TinyMCERails.initialize
    // will use to initialize TinyMCE in a specific field.
    // If the field come from a Turbo Stream, this will also help re-initialize the field.
    const fieldId = 'tinymce-field-' + crypto.randomUUID();
    
    // The config to be used for the field retrieved from the data-tinymce-config attribute.
    // If not assiged, then it will default to 'default'.
    const config = field.dataset.tinymceConfig || 'default';

    // The random ID is assigned to the tinyMCE field.
    field.id = fieldId;

    // tinyMCE is initialized to an element using the random ID as selector
    TinyMCERails.initialize(config, {
      selector: `#${fieldId}`
    });
  }

  // This function will be called on form submission.
  // It's used to set a hidden field with the value of the tinyMCE field.
  // This is so the tinyMCE field value can be properly passed to the controller because the
  // tinyMCE field is a div, and divs do not get sent with form submissions.
  setHiddenField() {
    this.fieldTargets.forEach((field, index) => {
      // It is important to assign the correct name attribute to the tinyMCE field,
      // as it will be used for the hidden field
      const fieldName = field.getAttribute('name');
      
      let hiddenTextAreaInput = document.createElement('textarea');
      hiddenTextAreaInput.style.display = 'none';
      hiddenTextAreaInput.setAttribute('name', fieldName)
      hiddenTextAreaInput.innerHTML = field.innerHTML;

      field.after(hiddenTextAreaInput);
    });
  }
}
