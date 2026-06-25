

     //-- Copy the text to clipboard
     function copyEmailToClipBoard() {
        // Get the text content from the div
        const emailText = document.getElementById('emailId').textContent.trim();

        // Create a temporary textarea element
        const textarea = document.createElement('textarea');
        textarea.value = emailText;

        // Make it invisible (but still selectable)
        textarea.style.position = 'fixed';
        textarea.style.opacity = 0;

        // Add to document
        document.body.appendChild(textarea);

        // Select and copy
        textarea.select();
        const successful = document.execCommand('copy');

        document.getElementById('copyDiv').innerHTML='<span style="color:blue"><i class="fa fa-check" aria-hidden="true"> </i> Email copied.! </span>';
        setTimeout(function() {
           document.getElementById('copyDiv').innerHTML='<a href="Javascript:void();" onclick="copyEmailToClipBoard()"> <i class="bi bi-copy"></i> Copy email id </a>';
        }, 2000);
     }

    function getRadioButtonValue() {

        // Get all radio buttons with class "form-check-input"
        const radioButtons = document.querySelectorAll('.form-check-input');
        let selectedValue = null;

        // Iterate through radio buttons to find the checked one
        for (const radioButton of radioButtons) {
           if (radioButton.checked) {
             selectedValue = radioButton.value;
             break;
           }
        }
        document.getElementById('Sex').value = selectedValue;

    }




    //-------- This method will assign the service request to the admin user who is logged in
    function updatePatientDetail() {
        //-- Collect radio button value (if this is doing something else, keep it)
        getRadioButtonValue();

        // Clear previous error styles
        clearValidationErrors();

        // Read radio for sex
        const selectedSexInput = document.querySelector('input[name="options"]:checked');
        const patientSex = selectedSexInput ? selectedSexInput.value : "";

        // Read form values once
        const data = {
            userId: document.getElementById("userId").value,
            firstName: document.getElementById("firstName").value,
            lastName: document.getElementById("lastName").value,
            birthDate: document.getElementById("birthDate").value,
            patientSex: patientSex,
            ppsNumber: document.getElementById("ppsNumber").value,
            phoneNumber: document.getElementById("phoneNumber").value,
            emailId: document.getElementById("patientEmailId").value,
            fullAddress: document.getElementById("fullAddress").value,
            eirCode: document.getElementById("eirCode").value,
            patientType: document.getElementById("patientType").value,
            gismNumber: document.getElementById("gismNumber").value,
            gpVisitCard: document.getElementById("gpVisitCard").value,
            userIsActive: document.getElementById("userIsActive").value
        };

        // Fields that must NOT be null/empty
        // `elementId` is used for highlighting
        const requiredFields = [
            { key: "firstName",   label: "First Name",   elementId: "firstName" },
            { key: "lastName",    label: "Last Name",    elementId: "lastName" },
            { key: "birthDate",   label: "Birth Date",   elementId: "birthDate" },
            { key: "patientSex",  label: "Sex",          elementId: "sex-group-container" }, // use container for radios
            { key: "phoneNumber", label: "Phone Number", elementId: "phoneNumber" },
            { key: "emailId",     label: "Email",        elementId: "patientEmailId" },
            { key: "fullAddress", label: "Full Address", elementId: "fullAddress" }
        ];

        const missingFields = [];

        requiredFields.forEach(f => {
            const value = data[f.key];
            if (value == null || value.toString().trim() === "") {
                missingFields.push(f);

                // Highlight the related input or group
                if (f.key === "patientSex") {
                    // Add class to the container wrapping radio buttons
                    const sexGroup = document.getElementById(f.elementId);
                    if (sexGroup) {
                        sexGroup.classList.add("sex-group-error");
                    }
                } else {
                    const el = document.getElementById(f.elementId);
                    if (el) {
                        el.classList.add("field-error");
                    }
                }
            }
        });

        if (missingFields.length > 0) {
            Swal.fire({
                title: 'Missing required information',
                html: 'Please fill in the following fields:<br><b>' +
                      missingFields.map(f => f.label).join(', ') +
                      '</b>',
                icon: 'warning',
                confirmButtonColor: '#d33',
                confirmButtonText: 'OK'
            });
            // Do NOT proceed further
            return;
        }

        // All required fields are present — show confirm dialog
        Swal.fire({
            title: 'Are you sure?',
            text: "You won't be able to revert this!",
            icon: 'warning',
            showCancelButton: true,
            confirmButtonColor: '#03c4eb',
            cancelButtonColor: '#d33',
            confirmButtonText: 'Yes, update patient detail.'
        }).then((result) => {
            if (!result.isConfirmed) {
                return;
            }

            // Make API call
            fetch('update-patient-detail', {
                method: 'POST',
                headers: { 'Content-Type': 'application/json' },
                body: JSON.stringify(data)
            })
            .then(response => response.text())
            .then(responseData => {
                if (responseData === 'success') {
                    Swal.fire(
                        'Updated!',
                        'This patient detail is updated.',
                        'success'
                    );
                } else if (responseData.includes("Error")) {
                    Swal.fire({
                        title: 'Sorry!',
                        text: 'This request is already updated by someone.',
                        icon: 'warning',
                        confirmButtonColor: '#d33',
                        confirmButtonText: 'OK'
                    });
                }
            })
            .catch(error => {
                document.getElementById("requestStatus").innerHTML = error;
            });
        });
    }

    function clearValidationErrors() {
        // Remove error class from text inputs
        const errorFields = document.querySelectorAll('.field-error');
        errorFields.forEach(el => el.classList.remove('field-error'));

        // Remove error from sex group
        const sexGroup = document.getElementById('sex-group-container');
        if (sexGroup) {
            sexGroup.classList.remove('sex-group-error');
        }
    }




    //-----Open Code Diagnostic Model ----------------
    function openCodeDiagnosisModal() {
        const prescriptionModal_1 = new bootstrap.Modal(document.getElementById('codeDiagnosisModel'));
        prescriptionModal_1.show();
    }

    function getSelectedClassifications() {
        // Select all checked checkboxes with name="classification[]"
        const checked = document.querySelectorAll('input[name="classification[]"]:checked');
        // Get their values in an array
        const selectedValues = Array.from(checked).map(cb => cb.value);
        return selectedValues;
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


    function openReferralPageFromPatient(userId) {
        const url = '/open-referral-page?patientId='+encodeURIComponent(userId);
        // window.open(url, '_blank');  // opens in new tab
       window.open(
            url,
            '_blank',
            'toolbar=no,location=no,status=no,menubar=no,scrollbars=yes,resizable=yes,width=1400,height=1000,top=50,left=50'
        );
    }


    function searchEhrLogAndRender(patientId) {

        const data = {
            patientId: patientId,
            documentType: document.getElementById("documentType").value,
            serviceType: document.getElementById("serviceId").value,
            messageType: document.getElementById("messageType").value
        };

        fetch('search-ehr-log?patientId=' + encodeURIComponent(patientId), {
            method: 'POST',
            headers: {'Content-Type': 'application/json'},
            body: JSON.stringify(data)
        })
        .then(res => {
            if (!res.ok) throw new Error("Network response was not ok");
            return res.json();
        })
        .then(medicalLogs => {
            const tbody = document.getElementById("logTableBody");
            tbody.innerHTML = "";

            if (!medicalLogs || medicalLogs.length === 0) {
                tbody.innerHTML = `
                    <tr>
                        <td colspan="6">Sorry No logs found.!!!!!</td>
                    </tr>
                `;
                return;
            }

            medicalLogs.forEach(log => {
                const row = document.createElement("tr");

                const formatDateTime = (dt) => {
                    if (!dt) return '';
                    const d = new Date(dt);
                    return !isNaN(d)
                        ? `${d.getFullYear()}-${String(d.getMonth()+1).padStart(2,'0')}-${String(d.getDate()).padStart(2,'0')}
                           ${String(d.getHours()).padStart(2,'0')}:${String(d.getMinutes()).padStart(2,'0')}`
                        : dt;
                };

                const header = (() => {
                    if (log.messageType?.includes('Patient Message')) {
                        return `<i class="bi bi-person-circle" style="color:#272EF5">
                                    ${log.doctorName || ''}
                                </i>`;
                    }

                    if (
                        log.messageType?.includes('Doctor Message') ||
                        log.messageType?.includes('Treatment Note')
                    ) {
                        return `<i class="fa-solid fa-user-doctor" style="color:#FF1493"></i>
                                ${log.doctorName ? log.doctorName + '&nbsp;' : ''}
                                ${formatDateTime(log.transDateTime || log.formatLocalDateTime)}
                                &nbsp;&nbsp;&nbsp;`;
                    }

                    return '';
                })();

                const notes = log.notes || '';

                // ✅ Always show Remove after notes
                const actions = notes
                    ? `
                    <p align="right">
                        <a href="javascript:void(0);"
                           onclick="removeItemFromEhrLog('${patientId}','${log.logId}');"
                           style="color:red;">
                            <i class="bi bi-trash"></i> Remove
                        </a>
                        ${
                            log.documentName
                                ? `&nbsp;&nbsp;&nbsp;&nbsp;
                                   <a href="javascript:void(0);"
                                      onclick="confirmPatientEmailAndResend('${log.documentName}');"
                                      style="color:blue;">
                                       <i class="bi bi-envelope-check"></i> Resend
                                   </a>`
                                : ''
                        }
                    </p>`
                    : '';

                const pdfPreview =
                    log.notes?.includes('.pdf') && log.documentName
                        ? `
                        <iframe src="view-document-admin?fileName=${encodeURIComponent(log.documentName)}"
                                style="width:100%; min-height:300px; margin-top:15px;">
                        </iframe>
                        `
                        : '';

                row.innerHTML = `
                    <td height="50px">
                        ${header}
                        ${notes}
                        ${pdfPreview}
                        ${actions}
                    </td>
                `;

                tbody.appendChild(row);
            });
        })
        .catch(error => {
            const tbody = document.getElementById("logTableBody");
            tbody.innerHTML = `
                <tr>
                    <td colspan="6" style="color:red;">
                        ${error.message || "Failed to fetch EHR logs."}
                    </td>
                </tr>
            `;
        });
    }



    //-------- This method will remove EHR log item -------------- from patient EHR
    function removeItemFromEhrLog(patientId,ehrLogId) {
        Swal.fire({
            title: 'Are you sure?',
            text: 'This action will permanently remove this line item from the patient EHR. \n Do you want to continue?',
            icon: 'warning',
            width: '800px',
            showCancelButton: true,
            confirmButtonText: 'Yes, remove it!',
            cancelButtonText: 'Cancel',
        }).then((result) => {
            if (result.isConfirmed) {
                const data = {
                    patientId: patientId,
                    ehrLogId: ehrLogId
                };
                fetch('remove_item_from_ehrlog', {
                    method: 'POST',
                    headers: { 'Content-Type': 'application/json' },
                    body: JSON.stringify(data)
                })
                .then(async response => {
                    const responseText = await response.text();
                    if (!response.ok || (responseText && responseText.includes('Error'))) {
                        Swal.fire({
                            title: 'Error!',
                            html: responseText || 'Could not remove. Please try again.',
                            icon: 'error',
                            width: '600px',
                        });
                    } else {
                        Swal.fire({
                            title: 'Success!',
                            html: responseText || 'Document removed successfully.',
                            icon: 'success',
                            width: '800px',
                        });
                        //--Reload ehr log
                        reloadEhrLogAndRender(patientId);
                    }
                })
                .catch(error => {
                    Swal.fire({
                        title: 'Error!',
                        text: error.message || 'Could not remove. Please try again.',
                        icon: 'error',
                    });
                });
            }
        });
    }

    function confirmPatientEmailAndResend(patientId,documentName) {
        // Fetch current email from input (change #emailId if your field id is different)
        var emailId = document.getElementById('patientEmailId').value;
        Swal.fire({
            title: 'Are you sure to resend document to patient ?',
            icon: 'info',
            showCancelButton: true,
            confirmButtonText: 'Confirm and Proceed',
            cancelButtonText: 'Cancel',
            width: '600px',
        }).then((result) => {
            if (result.isConfirmed) {
                const email = result.value;
                sendDocumentToPatient(patientId,documentName);
            }
            // If cancelled, do nothing (or handle if you want)
        });
    }


    function sendDocumentToPatient(patientId,documentName){
                const data = {
                    documentName: documentName,
                    patientId: patientId
                };

                 fetch('resend-patient-document-from-ehrlog', {
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
                         confirmButtonColor: '#03c4eb',
                          width: '800px'
                     });
                 })
                 .catch(error => {
                     Swal.fire({
                         title: 'Error!',
                         text: error.toString(),
                         icon: 'error',
                         confirmButtonText: 'OK',
                         confirmButtonColor: '#d33',
                          width: '800px',
                     });
                 });
    }



    function reloadEhrLogAndRender(patientId, patientDetail) {
        const data = {
            patientId: patientId,
            documentType: null,
            serviceType: null,
            messageType: null
        };

        fetch('search-ehr-log?patientId=' + encodeURIComponent(patientId), {
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
                cell.textContent = "Sorry, no logs found!";
                row.appendChild(cell);
                tbody.appendChild(row);
            } else {
                medicalLogs.forEach(log => {
                    const row = document.createElement("tr");
                    let icon = '';
                    if (log.messageType && log.messageType.includes('Patient Message')) {
                        icon = `<i class="bi bi-person-circle" style="color: #272EF5"></i>`;
                    } else if (log.messageType && log.messageType.includes('Doctor Message')) {
                        icon = `<i class="fa-solid fa-user-doctor" style="color: #FF1493"></i>`;
                    } else if (log.messageType && log.messageType.includes('Treatment Note') || log.messageType.includes('Consultation Note')) {
                        icon = `<i class="fa-solid fa-user-doctor" style="color: #FF1493"></i>`;
                    } else {
                        icon = `<i class="fa-solid fa-user-doctor" style="color: #FF1493"></i>`;
                    }

                    // Format date/time
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

                    // Main contents
                    let html = `
                        <td height="60px">
                            ${icon} ${log.doctorName ? log.doctorName + " " : ""}
                            ${formatDateTime(log.transDateTime || log.formatLocalDateTime)}. &nbsp;&nbsp;&nbsp;
                            ${log.notes ? log.notes : ""}
                    `;

                        html += `
                            <br><br>
                            <p align="right">
                                <a href="javascript:void(0);" onClick="removeItemFromEhrLog('${patientId}','${log.logId}');" style="color:red;">
                                    <i class="bi bi-trash"> Remove </i>
                                </a>
                            </p>
                        `;


                    // PDF preview and actions if notes contain .pdf
                    if (log.notes && log.notes.includes('.pdf') && log.documentName) {
                        html += `
                            <br><br>
                            <iframe src="view-document-admin?fileName=${encodeURIComponent(log.documentName)}"
                                style="width:100%; min-height:300px;margin-top:15px;"></iframe>
                            <br>
                            <p align="right">
                                <a href="javascript:void(0);" onClick="removeItemFromEhrLog('${patientId}','${log.logId}');" style="color:red;">
                                    <i class="bi bi-trash"> Remove </i>
                                </a>
                                &nbsp;&nbsp;&nbsp;&nbsp;
                                <a href="javascript:void(0);" onClick="confirmPatientEmailAndResend('${log.documentName}');" style="color:blue;">
                                    <i class="bi bi-envelope-check"> Resend </i>
                                </a>
                            </p>
                        `;
                    }

                    html += `</td>`;
                    row.innerHTML = html;
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


   function openPrescriptionPage(documentId, patientId) {
       const url = '/open-prescription-page?documentId=' + encodeURIComponent(documentId)+'&patientId='+encodeURIComponent(patientId);
       window.open(
            url,
            '_blank',
            'toolbar=no,location=no,status=no,menubar=no,scrollbars=yes,resizable=yes,width=1200,height=1000,top=100,left=100'
        );
   }


