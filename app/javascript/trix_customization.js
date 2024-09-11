import 'trix'

Trix.config.blockAttributes.heading2 = {
  tagName: 'h2',
  terminal: true,
  breakOnReturn: true,
  group: false
}

Trix.config.blockAttributes.heading3 = {
  tagName: 'h3',
  terminal: true,
  breakOnReturn: true,
  group: false
}

Trix.config.blockAttributes.heading4 = {
  tagName: 'h4',
  terminal: true,
  breakOnReturn: true,
  group: false
}

Trix.config.blockAttributes.heading5 = {
  tagName: 'h5',
  terminal: true,
  breakOnReturn: true,
  group: false
}

Trix.config.blockAttributes.heading6 = {
  tagName: 'h6',
  terminal: true,
  breakOnReturn: true,
  group: false
}

document.addEventListener("trix-initialize", function(event) {
    const editor = event.target.editor;
    const toolbar = editor.element.previousSibling;
    const btnGroup = toolbar.querySelector('.trix-button-group.trix-button-group--block-tools');

    const h2BtnHtml = '<button type="button" class="trix-button" data-trix-attribute="heading2" title="Heading 2" tabindex="-1">H2</button>'
    const h3BtnHtml = '<button type="button" class="trix-button" data-trix-attribute="heading3" title="Heading 3" tabindex="-1">H3</button>'
    const h4BtnHtml = '<button type="button" class="trix-button" data-trix-attribute="heading4" title="Heading 4" tabindex="-1">H4</button>'
    const h5BtnHtml = '<button type="button" class="trix-button" data-trix-attribute="heading5" title="Heading 5" tabindex="-1">H5</button>'
    const h6BtnHtml = '<button type="button" class="trix-button" data-trix-attribute="heading6" title="Heading 6" tabindex="-1">H6</button>'

    btnGroup.insertAdjacentHTML('afterBegin', h6BtnHtml);
    btnGroup.insertAdjacentHTML('afterBegin', h5BtnHtml);
    btnGroup.insertAdjacentHTML('afterBegin', h4BtnHtml);
    btnGroup.insertAdjacentHTML('afterBegin', h3BtnHtml);
    btnGroup.insertAdjacentHTML('afterBegin', h2BtnHtml);
  });
