document.addEventListener('turbo:load', function() {
    const selectedCollection = window.location.hash.substring(1);
    if (selectedCollection) {
        console.log(selectedCollection);
        const collectionHtmlTag = document.getElementById(selectedCollection);
        if (collectionHtmlTag) {
            collectionHtmlTag.classList.toggle('highlighted-background')
        }
    }
})
