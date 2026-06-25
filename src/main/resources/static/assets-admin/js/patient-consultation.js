// =======================================================
// 🔵 Utility helpers
// =======================================================

function getValue(id) {
  return (document.getElementById(id)?.value || '').trim();
}

function showLoading(message = 'Saving consultation...') {
  Swal.fire({
    title: message,
    allowOutsideClick: false,
    allowEscapeKey: false,
    didOpen: () => {
      Swal.showLoading();
    }
  });
}

function hideLoading() {
  Swal.close();
}

// =======================================================
// 🔵 Validation
// =======================================================

function validateConsultation(payload) {

  if (!payload.serviceMode) {
    document.getElementById('serviceMode')?.focus();
    Swal.fire({
      width: '600px',
      icon: 'warning',
      title: 'Service Mode is Required',
      text: 'Please select service mode.'
    });
    return false;
  }

  if (!payload.subjective) {
    document.getElementById('Subjective')?.focus();
    Swal.fire({
      width: '600px',
      icon: 'warning',
      title: 'Subjective is Required',
      text: 'Please enter details in the Subjective field.'
    });
    return false;
  }

  if (!payload.objective) {
    document.getElementById('Objective')?.focus();
    Swal.fire({
      width: '600px',
      icon: 'warning',
      title: 'Objective is Required',
      text: 'Please enter details in the Objective field.'
    });
    return false;
  }

  if (!payload.assessment) {
    document.getElementById('Assessment')?.focus();
    Swal.fire({
      width: '600px',
      icon: 'warning',
      title: 'Assessment is Required',
      text: 'Please enter details in the Assessment field.'
    });
    return false;
  }

  if (!payload.treatmentPlan) {
    document.getElementById('TreatmentPlan')?.focus();
    Swal.fire({
      width: '600px',
      icon: 'warning',
      title: 'Treatment Plan is Required',
      text: 'Please enter details in the Treatment Plan field.'
    });
    return false;
  }

  if (!payload.safetyNetMessageToPatient) {
    document.getElementById('safetyNetMessageToPatient')?.focus();
    Swal.fire({
      width: '600px',
      icon: 'warning',
      title: 'Safety Net Selection is  Required',
      text: 'Please enter details After clicking on this button .'
    });
    return false;
  }

  return true;
}

// =======================================================
// 🔵 Save Consultation (ASYNC + RETURN STATUS)
// =======================================================

async function saveConsultation() {

  const payload = {
    consultationId: getValue('consultationId'),
    consultationStatus: getValue('consultationStatus'),
    serviceMode: getValue('serviceMode'),
    patientId: getValue('patientId'),
    adminUserId: getValue('adminUserId'),
    subjective: getValue('Subjective'),
    weight: getValue('weight'),
    weightUnit: getValue('weightUnit'),
    height: getValue('height'),
    heightUnit: getValue('heightUnit'),
    systolicBP: getValue('systolicBP'),
    diastolicBP: getValue('diastolicBP'),
    pulseRate: getValue('pulseRate'),
    objective: getValue('Objective'),
    assessment: getValue('Assessment'),
    treatmentPlan: getValue('TreatmentPlan'),
    notesComment: getValue('notesComment'),
    safetyNetMessageToPatient: getValue('safetyNetMessageToPatient')
  };

  // Validation
  if (!validateConsultation(payload)) {
    return false;
  }

  try {
    showLoading('Saving SOAP notes...');

    const response = await fetch('/save-consultation-notes', {
      method: 'POST',
      headers: { 'Content-Type': 'application/json' },
      body: JSON.stringify(payload)
    });

    const result = await response.json().catch(() => ({}));
    hideLoading();

    if (!response.ok) {
      await Swal.fire({
        icon: 'error',
        title: 'Save Failed',
        text: result.message || 'Failed to save SOAP notes.'
      });
      return false;
    }

    await Swal.fire({
      icon: 'success',
      title: 'Success',
      text: result.message || 'SOAP notes saved successfully.',
      confirmButtonText: 'OK'
    });

    return true;

  } catch (error) {
    hideLoading();
    console.error('Error saving consultation:', error);

    await Swal.fire({
      icon: 'error',
      title: 'Network Error',
      text: 'Unable to save consultation. Please try again later.'
    });

    return false;
  }
}

// =======================================================
// 🔵 Finish Consultation (SAVE → OK → REDIRECT)
// =======================================================

async function finishConsultation() {

  const confirmation = await Swal.fire({
    title: "Are you sure?",
    text: "Do you want to finish this consultation ? ",
    icon: "question",
    width: '600px',
    showCancelButton: true,
    confirmButtonColor: "#3085d6",
    cancelButtonColor: "#d33",
    confirmButtonText: "Yes, finish it!",
    cancelButtonText: "Cancel"
  });

  if (!confirmation.isConfirmed) {
    return;
  }

  document.getElementById('consultationStatus').value = 'Finished';
  const success = await saveConsultation();
  if (!success) return;

  // -- Go to Consultation List if patientId is missing for some reason
  window.location.href = '/consultation-list';

}

