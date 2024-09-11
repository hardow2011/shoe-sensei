// Entry point for the build script in your package.json
import "@hotwired/turbo-rails"
import "./controllers"

import * as ActiveStorage from "@rails/activestorage"
ActiveStorage.start()

import './direct_uploads'
import "@fortawesome/fontawesome-free/js/all";
import './img_upload_previews'
import './navbar_burger'
import './model_filter_mobile'
import './model_grid_skeleton'
// import "trix"
// import "./trix_customization"
import "@rails/actiontext"
