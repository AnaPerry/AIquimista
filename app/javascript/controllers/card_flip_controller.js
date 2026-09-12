import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["card", "image", "panel", "name", "text"]

  flip(event) {
    const card = event.currentTarget
    if (card.classList.contains("flipped")) return // don't flip twice

    const image   = card.dataset.cardImage
    const name    = card.dataset.cardName
    const meaning = card.dataset.cardMeaning || "Meaning unavailable."

    // load the image only now (real lazy load)
    const img = card.querySelector("[data-card-flip-target='image']")
    if (img && image) img.src = image

    card.classList.add("flipped")

    // show the meaning panel right below the card
    const slot  = card.closest(".reading-card-show-slot")
    const panel = slot.querySelector("[data-card-flip-target='panel']")
    const name_ = slot.querySelector("[data-card-flip-target='name']")
    const text  = slot.querySelector("[data-card-flip-target='text']")

    if (name_) name_.textContent = name
    if (text) text.textContent = meaning
    if (panel) panel.hidden = false
  }
}
