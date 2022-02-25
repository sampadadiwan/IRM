import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  connect() {

      let table = $('.jqDataTable').DataTable({
        stateSave: true,
        retrieve: true,
        language: {
          search: '',
          searchPlaceholder: "Search...",
          paginate: {
            "previous": "Prev"
          }
        }
      });   
      
      // Ensure DataTable is destroyed, else it gets duplicated
      $(document).on('turbo:before-cache', function() {     
        table.destroy();
      });
      
  }

}
