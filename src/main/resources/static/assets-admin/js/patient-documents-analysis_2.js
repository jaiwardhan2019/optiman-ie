
  function loadReceptionistData(){
       fetch('get-staff-list')
            .then(response => response.json())
            .then(data => {
                const select = document.getElementById('receptionistId'); // This will load staff for task assignment
                // Remove all options except the first one
                select.options.length = 1;
                // data is an object: {user1: "Receptionist 1", user2: "Receptionist 2"}
                for (const [userId, fullName] of Object.entries(data)) {
                    const option = document.createElement('option');
                    option.value = userId;
                    option.textContent = fullName;
                    select.appendChild(option);
                }
            })
            .catch(error => {
                //alert("Failed to load receptionists: " + error);
            });
  }


  function loadStaffForDocumentDelegation(){
       fetch('get-staff-list')
            .then(response => response.json())
            .then(data => {
                const select = document.getElementById('staffId'); // This will load staff for task assignment
                // Remove all options except the first one
                select.options.length = 1;
                // data is an object: {user1: "Receptionist 1", user2: "Receptionist 2"}
                for (const [userId, fullName] of Object.entries(data)) {
                    const option = document.createElement('option');
                    option.value = userId;
                    option.textContent = fullName;
                    select.appendChild(option);
                }
            })
            .catch(error => {
                alert("Failed to load staff : " + error);
            });
  }



  function loadReceptionistActionItemData(){
         fetch('get-staff-action-list')
              .then(response => response.json())
              .then(data => {
                  const select = document.getElementById('actionId');
                  // Remove all options except the first one
                  select.options.length = 1;
                  // data is an object: {user1: "Receptionist 1", user2: "Receptionist 2"}
                  for (const [actionId, actionName] of Object.entries(data)) {
                      const option = document.createElement('option');
                      option.value = actionId;
                      option.textContent = actionName;
                      select.appendChild(option);
                  }
              })
              .catch(error => {
                  //alert("Failed to load action item : " + error);
              });

  }




    function addTaskToMessageBox() {
        var selectElement = document.getElementById('actionId');
        var selectedValue = selectElement.options[selectElement.selectedIndex].value;
        var textValue = document.getElementById('receptionTask');
        var start = textValue.selectionStart;
        var end = textValue.selectionEnd;
        // Insert the text at the cursor position
        textValue.setRangeText("\n\n" + selectedValue.replace(/<[^>]+>/g, ""), start, end, 'end');
        //textValue.value = textValue.value + "\n" + selectedValue;
        //textValue.value = selectedValue.replace(/PATIENT/g, patientName);
        autoResize(textValue);
    }


    function autoResize(textarea) {
      textarea.style.height = 'auto';
      textarea.style.height = textarea.scrollHeight + 'px';
    }


    function createTaskForStaff() {

        const form = document.getElementById('receptionTaskForm');
        const select = document.getElementById('actionId');
        const selectedDisplayName = select.options[select.selectedIndex].text;

        const selectStaff = document.getElementById('receptionistId');
        const staffDisplayName = selectStaff.options[selectStaff.selectedIndex].text;

        // Extract values
        const receptionistId = form.receptionistId.value && form.receptionistId.value.trim();
        const actionName = selectedDisplayName && selectedDisplayName.trim();
        const receptionTask = form.receptionTask.value && form.receptionTask.value.trim();

        // NULL/EMPTY validation
        if (!receptionistId || !actionName || !receptionTask) {
            let missingFields = [];
            if (!receptionistId) missingFields.push(" Staff ");
            if (!actionName) missingFields.push(" Action Item ");
            if (!receptionTask) missingFields.push("Action Details");

            Swal.fire({
                title: 'Validation Error',
                text: `Please select : ${missingFields.join(', ')}`,
                icon: 'warning',
                confirmButtonText: 'OK',
                confirmButtonColor: '#d33'
            });
            return;
        }

        const data = {
            documentId: form.documentId.value.trim(),
            receptionistId: receptionistId,
            actionName: actionName,
            receptionTask: receptionTask,
            staffDisplayName: staffDisplayName
        };

        Swal.fire({
            title: 'Are you sure?',
            text: "You won't be able to revert this!",
            icon: 'warning',
            showCancelButton: true,
            confirmButtonColor: '#03c4eb',
            cancelButtonColor: '#d33',
            confirmButtonText: 'Yes create task ..',
        }).then((result) => {
            if (result.isConfirmed) {
                fetch('create-task-for-staff', {
                    method: 'POST',
                    headers: { 'Content-Type': 'application/json' },
                    body: JSON.stringify(data)
                })
                .then(response => response.text())
                .then(responseData => {
                    Swal.fire({
                        title: responseData === 'success' ? 'Success!' : 'Status update',
                        text: responseData,
                        icon: responseData === 'success' ? 'success' : (responseData.includes("Error") ? 'error' : 'info'),
                        confirmButtonText: 'OK',
                        confirmButtonColor: '#03c4eb'
                    }).then(() => {
                              const modal = bootstrap.Modal.getInstance(
                                  document.getElementById('receptionModel')
                              );
                              modal.hide();
                          });
                })
                .catch(error => {
                    Swal.fire({
                        title: 'Error!',
                        text: error.toString(),
                        icon: 'error',
                        confirmButtonText: 'OK',
                        confirmButtonColor: '#d33'
                    });
                });
            }
        });
    }


