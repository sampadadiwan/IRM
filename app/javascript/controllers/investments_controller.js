import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  connect() {

      let options = {
        stateSave: true,
        retrieve: true,
        language: {
          search: '',
          searchPlaceholder: "Search...",
          paginate: {
            "previous": "Prev"
          }          
        }
      };   

      let t1 = $("#investments-Equity").DataTable(options);
      let t2 = $("#investments-Debt").DataTable(options);
      
      // Ensure DataTable is destroyed, else it gets duplicated
      $(document).on('turbo:before-cache', function() {     
        t2.destroy();
        t1.destroy();
      });
      
  }

}
