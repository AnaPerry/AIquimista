import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["card", "image", "panel", "name", "text"]

  flip(event) {
    const card = event.currentTarget
    if (card.classList.contains("flipped")) return // don't flip twice

    const image    = card.dataset.cardImage
    const name     = card.dataset.cardName
    const meaning  = card.dataset.cardMeaning || "Meaning unavailable."
    const reversed = card.dataset.cardReversed === "true"
    const position = card.dataset.position

    // load the image only now (real lazy load)
    const img = card.querySelector("[data-card-flip-target='image']")
    if (img && image) img.src = image

    // aplica a rotação visual na imagem, se invertida
    if (img) img.classList.toggle("reversed", reversed)

    card.classList.add("flipped")
    card.classList.toggle("reversed", reversed) // ativa a borda vermelha via CSS

    // busca o painel correspondente pela posição, não pela proximidade no DOM
    const panel = this.element.querySelector(`[data-card-flip-target='panel'][data-position="${position}"]`)
    if (!panel) return

    const name_ = panel.querySelector("[data-card-flip-target='name']")
    const text  = panel.querySelector("[data-card-flip-target='text']")

    if (name_) name_.textContent = reversed ? `${name} (Invertida)` : name
    if (text) text.textContent = meaning
    panel.hidden = false
  }
}
