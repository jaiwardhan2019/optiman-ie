    //----------- Resize the medication detail Text Box based on value
    const textarea = document.querySelector('textarea[name="commentContent"]');


    function adjustTextareaHeight() {
        // Reset height to get correct scrollHeight
        textarea.style.height = 'auto';
        // Set height to scrollHeight (content height)
        textarea.style.height = textarea.scrollHeight+'px';
    }


    // Adjust height initially if there's content
    adjustTextareaHeight();
    //-----------End of Resize the medication detail Text Box based on value


    function updatePatientReport(rawFileName) {
        const updateReport = document.getElementById('updateReport');
        updateReport.disabled = true;

        updateReport.innerHTML = '<i class="fa fa-spinner fa-pulse fa-lg"></i> Updating report...';

        const data = {
            gpComment: document.getElementById('commentContent').value,
            reportFileName: rawFileName,
        };

        fetch('update-gp-comment-on-patient-document', {
            method: 'POST',
            headers: { 'Content-Type': 'application/json' },
            body: JSON.stringify(data)
        })
        .then(response => response.text())
        .then(data => {
            //console.log('Success:', data);
            reloadPdfPreview(rawFileName+".pdf"); // Reload the PDF preview to reflect updated comments
        })
        .catch(error => {
            console.error('Error:', error);
        });

        setTimeout(function() {
            updateReport.disabled = false;
            updateReport.innerHTML = '<i class="bi bi-floppy2"></i> &nbsp;Update report';
        }, 1000);

        //-- Update label under button
        document.getElementById('buttonEventStatus').innerHTML = "<i class='bi bi-check2-circle' style='font-size:1.2em;'> </i> Document is updated with your comment..!";

    }

    function addMessageToCommentBox() {
        var selectElement = document.getElementById('tempId');
        var selectedValue = selectElement.options[selectElement.selectedIndex].value;
        var textValue = document.getElementById('commentContent');
        var start = textValue.selectionStart;
        var end = textValue.selectionEnd;
        // Insert the text at the cursor position
        textValue.setRangeText("\n" + extractTextFromHtml(selectedValue), start, end, 'end');
        //textValue.value = textValue.value + "\n" + selectedValue;
        //textValue.value = selectedValue.replace(/PATIENT/g, patientName);
         adjustTextareaHeight();
    }


    function reloadPdfPreview(fileName) {
        var src = 'view-document-admin';
        var iframe2 = document.getElementById('pdfPreview_2');
        iframe2.src = src + '?fileName='+fileName
    }

    function extractTextFromHtml(htmlContent) {
        let text = htmlContent
            .replace(/<br\s*\/?>/gi, '\n')           // Replace <br> and <br/> tags with newlines (case insensitive)
            .replace(/<[^>]*>/g, '')                 // Remove all remaining HTML tags
            .replace(/&nbsp;/g, ' ')                 // Replace non-breaking spaces
            .replace(/&amp;/g, '&')                  // Replace ampersands
            .replace(/&lt;/g, '<')                   // Replace less than
            .replace(/&gt;/g, '>')                   // Replace greater than
            .replace(/&quot;/g, '"')                 // Replace quotes
            .trim();
        return text;
    }




    //-------- This method will send report to patient on www.gp4less.ie  -----------
    function sendReportToPatient(rawFileName) {
        const data = {
            reportFileName: rawFileName
        };

        Swal.fire({
            title: 'Are you sure?',
            text: "You won't be able to revert this!",
            icon: 'warning',
            showCancelButton: true,
            confirmButtonColor: '#03c4eb',
            cancelButtonColor: '#d33',
            confirmButtonText: 'Yes send report to patient.',
        }).then((result) => {
            if (result.isConfirmed) {
                fetch('send-report-to-patient', {
                    method: 'POST',
                    headers: { 'Content-Type': 'application/json' },
                    body: JSON.stringify(data)
                })
                .then(response => response.text())
                .then(responseData => {
                    // Always show the backend response in a modal, wait for user to click 'OK' to close
                    if (responseData.includes("Patient not exists in www.GP4Less.ie")) {
                        Swal.close(); // Close any currently open Swal modal
                        createPatientSendReport(rawFileName); //  This will open a new modal to ask for email
                    } else {
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
                    }

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



    //-------- Notify patient to set up account on www.gp4less.ie -----
    function notifyPatientToSetupAccount(documentId, buttonId) {

        const button = document.getElementById(buttonId);
        if (!button) return;

        const emailInput = document.getElementById('emailId');
        const patientNameInput = document.getElementById('patientName');

        const emailId = emailInput?.value?.trim();
        const patientName = patientNameInput?.value?.trim();

        // ---------------- EMAIL VALIDATION ----------------
        const emailRegex =
            /^[^\s@]+@[^\s@]+\.[^\s@]+$/;   // simple + reliable email validation

        if (!emailId || !emailRegex.test(emailId)) {
            Swal.fire({
                title: 'Invalid Email',
                text: 'Please enter a valid email address before continuing.',
                icon: 'warning',
            }).then(() => {
                  window.location.href = `update-manually-added-document?documentId=`+documentId;
              });
            return;
        }

        // ---------------- DISABLE BUTTON & SHOW SPINNER ----------------
        const originalHTML = button.innerHTML;
        button.innerHTML = `
            <span class="spinner-border spinner-border-sm" role="status" aria-hidden="true"></span>
            In progress...
        `;
        button.disabled = true;

        const restoreButton = () => {
            button.innerHTML = originalHTML;
            button.disabled = false;
        };

        const requestData = {
            documentId: documentId,
            emailId: emailId,
            patientName: patientName
        };

        // ---------------- SEND REQUEST ----------------
        fetch('notify-patient-to-setup-account', {
            method: 'POST',
            headers: { 'Content-Type': 'application/json' },
            body: JSON.stringify(requestData)
        })
        .then(async response => {

            const text = await response.text();
            const isError = !response.ok || (text && text.includes('Error'));

            if (isError) {
                Swal.fire({
                    title: 'Error!',
                    html: text || 'Could not send notification. Please try again.',
                    icon: 'error',
                    width: '800px',
                }).then(() => {
                    restoreButton();
                    window.location.href = `update-manually-added-document?documentId=${documentId}`;
                });
            } else {
                Swal.fire({
                    title: 'Success!',
                    html: text || 'Notification sent successfully.',
                    icon: 'success',
                    width: '800px',
                }).then(() => {
                    restoreButton();
                    window.location.href = `paitent-document-analysis?documentId=${documentId}`;
                });
            }
        })
        .catch(error => {
            Swal.fire({
                title: 'Error!',
                text: error.message || 'Could not send notification. Please try again.',
                icon: 'error',
            }).then(() => restoreButton());
        });
    }


    //-------- This method will notify patient through email  to setup account  on www.gp4less.ie -----
    function createPatientWithEhr(documentId,buttonId) {

            // Swap button to loader spinner
            const button = document.getElementById(buttonId);
            if (!button) return;
            const originalHTML = button.innerHTML;
            button.innerHTML = '<span class="spinner-border spinner-border-sm" role="status" aria-hidden="true"></span> In progress...';
            button.disabled = true;

           const requestData = {
               documentId: document.getElementById('documentId').value,
               patientName: document.getElementById('patientName').value
           };

            fetch('create-new-patient-from-document', {
                method: 'POST',
                headers: { 'Content-Type': 'application/json' },
                body: JSON.stringify(requestData)
            })
            .then(async response => {
                const responseText = await response.text();
                if (!response.ok || (responseText && responseText.includes('Error'))) {
                    Swal.fire({
                        title: 'Error!',
                        html: responseText || 'Could not send Notification. Please try again.',
                        icon: 'error',
                        width: '800px',
                    });

                    //--- Swap button to normal
                    button.innerHTML = originalHTML;
                    button.disabled = false;

                } else {
                    Swal.fire({
                        title: 'Success!',
                        html: responseText || 'Notification sent successfully.',
                        icon: 'success',
                        width: '800px',
                   }).then(() => {
                       window.location.href = `paitent-document-analysis?documentId=${documentId}`;
                   });

                      //--- Swap button to normal
                      button.innerHTML = originalHTML;
                      button.disabled = false;

                }
            })
            .catch(error => {
                Swal.fire({
                    title: 'Error!',
                    text: error.message || 'Could not send notification . Please try again.',
                    icon: 'error',
                });
            });

    }



    function createPatientOnGp4Less(rawFileName) {

        var emailId= document.getElementById('emailId').value;
        Swal.fire({
            title: 'Create new Patient on www.GP4Less.ie',
            text: 'System could  not find patient in www.GP4Less.ie. Please enter patient email to create.',
            html: `
                <input type="email" id="patientEmail" style="min-width: 400px;" class="swal2-input"
                 value="${emailId}" placeholder="Enter patient email" required>
            `,
            icon: 'info',
            showCancelButton: true,
            confirmButtonColor: '#03c4eb',
            cancelButtonColor: '#d33',
            confirmButtonText: 'Create Patient',
            width: '800px',
            preConfirm: () => {
                const email = Swal.getPopup().querySelector('#patientEmail').value;
                if (!email) {
                    Swal.showValidationMessage('Email is required!');
                    return false;
                }
                // Simple email validation
                if (!/^[^\s@]+@[^\s@]+\.[^\s@]+$/.test(email)) {
                    Swal.showValidationMessage('Please enter a valid email address!');
                    return false;
                }
                return email;
            }
        }).then((result) => {
            if (result.isConfirmed) {
                const email = result.value;
                const data = {
                    reportFileName: rawFileName,
                    patientEmail: email
                };

                Swal.fire({
                    title: 'In progress...',
                    allowOutsideClick: false,
                    allowEscapeKey: false,
                    didOpen: () => {
                        Swal.showLoading();
                    }
                });

                fetch('create-new-patient-from-document', {
                    method: 'POST',
                    headers: { 'Content-Type': 'application/json' },
                    body: JSON.stringify(data)
                })
                .then(response => {
                    return response.text().then(text => {
                        if (!response.ok) {
                            // Show error block for HTTP errors
                            Swal.fire({
                                title: 'Error!',
                                text: text,
                                icon: 'error',
                                confirmButtonText: 'OK',
                                confirmButtonColor: '#d33'
                            });
                        } else {

                            const element = document.getElementById('createPatientRow');
                            if (element) {
                              element.style.display = 'none';
                            }

                            const element_1 = document.getElementById('createPatientRow_1');
                            if (element_1) {
                              element_1.style.display = 'none';
                            }

                            Swal.fire({
                                title: text === 'success' ? 'Success!' : 'Status update',
                                text: text,
                                icon: text === 'success' ? 'success' : (text.includes("Error") ? 'error' : 'info'),
                                confirmButtonText: 'OK',
                                confirmButtonColor: '#03c4eb'
                            });
                        }
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



    //-------- This method will ask for email and send the report to the patient after creating patient on www.gp4less.ie  -----------
    function createPatientSendReport(rawFileName) {

        var emailFromInput= document.getElementById('emailId').value;
        Swal.fire({
            title: 'Send Report to Patient',
            text: 'System could  not find patient in www.GP4Less.ie. Please enter patient email to send report.',
            html: `
                <input type="email" value="${emailFromInput}" id="patientEmail" class="swal2-input" placeholder="Enter patient email" required>
            `,
            icon: 'info',
            showCancelButton: true,
            confirmButtonColor: '#03c4eb',
            cancelButtonColor: '#d33',
            confirmButtonText: 'Send',
            preConfirm: () => {
                const email = Swal.getPopup().querySelector('#patientEmail').value;
                if (!email) {
                    Swal.showValidationMessage('Email is required!');
                    return false;
                }
                // Simple email validation
                if (!/^[^\s@]+@[^\s@]+\.[^\s@]+$/.test(email)) {
                    Swal.showValidationMessage('Please enter a valid email address!');
                    return false;
                }
                return email;
            }
        }).then((result) => {
            if (result.isConfirmed) {
                const email = result.value;
                const data = {
                    reportFileName: rawFileName,
                    patientEmail: email
                };

                Swal.fire({
                    title: 'Sending...',
                    allowOutsideClick: false,
                    allowEscapeKey: false,
                    didOpen: () => {
                        Swal.showLoading();
                    }
                });

                fetch('create-patient-send-report', {
                    method: 'POST',
                    headers: { 'Content-Type': 'application/json' },
                    body: JSON.stringify(data)
                })
                .then(response => response.text())
                .then(responseData => {
                    Swal.fire({
                        title: responseData === 'success' ? 'Success!' : 'Status update',
                        html: responseData,
                        icon: responseData === 'success' ? 'success' : (responseData.includes("Error") ? 'error' : 'info'),
                        confirmButtonText: 'OK',
                        width : '800px',
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




    //-------- This method will ask for email and send the report to the patient
    function sendReportToPatientViaEmail(rawFileName) {
        Swal.fire({
            title: 'Send Report to Patient',
            html: `
                <input type="email" id="patientEmail" class="swal2-input" placeholder="Enter patient email" required>
            `,
            icon: 'info',
            showCancelButton: true,
            confirmButtonColor: '#03c4eb',
            cancelButtonColor: '#d33',
            confirmButtonText: 'Send',
            preConfirm: () => {
                const email = Swal.getPopup().querySelector('#patientEmail').value;
                if (!email) {
                    Swal.showValidationMessage('Email is required!');
                    return false;
                }
                // Simple email validation
                if (!/^[^\s@]+@[^\s@]+\.[^\s@]+$/.test(email)) {
                    Swal.showValidationMessage('Please enter a valid email address!');
                    return false;
                }
                return email;
            }
        }).then((result) => {
            if (result.isConfirmed) {
                const email = result.value;
                const data = {
                    reportFileName: rawFileName,
                    email: email
                };

                Swal.fire({
                    title: 'Sending...',
                    allowOutsideClick: false,
                    allowEscapeKey: false,
                    didOpen: () => {
                        Swal.showLoading();
                    }
                });

                fetch('send-report-to-patient-via-email', {
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







     //-----Open deligateToFormModal Model ----------------
   function opendeligateToFormModal() {
         const deligateToFormModal = new bootstrap.Modal(document.getElementById('deligateToFormModal'));
         deligateToFormModal.show();
   }


   function assignToStaff() {
        const documentIdElem = document.getElementById('documentId');
        const staffIdElem = document.getElementById('officeStaffId');

        // Validate existence of elements
        if (!staffId ) {
            Swal.fire({
                title: 'Error!',
                text: 'Please select staff from list.',
                icon: 'error',
                confirmButtonText: 'OK',
                confirmButtonColor: '#d33'
            });
            return;
        }

        const documentId = documentIdElem.value?.trim();
        const staffContent = staffIdElem.value?.trim();

        // Validate null or empty values
        if (!staffContent) {
            Swal.fire({
                title: 'Validation Error',
                text: 'Please select staff from list.',
                icon: 'warning',
                confirmButtonText: 'OK',
                confirmButtonColor: '#d33'
            });
            return;
        }

        const data = {
            documentId: documentId,
            staffId: staffContent
        };

        Swal.fire({
            title: 'Are you sure?',
            text: "You won't be able to revert this!",
            icon: 'warning',
            showCancelButton: true,
            confirmButtonColor: '#03c4eb',
            cancelButtonColor: '#d33',
            confirmButtonText: 'Yes Create Reminder.',
        }).then((result) => {
            if (result.isConfirmed) {
                fetch('create-test-reminder', {
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





    //-------- This method will show the modal to assign task to  reception -----------
    function RetestReminder() {
         //document.getElementById("CreateTaskForStaff").value="";
         const retestReminderModel = new bootstrap.Modal(document.getElementById('retestReminder'));
         retestReminderModel.show();
    } //  End of function alertUnderConstruction


    function addTestTypeContentToTextBox() {
        var selectElement = document.getElementById('testType');
        var selectedValue = selectElement.options[selectElement.selectedIndex].value;
        var textValue = document.getElementById('emailContent');
        // Overwrite the whole content, not just at the cursor
        textValue.value = "\n" + selectedValue;
        autoResize(textValue);
    }

    function createTestReminder() {
        const documentIdElem = document.getElementById('documentId');
        const emailContentElem = document.getElementById('emailContent');
        const weeksMonthElem = document.getElementById('weeksMonth');
        const retestAfterElem = document.getElementById('retestAfter');

        // Validate existence of elements
        if (!documentIdElem || !emailContentElem || !weeksMonthElem || !retestAfterElem) {
            Swal.fire({
                title: 'Error!',
                text: 'One or more required input fields are missing from the page.',
                icon: 'error',
                confirmButtonText: 'OK',
                confirmButtonColor: '#d33'
            });
            return;
        }

        const documentId = documentIdElem.value?.trim();
        const emailContent = emailContentElem.value?.trim();
        const weeksMonth = weeksMonthElem.value?.trim();
        const retestAfter = retestAfterElem.value?.trim();

        // Validate null or empty values
        if (!documentId || !emailContent || !weeksMonth || !retestAfter) {
            Swal.fire({
                title: 'Validation Error',
                text: 'All fields are required. Please fill / Select  all the details.',
                icon: 'warning',
                confirmButtonText: 'OK',
                confirmButtonColor: '#d33'
            });
            return;
        }

        const data = {
            documentId: documentId,
            emailContent: emailContent,
            weeksMonth: weeksMonth,
            retestAfter: retestAfter
        };

        Swal.fire({
            title: 'Are you sure?',
            text: "You won't be able to revert this!",
            icon: 'warning',
            showCancelButton: true,
            confirmButtonColor: '#03c4eb',
            cancelButtonColor: '#d33',
            confirmButtonText: 'Yes Create Reminder.',
        }).then((result) => {
            if (result.isConfirmed) {
                fetch('create-test-reminder', {
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


    //-------- This method will show the modal to assign task to  reception -----------
    function CreateTaskForStaff() {
         //document.getElementById("CreateTaskForStaff").value="";
         const pharmacyModal = new bootstrap.Modal(document.getElementById('receptionModel'));
         pharmacyModal.show();
    } //  End of function alertUnderConstruction



 // This function will fetch the receptionist list from the server and populate the dropdown when the page loads
  /*document.addEventListener("DOMContentLoaded", function() {
     loadReceptionistData();
     loadStaffForDocumentDelegation(); // For the delegation dropdown
     loadReceptionistActionItemData(); // For staff action dropdown
  });
  */
