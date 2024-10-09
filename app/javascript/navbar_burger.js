window.toggleNavbar = function(clickBtn) {
  // Get the target from the "data-target" attribute
  const target = clickBtn.dataset.target;
  const $target = document.getElementById(target);

  // Toggle the "is-active" class on both the "navbar-burger" and the "navbar-menu"
  clickBtn.classList.toggle('is-active');
  $target.classList.toggle('is-active');
  document.querySelector('nav.navbar').classList.toggle('is-active');

  document.documentElement.classList.toggle("is-clipped");
}

// Remove the is-clipped style (if present) from the html tag after page visit
document.addEventListener('turbo:load', () => {
  if (document.documentElement.classList.contains("is-clipped")) {
    removeMobileMenu()
  }
});


window.addEventListener('resize', function(event) {
  const $htmlTag = document.documentElement;
  if($htmlTag.classList.contains('is-clipped') && window.screen.width > 768) {
    removeMobileMenu();
  }
}, true);

function removeMobileMenu() {
  document.documentElement.classList.remove('is-clipped');
  document.querySelector('nav.navbar').classList.remove('is-active');
  document.querySelector('.navbar-menu').classList.remove('is-active');
  document.querySelector('.navbar-burger').classList.remove('is-active');
}