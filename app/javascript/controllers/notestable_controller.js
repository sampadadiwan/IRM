import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  connect() {
    $('#notes-table').DataTable({
        ajax: {
            url: '/notes',
            dataSrc: ''
        },
        serverSide: true,
        columns: [
          {title: 'User', data: 'user_name'},
          {title: 'Investor', data: 'investor_name'},
          {title: 'Details', data: 'details'}
        ]
      });
  }
}
