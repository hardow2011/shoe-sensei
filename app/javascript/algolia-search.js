import { autocomplete } from '@algolia/autocomplete-js';

autocomplete({
  container: '#autocomplete',
  placeholder: 'Search',
  openOnFocus: true,
  getSources() {
    return [];
  },
});
