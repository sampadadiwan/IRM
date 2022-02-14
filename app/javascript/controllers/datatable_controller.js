import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  connect() {

      let table = $('.jqDataTable').DataTable({
        stateSave: true,
        language: {
          search: '',
          searchPlaceholder: "Search...",
          paginate: {
            "previous": "Prev"
          }
        }
      });   
      
      $(document).on('turbo:before-cache', function() {     
        table.destroy();
      });
      
  }

}
