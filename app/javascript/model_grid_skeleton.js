window.submit_filter_form = function (el, skip_form_sending = false) {
    const modelsFilter = document.querySelector('.models-filter');
    modelsFilter.classList.add('is-loading');
    el.form.requestSubmit();
  }