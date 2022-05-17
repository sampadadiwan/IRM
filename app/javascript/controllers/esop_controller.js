import { Controller } from "@hotwired/stimulus"

export default class extends Controller {

  connect() {
    this.onChange(null);
    console.log("ESOP javascript loaded");
  }

  onChange(event) {
    console.log("onChange");
    console.log("change");
    let selected = $("#holding_investment_instrument").val();
    switch (selected) {
      case "Options":
        $(".funding_round_group").hide();
        $(".esop_pool_group").show();
        break;
      default:
        $(".funding_round_group").show();
        $(".esop_pool_group").hide();
        break;
    }
  }

}
