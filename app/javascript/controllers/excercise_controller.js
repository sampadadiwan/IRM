import { Controller } from "@hotwired/stimulus"

export default class extends Controller {

  connect() {
    
    console.log("Excercise controller loaded");
    this.onChange(null);
    
  }

  onChange(event) {
    console.log("onChange");
    let qty = $("#excercise_quantity").val();
    let price = $("#excercise_price").val();
    
    let amount = qty * price;
    let tax_rate = $("#excercise_tax_rate").val();
    let tax = amount * tax_rate / 100.0;
    console.log("amount: " + amount);
    console.log("tax: " + tax);

    $("#excercise_amount").val(amount.toFixed(2));
    $("#excercise_tax").val(tax.toFixed(2));
  }

}
