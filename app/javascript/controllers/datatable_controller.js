import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  connect() {
    let data_url = $("#data_url").val();

    $('.jqDataTable').DataTable( {
        stateSave: true,
        "processing": true,
        "serverSide": true,
        "ajax": `${data_url}`,
        "columns": [         
        ]
    } );
  }
}