// =======================================================
// 🔵 Navigation helper
// =======================================================

function gotoPatientProfile(patientId) {
  const form = document.createElement('form');
  form.method = 'POST';
  form.action = 'manage-patient';
  form.style.display = 'none';

  const input = document.createElement('input');
  input.type = 'hidden';
  input.name = 'patientId';
  input.value = patientId;

  form.appendChild(input);
  document.body.appendChild(form);
  form.submit();
}



   // =========OPEN PRESCRIPTION PAGE IN NEW TAB=========
   function openPrescriptionPage(documentId, patientId) {
       const url = '/open-prescription-page?documentId=' + encodeURIComponent(documentId)+'&patientId='+encodeURIComponent(patientId);
       window.open(
            url,
            '_blank',
            'toolbar=no,location=no,status=no,menubar=no,scrollbars=yes,resizable=yes,width=1200,height=1000,top=100,left=100'
        );
   }



    // =========OPEN REFERRAL PAGE IN NEW TAB=========
    function openReferralPageFromPatient(userId) {
        const url = '/open-referral-page?patientId='+encodeURIComponent(userId);
        // window.open(url, '_blank');  // opens in new tab
       window.open(
            url,
            '_blank',
            'toolbar=no,location=no,status=no,menubar=no,scrollbars=yes,resizable=yes,width=1400,height=1000,top=50,left=50'
        );
    }