//-------- All  related to PRESCRIPTION  button  -----------

    //-----Open Pharmacy Model ----------------
    function openPrescriptionModal() {
        // Show the confirmation modal
        document.getElementById('pharmacyDetail').value = "";
        document.getElementById('medicationSnippet').value = "";
        document.getElementById("medicationAdvise").value="";
        document.getElementById("noteToPatient").value="";

        renderClinicNote("PHARMACY");

        var textValue1 = document.getElementById('medicationAdvise');
        textValue1.style.minHeight = (textValue1.rows || 5) * 24 + 'px'; // 24px is an estimated line height, adjust if needed
        textValue1.style.height = 'auto';
        textValue1.style.height = textValue1.scrollHeight + 'px';

        const prescriptionModal = new bootstrap.Modal(document.getElementById('prescriptionModal'));
        prescriptionModal.show();
    }



    // This part of code will update pharmacy detail to the input box on click of suggestion
    document.getElementById('pharmacySuggestions').addEventListener('click', function(event) {
        document.getElementById('pharmacyDetail').value = event.target.textContent;
        const str = event.target.textContent;
        const firstPart = str.split('|')[0].trim();
        renderClinicNote(firstPart);
    });


    function renderClinicNote(PHARMACY) {
         var patientName =  document.getElementById("patientName").value;
         var gpName =  document.getElementById("systemUserName");
         var noteToPatient  = "Hi "+patientName+" \n\nYour script has been sent to the pharmacy via Healthmail. \nPlease call the pharmacy now to ensure they are open and that the medicine is in stock and ready for you to collect from.\n\n"+PHARMACY+"\n\nIf there are any issues when you call, you must Email us : support@gp4less.ie  straight away. \n\nKind Regards\n"+ gpName.textContent + "\n";
         document.getElementById("noteToPatient").value = noteToPatient;
  }



   function openPrescriptionPage(documentId, patientId) {
       const url = '/open-prescription-page?documentId=' + encodeURIComponent(documentId)+'&patientId='+encodeURIComponent(patientId);
       window.open(
            url,
            '_blank',
            'toolbar=no,location=no,status=no,menubar=no,scrollbars=yes,resizable=yes,width=1200,height=1000,top=100,left=100'
        );
   }







//-------- All  related to Referral   button  -----------


/*
    function openReferralPage() {
        const url = '/open-referral-page?documentId=' + document.getElementById('documentId').value;
        window.open(
            url,
            '_blank',
            'toolbar=no,location=no,status=no,menubar=no,scrollbars=yes,resizable=yes,width=1200,height=1000,top=100,left=100'
        );
    }*/


        function openReferralPage() {
            const documentId = document.getElementById('documentId').value;
            const url = '/open-referral-page?documentId=' + encodeURIComponent(documentId);
            window.open(url, '_blank');  // opens in new tab
        }



    //-----Open Pharmacy Model ----------------
    function openCodeDiagnosisModal() {
        const prescriptionModal_1 = new bootstrap.Modal(document.getElementById('codeDiagnosisModel'));
        prescriptionModal_1.show();
    }



    //----- add remove code Diagnosis to patient HCR -------------
    function updateCodeToPatientHcr(checkbox) {
        var codeId = checkbox.value;
        // Use "add" if checked, "remove" if not
        var operation = checkbox.checked ? "add" : "remove";

        const data = {
            patientId: document.getElementById("userId").value,
            diagnosisCodes: codeId,
            operation: operation
        };
        fetch('save-code-diagnosis', {
            method: 'POST',
            headers: { 'Content-Type': 'application/json' },
            body: JSON.stringify(data)
        });
    }

    function getSelectedClassifications() {
        // Select all checked checkboxes with name="classification[]"
        const checked = document.querySelectorAll('input[name="classification[]"]:checked');
        // Get their values in an array
        const selectedValues = Array.from(checked).map(cb => cb.value);
        return selectedValues;
    }



