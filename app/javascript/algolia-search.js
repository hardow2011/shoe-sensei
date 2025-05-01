import { autocomplete } from '@algolia/autocomplete-js';

window.addEventListener('turbo:load', () => {
    autocomplete({
    container: '#autocomplete',
    placeholder: 'Search',
    //   openOnFocus: true,
    getSources({query}) {
        return [
            {
                sourceId: 'results',
                async getItems() {
                    const url = `/search/${query}`;
                    try {
                    const response = await fetch(url);
                    if (!response.ok) {
                        throw new Error(`Response status: ${response.status}`);
                    }
                
                    const json = await response.json();
                    return json;
                    } catch (error) {
                    console.error(error);
                    }
                },
                getItemUrl({ item }) {
                    return item.path;
                },
                templates: {
                    item({ item, html }) {
                    return html
                    `
                    <a href="${item.path}">
                        <div class="aa-ItemWrapper">
                                <div class="aa-ItemContent">
                                    <div class="aa-ItemIcon aa-ItemIcon--alignTop">
                                        <img src="${item.image}" alt="${item.name}" width="40" height="40" />
                                    </div>
                                    <div class="aa-ItemContentBody">
                                        <div class="aa-ItemContentTitle">
                                            ${item.name}
                                        </div>
                                        <div class="aa-ItemContentDescription">
                                            ${item.description}
                                        </div>
                                    </div>
                                </div>
                            </div>
                        </a>
                    `;
                    },
                    noResults() {
                        return 'No results.';
                    },
                },
            }
        ];
    },
    });
})