//------------- OPEN  MODEL FOR RETEST REMINDER ----------------------------------------------------------------
 function RetestReminder() {
        // Set the patientId in the hidden input field
         const document_upload = new bootstrap.Modal(document.getElementById('retestReminder'));
         document_upload.show();
 }




   function openInvoicePage(patientId) {
       const url = '/open-invoice-page?patientId='+encodeURIComponent(patientId);
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

    //------------- OPEN  MODEL TO SEND MESSAGE -----------------------------------------------------------------------
    function openSafetyNetModel() {
        // Set the patientId in the hidden input field
         const document_upload = new bootstrap.Modal(document.getElementById('safetyNetModelId'));
         document_upload.show();
    }




   //*== SEND PATIENT MESSAGE TO THEIR ACCOUNT   ==*//
    function sendMessageToPatientAccount() {
        // Get the message input and send button elements
        const sendMessageButton = document.getElementById("sendButton");
        const messageInput = document.getElementById("DetailMessageToPatient");
        const messageBody = messageInput.value;

        // Check if the message is null or empty
        if (!messageBody.trim()) {
            Swal.fire(
                "Empty Message!",
                "Please write a message before sending.",
                "warning"
            );
            return;
        }

        // Show confirmation dialog before sending the message
        Swal.fire({
            title: "Are you sure?",
            text: "Do you want to send this message to the patient?",
            icon: "question",
            showCancelButton: true,
            confirmButtonColor: "#3085d6",
            cancelButtonColor: "#d33",
            confirmButtonText: "Yes, send it!",
        }).then((result) => {
            if (result.isConfirmed) {
                // Change button to loader (disable send button)
                sendMessageButton.disabled = true;

                // Prepare request data
                const requestData = {
                    requestId: "",
                    messageFrom: document.getElementById("adminFullName").value,
                    messageFromId: document.getElementById("adminUserId").value,
                    messageTo: document.getElementById("patientFullName").value,
                    messageToId: document.getElementById("patientId").value,
                    messageToEmailId: document.getElementById("patientEmail").value,
                    messageBody: messageBody,
                    requestType: "Doctor Message",
                };

                // Send the message via fetch
                fetch("send-message-patient", {
                    method: "POST",
                    headers: { "Content-Type": "application/json" },
                    body: JSON.stringify(requestData),
                })
                    .then(async (response) => {
                        const responseText = await response.text(); // Read response as text
                        Swal.fire("Message Sent!", responseText, "success").then(() => {
                            // Close modal programmatically after the user clicks "OK"
                            const modalElement = document.getElementById("sendMessage");
                            const bootstrapModal = bootstrap.Modal.getInstance(
                                modalElement
                            ); // Get the modal instance
                            bootstrapModal.hide(); // Hide the modal
                            reloadEhrLogPageForPatient(messageToId); // Reload EHR log page to show the new message
                        });
                    })
                    .catch((error) => {
                        console.error("Error:", error);
                        Swal.fire(
                            "Message Not Sent!",
                            "An error occurred while sending the message. Please try again.",
                            "error"
                        );
                    })
                    .finally(() => {
                        // Re-enable the send button
                        sendMessageButton.disabled = false;
                    });
            } // If confirmed ends
        });
    } //--- End of function





    //------------- OPEN  MODEL TO SELECT DOCUMENT -----------------------------------------------------------------------
    function openAddDocumentPage(patientId) {
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
            formData.append("documentType", documentType);
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
                               const addDocumentToEhrModal = bootstrap.Modal.getInstance(document.getElementById('addDocumentToEhr'));
                               addDocumentToEhrModal.hide();
                              //viewPatientDetail(document.getElementById("patientId").value);
                             reloadEhrLogPageForPatient(document.getElementById("patientId").value);
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




    // Function to fetch health trend data and initialize chart
    async function fetchAndInitializeChart(userid,mainCategory) {

         fetch('/get-health-trend-data/'+userid+'/'+mainCategory, {
            method: 'GET',
            headers: {
                'Content-Type': 'application/json'
            }
        })
        .then(response => {
            console.log('Fetch response status:', response);
            if (!response.ok) {
                throw new Error('Failed to fetch health trend data');
            }
            return response.json();
        })
        .then(ehrDataObject => {

         if(mainCategory === 'BP'){
            // Initialize the BP chart with the fetched data
            initializeBPChart(ehrDataObject);
            }
            else if(mainCategory === 'BMI'){
            // Initialize the BMI chart with the fetched data
            initializeBMIChart(ehrDataObject);
         }

        })
        .catch(error => {
            console.error('Error fetching health trend data:', error);
            Swal.fire({
                icon: 'error',
                title: 'Data Fetch Failed',
                text: 'Unable to fetch health trend data. Please try again later.',
                confirmButtonText: 'OK'
            });
        });
    }




    function loadSafetyNetDateToTextArea() {

        const selectElement = document.getElementById('safetyNetTemplate');
        const selectedOption = selectElement.options[selectElement.selectedIndex];
        const textValue = document.getElementById('safetyNetMessageToPatient');


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




  //================= FEEDING DATA FOR BMI  =================
  let bmiChart = null;
  async  function initializeBMIChart(ehrDataObject) {

        // ================= FORMAT DATE =================
        function formatDate(arr) {
            var year = arr[0];
            var month = String(arr[1]).padStart(2, '0');
            var day = String(arr[2]).padStart(2, '0');
            return day + "/" + month + "/" + year;
        }

        // ================= PREPARE DATA FOR BMI CHART =================
        var bmiData = [];
        var dates = [];


        ehrDataObject.forEach(function (r) {
            bmiData.push(r.bmi);
            dates.push(formatDate(r.recordedAt));
        });

        var bmiOptions = {
            chart: { type: 'area', height: 320, width: '100%' },
            series: [{ name: 'BMI', data: bmiData }],
            xaxis: { categories: dates },
            stroke: { curve: 'smooth', width: 3 },
            colors: ['#00A8E8'],
            fill: { type: 'gradient' },
            markers: { size: 5 },
            title: { text: 'BMI Trend (kg/m²)', align: 'left' }
        };

       // ✅ Proper destroy
        if (bmiChart) {
            bmiChart.destroy();
        }

       // ✅ Clean container (IMPORTANT FIX)
       document.querySelector("#bmiChart").innerHTML = "";

      //==== Draw BMI Chart ====
      bmiChart = new ApexCharts(document.querySelector("#bmiChart"), bmiOptions);
      bmiChart.render();
    }






 //================= FEEDING DATA FOR BLOOD PRESSURE =================
  let bpChart = null;
  async  function initializeBPChart(ehrDataObject) {

         console.log('Fetch data length :', ehrDataObject.length);
        // ================= FORMAT DATE =================
        function formatDate(arr) {
            var year = arr[0];
            var month = String(arr[1]).padStart(2, '0');
            var day = String(arr[2]).padStart(2, '0');
            return day + "/" + month + "/" + year;
        }

        // ================= PREPARE DATA FOR BMI CHART =================
        var systolicData = [];
        var diastolicData = [];
        var pulseData = [];
        var dates = [];

        ehrDataObject.forEach(function (r) {
            systolicData.push(r.systolicBp);
            diastolicData.push(r.diastolicBp);
            pulseData.push(r.pulseRate);
            dates.push(formatDate(r.recordedAt));
        });

     //==== Draw Blood Pressure Chart ====
        var bpOptions = {
            chart: { type: 'line', height: 320, width: '100%' },
            series: [
                { name: 'Systolic BP', data: systolicData },
                { name: 'Diastolic BP', data: diastolicData },
                { name: 'Pulse Rate', data: pulseData }
            ],
            xaxis: { categories: dates },
            stroke: { curve: 'smooth', width: 3 },
            colors: ['#F54927', '#33C1FF', '#497D15'],
            markers: { size: 5 },
            title: { text: 'Blood Pressure & Pulse Trend', align: 'left' }
        };

        // ✅ Proper destroy
        if (bpChart) {
            bpChart.destroy();
        }

       // ✅ Clean container (IMPORTANT FIX)
       document.querySelector("#bpChart").innerHTML = "";

        var bpChart = new ApexCharts(document.querySelector("#bpChart"), bpOptions);
        bpChart.render();
    }

