import { Controller } from "@hotwired/stimulus";

export default class extends Controller {
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
