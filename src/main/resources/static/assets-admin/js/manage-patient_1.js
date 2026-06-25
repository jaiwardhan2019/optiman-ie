

 function openConsultation(patientId) {
        const form = document.createElement('form');
        form.method = 'POST';
        form.action = 'patient-consultation'; // endpoint should accept POST
        form.style.display = 'none';

        const input = document.createElement('input');
        input.type = 'hidden';
        input.name = 'patientId';
        input.value = patientId;
        form.appendChild(input);
        document.body.appendChild(form);
        form.submit();
  }


  function viewPatientProfile(patientId) {
                const form = document.createElement('form');
                form.method = 'POST';
                form.action = 'manage-patient'; // endpoint should accept POST
                form.style.display = 'none';

                const input = document.createElement('input');
                input.type = 'hidden';
                input.name = 'patientId';
                input.value = patientId;
                form.appendChild(input);
                document.body.appendChild(form);
                form.submit();
  }




function sendMeetingLinkToPatient(gpId, patientName) {

    const patientEmail = document.getElementById("patientEmail").value.trim();
    const patientPhone = document.getElementById("phoneNumber").value.trim();
    const btn = document.getElementById("send-meeting-link");
    const resendmeetingbtn = document.getElementById("re-send-meeting-link");
    const statusBox = document.getElementById("meeting-link-status");
    const startMeetingBtn = document.getElementById("start-meeting");

    statusBox.innerHTML = ""; // Clear previous status

    // ---------- REQUIRE PHONE OR EMAIL ----------
    if (!patientEmail && !patientPhone) {
        return Swal.fire({
            icon: "warning",
            title: "Contact Required",
            text: "Please enter either patient email or phone number."
        });
    }

    // ---------- EMAIL VALIDATION ----------
    if (patientEmail) {
        const emailRegex = /^[^\s@]+@[^\s@]+\.[^\s@]+$/;
        if (!emailRegex.test(patientEmail)) {
            return Swal.fire({
                icon: "error",
                title: "Invalid Email",
                text: "Please enter a valid email address."
            });
        }
    }

    // ---------- Disable button + Loader ----------
    btn.disabled = true;
    btn.innerHTML = `<span class="spinner-border spinner-border-sm"></span> Sending...`;

    const data = {
        patientEmail,
        patientPhone,
        patientName,
        gpId
    };

    fetch("create-instant-video-meeting-send-to-patient", {
        method: "POST",
        headers: { "Content-Type": "application/json" },
        body: JSON.stringify(data)
    })
    .then(response => response.text())
    .then(result => {
        document.getElementById("meeting-link").value = result;

        // Restore button
        btn.innerHTML = `<i class="bi bi-people"></i> Send video meeting link`;

        // ---------- Show additional buttons ----------
        resendmeetingbtn.style.display = "inline-block";
        startMeetingBtn.style.display = "inline-block";

        // ---------- Confirmation Alert ----------
        Swal.fire({
            icon: "success",
            title: "Meeting Link Sent!",
            html: `Below meeting link has been sent to the patient <br><br>`+result ,
            width: '700px',
            confirmButtonText: "OK"
        });
    })
    .catch(error => {
        statusBox.style.color = "red";
        statusBox.innerHTML = "Error: " + error;
    })
    .finally(() => {
        btn.disabled = false;
    });
}


function openDailyMeeting() {
    const meetingUrl = document.getElementById("meeting-link").value;

    // Mid-size floating popup window
    const width = 600;
    const height = 600;
    const left = (screen.width - width) / 2;
    const top = (screen.height - height) / 2;

    window.open(
        meetingUrl,
        "DailyMeetingPopup",
        `width=${width},height=${height},top=${top},left=${left},resizable=yes,scrollbars=yes`
    );
}


