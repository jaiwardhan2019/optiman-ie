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
                            ${
                                log.messageType && log.messageType.includes('Patient Message')
                                    ? `<i class="bi bi-person-circle" style="color: #272EF5"> ${log.doctorName ? log.doctorName : ''} </i>`
                                    : log.messageType && log.messageType.includes('Doctor Message')
                                        ? `<i class="bi bi-clipboard2-pulse" style="color: #FF1493"></i> ${log.doctorName ? log.doctorName + '&nbsp;' : ''} ${formatDateTime(log.transDateTime || log.formatLocalDateTime)}. &nbsp;&nbsp;&nbsp;`
                                        : ''
                            }
                            ${log.notes ? log.notes : ''}
                            ${
                                log.notes && log.notes.includes('.pdf') && log.documentName
                                    ? `<iframe src="view-document-admin?fileName=${encodeURIComponent(log.documentName)}" style="width:100%; min-height:300px; margin-top:15px;"></iframe>
                                     <br>
                                        <p align="right">
                                            <a href="javascript:void(0);" onClick="removeItemFromEhrLog('${patientId}','${log.logId}');" style="color:red;">
                                                <i class="bi bi-trash"> Remove </i>
                                            </a>
                                            &nbsp;&nbsp;&nbsp;&nbsp;
                                            <a href="javascript:void(0);" onClick="confirmPatientEmailAndResend('${log.documentName}');" style="color:blue;">
                                                <i class="bi bi-envelope-check"> Resend </i>
                                            </a>
                                        </p>`
                                    : ''
                            }
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
                        icon = `<i class="bi bi-shield-plus" style="color: #FF1493"></i>`;
                    } else {
                        icon = `<i class="bi bi-clipboard2-pulse" style="color: #FF1493"></i>`;
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


