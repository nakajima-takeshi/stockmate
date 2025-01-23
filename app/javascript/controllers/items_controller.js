import { Controller } from "@hotwired/stimulus";

export default class extends Controller {
  static targets = ["categorySelect", "unit", "select"];

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

  confirmIcon(event) {
    const selectedCategory = this.categorySelectTarget.value
    if (!selectedCategory) {
      event.preventDefault()
      alert("カテゴリーを選択してください")
      return false
    }

    const hidden = document.createElement("input")
    const iconPath = this.iconMapping[selectedCategory] || this.iconMapping["others"]
    hiddenIconField.type = "hidden"
    hiddenIconField.name = "item[icon_path]"
    hiddenIconField.value = iconPath
    event.target.appendChild(hiddenIconField)

    return true
  }

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
