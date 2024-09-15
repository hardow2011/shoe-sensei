const selectedCollection = window.location.hash.substring(1);
if (selectedCollection) {
    const collectionHtmlTag = document.getElementById(selectedCollection);
    if (collectionHtmlTag) {
        collectionHtmlTag.classList.add('highlighted-background')
    }
}