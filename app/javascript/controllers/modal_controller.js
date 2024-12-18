import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="modal"
export default class extends Controller {
  connect() {
    this.element.focus();
  }

  hide(event) {
    event.preventDefault();

    this.element.remove();
  }

  hideOnSubmit(event) {
    if (event.detail.success) {
      this.hide();
    }
  }

  disconnect() {
    this.#modalTurboFrame.src = null;
  }

  // private

  get #modalTurboFrame() {
    return document.querySelector("turbo-frame[id='modal']");
  }
}