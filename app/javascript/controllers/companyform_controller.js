import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  connect() {
    $( document ).on('turbo:render', function() {
        console.log("CompanyFormController");

        if ($("#company_company_type").val() == "VC") {
          $("#company_founded_group").toggle();
          $("#company_funding_amount").toggle();
          $("#company_funding_unit").toggle();
          console.log("CompanyFormController: toggled");
        }
      
        $("#company_company_type").on("change", function(){
            console.log("CompanyFormController: change");
            $("#company_founded_group").toggle();
            $("#company_funding_amount").toggle();
            $("#company_funding_unit").toggle();
        });

    });
  }
}
