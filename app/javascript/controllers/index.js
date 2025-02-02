// This file is auto-generated by ./bin/rails stimulus:manifest:update
// Run that command whenever you add a new controller or create them with
// ./bin/rails generate stimulus controllerName

import { application } from "./application"

import ClipboardController from "./clipboard_controller"
application.register("clipboard", ClipboardController)

import DialogController from "./dialog_controller"
application.register("dialog", DialogController)

import ExpandImageController from "./expand_image_controller"
application.register("expand-image", ExpandImageController)

import ListFilterController from "./list_filter_controller"
application.register("list-filter", ListFilterController)

import LeafletController from "./leaflet_controller"
application.register("leaflet", LeafletController)

import MentionController from "./mention_controller"
application.register("mention", MentionController)

import PwaInstallController from "./pwa_install_controller"
application.register("pwa-install", PwaInstallController)

import ToastController from "./toast_controller"
application.register("toast", ToastController)

import VisualizationCategorySwitchController from "./visualization_category_switch_controller"
application.register("visualization-category-switch", VisualizationCategorySwitchController)
