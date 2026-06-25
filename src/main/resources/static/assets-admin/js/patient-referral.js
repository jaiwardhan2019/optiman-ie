
    function addReferralBodyToMessageBox() {
        var selectedValue = document.getElementById('referralBody').value;
        //alert(selectedValue);
        getTemplateDataAddTotheReferralDetail(selectedValue);
    }



    async function getTemplateDataAddTotheReferralDetail(templateId) {
        if (!templateId) {
            templateId = "00";
        }
        const url = "get_template_data/" + templateId;
        try {
            const response = await fetch(url, {
                method: 'GET',
                headers: { 'Content-Type': 'application/json' }
            });
            if (!response.ok) {
                throw new Error('Network response was not ok');
            }
            const data = await response.text();
            //document.getElementById('emailContent').value = data;
            quill.clipboard.dangerouslyPasteHTML(data);
        } catch (error) {
            console.error('Fetch error:', error);
            alert('An error occurred');
        }
    }



    function addReferralTypeToMessageBox() {
        var selectedValue = document.getElementById('referralSnippet').value;
        getTemplateDataAddTotheTextArea(selectedValue)
        //autoResize(textValue);
    }


    let quill; // global variable
    window.addEventListener('DOMContentLoaded', function() {
        quill = new Quill('#referralDetail', {
            theme: 'snow'
        });
    });

    async function getTemplateDataAddTotheTextArea(templateId) {
        if (!templateId) {
            templateId = "00";
        }
        const url = "get_template_data/" + templateId;
        try {
            const response = await fetch(url, {
                method: 'GET',
                headers: { 'Content-Type': 'application/json' }
            });
            if (!response.ok) {
                throw new Error('Network response was not ok');
            }
            const data = await response.text();
            //document.getElementById('emailContent').value = data;
            quill1.clipboard.dangerouslyPasteHTML(data);
        } catch (error) {
            console.error('Fetch error:', error);
            alert('An error occurred');
        }
    }



     function UpdateDataToTheReferralPdfFile(documentId) {

         const referralType = document.getElementById('referralType').value;
         const referralReason = document.getElementById('referralReason').value;
         const referralDetails = document.getElementById('referralDetail').innerHTML;
         const hospitalName = document.getElementById('hospitalName').value;
         const documentIdValue = document.getElementById('documentUserId').value;

         if (document.getElementById('referralDetail').innerHTML == "") {
             Swal.fire({
                 title: 'Validation Error',
                 text: 'Referral Details must be provided.',
                 icon: 'warning'
             }).then(() => {
                 document.getElementById('referralDetail').focus();
             });
             return;
         }

       const requestData = {
                 documentName: document.getElementById('referralFileName').value,
                 documentUserId: document.getElementById('documentUserId').value,
                 referralType: referralType,
                 hospitalName: document.getElementById('hospitalName').value,
                 referralReason: document.getElementById('referralReason').value,
                 healthSummary: document.getElementById('healthSummary').value,
                 referralDetails: document.getElementById('referralDetail').innerHTML
       };

         // Show loading state
         //Swal.fire({title: 'In progress...',allowOutsideClick: false, didOpen: () => Swal.showLoading(),});

         // Call the endpoint using fetch
         fetch('create_referral_letter', {
             method: 'POST',
             headers: { 'Content-Type': 'application/json' },
             body: JSON.stringify(requestData)
         })
         .then(response => {
             if (!response.ok) {
                 throw new Error('Network response was not ok: ' + response.statusText);
             }
             return response.text();
         })
         .then(data => {
             //Swal.fire({title: 'Success!',text: data,icon: 'success'});
             // ... additional logic if needed
             document.getElementById('pdfPreview_2').src = document.getElementById('pdfPreview_2').src;
             reloadEhrLogAndRender(documentId);


         })
         .catch(error => {
             Swal.fire({
                 title: 'Error',
                 text: error.message,
                 icon: 'error'
             });
         });
     }

    function createReferralPdfAndView(refFileName){
            //createReferralBackGround(documentId);
            viewPdfDocument(refFileName);
    }



    //-------- This method will send the referral letter to the patient
    function sendReferralToPatientAccountAndNotifyViaEmail(documentName) {
        const referralType = document.getElementById('referralType').value;
        const documentUserId = document.getElementById('documentUserId').value;
        const documentEmailId = document.getElementById('patientEmailId').value;

        // Show confirmation prompt with input box for documentEmailId
        Swal.fire({
            title: 'Confirm Patient Email',
            html: `
                <input id="swal-input-patientEmailId" class="swal2-input" type="text" value="${documentEmailId}" autocomplete="off" style="width: 400px;">
            `,
            input: null,
            width: '600px',
            showCancelButton: true,
            confirmButtonText: 'Send Referral',
            preConfirm: () => {
                const email = document.getElementById('swal-input-patientEmailId').value.trim();
                if (!email) {
                    Swal.showValidationMessage('Patient email cannot be blank or empty!');
                    return false;
                }
                return email;
            }
        }).then((result) => {
            if (result.isConfirmed && result.value) {
                const requestData = {
                    documentName: documentName,
                    documentUserId: documentUserId,
                    referralType: referralType,
                    documentEmailId: result.value
                };

                // Show loading state
                Swal.fire({
                    title: 'Sending in progress...',
                    allowOutsideClick: false,
                    didOpen: () => Swal.showLoading(),
                });

                fetch('send-referral-to-patient', {
                    method: 'POST',
                    headers: { 'Content-Type': 'application/json' },
                    body: JSON.stringify(requestData)
                })
                .then(async response => {
                    const responseText = await response.text();
                    if (!response.ok || (responseText && responseText.includes('Error'))) {
                        Swal.fire({
                            title: 'Error!',
                            html: responseText || 'Could not send referral. Please try again.',
                            icon: 'error',
                            width: '800px',
                        });
                    } else {
                        Swal.fire({
                            title: 'Success!',
                            html: responseText || 'Referral sent successfully.',
                            icon: 'success',
                            width: '800px',
                        });

                        reloadEhrLogAndRender(documentUserId);

                    }
                })
                .catch(error => {
                    Swal.fire({
                        title: 'Error!',
                        text: error.message || 'Could not send referral. Please try again.',
                        icon: 'error',
                    });
                });
            }
        });
    }


      function viewPdfDocument(fileName) {
            const pdfUrl = "view-document-admin" + "?fileName=" + fileName;
            //const pdfUrl = "viewfile";
            window.open(pdfUrl, '_blank');
      }


    function reloadEhrLogAndRender(patientId) {

       const data = {
           patientId: patientId,
           documentType: null,
           serviceType: null,
           messageType: null
         };

         fetch('search-ehr-log?patientId='+encodeURIComponent(patientId), {
             method: 'POST',
             headers: {'Content-Type': 'application/json'},
             body: JSON.stringify(data)
         })
         .then(response => {
             if (!response.ok) throw new Error("Network response was not ok");
             return response.json();
         })
         .then(medicalLogs => {
             const tbody = document.getElementById("logTableBody");
             tbody.innerHTML = "";

             if (!medicalLogs || medicalLogs.length === 0) {
                 const row = document.createElement("tr");
                 const cell = document.createElement("td");
                 cell.colSpan = 6;
                 cell.textContent = " Sorry No logs found.!!!!!";
                 row.appendChild(cell);
                 tbody.appendChild(row);
             } else {
                 medicalLogs.forEach(log => {
                     const row = document.createElement("tr");

                     function formatDateTime(dt) {
                         if (!dt) return '';
                         const d = new Date(dt);
                         if (!isNaN(d)) {
                             return d.getFullYear() + '-' +
                                 String(d.getMonth() + 1).padStart(2, '0') + '-' +
                                 String(d.getDate()).padStart(2, '0') + ' ' +
                                 String(d.getHours()).padStart(2, '0') + ':' +
                                 String(d.getMinutes()).padStart(2, '0');
                         }
                         return dt;
                     }

                     row.innerHTML = `
                         <td height="50px">
                             <i class="bi bi-clipboard2-pulse" style="color: #FF1493"></i> ${log.doctorName ? log.doctorName + '&nbsp;' : ''}
                             ${formatDateTime(log.transDateTime || log.formatLocalDateTime)}. &nbsp;&nbsp;&nbsp;
                             ${log.notes ? log.notes : ''}
                             ${log.notes && log.notes.includes('.pdf') && log.documentName ? `
                                 <iframe src="view-document-admin?fileName=${encodeURIComponent(log.documentName)}"
                                     style="width:100%; min-height:300px; margin-top:15px;"></iframe>
                             ` : ''}
                         </td>
                     `;
                     tbody.appendChild(row);
                 });
             }
         })
         .catch(error => {
             const tbody = document.getElementById("logTableBody");
             tbody.innerHTML = "";
             const row = document.createElement("tr");
             const cell = document.createElement("td");
             cell.colSpan = 6;
             cell.textContent = error.message || "Failed to fetch EHR logs.";
             cell.style.color = "red";
             row.appendChild(cell);
             tbody.appendChild(row);
         });

    }




    let quill1; // global variable
    window.addEventListener('DOMContentLoaded', function() {
        quill1 = new Quill('#emailContent', {
            theme: 'snow'
        });
    });

    //-------- This method will show the modal to assign task to  reception -----------
    function openReferralSendingModel() {

       // clear previous input and assign new one
       document.getElementById('patientEmailId_1').value = document.getElementById('patientEmailId').value;

       const contentDiv = document.getElementById('emailContent');
       if (contentDiv) {
          quill1.clipboard.dangerouslyPasteHTML("");
       }

       const select = document.getElementById('referralSnippet');
        if (select) {
            select.selectedIndex = 0; // first option (blank)
        }

       //  Show model
       const referralEmail = new bootstrap.Modal(document.getElementById('referralEmailModel'));
       referralEmail.show();
    }


    function closeReferralSendingModel() {
        const modalEl = document.getElementById('referralEmailModel');
        const modalInstance = bootstrap.Modal.getInstance(modalEl) || new bootstrap.Modal(modalEl);
        modalInstance.hide();
    }


    //-------- This method will send the referral letter to the patient
   function sendReferralToPatient(documentName) {

       const patientEmailId = document.getElementById('patientEmailId_1').value;  // The  email id from the modal
       const referralFileName = document.getElementById('referralFileName').value;
       var emailContent = document.getElementById("emailContent").innerHTML;

       const requestData = {
           emailContent: emailContent,
           referralFileName: referralFileName,
           patientEmailId: patientEmailId
       };

        fetch('send-referral-to-patient', {
            method: 'POST',
            headers: { 'Content-Type': 'application/json' },
            body: JSON.stringify(requestData)
        })
        .then(async response => {
            const responseText = await response.text();
            if (!response.ok || (responseText && responseText.includes('Error'))) {
                Swal.fire({
                    title: 'Error!',
                    html: responseText || 'Could not send referral. Please try again.',
                    icon: 'error',
                    width: '800px',
                });
            } else {
                Swal.fire({
                    title: 'Success!',
                    html: responseText || 'Referral sent successfully.',
                    icon: 'success',
                    width: '800px',
                });

                //--Close the model
                closeReferralSendingModel();

                //--Reload ehr log
                //reloadEhrLogAndRender(documentUserId);
            }
        })
        .catch(error => {
            Swal.fire({
                title: 'Error!',
                text: error.message || 'Could not send referral. Please try again.',
                icon: 'error',
            });
        });

   }


   function sendReferralToHospital(documentName) {
        Swal.fire({
            title: 'Under Construction!',
            html:  'This feature is coming soon .',
            icon:  'error',
            width: '800px',
        });
   }