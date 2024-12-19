import { Controller } from "@hotwired/stimulus"
export default class extends Controller {
  static targets = ["modal"]
  // コントローラー接続で呼び出される
  connect() {
    this.element.focus();
  }

  // モーダルを非表示
  hide(event) {
    event.preventDefault();

    //DOMからモーダルを削除
    this.element.remove();
  }

  //フォーム送信が終わるとモーダルを非表示
  hideOnSubmit(event) {
    if (event && event.detail.success) {
      this.hide();
    }
  }

// モーダルをDOMから削除
  hide() {
    this.element.remove(); 
  }

  //モーダルが閉じられると発火
  disconnect() {
    if (this.element) {
      //モーダルが閉じられたときにTurboフレームのsrc属性をnullに設定
      this.#modalTurboFrame.src = null;
    }
  }

  // private

  // Turbo flame要素を取得
  get #modalTurboFrame() {
    return document.querySelector("turbo-frame[id='modal']");
  }
}