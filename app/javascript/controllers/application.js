import { Application } from "@hotwired/stimulus"

const application = Application.start()
application.debug = false

window.Stimulus = application

export { application }
import "controllers/tabs_controller"
import "controllers/formbuilder_controller"