function assignDocumentToStaff() {
    const documentIdElem = document.getElementById('documentId');
    const staffIdElem = document.getElementById('staffId');

    // Validate existence of elements
    if (!staffIdElem) {
        Swal.fire({
            title: 'Error!',
            text: 'Staff selection element not found.',
            icon: 'error',
            confirmButtonText: 'OK',
            confirmButtonColor: '#d33'
        });
        return;
    }

    const documentId = documentIdElem.value?.trim();
    const staffId = staffIdElem.value?.trim();

    // Validate value
    if (!staffId) {
        Swal.fire({
            title: 'Error!',
            text: 'Please select staff from list.',
            icon: 'error',
            confirmButtonText: 'OK',
            confirmButtonColor: '#d33'
        });
        return;
    }

    Swal.fire({
        title: 'Are you sure?',
        text: "This will assign this document to the selected user!",
        icon: 'warning',
        showCancelButton: true,
        confirmButtonColor: '#03c4eb',
        cancelButtonColor: '#d33',
        confirmButtonText: 'Yes please.'
    }).then((result) => {
        if (result.isConfirmed) {
            fetch(`assign-document-to-staff/${documentId}/${staffId}`, {
                method: 'GET',
                headers: { 'Content-Type': 'application/json' },
            })
            .then(response => response.text())
            .then(responseData => {
                Swal.fire({
                    title: responseData === 'success' ? 'Success!' : 'Status update',
                    text: responseData,
                    icon: responseData === 'success' ? 'success' : (responseData.includes("Error") ? 'error' : 'info'),
                    confirmButtonText: 'OK',
                    confirmButtonColor: '#03c4eb'
                }).then(() => {
                      //document.getElementById('buttonEventStatus').innerHTML = "<i class='bi bi-check2-circle' style='font-size:1.2em;'> </i> Updated document is sent to the patient..!";
                      window.location.href = "manage-patient-documents#pending-review";
                 });
            })
            .catch(error => {
                Swal.fire({
                    title: 'Error!',
                    text: error.toString(),
                    icon: 'error',
                    confirmButtonText: 'OK',
                    confirmButtonColor: '#d33'
                });
            });
        }
    });
}


//---- This will remove the document permanently from clinic Document Master
function removeThisItem(documentId) {
    Swal.fire({
        title: 'Are you sure?',
        text: "You are about to permanently remove this  document from system !",
        icon: 'warning',
        showCancelButton: true,
        confirmButtonColor: '#3085d6',
        cancelButtonColor: '#d33',
        confirmButtonText: 'Yes, delete it!',
        cancelButtonText: 'Cancel',
        allowOutsideClick: false
    }).then((result) => {
        if (result.isConfirmed) {
            Swal.fire({
                title: 'Deleting...',
                html: 'Please wait while we remove the document.',
                allowOutsideClick: false,
                didOpen: () => {
                    Swal.showLoading();
                }
            });

            // Redirect to the delete action
            window.location.href = "manage-patient-documents?delDocumentId=" + documentId;
        }
    });
}



//---- This will remove the document permanently from clinic Document Master
function revertPatientDocument(documentId) {
        Swal.fire({
            title: 'Are you sure?',
             text: "You are about to revert document from  patient !  Patient  will no longer have access to this document.",
            icon: 'warning',
            showCancelButton: true,
            confirmButtonColor: '#03c4eb',
            cancelButtonColor: '#d33',
            confirmButtonText: 'Yes revert document.',
        }).then((result) => {
            if (result.isConfirmed) {
                fetch('revert-document-from-patient/'+documentId, {
                    method: 'GET'

                })
                .then(response => response.text())
                .then(responseData => {
                    Swal.fire({
                        title: responseData === 'success' ? 'Success!' : 'Status update',
                        text: responseData,
                        icon: responseData === 'success' ? 'success' : (responseData.includes("Error") ? 'error' : 'info'),
                        confirmButtonText: 'OK',
                        confirmButtonColor: '#03c4eb'
                    });

                    document.getElementById('buttonEventStatus').innerHTML = " <i class='bi bi-check2-circle' style='font-size:1.2em;'> </i> Document reverted !  Patient  will no longer have access to this document.";

                })
                .catch(error => {
                    Swal.fire({
                        title: 'Error!',
                        text: error.toString(),
                        icon: 'error',
                        confirmButtonText: 'OK',
                        confirmButtonColor: '#d33'
                    });
                });
            }
        });
    }

