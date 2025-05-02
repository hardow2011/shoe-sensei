// Entry point for the build script in your package.json
import "@hotwired/turbo-rails"
import "./controllers"

import * as ActiveStorage from "@rails/activestorage"
ActiveStorage.start()

import "@fortawesome/fontawesome-free/js/solid.min";
import "@fortawesome/fontawesome-free/js/brands.min";
import "@fortawesome/fontawesome-free/js/fontawesome.min";
import './navbar_burger'
import './tinymce_reinit_fix'