import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  connect() {
    $('#smartwizard').smartWizard({
        theme: 'dots',
    });
  }
}
