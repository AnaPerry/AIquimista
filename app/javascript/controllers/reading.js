document.addEventListener("DOMContentLoaded", function () {
  const cartaModal = document.getElementById("cartaModal");
  if (!cartaModal) return;

  cartaModal.addEventListener("show.bs.modal", function (event) {
    const trigger = event.relatedTarget;
    if (!trigger) return;

    const name    = trigger.getAttribute("data-card-name") || "";
    const image   = trigger.getAttribute("data-card-image") || "";
    const meaning = trigger.getAttribute("data-card-meaning") || "Significado indisponível.";

    cartaModal.querySelector("#cartaModalLabel").textContent = name;

    const img = cartaModal.querySelector("#cartaModalImg");
    img.src = image;
    img.alt = name;
    img.style.display = image ? "block" : "none";

    cartaModal.querySelector("#cartaModalMeaning").textContent = meaning;
  });
});
