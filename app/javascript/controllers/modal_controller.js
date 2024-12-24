import { Controller } from "@hotwired/stimulus"
export default class extends Controller {
  static targets = ["modal"]

  connect() {
    this.element.focus();
  }

  hide(event) {
    if (event) {
      event.preventDefault();
    }
    this.element.remove();
  }

  hideOnSubmit(event) {
    if (event && event.detail.success) {
      this.hide();
    }
  }
  disconnect() {
    if (this.element) {
      const frame = this.#modalTurboFrame;
      if (frame) {
        frame.src = null;
        this.event?.preventDefault();
      }
    }
  }

  get #modalTurboFrame() {
    return document.querySelector("turbo-frame[id='modal']");
  }
}
