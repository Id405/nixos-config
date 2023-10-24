{ colors }: ''
  /*
  ┌─┐┬┌┬┐┌─┐┬  ┌─┐
  └─┐││││├─┘│  ├┤
  └─┘┴┴ ┴┴  ┴─┘└─┘
  ┌─┐┌─┐─┐ ┬
  ├┤ │ │┌┴┬┘
  └  └─┘┴ └─
  by Miguel Avila
  */

  :root {
        scrollbar-width: none !important;
  }

  @-moz-document url(about:privatebrowsing) {
        :root {
                scrollbar-width: none !important;
        }
  }

  @-moz-document url-prefix(about:home), url-prefix(about:newtab), url-prefix(about:blank) {
    body {
      background-color: #${colors.base00};
    }
  }

''
