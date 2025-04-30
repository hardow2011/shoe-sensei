import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="tinymce"
export default class extends Controller {
  // The form target will be the form element surrounding the tinyMCE field
  // The field target will be the tinyMCE field itself
  static targets = ['form', 'field']

  connect() {
  }

  disconnect() {
    // Remove tinyMCE from children fields when form is removed from page.
    // This fixes an issue where the inline toolbar would be stuck if it was open before going back
    // from a page and going back in, using the browser arrows
    this.fieldTargets.forEach((field, _) => {
      if (field.id) {
        tinymce.remove('#' + field.id)
      }
    })
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

  // Get all tinyMCE fields in a form (identified by the attribute data-tinymce-target="field")
  get tinymceFields() {
    return this.element.querySelectorAll('[data-tinymce-target="field"]');
  }

  // This function will be called on form submission.
  // It's used to set a hidden field with the value of the tinyMCE field.
  // This is so the tinyMCE field value can be properly passed to the controller because the
  // tinyMCE field is a div, and divs do not get sent with form submissions.
  setHiddenField() {
    this.tinymceFields.forEach((field, index) => {
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
