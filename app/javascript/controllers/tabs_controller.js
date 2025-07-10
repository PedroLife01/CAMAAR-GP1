// app/javascript/controllers/tabs_controller.js
import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["tab", "panel"]

  connect() {
    // Procura pela aba com a classe 'tab-active' e a ativa
    const defaultTab = this.tabTargets.find(tab => tab.classList.contains('tab-active')) || this.tabTargets[0]
    this.showTab(defaultTab)
  }

  select(event) {
    event.preventDefault()
    this.showTab(event.currentTarget)
  }

  showTab(selectedTab) {
    const index = this.tabTargets.indexOf(selectedTab)

    this.tabTargets.forEach((tab, i) => {
      tab.classList.toggle("tab-active", i === index)
    })

    this.panelTargets.forEach((panel, i) => {
      panel.classList.toggle("hidden", i !== index)
    })
  }
}
