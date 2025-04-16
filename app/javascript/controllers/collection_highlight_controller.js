import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="collection-highlight"
export default class extends Controller {
  connect() {
    if (this.selectedCollection && this.element.id == this.selectedCollection) {
        this.element.classList.toggle('highlighted-background')
    }
  }

  get selectedCollection() {
    return window.location.hash.substring(1);
  }
}
