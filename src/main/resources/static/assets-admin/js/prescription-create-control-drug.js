
   //====================================================================================
   //
   //  THIS WILL ADD MEDICINE DATA TO TEMP DATABASE
   //
   //====================================================================================
   function  addMedicineToTempCD(){

       // Collect form data
       const formData = {
           rpdfFileName: document.getElementById('rpdfFileNameCD').value,
           rdocumentUserId: document.getElementById('rdocumentUserIdCD').value,
           rmedicationName: document.getElementById('rmedicationNameCD').value,
           dosage: document.getElementById('dosageCD').value,
           frequency: document.getElementById('frequencyCD').value,
           quantity: document.getElementById('quantityCD').value,
           noOfRepeat: document.getElementById('noOfRepeatCD').value,
           startDate: document.getElementById('startDateCD').value,
           endDate: document.getElementById('endDateCD').value,
           controlDrug: "YES"
           //lastDispense: document.getElementById('lastDispense').value,
           //nextDispense: document.getElementById('nextDispense').value
       };

       // Validate required fields
        // Validate required fields
        if (
                formData.rmedicationName.trim() === "" ||
                formData.dosage.trim() === "" ||
                formData.startDate.trim() === "" ||
                formData.frequency.trim() === "" || formData.frequency.trim() === "0" ||
                formData.quantity.trim() === "" ||  formData.quantity.trim() === "0" ||
                Number.isNaN(formData.frequency) ||
                Number.isNaN(formData.quantity)
            ) {
            Swal.fire({
                title: ' Error !',
                html: 'Please fill in all required fields. <br><br><strong style="color:#7F22FE;">Medication Name <br>Dosage<br>Frequency<br>Quantity<br>Start Date </strong><br><br> are mandatory data.!!!!<br><br>',
                icon: 'warning',
                width: '700px',
                confirmButtonColor: '#d33',
                confirmButtonText: 'OK'
            });
            return;
        }


       if (parseInt(formData.noOfRepeat, 10) > 3) {
            Swal.fire({
                title: 'Required!',
                html: '<strong style="color:red;">No of Repeat cannot exceed 3.</strong>',
                icon: 'warning',
                width: '700px',
                confirmButtonColor: '#d33',
                confirmButtonText: 'OK'
            });
            return;
       }


       fetch('/add-medicine-detail-to-ehr', {
                method: 'POST',
                headers: { 'Content-Type': 'application/json' },
                body: JSON.stringify(formData)
       })
        .then(response => response.text())
        .then(data => {
            Swal.fire({
                title: 'Success!',
                text: data || 'Medicine added successfully.',
                icon: 'success',
                confirmButtonColor: '#03c4eb'
            }).then(() => {

              document.getElementById('rmedicationNameCD').value = '';
              document.getElementById('dosageCD').value = '';
              document.getElementById('frequencyCD').value = '';
              document.getElementById('quantityCD').value = '';
              document.getElementById('noOfRepeatCD').value = '';
              document.getElementById('endDateCD').value = '';

              //-- Load added medicine details to the table
              loadMedicineDetailsToTableCD(formData.rdocumentUserId, formData.startDate,formData.rpdfFileName);

              });

        })
        .catch(error => {
            Swal.fire({
                title: 'Failed!',
                text: error.message || 'Could not add medicine. Please try again.',
                icon: 'error',
                confirmButtonColor: '#d33'
            });
        });

   }

    /// This function will calculate the next dispense date based on the start date, number of repeats, and frequency
    function calculateNextDispenseDateCD() {
        try {
            // Parse inputs
            const startDate = new Date(document.getElementById('startDateCD').value);
            const repeats = parseInt(document.getElementById('noOfRepeatCD').value, 10);
            const freqDays = parseInt(document.getElementById('frequencyCD').value, 10);

            if (isNaN(startDate.getTime()) || isNaN(repeats) || isNaN(freqDays)) {
                throw new Error("Invalid input");
            }

            // Calculate next dispense date
            const totalDaysToAdd = repeats * freqDays;

            const nextDate = new Date(startDate);
            nextDate.setDate(startDate.getDate() + totalDaysToAdd);

            // Format as yyyy-MM-dd
            const formattedDate = nextDate.toISOString().split("T")[0];

            document.getElementById('endDateCD').value = formattedDate;



        } catch (e) {
            console.error(e);
            return null;
        }
    }


    /// This function will calculate the next dispense date based on the start date, number of repeats, and frequency
    function calculateNextDispenseDateCD_model() {
        try {
            // Parse inputs
            const startDate = new Date(document.getElementById('M_startDateCD').value);
            const repeats = parseInt(document.getElementById('M_noOfRepeatCD').value, 10);
            const freqDays = parseInt(document.getElementById('M_frequencyCD').value, 10);

            if (isNaN(startDate.getTime()) || isNaN(repeats) || isNaN(freqDays)) {
                throw new Error("Invalid input");
            }

            // Calculate next dispense date
            const totalDaysToAdd = repeats * freqDays;

            const nextDate = new Date(startDate);
            nextDate.setDate(startDate.getDate() + totalDaysToAdd);

            // Format as yyyy-MM-dd
            const formattedDate = nextDate.toISOString().split("T")[0];

            document.getElementById('M_endDateCD').value = formattedDate;


        } catch (e) {
            console.error(e);
            return null;
        }
    }



   //====================================================================================
   //
   //  THIS WILL GET LIST OF ADDED MEDICATION DETAIL FROM BACKEND AND RENDER TO THE TABLE
   //
   //====================================================================================
    function loadMedicineDetailsToTableCD(patientId, createDate) {

        var pdfFileName = document.getElementById("pdfFileNameCD").value;

        fetch('/read-medicine-details-from-ehr/'+patientId+'/'+createDate)
            .then(response => {
                if (!response.ok) {
                    throw new Error('Failed to fetch data');
                }
                return response.json();
            })
            .then(data => {
                const tableBody = document.getElementById('medicineTableBodyCD');
                tableBody.innerHTML = '<th style="font-size:11px;">No.</th><th style="font-size:11px;"> Medicine </th> <th style="font-size:11px;"> Dosage </th> <th style="font-size:11px;"> Qty </th>'; // Clear existing data and set header

                data.forEach((item, index) => {
                    const row = document.createElement('tr');
                    row.style.marginBottom = '10px';
                    row.innerHTML = `
                        <td style="font-size:11px;padding:8px 0;" >${index + 1}</td>
                        <td style="font-size:11px;padding:8px 0;">${item.medicineName || ''}</td>
                        <td style="font-size:11px;padding:8px 0;">${item.dosage || ''}</td>
                        <td style="font-size:11px;padding:8px 0;">${item.quantity || ''}</td>
                        <td style="font-size:11px;padding:8px 0;">
                            <a href="javascript:void(0);" onclick="removeMedicineFromTempCD('${item.tempPrescriptionId}','${item.patientId}','${item.presPdfFileName}')">
                                <i class="bi bi-trash3" style="color:red"></i>
                                <span style="color:red">Rem</span>
                            </a>
                        </td>
                    `;
                    pdfFileName = item.presPdfFileName; // Update PDF file name from the latest item (if needed)
                    tableBody.appendChild(row);
                });

               // -- Load pdf file to the frame
               const frameId = document.getElementById("pdfPreviewCD");
               frameId.src = "view-document-admin?fileName="+pdfFileName;

            })
            .catch(error => {
                console.error('Error fetching medicine details:', error);
            });
    }


    //====================================================================================
    //
    //  ADD CONTROLLED DRUG MEDICINE DATA TO PT EHR (FROM MODAL)
    //
    //====================================================================================
    function addMedicineToEhrFromModel() {
        const formData = {
            rdocumentUserId: document.getElementById('userId')?.value || '',
            medicationId: document.getElementById('medicationId')?.value || '',
            isControlledDrug: document.getElementById('isControlledDrugMedication')?.value || '',
            operationMedication: document.getElementById('operationMedication')?.value || 'UPDATE',
            rmedicationName: document.getElementById('M_rmedicationNameCD')?.value || '',
            dosage: document.getElementById('M_dosageCD')?.value || '',
            frequency: document.getElementById('M_frequencyCD')?.value || '',
            quantity: document.getElementById('M_quantityCD')?.value || '',
            noOfRepeat: document.getElementById('M_noOfRepeatCD')?.value || '',
            startDate: document.getElementById('M_startDateCD')?.value || '',
            endDate: document.getElementById('M_endDateCD')?.value || ''
        };


        const frequencyNum = Number(formData.frequency);
        const quantityNum = Number(formData.quantity);

        // Validate required fields
        if (
            formData.rmedicationName.trim() === '' ||
            formData.dosage.trim() === '' ||
            formData.startDate.trim() === '' ||
            !Number.isFinite(frequencyNum) || frequencyNum <= 0 ||
            !Number.isFinite(quantityNum) || quantityNum <= 0
        ) {
            Swal.fire({
                title: 'Required!',
                html: 'Please fill required fields:<br><br><strong style="color:#7F22FE;">Medication Name<br>Dosage<br>Frequency<br>Quantity<br>Start Date</strong>',
                icon: 'warning',
                width: '700px',
                confirmButtonColor: '#d33',
                confirmButtonText: 'OK'
            });
            return;
        }

        fetch('/add-medicine-detail-to-ehr', {
            method: 'POST',
            headers: { 'Content-Type': 'application/json' },
            body: JSON.stringify(formData)
        })
        .then(async (response) => {
            const text = await response.text();
            if (!response.ok) throw new Error(text || 'Request failed');
            return text;
        })
        .then((data) => {
            Swal.fire({
                title: 'Success!',
                text: data || 'Medicine added successfully.',
                icon: 'success',
                confirmButtonColor: '#03c4eb'
            }).then(() => {
                // Clear modal fields
                document.getElementById('M_rmedicationNameCD').value = '';
                document.getElementById('M_dosageCD').value = '';
                document.getElementById('M_frequencyCD').value = '0';
                document.getElementById('M_quantityCD').value = '0';
                document.getElementById('M_noOfRepeatCD').value = '0';
                document.getElementById('M_startDateCD').value = '';
                document.getElementById('M_endDateCD').value = '';

                // Refresh table
                loadMedicineDetailsToTable(formData.rdocumentUserId);

                // Close modal
                const modalEl = document.getElementById('prescriptionModel');
                const modalInstance = bootstrap.Modal.getInstance(modalEl);
                if (modalInstance) modalInstance.hide();
            });
        })
        .catch((error) => {
            Swal.fire({
                title: 'Failed!',
                text: error.message || 'Could not add medicine. Please try again.',
                icon: 'error',
                confirmButtonColor: '#d33'
            });
        });
    }