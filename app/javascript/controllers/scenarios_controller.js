import { Controller } from "@hotwired/stimulus"

export default class extends Controller {

  connect() {
    
  }

  setScenario(event) {
    let scenario_id = $("#scenario_id").val();
    console.log(`setScenario called ${scenario_id}`);
    let form = $("#scenarios_form");
    let actionUrl = window.location.href;
    console.log(actionUrl);
    form.attr('action', actionUrl);
    let submit = $(event.target).closest("form").find("input[type='submit']");
    submit.click();
  }
}
