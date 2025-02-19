import { Controller } from "@hotwired/stimulus";

export default class extends Controller {
  static targets = ["categorySelect", "unit", "select"];

  // iconPathをマッピング
  iconMapping = {
    'shampoo': '/assets/icons/shampoo.jpg',
    'body_soap': '/assets/icons/body_soap.jpg',
    'laundry_detergent_powder': '/assets/icons/laundry_powder.jpg',
    'laundry_detergent_liquid': '/assets/icons/laundry_liquid.jpg',
    'fabric_softeners': '/assets/icons/softener.jpg',
    'dishwashing_detergent': '/assets/icons/dish.jpg',
    'lotion': '/assets/icons/lotion.jpg',
    'serum': '/assets/icons/serum.jpg',
    'moisturising_cream': '/assets/icons/cream.jpg',
    'face_wash': '/assets/icons/face_wash.jpg',
    'sunscreen': '/assets/icons/sunscreen.jpg',
    'others': '/assets/icons/others.jpg'
  }

  // 入力されたデータからアセットパイプラインを利用して画像を選択して取得
  confirmIcon(event) {
    const selectedCategory = this.categorySelectTarget.value
    const hidden = document.createElement("input")
    const iconPath = this.iconMapping[selectedCategory]
    hidden.type = "hidden"
    hidden.name = "item[icon_path]" //params[:item][:icon_path]と同義
    hidden.value = iconPath
    event.target.appendChild(hidden)
    return true
  }

  // カテゴリー選択時に単位を変更
  connect() {
    this.updateUnit();
    this.categorySelectTarget.addEventListener('change', () => this.updateUnit());
  }

  // 選択したvalueを返す
  updateUnit() {
    let unit = "";
    const value = this.categorySelectTarget.value;
    switch(value) {
      case "shampoo":
      case "body_soap":
      case "fabric_softeners":
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
