window.minimizeComment = function minimizeComment(event) {
    const commentsToggleBar = event.target
    const repliesList = commentsToggleBar.closest('.replies-wrapper')
    repliesList.classList.toggle('is-compacted')
}
