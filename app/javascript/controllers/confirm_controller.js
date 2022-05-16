import { Controller } from "@hotwired/stimulus"

export default class extends Controller {

    connect() {
        console.log("confirm connect");
    }

    delete(event) { 
        let btn = $(event.target);
        console.log();
        this.deleteForm = event.target.closest("form");
        // We set the action to the delete btn form action
        $("#confirm_submit").attr("action", this.deleteForm.action);

        // Now we need to set turbo on or off, depending on the buttons turbo setting
        $("#confirm_submit").attr("data-turbo", true);
        if(btn.attr("data-turbo") == "false") {
            $("#confirm_submit").attr("data-turbo", false);    
        }

        // Finally we need the authenticity token from the delete btn form
        let at = $(this.deleteForm).find('input[name="authenticity_token"]').val();
        $("#confirm_submit").find("#confirm_at").val(at);

        $('#confirmModal').modal({});
        event.preventDefault();
    }

    ok(event) {
        console.log("confirm clicked");
        $('#confirmModal').modal('hide');
    }

}


