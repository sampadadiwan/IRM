import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  connect() {
    $('.jqDataTable').DataTable( {
        stateSave: true,      
        language: { 
          search: '', 
          searchPlaceholder: "Search..." ,
          paginate: {
            "previous": "Prev"
          }
        }
    } );
  }
}
