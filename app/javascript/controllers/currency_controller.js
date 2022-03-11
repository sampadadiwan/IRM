import { Controller } from "@hotwired/stimulus"

export default class extends Controller {

  connect() {
    
  }

  setCurrencyUnit(event) {
    let units = $("#currency_units").val();
    console.log(`setCurrencyUnit called ${units}`);
    let form = $("#currency_units_form");
    form.attr('action', window.location.href);
    let submit = $("#currency_units_form #submit");
    submit.click();
  }
}
