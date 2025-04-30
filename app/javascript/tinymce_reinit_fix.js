// Remove tinyMCE from fields when page visited.
// This fixes an issue where the toolbar in inline mode would be stuck in place if it was open before going back
// from a page and going back in, using the browser arrows
window.addEventListener('turbo:visit', () => {
    tinymce.remove();
})