import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="models-filter"
export default class extends Controller {
  static targets = ['form', 'filterWrapper']
  
  connect() {
  }

  submitForm() {
    this.formTarget.classList.add('is-loading');
    this.formTarget.requestSubmit();
  }

  toggleMobileFilter() {
    this.filterWrapperTarget.classList.toggle('mobile-filter-active');
    if (this.filterWrapperTarget.classList.contains('mobile-filter-active')) {
      this.filterWrapperTarget.scrollIntoView({
        behavior: 'smooth'
      });
    }
  }
}
