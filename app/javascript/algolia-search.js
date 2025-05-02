import { autocomplete } from '@algolia/autocomplete-js';

window.addEventListener('turbo:load', () => {
    const locale = window.location.pathname.split('/')[1];
    autocomplete({
    container: '#autocomplete',
    placeholder: locale == 'es' ? 'Buscar' : 'Search',
    translations: {
        clearButtonTitle: locale == 'es' ? 'Limpiar' : 'Clear', // defaults to 'Clear'
        detachedCancelButtonText: locale == 'es' ? 'Cancelar' : 'Cancel', // defaults to 'Cancel'
        submitButtonTitle: locale == 'es' ? 'Enviar' : 'Submit' // defaults to 'Submit'
        },
    getSources({query}) {
        return [
            {
                sourceId: 'results',
                async getItems() {
                    let url = `/search/${query}`;
                    if(locale == 'es' || locale == 'en') {
                        url = `/${locale}${url}`;
                    }
                    try {
                    const response = await fetch(new URL(url, window.location.origin));
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
                                    <div class="aa-ItemIcon aa-ItemIcon--picture aa-ItemIcon--alignTop">
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