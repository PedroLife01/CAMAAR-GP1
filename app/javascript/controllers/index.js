// Import and register all your controllers from the importmap via controllers/**/*_controller
import { application } from "controllers/application"
import { eagerLoadControllersFrom } from "@hotwired/stimulus-loading"
eagerLoadControllersFrom("controllers", application)
import TabsController from "./tabs_controller"
application.register("tabs", TabsController)
import FormbuilderController from "./formbuilder_controller"
application.register("formbuilder", FormbuilderController)
