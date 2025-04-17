import { Controller } from "@hotwired/stimulus"
import { Turbo } from "@hotwired/turbo"

// Connects to data-controller="comment-interactivity"
export default class extends Controller {
  static targets = [ 'repliesWrapper', 'repliesCountWrapper', 'replyFormToggleBtn', 'replyForm' ]

  connect() {
    // The first time the reply form is rendered (that is, after replyFormToggleBtn is pressed)
    // the function toggleReplyFormLink() is called
    this.replyFormTarget.addEventListener('turbo:frame-render', ((event) => {
      this.toggleReplyFormLink()
    }));

    // Re-call the toggleReplyFormLink function after the reply submission. That will remove data-turbo=false
    this.replyFormTarget.addEventListener('submit', ((event) => {
      this.toggleReplyFormLink()
    }));
  }

  toggleReplies() {
    this.repliesWrapperTarget.classList.toggle('is-compacted')
  }

  hideRepliesCountWrapper() {
    this.repliesCountWrapperTarget.classList.add('is-hidden')
  }

  // This function removes the turbo functionality from replyFormToggleBtn if data-turbo=false,
  // effectively making it a toggle through the toggleCommentForm function.
  // If data-turbo is not false (that is when the button is pressed for the first time, or after the reply submission),
  // then it regains its turbo functionality
  toggleReplyFormLink() {
    if(this.replyFormToggleBtnTarget.dataset.turbo == 'false') {
      this.replyFormToggleBtnTarget.removeAttribute("data-turbo")
    } else {
      this.replyFormToggleBtnTarget.dataset.turbo = false
    }
    this.replyFormToggleBtnTarget.addEventListener("click", function(event){
      if(event.target.dataset.turbo == 'false') {
        event.preventDefault()
      }
    });
  }

  toggleCommentForm() {
    if(this.replyFormToggleBtnTarget.dataset.turbo == 'false') {
      this.replyFormTarget.classList.toggle('is-hidden');
      this.replyFormTarget.classList.toggle('is-block');
    }
  }
}
