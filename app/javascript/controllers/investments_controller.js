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
    $(document).on('turbo:before-cache', function () {
      t2.destroy();
      t1.destroy();
    });

    // Add event listener for opening and closing details
    $('#investments-Equity tbody').on('click', 'td.dt-control', function () {
      var tr = $(this).closest('tr');
      var row = t1.row(tr);

      if (row.child.isShown()) {
        // This row is already open - close it
        row.child.hide();
        tr.removeClass('shown');
        tr.find('svg').attr('data-icon', 'plus-circle');    // FontAwesome 5
      }
      else {

        $.ajax({
          url: `/holdings.json?limit=5`
        }).then(function(data) {
            console.log(data);
            row.child(format(data)).show();
            tr.addClass('shown');
            tr.find('svg').attr('data-icon', 'minus-circle');    // FontAwesome 5
        });

      }
    });

    function rowHtml(row, index) {
      return '<tr>'+
                '<td>'+row.user_name+'</td>'+
                '<td>'+row.investment_instrument+'</td>'+
                '<td>'+row.quantity+'</td>'+
              '</tr>'            
    }

    function format ( data ) {
      // `d` is the original data object for the row

      let rows = "";
      for (var i = 0; i < data.length; i++) { 
        rows += rowHtml(data[i]); 
      }

      // return rows;

      return '<table class="table table-bordered table-striped dataTable">'+
          '<tr>'+
            '<th>Name</th>'+
            '<th>Instrument</th>'+
            '<th>Quantity</th>'+
          '</tr>'+
          rows+          
      '</table>';
    }
  

  }



}