function resendMeeting(patientName) {

    const patientEmail = document.getElementById("patientEmail").value;
    const btn = document.getElementById("send-meeting-link");
    const resend = document.getElementById("re-send-meeting-link");
    const statusBox = document.getElementById("meeting-link-status");
    const startMeetingBtn = document.getElementById("start-meeting");
    statusBox.innerHTML = ""; // Clear previous status

    // Disable button + show loader
    resend.disabled = true;
    resend.innerHTML = `<span class="spinner-border spinner-border-sm"></span> Sending...`;

    // Backend API payload
    const data = {
        patientEmail: patientEmail,
        patientName: patientName,
        meetingLink : document.getElementById("meeting-link").value
    };

    fetch("re-send-meeting-link", {
        method: "POST",
        headers: { "Content-Type": "application/json" },
        body: JSON.stringify(data)
    })
    .then(response => response.text())
    .then(result => {

     resend.innerHTML = `<i class="bi bi-send"></i> Sent to patient ...`;

        // Confirmation Alert
        Swal.fire({
            icon: "success",
            title: "Meeting Link Re-Sent!",
            html: `Below meeting link has been re-sent to the patient <br><br>`+result ,
            width: '700px',
            confirmButtonText: "OK"})

        // Restore button
        resend.innerHTML = `<i class="bi bi-send"></i> Re Send Link`;
        resend.disabled = false;

    })
    .catch(error => {

        statusBox.style.color = "red";
        statusBox.innerHTML = "Error: " + error;

    })
    .finally(() => {
        btn.disabled = false; // Enable button again
    });
}




    //-------- This method will notify patient through email  to setup account  on www.gp4less.ie -----
    function invitePatientToSetupAccount(patientId, buttonId) {
        const button = document.getElementById(buttonId);
        if (!button) return;
        const originalHTML = button.innerHTML;
        button.innerHTML = '<span class="spinner-border spinner-border-sm" role="status" aria-hidden="true"></span> In progress...';
        button.disabled = true;

        const requestData = {
            patientId: patientId,
            emailId: document.getElementById('patientEmailId').value,
            patientName: document.getElementById('patientFullName').value
        };

        fetch('notify-patient-to-setup-account', {
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
                }).then(() => {
                    button.innerHTML = originalHTML;
                    button.disabled = false;
                });
            } else {
                Swal.fire({
                    title: 'Success!',
                    html: responseText || 'Notification sent successfully.',
                    icon: 'success',
                    width: '800px',
                }).then(() => {
                    button.innerHTML = originalHTML;
                    button.disabled = false;
                });
            }
        })
        .catch(error => {
            Swal.fire({
                title: 'Error!',
                text: error.message || 'Could not send notification. Please try again.',
                icon: 'error',
            }).then(() => {
                button.innerHTML = originalHTML;
                button.disabled = false;
            });
        });
    }




//------------- OPEN  MODEL TO SELECT HL7 XML FILE -----------------------------------------------------------------------
function openHl7DocumentUploadModel(patientId) {
    // Set the patientId in the hidden input field
     const document_upload = new bootstrap.Modal(document.getElementById('addXmlToEhr'));
     document_upload.show();
}


function addxMLFiletoPatientEhr() {
    const fileInput = document.getElementById("PatientfileUpload_2");
    const files = fileInput.files;
    const documentTypeSelect = document.getElementById("documentType_2");
    const documentType = documentTypeSelect.value;
    const shareWitPatient = document.querySelector('input[name="shareWithPatient_2"]:checked')?.value;

    // ---------------- STEP 1: Validate Document Type ----------------
    if (documentType === "All") {
        Swal.fire({
            title: "Document Type Required",
            text: "Please select a document type before uploading.",
            icon: "warning",
            confirmButtonText: "OK"
        }).then(() => {
            documentTypeSelect.focus();  // <<< FOCUS after alert closes
        });
        return;
    }

    // ---------------- STEP 2: Validate File Input ----------------
    if (!files || files.length === 0) {
        Swal.fire({
            title: "No File Selected",
            text: "Please select at least one XML file to upload.",
            icon: "warning",
            confirmButtonText: "OK"
        }).then(() => {
            fileInput.focus();  // <<< FOCUS after alert closes
        });
        return;
    }

    // ---------------- STEP 3: Validate Only PDF Files ----------------
    const invalidFiles = Array.from(files).filter(file =>
        (!file.name.toLowerCase().endsWith(".xml"))
    );

    if (invalidFiles.length > 0) {
        Swal.fire({
            title: "Invalid File Type",
            text: "Only XML files are allowed. Please select XML files only.",
            icon: "error",
            confirmButtonText: "OK"
        }).then(() => {
            fileInput.value = "";
            fileInput.focus();  // <<< FOCUS after alert closes
        });
        return;
    }

    // ---------------- STEP 4: Confirm Upload ----------------
    Swal.fire({
        title: "Are you sure?",
        text: `You are about to upload ${files.length} XML file(s).`,
        icon: "question",
        showCancelButton: true,
        confirmButtonColor: "#3085d6",
        cancelButtonColor: "#d33",
        confirmButtonText: "Yes, upload!",
        cancelButtonText: "Cancel",
        allowOutsideClick: false
    }).then((result) => {

        if (!result.isConfirmed) {
            return;
        }

        // ---------------- STEP 5: Upload Processing ----------------
        Swal.fire({
            title: "Uploading...",
            html: "Please wait while we process your XML file(s).",
            allowOutsideClick: false,
            didOpen: () => Swal.showLoading()
        });

        const formData = new FormData();

        for (let file of files) {
            formData.append("PatientfileUpload", file);
        }

        formData.append("patientId", document.getElementById("patientId").value);
        formData.append("documentType", documentType);
        formData.append("shareWitPatient", shareWitPatient);

        // ---------------- STEP 6: AJAX Upload ----------------
        fetch("add-xml-documents-to-patient-ehr", {
            method: "POST",
            body: formData
        })
        .then(response => response.json())
        .then(data => {

            Swal.close();

            if (data.success) {
                Swal.fire({
                    title: "Upload Successful",
                    text: data.message,
                    icon: "success",
                    width: "700px",
                    confirmButtonText: "OK"
                }).then(() => {
                          viewPatientDetail(document.getElementById("patientId").value);
                          // Redirect after user acknowledges
                          //window.location.href = `/manage-patient?patientId=`+document.getElementById("patientId").value;
                          // Alternatively: window.location.assign(`/manage-patient?patientId=${encodeURIComponent(patientId)}`);
                      });
            } else {
                Swal.fire({
                    title: "Upload Failed",
                    text: data.message,
                    icon: "error",
                    confirmButtonText: "OK"
                });
            }

            fileInput.value = "";
            documentTypeSelect.value = "All";
        })
        .catch(error => {
            Swal.close();
            Swal.fire({
                title: "Error",
                text: error.toString(),
                icon: "error",
                confirmButtonText: "OK"
            });
            fileInput.value = "";
        });
    });
}

