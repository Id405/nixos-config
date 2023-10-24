{ colors, fontSize, fontSizeSmall }: ''
   /* This is a modified version of minimal-functional-fox
   https://github.com/mut-ex/minimal-functional-fox */

   :root {
     /* Minimal Functional Fox variables*/
    --mff-bg: #${colors.base00};
    --mff-icon-color: #${colors.base07};
    --mff-nav-toolbar-padding: 0px;
    --mff-sidebar-bg: var(--mff-bg);
    --mff-sidebar-color: #${colors.base07};
    --mff-tab-border-radius: 0px;
    --mff-tab-color: #${colors.base07};
    --mff-tab-font-family: "Inter", sans;
    --mff-tab-font-size: ${toString fontSizeSmall}pt;
    --mff-tab-font-weight: 400;
    --mff-tab-height: 1.5em;
    --mff-tab-pinned-bg: #${colors.base00};
    --mff-tab-selected-bg: #${colors.base01};
    --mff-tab-soundplaying-bg: #${colors.base00};
    --mff-urlbar-color: #${colors.base07};
    --mff-urlbar-focused-color: #${colors.base07};
    --mff-urlbar-font-family: "Inter", serif;
    --mff-urlbar-font-size: ${toString fontSize}pt;
    --mff-urlbar-font-weight: 400;
    --mff-urlbar-results-color: #${colors.base07};
    --mff-urlbar-results-font-family: "Inter", serif;
    --mff-urlbar-results-font-size: ${toString fontSize}pt;
    --mff-urlbar-results-font-weight: 400;
    --mff-urlbar-results-url-color: #${colors.base07};
    /*   --mff-tab-selected-bg: linear-gradient(90deg, rgba(232,74,95,1) 0%, rgba(255,132,124,1) 50%, rgba(254,206,168,1) 100%); */
    /*   --mff-urlbar-font-weight: 600; */

    /* Overriden Firefox variables*/
    --autocomplete-popup-background: var(--mff-bg) !important;
    --default-arrowpanel-background: var(--mff-bg) !important;
    --default-arrowpanel-color: #${colors.base00} !important;
    --lwt-toolbarbutton-icon-fill: var(--mff-icon-color) !important;
    --panel-disabled-color: #${colors.base07};
    --toolbar-bgcolor: var(--mff-bg) !important;
    --urlbar-separator-color: transparent !important;
  }

  /*
    _____ _   ___ ___
   |_   _/_\ | _ ) __|
     | |/ _ \| _ \__ \
     |_/_/ \_\___/___/

  */

  #TabsToolbar {visibility: collapse;} /* hide tab bar */

  /*
    _____ ___   ___  _    ___   _   ___
  |_   _/ _ \ / _ \| |  | _ ) /_\ | _ \
    | || (_) | (_) | |__| _ \/ _ \|   /
    |_| \___/ \___/|____|___/_/  \_\_|_\
  */

  .urlbar-icon > image {
    fill: var(--mff-icon-color) !important;
    color: var(--mff-icon-color) !important;
  }

  .toolbarbutton-text {
    color: var(--mff-icon-color)  !important;
  }
  .urlbar-icon {
    color: var(--mff-icon-color)  !important;

  }

  .toolbarbutton-icon {
  /* filter: drop-shadow(0 0 0.75rem crimson); */
  }

  #urlbar-results {
    font-family: var(--mff-urlbar-results-font-family);
    font-weight: var(--mff-urlbar-results-font-weight);
    font-size: var(--mff-urlbar-results-font-size) !important;
    color: var(--mff-urlbar-results-color) !important;
  }

  .urlbarView-row[type="bookmark"] > span{
    color: green !important;
  }

  .urlbarView-row[type="switchtab"] > span{
    color: orange !important;
  }

  .urlbarView-url, .search-panel-one-offs-container {
    color: var(--mff-urlbar-results-url-color) !important;
    font-family: var(--mff-urlbar-font-family);
    font-weight: var(--mff-urlbar-results-font-weight);
    font-size: var(--mff-urlbar-font-size) !important;
  }

  .urlbarView-favicon, .urlbarView-type-icon {
    display: none !important;
  }

  #urlbar-input {
    font-size: var(--mff-urlbar-font-size) !important;
    color: var(--mff-urlbar-color) !important;
    font-family: var(--mff-urlbar-font-family) !important;
    font-weight: var(--mff-urlbar-font-weight)!important;
    text-align: center !important;
  }

  #tracking-protection-icon-container, #identity-box {
    display: none;
  }

  #back-button > .toolbarbutton-icon{
    --backbutton-background: transparent !important;
    border: none !important;
  }

  toolbar {
    background-image: none !important;
  }

  #urlbar-background {
    opacity: .98 !important;
  }

  #navigator-toolbox, toolbaritem {
    border: none !important;
  }

  #urlbar-background {
    background-color: var(--mff-bg) !important;
    border: none !important;
  }

  .toolbar-items {
    background-color: var(--mff-bg) !important;
  }

  #sidebar-search-container {
    background-color: var(--mff-sidebar-bg) !important;
  }

  box.panel-arrowbox {
    display: none;
  }

  box.panel-arrowcontent {
    border-radius: 8px !important;
    border: none !important;
  }

  tab.tabbrowser-tab {
    overflow: hidden;
  }

  tab.tabbrowser-tab:hover {
    box-shadow: 0 1px 4px rgba(0,0,0,.05);
  }

  image#star-button {
    display: none;
  }

  toolbar#nav-bar {
    padding: var(--mff-nav-toolbar-padding) !important;
  }

  toolbar#nav-bar {
    padding: 0px !important;
  }

  #urlbar {
    max-width: 100% !important;
    margin: 0 !important;
    /* 	position: unset!important; */;
  }

  #urlbar-input:focus {
    color: var(--mff-urlbar-focused-color) !important;
  }

  .megabar[breakout-extend="true"]:not([open="true"]) > #urlbar-background {
    box-shadow: none !important;
    background-color: transparent !important;
  }

  toolbarbutton {
    box-shadow: none !important;
  }
''
