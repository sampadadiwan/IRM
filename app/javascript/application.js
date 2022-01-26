// Configure your import map in config/importmap.rb. Read more: https://github.com/rails/importmap-rails
import "@hotwired/turbo-rails"
import "trix"
import "@rails/actiontext"
import "controllers"
import "@popperjs/core"
import "chartkick"
import "Chart.bundle"

$( document ).on('turbo:load', function() {
    $('[data-toggle="tooltip"]').tooltip({'placement': 'top'});
});