//------------- END OF MODEL TO SELECT HL7 XML FILE -----------------------------------------------------------------------




//------------- OPEN  MODEL TO SELECT DOCUMENT -----------------------------------------------------------------------
function openDocumentUploadModel(patientId) {
    // Set the patientId in the hidden input field
     const document_upload = new bootstrap.Modal(document.getElementById('addDocumentToEhr'));
     document_upload.show();
}





function addFiletoPatientEhr() {

    const fileInput = document.getElementById("PatientfileUpload");
    const files = fileInput.files;
    const documentTypeSelect = document.getElementById("documentType_1");
    const documentType = documentTypeSelect.value;
    const shareWitPatient = document.querySelector('input[name="shareWithPatient"]:checked')?.value;

    // ---------------- STEP 1: Validate Document Type ----------------
    if (documentType === "All") {
        Swal.fire({
            title: "Document Type Required",
            text: "Please select a document type before uploading.",
            icon: "warning",
            confirmButtonText: "OK"
        }).then(() => {
            documentTypeSelect.focus();  // <<< FOCUS after alert closes
        });
        return;
    }

    // ---------------- STEP 2: Validate File Input ----------------
    if (!files || files.length === 0) {
        Swal.fire({
            title: "No File Selected",
            text: "Please select at least one PDF file to upload.",
            icon: "warning",
            confirmButtonText: "OK"
        }).then(() => {
            fileInput.focus();  // <<< FOCUS after alert closes
        });
        return;
    }

    // ---------------- STEP 3: Validate Only PDF Files ----------------
    const invalidFiles = Array.from(files).filter(file =>
        (file.type !== "application/pdf" && !file.name.toLowerCase().endsWith(".pdf"))
    );

    if (invalidFiles.length > 0) {
        Swal.fire({
            title: "Invalid File Type",
            text: "Only PDF files are allowed. Please select PDF files only.",
            icon: "error",
            confirmButtonText: "OK"
        }).then(() => {
            fileInput.value = "";
            fileInput.focus();  // <<< FOCUS after alert closes
        });
        return;
    }

    // ---------------- STEP 4: Confirm Upload ----------------
    Swal.fire({
        title: "Are you sure?",
        text: `You are about to upload ${files.length} PDF file(s).`,
        icon: "question",
        showCancelButton: true,
        confirmButtonColor: "#3085d6",
        cancelButtonColor: "#d33",
        confirmButtonText: "Yes, upload!",
        cancelButtonText: "Cancel",
        allowOutsideClick: false
    }).then((result) => {

        if (!result.isConfirmed) {
            return;
        }

        // ---------------- STEP 5: Upload Processing ----------------
        Swal.fire({
            title: "Uploading...",
            html: "Please wait while we process your PDF file(s).",
            allowOutsideClick: false,
            didOpen: () => Swal.showLoading()
        });

        const formData = new FormData();

        for (let file of files) {
            formData.append("PatientfileUpload", file);
        }

        formData.append("patientId", document.getElementById("patientId").value);
        formData.append("documentType", document.getElementById("documentType_1").value);
        formData.append("shareWitPatient", shareWitPatient);

        // ---------------- STEP 6: AJAX Upload ----------------
        fetch("add-documents-to-patient-ehr", {
            method: "POST",
            body: formData
        })
        .then(response => response.json())
        .then(data => {

            Swal.close();

            if (data.success) {
                Swal.fire({
                    title: "Upload Successful",
                    text: data.message,
                    icon: "success",
                    width: "700px",
                    confirmButtonText: "OK"
                }).then(() => {
                          viewPatientDetail(document.getElementById("patientId").value);
                          // Redirect after user acknowledges
                          //window.location.href = `/manage-patient?patientId=`+document.getElementById("patientId").value;
                          // Alternatively: window.location.assign(`/manage-patient?patientId=${encodeURIComponent(patientId)}`);
                      });
            } else {
                Swal.fire({
                    title: "Upload Failed",
                    text: data.message,
                    icon: "error",
                    confirmButtonText: "OK"
                });
            }

            fileInput.value = "";
            documentTypeSelect.value = "All";
        })
        .catch(error => {
            Swal.close();
            Swal.fire({
                title: "Error",
                text: error.toString(),
                icon: "error",
                confirmButtonText: "OK"
            });
            fileInput.value = "";
        });
    });
}



 function viewPatientDetail(patientId) {
        const form = document.createElement('form');
        form.method = 'POST';
        form.action = 'manage-patient'; // endpoint should accept POST
        form.style.display = 'none';

        const input = document.createElement('input');
        input.type = 'hidden';
        input.name = 'patientId';
        input.value = patientId;
        form.appendChild(input);
        document.body.appendChild(form);
        form.submit();
  }



   function openSickNotePage(patientId) {
       const url = '/open-sicknote-page?patientId='+encodeURIComponent(patientId);
       window.open(
            url,
            '_blank',
            'toolbar=no,location=no,status=no,menubar=no,scrollbars=yes,resizable=yes,width=1200,height=1000,top=100,left=100'
        );
   }

    function openCreateDocumentPage(patientId) {
       const url = '/create-document-page?patientId='+encodeURIComponent(patientId);
       window.open(
            url,
            '_blank',
            'toolbar=no,location=no,status=no,menubar=no,scrollbars=yes,resizable=yes,width=1200,height=1000,top=100,left=100'
        );
    }



    //------------- OPEN  MODEL TO SEND MESSAGE -----------------------------------------------------------------------
    function openSendMessageToPatient(patientId) {
        // Set the patientId in the hidden input field
         const document_upload = new bootstrap.Modal(document.getElementById('sendMessage'));
         document_upload.show();
    }


    function loadMessageTemplateContentToTextArea() {

        const selectElement = document.getElementById('messageTemplate');
        const selectedOption = selectElement.options[selectElement.selectedIndex];
        const textValue = document.getElementById('DetailMessageToPatient');

        // Get cursor position
        const start = textValue.selectionStart;
        const end = textValue.selectionEnd;

        // Skip if "All" or empty option is selected
        if (selectedOption.value === "All" || selectedOption.value === "") {
            return;
        }

        // Get content from data attribute
        let content = selectedOption.getAttribute('data-content');

        // Remove HTML tags
        const cleanContent = removeHtmlTagsFromString(content);

        // Insert at cursor position
        textValue.setRangeText("\n" + cleanContent, start, end, 'end');

        // Auto-resize textarea
        textValue.style.height = 'auto';
        textValue.style.height = textValue.scrollHeight + 'px';

        // Focus back on textarea
        textValue.focus();
    }

