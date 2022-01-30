import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  connect() {
    console.log("Sortable setup.")
    // Setup the sortable content
    new Sortable(deal_activities_tbody, {
        animation: 150,
        draggable: ".item",
        handle: ".handle",
        ghostClass: 'blue-background-class',
        onEnd: function(event) {
            console.log(event.item);
            let id = event.item.id.replace("deal_activity_", "");
            $.post(`/deal_activities/${id}/update_sequence`, {sequence: event.newIndex}, function(result){
                location.reload();
            });
        }
    });  

    
  }
}
