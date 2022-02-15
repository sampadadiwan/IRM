import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
    connect() {
        console.log("Tree view controller");
        
        var toggler = document.getElementsByClassName("caret");
        var i;

        for (i = 0; i < toggler.length; i++) {
            toggler[i].addEventListener("click", function () {
                this.parentElement.querySelector(".nested").classList.toggle("active");
                this.classList.toggle("caret-down");
            });
        }
    }
}
