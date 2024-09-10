window.submit_filter_form = function (el, skip_form_sending = false) {
    const filterWrapper = document.getElementById('filter-wrapper');
    filterWrapper.classList.add('is-loading');
    el.form.requestSubmit();
  }