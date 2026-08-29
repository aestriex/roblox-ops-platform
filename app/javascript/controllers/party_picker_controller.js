import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = [
    "list", "fieldsTemplate",
    "personWrapper", "customNameWrapper", "customNameInput", "roleInput", "error",
  ]

  connect() {
    this.selectedEntity = null
    this.selectedLabel = null

    const comboboxLabel = this.element.querySelector('[data-ui--combobox-target="label"]')
    this.comboboxPlaceholder = comboboxLabel ? comboboxLabel.textContent : ""
  }

  personSelected(event) {
    this.selectedEntity = event.detail.value
    this.selectedLabel = event.detail.label
  }

  showCustomName(event) {
    event.preventDefault()

    this.resetCombobox()
    this.personWrapperTarget.classList.add("hidden")
    this.customNameWrapperTarget.classList.remove("hidden")
    this.customNameInputTarget.focus()
  }

  showPersonPicker(event) {
    event.preventDefault()

    this.customNameWrapperTarget.classList.add("hidden")
    this.customNameInputTarget.value = ""
    this.personWrapperTarget.classList.remove("hidden")
  }

  confirm(event) {
    event.preventDefault()

    const customName = this.customNameInputTarget.value.trim()
    const role = this.roleInputTarget.value.trim()

    if (!this.selectedEntity && !customName) {
      this.errorTarget.textContent = "Select a person or enter a custom party name."
      this.errorTarget.classList.remove("hidden")
      return
    }

    const displayName = this.selectedEntity ? this.selectedLabel : customName

    const html = this.fieldsTemplateTarget.innerHTML.replace(/NEW_RECORD/g, new Date().getTime())
    const wrapper = document.createElement("div")
    wrapper.innerHTML = html.trim()
    const row = wrapper.firstElementChild

    row.querySelector("input[name*='[entity_selector]']").value = this.selectedEntity || ""
    row.querySelector("input[name*='[custom_party_name]']").value = this.selectedEntity ? "" : customName
    row.querySelector("input[name*='[role]']").value = role
    row.querySelector("[data-row-name]").textContent = displayName
    row.querySelector("[data-row-role]").textContent = role || "—"

    this.listTarget.appendChild(row)
    this.resetPopup()
    this.closePopup(event.target)
  }

  removeRow(event) {
    const row = event.target.closest("[data-row]")
    const idInput = row.querySelector("input[name*='[id]']")

    if (idInput && idInput.value) {
      row.querySelector("input[name*='_destroy']").value = "1"
      row.classList.add("hidden")
    } else {
      row.remove()
    }
  }

  resetPopup() {
    this.selectedEntity = null
    this.selectedLabel = null
    this.roleInputTarget.value = ""

    if (this.hasErrorTarget) this.errorTarget.classList.add("hidden")

    this.customNameWrapperTarget.classList.add("hidden")
    this.customNameInputTarget.value = ""
    this.personWrapperTarget.classList.remove("hidden")

    this.resetCombobox()
  }

  resetCombobox() {
    this.selectedEntity = null
    this.selectedLabel = null

    const comboboxLabel = this.element.querySelector('[data-ui--combobox-target="label"]')
    const comboboxInput = this.element.querySelector('[data-ui--combobox-target="input"]')
    if (comboboxLabel) comboboxLabel.textContent = this.comboboxPlaceholder
    if (comboboxInput) comboboxInput.value = ""
  }

  closePopup(target) {
    const dialog = target.closest('[data-controller~="ui--dialog"]')
    dialog?.querySelector('[data-ui--dialog-target="closeButton"]')?.click()
  }
}
