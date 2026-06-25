         function createMedical_Cert_UsingModel(dataForModal) {

                //--- Display button
                var canButton = document.getElementById('canButton');
                canButton.style.display = "block";

                var okButton = document.getElementById('okButton');
                okButton.style.display = "block";

                var clButton = document.getElementById('close-Button');
                clButton.style.display = "none";

                // Show the confirmation modal
                document.getElementById('modelBodyContent_1').innerHTML = dataForModal;
                const confirmationModal = new bootstrap.Modal(document.getElementById('createCertModel'));
                confirmationModal.show();

            }


            function confirmActionCreateSickNote(requestId){

                document.getElementById('modelBodyContent_1').innerHTML = "<div class='spinner-border text-dark' role='status'></div> &nbsp; In progress...";
                const emailData = {
                    requestId:  requestId,
                    additionalNote:  document.getElementById('additionalNote').value
                 };

                setTimeout(function() {
                    fetch('save-gpcomment-on-sicknote', { method: 'POST', headers: { 'Content-Type': 'application/json' },
                        body: JSON.stringify(emailData) })
                        .then(response => response.text())
                        .then(data => {

                            document.getElementById("modelBodyContent_1").innerHTML = "<i class='bi bi-check2-all' style='color: green;font-size:1.4em;'> </i> "+data;

                            var sickNote = document.getElementById('mainFile');
                            sickNote.style.display = "block";

                            var secureSickNote = document.getElementById('secureFile');
                            secureSickNote.style.display = "block";


                        }).catch(error => {document.getElementById("modelBodyContent_1").innerHtml = error;}
                    );

                    var clButton = document.getElementById('close-Button');
                    clButton.style.display = "block";

                }, 1000);


                var canButton = document.getElementById('canButton');
                canButton.style.display = "none";

                var okButton = document.getElementById('okButton');
                okButton.style.display = "none";

            }//-- End of function




           function back_to_list_page(endpoint){
             window.location.href = "${pageContext.request.contextPath}/"+endpoint;
           }


           function showConfirmationModal(dataForModal) {

                 //--- Display button
                 const modalFooter = document.querySelector(".modal-footer");
                 const cancelButton = modalFooter.querySelector(".btn-danger");
                 const okButton = modalFooter.querySelector(".btn-info");
                 cancelButton.style.display = "block";
                 okButton.style.display = "block";

                 //---  Hide cross button
                 var closeButton = document.getElementById('closeButton');
                 closeButton.style.display = "none";


               // Show the confirmation modal
               document.getElementById('modelBodyContent').innerText = dataForModal;
               const confirmationModal = new bootstrap.Modal(document.getElementById('confirmationModal'));
               confirmationModal.show();
           }



         function confirmAction(confirmationMessage){

            document.getElementById('modelBodyContent').innerHTML = "<div class='spinner-border text-dark' role='status'></div> &nbsp; In progress...";
            const emailData = {
                requestId:  "${requestObj.srvRequest.requestId}",
                additionalNote:  document.getElementById('additionalNote').value
             };


                fetch('notify-patient-sicknote', { method: 'POST', headers: { 'Content-Type': 'application/json' },
                    body: JSON.stringify(emailData) })
                    .then(response => response.text())
                    .then(data => {
                        document.getElementById("modelBodyContent").innerHTML = "<i class='bi bi-check2-all' style='color: green;font-size:1.4em;'> </i> "+data;
                    }).catch(error => {document.getElementById("modelBodyContent").innerHtml = error;}


                );

                var closeButton = document.getElementById('closeButton');
                closeButton.style.display = "block";



            hideOkButton();

         } //  End of method


        function hideOkButton(){
              // Select modal-footer element
              const modalFooter = document.querySelector(".modal-footer");
              // Hide ok buttons
              const okButton = modalFooter.querySelector(".btn-info");
              okButton.style.display = "none";

              const cancButton = modalFooter.querySelector(".btn-danger");
              cancButton.style.display = "none";
        }