function fileToPatientEhr(documentId) {
    Swal.fire({
        title: 'Are you sure?',
        text: "You are about to save this document to patient record !",
        icon: 'warning',
        showCancelButton: true,
        confirmButtonColor: '#03c4eb',
        cancelButtonColor: '#d33',
        confirmButtonText: 'Yes save to patient file.',
    }).then((result) => {
        if (result.isConfirmed) {
            fetch('file-document-to-patient-ehr/' + documentId, {
                method: 'GET'
            })
            .then(async response => {
                const responseData = await response.text();

                if (response.ok) {
                    Swal.fire({
                        title: 'Success!',
                        text: responseData,
                        icon: 'success',
                        confirmButtonText: 'OK',
                        confirmButtonColor: '#03c4eb'
                    }).then(() => {
                        window.location.href = "manage-patient-documents";
                    });
                } else {
                    // Backend returned error status (like 500)
                    Swal.fire({
                        title: 'Server Error!',
                        text: responseData,
                        icon: 'error',
                        confirmButtonText: 'OK',
                        confirmButtonColor: '#d33'
                    });
                }
            })
            .catch(error => {
                // Network error or fetch rejected
                Swal.fire({
                    title: 'Error!',
                    text: error.toString(),
                    icon: 'error',
                    confirmButtonText: 'OK',
                    confirmButtonColor: '#d33'
                });
            });
        }
    });
}


//---- THIS WILL REMOVE THE DOCUMENT PERMANENTLY FROM CLINIC DOCUMENT MASTER
function removeDocumentFromMyName(documentId) {
    Swal.fire({
        title: 'Are you sure?',
         text: "You are about to take your name Off from this document !!.",
        icon: 'warning',
        showCancelButton: true,
        confirmButtonColor: '#03c4eb',
        cancelButtonColor: '#d33',
        confirmButtonText: 'Yes please .',
    }).then((result) => {
        if (result.isConfirmed) {
            fetch('remove-name-from-document/'+documentId, {
                method: 'GET'
            })
            .then(response => response.text())
            .then(responseData => {
                Swal.fire({
                    title: responseData === 'success' ? 'Success!' : 'Status update',
                    text: responseData,
                    icon: responseData === 'success' ? 'success' : (responseData.includes("Error") ? 'error' : 'info'),
                    confirmButtonText: 'OK',
                    confirmButtonColor: '#03c4eb'
                });
            })
            .catch(error => {
                Swal.fire({
                    title: 'Error!',
                    text: error.toString(),
                    icon: 'error',
                    confirmButtonText: 'OK',
                    confirmButtonColor: '#d33'
                });
            });
        }
    });
}

function summarizeUsingAi(documentName, btn){

    Swal.fire({
        title: 'Are you sure?',
        html: "You are about to generate AI summary... This might take few seconds !!.",
        icon: 'warning',
        width: '700px',
        showCancelButton: true,
        confirmButtonText: 'Yes'
    }).then((result) => {

        if (result.isConfirmed) {

            var originalHtml = btn.innerHTML;
            btn.disabled = true;
            btn.innerHTML = '<span class="spinner-border spinner-border-sm me-2"></span> Processing...';

            fetch('summarized_content_get_aiadvise/' + documentName, {
                method: 'POST'
            })
            .then(response => response.text()) // ✅ FIXED
            .then(data => {

            //    Swal.fire({
            //        title: 'AI Summary',
            //        html: data.replace(/\n/g, '<br>'), // ✅ FIXED
            //        icon: 'info',
            //        width: '700px'
            //    });

             const commentContent = document.getElementById('commentContent');
             commentContent.value = data; // ✅ FIXED
             autoResize(commentContent); // Adjust height after setting value
             commentContent.focus(); // Focus on the textarea to show the result

            })
            .catch(error => {
                Swal.fire('Error', error.toString(), 'error');
            })
            .finally(() => {
                btn.disabled = false;
                btn.innerHTML = originalHtml;
            });
        }
    });
}