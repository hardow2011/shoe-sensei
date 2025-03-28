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
