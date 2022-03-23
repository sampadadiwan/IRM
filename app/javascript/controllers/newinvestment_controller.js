import { Controller } from "@hotwired/stimulus"

export default class extends Controller {

  connect() {
    $("#investment_investor_id").on('select2:select', function () {
        let event = new Event('change', { bubbles: true }) // fire a native event
        this.dispatchEvent(event);
    });

    $(".rmbtn").first().hide();

  }

  setCategory(event) {
    let investor_id = $("#investment_investor_id").val();
    $.ajax({
        url: `/investors/${investor_id}.json`
    }).then(function(data) {
        console.log(`Setting category to ${data.category}`);
        $("#investment_category").val(data.category);       
    });
  }

  rmInvestmentRow(event) {
    event.preventDefault();
    console.log(event);
    let row = $(event.target).closest(".investment_row");
    row.remove();
    return false;
  }

  addInvestmentRow(event) {
    console.log("addInvestmentRows");
    event.preventDefault();

    let count = $(".form-row").length;
    console.log(`Length of form-rows = ${count}`)
    $(".investment_row_container").append(
      `<div class="card investment_row" id="investment_row_${count + 10}">` + 
      $("#investment_row").html() +
      '</div>'
      );
    
      $(`#investment_row_${count + 1}`).find(':input').val('');    

      $(".rmbtn").last().show();
  }
}
