import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
    connect() {

        Core.setWorkerPath('/lib/core');

        $("#viewer").width(screen.availWidth * .9);

        let viewer_link = $("#viewer_link").val();
        let viewer_watermark = $("#viewer_watermark").val();
        let viewer_content_type = $("#viewer_content_type").val();

        console.log(`pdf_controller connected: ${viewer_link}`);

        if (viewer_content_type == "application/pdf") {
            this.viewPDF(viewer_link, viewer_watermark);
        } else {
            this.officeToPDF(viewer_link, viewer_watermark);
        }

    }

    viewPDF(viewer_link, viewer_watermark) {
        WebViewer({
            path: '/lib', // path to the PDFTron 'lib' folder on your server
            // initialDoc: 'https://pdftron.s3.amazonaws.com/downloads/pl/demo-annotated.pdf',
        }, document.getElementById('viewer'))
            .then(instance => {
                const docViewer = instance.Core.documentViewer;
                const annotManager = instance.Core.annotationManager;

                instance.UI.loadDocument(viewer_link, {
                    filename: 'myfile.pdf'
                });

                $("#viewer_label").hide();

                const { documentViewer } = instance.Core;

                documentViewer.setWatermark({
                    // Draw diagonal watermark in middle of the document
                    diagonal: {
                        fontSize: 25, // or even smaller size
                        fontFamily: 'sans-serif',
                        color: 'red',
                        opacity: 40, // from 0 to 100
                        text: viewer_watermark
                    },

                    // Draw header watermark
                    header: {
                        fontSize: 8,
                        fontFamily: 'sans-serif',
                        color: 'red',
                        opacity: 40,
                        // left: 'left watermark',
                        center: viewer_watermark,
                        right: ''
                    }
                });

                // // call methods from instance, documentViewer and annotationManager as needed

                // // you can also access major namespaces from the instance as follows:
                // // const Tools = instance.Core.Tools;
                // // const Annotations = instance.Core.Annotations;

                // docViewer.addEventListener('documentLoaded', () => {
                //     // call methods relating to the loaded document
                // });
            });
    }

    officeToPDF(viewer_link, viewer_watermark) {
        
        PDFNet.initialize()
            .then(() => this.convertOfficeToPDF(viewer_link, `converted.pdf`, viewer_watermark))
            .then(() => {
                console.log('Test Complete!');

            })
            .catch(err => {
                console.log('An error was encountered! :(', err);
            });
    }

    convertOfficeToPDF(inputUrl, outputName, viewer_watermark, l) {

        Core.officeToPDFBuffer(inputUrl, { l }).then(buffer => {
            this.viewPDF(buffer, viewer_watermark);
        });
    }


}
