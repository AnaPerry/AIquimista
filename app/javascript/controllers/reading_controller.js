import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = [ "label", "image", "meaning" ]

  populate(event) {
    const trigger = event.relatedTarget
    if (!trigger) return

    const name = trigger.getAttribute("data-card-name") || ""
    const image = trigger.getAttribute("data-card-image") || ""
    const meaning = trigger.getAttribute("data-card-meaning") || "Significado indisponível."

    // Atualiza o título
    if (this.hasLabelTarget) {
      this.labelTarget.textContent = name
    }

    // Atualiza a imagem
    if (this.hasImageTarget) {
      this.imageTarget.src = image
      this.imageTarget.alt = name
      this.imageTarget.style.display = image ? "block" : "none"
    }

    // Atualiza o significado
    if (this.hasMeaningTarget) {
      this.meaningTarget.textContent = meaning
    }
  }
}
