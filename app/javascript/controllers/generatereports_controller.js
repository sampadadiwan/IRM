import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["periodContainer"]

  connect() {
    console.log("Connected to generate reports controller")
  }

  addPeriod(event) {
    event.preventDefault();

    // Find the hidden template and clone it
    const template = `<!-- Hidden Template Row for Cloning -->
        <div class="row period-row">
          <div class="col-md-3">
            <div class="form-group">
              <label for="period">Period</label>
              <select name="kpi_report[period][]" class="form-control">
                <option value="Month">Month</option>
                <option value="Quarter">Quarter</option>
                <option value="Semi Annual">Semi Annual</option>
                <option value="Annual">Annual</option>
              </select>
              <small class="form-text text-muted">Select the KPI Report Period.</small>
            </div>
          </div>
          <div class="col-md-4">
            <div class="form-group">
              <label for="as_of">As of</label>
              <input type="date" name="kpi_report[as_of][]" class="form-control" >
              <small class="form-text text-muted">Select the date of the KPI report.</small>
            </div>
          </div>
          <div class="col-md-3">
            <div class="form-group">
              <label for="as_of">Add Docs</label>
              <input type="checkbox" name="kpi_report[add_docs][]" class="form-check-input mt-2" value="true" >
            </div>
          </div> 
          <div class="col-md-2 d-flex align-items-center justify-content-center">
            <button type="button" class="btn btn-danger remove-period" data-action="click->generatereports#removePeriod">
              ×
            </button>
          </div>
        </div>`;
    
      this.periodContainerTarget.insertAdjacentHTML("beforeend", template);

  }

  removePeriod(event) {
    event.preventDefault();
    event.target.closest(".period-row").remove();
  }
}
