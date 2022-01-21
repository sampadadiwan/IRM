
import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  connect() {
    this.element.textContent = "Hello Investment!"
    $('.select2').select2();
  }
}
