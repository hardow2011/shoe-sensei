import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="models-filter"
export default class extends Controller {
  static targets = ['form']
  
  connect() {
  }

  submitForm() {
    this.formTarget.classList.add('is-loading');
    this.formTarget.requestSubmit();
  }
}
