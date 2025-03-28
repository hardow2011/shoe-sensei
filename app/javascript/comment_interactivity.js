window.minimizeComment = function minimizeComment(event) {
    const commentsToggleBar = event.target
    const repliesList = commentsToggleBar.closest('.replies-wrapper')
    if (repliesList.classList.contains('is-compacted')) {
        repliesList.classList.add('is-opened')
        repliesList.classList.remove('is-compacted')
    } else {
        repliesList.classList.add('is-compacted')
        repliesList.classList.remove('is-opened')
    }
}

window.toggleReplyCountbutton = function toggleReplyCountbutton(button) {
    button.style.display = "none";
}

window.toggleDummyReplyBtn = function toggleCommentForm(btn) {
    const replyBtnsWrapper = btn.closest('.reply-btns-wrapper');
    replyBtnsWrapper.classList.add('show-dummy-reply-btn');
}


window.toggleCommentForm = function toggleCommentForm(targetId) {
    const form = document.getElementById(targetId)
    form.classList.toggle('is-hidden');
    form.classList.toggle('is-block');
    event.preventDefault();
}
