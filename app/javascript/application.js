// Configure your import map in config/importmap.rb. Read more: https://github.com/rails/importmap-rails
import "@hotwired/turbo-rails"
import "controllers"
import "trix"
import "@rails/actiontext"
import "bootstrap"

// Instantiate the Bloodhound suggestion engine
const companies = new Bloodhound({
    datumTokenizer: datum => Bloodhound.tokenizers.whitespace(datum.value),
    queryTokenizer: Bloodhound.tokenizers.whitespace,
    remote: {
      wildcard: '%QUERY',
      url: "/companies/search.json?query=%QUERY",
      // Map the remote source JSON array to a JavaScript object array
      transform: response => $.map(response, company => ({
        value: company.name
      }))
    }
  });
  
  // Instantiate the Typeahead UI
  $('.typeahead').typeahead(null, {
    display: 'value',
    source: companies
  });
  