import { Controller } from "@hotwired/stimulus";

// Stimulusのコントローラーを定義　Controllerクラスを拡張して、新しいクラスを作成
export default class extends Controller {
// Stimulusのターゲットを定義・[カテゴリの選択要素, 単位を表示する要素];
  static targets = ["categorySelect", "unit"];

  connect() {
    this.updateUnit();
    this.categorySelectTarget.addEventListener('change', () => this.updateUnit());
  }

  updateUnit() {
    let unit = "";
    const value = this.categorySelectTarget.value;

    switch(value) {
      case "shampoo":
      case "body_soap":
      case "fabric_softener":
      case "dishwashing_detergent":
      case "lotion":
      case "serum":
        unit = 'mL';
        break;
      case "laundry_detergent_powder":
      case "laundry_detergent_liquid":
      case "face_wash":
      case "sunscreen":
      case "moisturising_cream":
        unit = 'mg';
        break;
      case "others":
      default:
        unit = ''
    }
    this.unitTarget.textContent = unit;
  }
}
