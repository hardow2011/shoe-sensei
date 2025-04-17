import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="comment-interactivity"
export default class extends Controller {
  static targets = [ 'repliesWrapper', 'repliesCountWrapper', 'replyForm' ]

  connect() {
    
  }

  toggleReplies() {
    this.repliesWrapperTarget.classList.toggle('is-compacted')
  }

  hideRepliesCountWrapper() {
    this.repliesCountWrapperTarget.classList.add('is-hidden')
  }

  toggleCommentForm(e) {
    // If turbo is disabled, that means we are just toggling the reply form on and off
    if(e.target.dataset.turbo == false) {

    }

    // After fetching the reply form, we disable turbo on that button.
    // e.target.dataset.href = false
    // e.target.dataset.turbo = false
    e.preventDefault();
    console.log(e.target)
    console.log(this.replyFormTarget)
  }
}