//-------------FINISH SEND MESSAGE -----------------------------------------------------------------------



//------------- OPEN  MODEL FOR CREATE TASK ----------------------------------------------------------------
    function openCreateTaskModel() {
        // Set the patientId in the hidden input field
         const document_upload = new bootstrap.Modal(document.getElementById('createTaskModel'));
         document_upload.show();
    }



    <!-- This is going to load data into option for Create Task -->
    loadStaffDataForCreateTaskAndBookAppointment();
    loadStaffActionItemData();


    function loadStaffDataForCreateTaskAndBookAppointment(){
       fetch('get-staff-list')
            .then(response => response.json())
            .then(data => {
                const select = document.getElementById('staffId'); // This will loaded staff for task assignment
                // Remove all options except the first one
                select.options.length = 1;
                for (const [userId, fullName] of Object.entries(data)) {
                    //for create task
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

    function loadStaffActionItemData(){
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

     function createTaskForStaff() {
         const patientId = document.getElementById('patientId').value;
         const form = document.getElementById('receptionTaskForm');
         const select = document.getElementById('actionId');
         const selectedDisplayName = select.options[select.selectedIndex].text;

         const selectStaff = document.getElementById('staffId');
         const staffDisplayName = selectStaff.options[selectStaff.selectedIndex].text;

         // Extract values
         const staffId = form.staffId.value && form.staffId.value.trim();
         const actionName = selectedDisplayName && selectedDisplayName.trim();
         const receptionTask = form.receptionTask.value && form.receptionTask.value.trim();

         // NULL/EMPTY validation
         if (!staffId || !actionName || !receptionTask) {
             let missingFields = [];
             if (!staffId) missingFields.push(" Staff ");
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
             staffId: staffId,
             actionName: actionName,
             receptionTask: receptionTask,
             staffDisplayName: staffDisplayName,
             patientId: patientId
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
                     return Swal.fire({
                         title: responseData === 'success' ? 'Success!' : 'Status update',
                         text: responseData,
                         icon: responseData === 'success' ? 'success' : (responseData.includes("Error") ? 'error' : 'info'),
                         confirmButtonText: 'OK',
                         confirmButtonColor: '#03c4eb'
                     });
                 })
                 .then(() => {
                     // Close the modal after final OK
                     const modalEl = document.getElementById('createTaskModel');
                     if (modalEl) {
                         const modalInstance = bootstrap.Modal.getInstance(modalEl) || new bootstrap.Modal(modalEl);
                         modalInstance.hide();
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
//----------------------------------------------------------


//------------- OPEN  MODEL FOR RETEST REMINDER ----------------------------------------------------------------

 function RetestReminder() {
        // Set the patientId in the hidden input field
         const document_upload = new bootstrap.Modal(document.getElementById('retestReminder'));
         document_upload.show();
 }

  function addTestTypeContentToTextBox() {
        var selectElement = document.getElementById('testType');
        var selectedValue = selectElement.options[selectElement.selectedIndex].value;
        var textValue = document.getElementById('emailContent');
        // Overwrite the whole content, not just at the cursor
        textValue.value = "\n" + selectedValue;
        autoResize(textValue);
  }

    function createTestReminder() {
        const patientId = document.getElementById('patientId').value;
        const emailContentElem = document.getElementById('emailContent');
        const weeksMonthElem = document.getElementById('weeksMonth');
        const retestAfterElem = document.getElementById('retestAfter');

        // Validate existence of elements
        if (!emailContentElem || !weeksMonthElem || !retestAfterElem) {
            Swal.fire({
                title: 'Error!',
                text: 'One or more required input fields are missing from the page.',
                icon: 'error',
                confirmButtonText: 'OK',
                confirmButtonColor: '#d33'
            });
            return;
        }


        const emailContent = emailContentElem.value?.trim();
        const weeksMonth = weeksMonthElem.value?.trim();
        const retestAfter = retestAfterElem.value?.trim();

        // Validate null or empty values
        if (!emailContent || !weeksMonth || !retestAfter) {
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
            patientId: patientId,
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

                    // Close model and clear input fields after final OK
                    const modalEl = document.getElementById('retestReminder');
                    if (modalEl) {
                        const modalInstance = bootstrap.Modal.getInstance(modalEl) || new bootstrap.Modal(modalEl);
                        modalInstance.hide();
                    }
                    emailContentElem.value = "";
                    weeksMonthElem.value = "";
                    retestAfterElem.value = "";

                    //--- Reload log
                    reloadEhrLogPageForPatient(patientId);



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
//-------------CLOSE OPEN MODEL FOR RETEST REMINDER ----------------------------------------------------------------


//----------------------------------------------------------
 function openModelForBookAppointment() {
        // Set the patientId in the hidden input field
         const document_upload = new bootstrap.Modal(document.getElementById('bookAppointment'));
         document_upload.show();
 }


//-------------END OF OPEN  MODEL  FOR CREATE TASK -----------------------------------------------------------------------



   function openInvoicePage(patientId) {
       const url = '/open-invoice-page?patientId='+encodeURIComponent(patientId);
       window.open(
            url,
            '_blank',
            'toolbar=no,location=no,status=no,menubar=no,scrollbars=yes,resizable=yes,width=1200,height=1000,top=100,left=100'
        );
   }
