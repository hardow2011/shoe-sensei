document.addEventListener('DOMContentLoaded', () => {

    // Get all "navbar-burger" elements
    const $navbarBurgers = Array.prototype.slice.call(document.querySelectorAll('.navbar-burger'), 0);
  
    // Add a click event on each of them
    $navbarBurgers.forEach( el => {
      el.addEventListener('click', () => {
  
        // Get the target from the "data-target" attribute
        const target = el.dataset.target;
        const $target = document.getElementById(target);
  
        // Toggle the "is-active" class on both the "navbar-burger" and the "navbar-menu"
        el.classList.toggle('is-active');
        $target.classList.toggle('is-active');
        document.querySelector('nav.navbar').classList.toggle('is-active');

        document.documentElement.classList.toggle("is-clipped");
  
      });
    });
  
  });

  window.addEventListener('resize', function(event) {
    const $htmlTag = document.documentElement;
    if($htmlTag.classList.contains('is-clipped') && window.screen.width > 768) {
      document.documentElement.classList.remove('is-clipped');
      document.querySelector('nav.navbar').classList.remove('is-active');
      document.querySelector('.navbar-menu').classList.remove('is-active');
      document.querySelector('.navbar-burger').classList.remove('is-active');
    }
}, true);