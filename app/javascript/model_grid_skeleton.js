window.submit_filter_form = function (el, skip_form_sending = false) {
    const modelsFilter = document.getElementById('models-filter-form');
    modelsFilter.classList.add('is-loading');
    el.form.requestSubmit();
  }