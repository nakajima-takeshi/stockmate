import { Controller } from "@hotwired/stimulus"
export default class extends Controller {
  static targets = ["modal"]

  // 接続時に要素にフォーカスを設定
  connect() {
    this.element.focus();
  }

  // デフォルト動作を防止し、削除
  hide(event) {
    if (event) {
      event.preventDefault();
    }
    this.element.remove();
  }

  // フォーム送信したらモーダル非表示
  hideOnSubmit(event) {
    if (event && event.detail.success) {
      this.hide();
    }
  }

  //切断時にturbo-flameのsrcをリセット
  disconnect() {
    if (this.element) {
      const frame = this.#modalTurboFrame;
      if (frame) {
        frame.src = null;
      }
    }
  }

  // if="modal"のturbo-flame要素を取得
  get #modalTurboFrame() {
    return document.querySelector("turbo-frame[id='modal']");
  }
}
