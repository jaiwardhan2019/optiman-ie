//********************************* REPEAT PRESCRIPTION ************************************//


 //---- This will render current date to the filed start date
  document.addEventListener('DOMContentLoaded', function () {
    const dateInput = document.getElementById('startDate');
    const dateInputCD = document.getElementById('startDateCD');
    const today = new Date();
    const yyyy = today.getFullYear();
    const mm = String(today.getMonth() + 1).padStart(2, '0');
    const dd = String(today.getDate()).padStart(2, '0');
    const todayStr = yyyy + '-' + mm + '-' + dd;
    dateInput.value = todayStr;
    dateInput.min = todayStr;
    // -- FOR CD
    dateInputCD.value = todayStr;
    dateInputCD.min = todayStr;

   //-- Load added medicine details to the table when the page loads
    const patientId = document.getElementById('rdocumentUserId').value;
    const startDate = document.getElementById('startDate').value;
    loadMedicineDetailsToTable(patientId);
  });





   //-- Search and display medicien function searchMedicine--------


   //====================================================================================
   //
   //  START OF SEARCH MEDICINE AND DISPLAY THEN PICK MEDICINE AND ADD TO THE TEXT AREA
   //
   //====================================================================================

   const textarea = document.getElementById("rmedicationName");
   textarea.addEventListener("input", function () {
     this.style.height = "auto";
     this.style.height = this.scrollHeight + "px";
   });

   //const suggestions = ["Asthama", "Cough", "Diahoria", "Flue", "Gastro"];
   // suggestions will be comming from JSP page

    let activeIndex = -1;
    let currentFiltered = [];

    let selectedSuggestions = [];

    function getCurrentWord(text) {
      const words = text.split(/[\s,]+/);
      return words[words.length - 1].toLowerCase();
    }


    function replaceCurrentWord(textarea, selectedItem) {

      let lines = textarea.value.split("\n");
      let lastLine = lines[lines.length - 1].trim();

      // Prevent duplicates
      if (selectedSuggestions.includes(selectedItem)) {
        return;
      }

      selectedSuggestions.push(selectedItem);

      // Replace current line
      lines[lines.length - 1] = selectedItem;

      // Add new empty line
      textarea.value = lines.join("\n") + "\n";

      // ✅ Auto resize
      textarea.style.height = "auto";              // reset height
      textarea.style.height = textarea.scrollHeight + "px"; // set new height

      // Keep cursor at end
      textarea.selectionStart = textarea.selectionEnd = textarea.value.length;
    }



    function showSuggestions(textarea) {
        const suggestionList = document.getElementById("suggestionList");
        const currentWord = getCurrentWord(textarea.value);
        suggestionList.innerHTML = "";

        if (!currentWord) {
          suggestionList.style.display = "none";
          return;
        }

        const filteredSuggestions = suggestions.filter(item =>
          item.toLowerCase().includes(currentWord)
        );

        currentFiltered = filteredSuggestions;
        activeIndex = -1;


      if (filteredSuggestions.length > 0) {

        suggestionList.style.display = "block";
        filteredSuggestions.forEach((item, index) => {
          const div = document.createElement("div");
          div.textContent = item;
          div.style.padding = "5px";
          div.style.cursor = "pointer";

          function updateBackground() {
            if (index === activeIndex) {
              div.style.backgroundColor = "#C7D2FE"; // active (keyboard)
            } else if (selectedSuggestions.includes(item)) {
              div.style.backgroundColor = "#DCFCE7";
            } else {
              div.style.backgroundColor = "#F1F5F9";
            }
          }

          updateBackground();

        div.addEventListener("mouseover", () => {

          activeIndex = index;
          // Remove highlight from all items
          const allItems = suggestionList.children;
          for (let i = 0; i < allItems.length; i++) {
            if (selectedSuggestions.includes(currentFiltered[i])) {
              allItems[i].style.backgroundColor = "#DCFCE7";
            } else {
              allItems[i].style.backgroundColor = "#F1F5F9";
            }
          }

          // Highlight hovered item
          div.style.backgroundColor = "#C7D2FE";
        });


          div.addEventListener("click", () => {
            replaceCurrentWord(textarea, item);
            showSuggestions(textarea);
          });

          suggestionList.appendChild(div);
        });


      } else {
        suggestionList.style.display = "none";
      }
    }

    // Hide suggestions when clicking outside
    document.addEventListener("click", (event) => {
      const suggestionList = document.getElementById("suggestionList");
      if (!event.target.closest("#rmedicationName")) {
        suggestionList.style.display = "none";
      }
    });


    document.getElementById("rmedicationName").addEventListener("keydown", function(e) {
      const suggestionList = document.getElementById("suggestionList");

      if (suggestionList.style.display === "none") return;

      if (e.key === "ArrowDown") {
        e.preventDefault();
        activeIndex = (activeIndex + 1) % currentFiltered.length;
        renderSuggestions(this);
      }

      if (e.key === "ArrowUp") {
        e.preventDefault();
        activeIndex =
          (activeIndex - 1 + currentFiltered.length) % currentFiltered.length;
        renderSuggestions(this);
      }

      if (e.key === "Enter") {
        e.preventDefault();
        if (activeIndex >= 0) {
          replaceCurrentWord(this, currentFiltered[activeIndex]);
          showSuggestions(this);
        }
      }
    });


    function renderSuggestions(textarea) {
      const suggestionList = document.getElementById("suggestionList");
      suggestionList.innerHTML = "";

      currentFiltered.forEach((item, index) => {
        const div = document.createElement("div");
        div.textContent = item;
        div.style.padding = "5px";
        div.style.cursor = "pointer";

        if (index === activeIndex) {
          div.style.backgroundColor = "#C7D2FE";
        } else if (selectedSuggestions.includes(item)) {
          div.style.backgroundColor = "#DCFCE7";
        } else {
          div.style.backgroundColor = "#F1F5F9";
        }

        div.addEventListener("click", () => {
          replaceCurrentWord(textarea, item);
          showSuggestions(textarea);
        });

        suggestionList.appendChild(div);
      });
    }





   //====================================================================================
   //
   //  THIS WILL ADD MEDICINE DATA TO EHR FILE
   //
   //====================================================================================
   function  addMedicineToEhr(){

       // Collect form data
       const formData = {
           rpdfFileName: document.getElementById('rpdfFileName').value,
           rdocumentUserId: document.getElementById('rdocumentUserId').value,
           rmedicationName: document.getElementById('rmedicationName').value,
           isControlledDrug: document.getElementById('isControlledDrugMedication').value,
           dosage: document.getElementById('dosage').value,
           frequency: document.getElementById('frequency').value,
           quantity: document.getElementById('quantity').value,
           noOfRepeat: document.getElementById('noOfRepeat').value,
           startDate: document.getElementById('startDate').value,
           endDate: document.getElementById('endDate').value
       };

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
               title: 'Required!',
               html: 'Please fill in all required fields. <br><br><strong style="color:#7F22FE;">Medication Name <br>Dosage<br>Frequency<br>Quantity<br>Start Date </strong><br><br> are mandatory data.!!!!',
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

              document.getElementById('rmedicationName').value = '';
              document.getElementById('dosage').value = '';
              document.getElementById('frequency').value = '';
              document.getElementById('quantity').value = '';
              document.getElementById('noOfRepeat').value = '';
              document.getElementById('endDate').value = '';

              //-- Load added medicine details to the table
              loadMedicineDetailsToTable(formData.rdocumentUserId);

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



    // Helper: show swal and focus an element after confirm
    function swalAndFocus(messageHtml, elementId) {
      return Swal.fire({
        title: 'Required!',
        html: messageHtml,
        icon: 'warning',
        width: '700px',
        confirmButtonColor: '#d33',
        confirmButtonText: 'OK'
      }).then(() => {
        const el = document.getElementById(elementId);
        if (el) {
          el.scrollIntoView({ behavior: 'smooth', block: 'center' });
          el.focus();
        }
      });
    }



   //====================================================================================
   //
   //  THIS WILL GET LIST OF ADDED MEDICATION DETAIL FROM BACKEND AND RENDER TO THE TABLE
   //
   //====================================================================================
    async function loadMedicineDetailsToTable(patientId) {

            var pdfFileName = document.getElementById("pdfFileName").value;

            fetch('/read-medicine-details-from-ehr/' + patientId)
                .then(response => {
                    if (!response.ok) {
                        throw new Error('Failed to fetch data');
                    }
                    return response.json();
                })
                .then(data => {

                    // Sort by createdDate DESC (latest first)
                    data.sort((a, b) => {

                        const dateA = a.createdDate
                            ? new Date(a.createdDate)
                            : new Date(0);

                        const dateB = b.createdDate
                            ? new Date(b.createdDate)
                            : new Date(0);

                        return dateB - dateA;
                    });

                    const tableBody =   document.getElementById('medicineTableBody');

                    const tableBodyForCD =   document.getElementById('medicineTableBodyCD');

                    tableBody.innerHTML = `

                        <th style="font-size:11px;">Select</th>
                        <th style="font-size:11px;">Medicine</th>
                        <th style="font-size:11px;">Create Date</th>
                        <th style="font-size:11px;">Repeat</th>
                        <th style="font-size:11px;">Start Date</th>
                        <th style="font-size:11px;">End Date</th>
                        <th style="font-size:11px;">Dosage</th>
                        <th style="font-size:11px;">Qty</th>
                        <th style="font-size:11px;">  </th>

                    `;

                    tableBodyForCD.innerHTML =  tableBody.innerHTML;

                    data.forEach((item, index) => {

                        const row = document.createElement('tr');
                        row.style.marginBottom = '10px';

                        row.innerHTML = `

                            <td style="font-size:11px;padding:8px 0;" align="center">
                                <input type="checkbox" class="medicine-checkbox" data-id="${item.medicationId}" value="${item.medicationId}">
                            </td>

                            <td style="font-size:11px;padding:10px 0;">
                                <a href="Javascript:void(0);" onclick="loadMedicationDataFromEhrToTheModel('${patientId}','${item.medicationId}');">
                                  ${item.medicationName || ''}
                               </a>
                            </td>

                            <td style="font-size:11px;padding:10px 0;">
                                ${formatDate(item.createdDate)}
                            </td>

                            <td style="font-size:11px;padding:10px 0;" align="center">
                                <b> ${item.frequency} </b>
                            </td>

                            <td style="font-size:11px;padding:10px 0;">
                                ${formatDate(item.startDate)}
                            </td>

                            <td style="font-size:11px;padding:10px 0;">
                                ${formatDate(item.endDate)}
                            </td>

                            <td style="font-size:11px;padding:10px 0;">
                                ${item.dosage || ''}
                            </td>

                            <td style="font-size:11px;padding:10px 0;"  align="center">
                                <b> ${item.quantityPerDispense || ''} </b>
                            </td>

                            <td style="font-size:11px;padding:10px 0;">
                                <a href="javascript:void(0);"
                                   onclick="removeMedicineFromTemp('${item.medicationId}','${patientId}')">

                                    <i class="bi bi-trash3" style="color:red"></i>
                                    <span style="color:red">Remove</span>

                                </a>
                            </td>

                        `;

                        if (String(item.isControlledDrugMedication).trim().toLowerCase() === 'false') {
                            tableBody.appendChild(row);
                        }

                        if (String(item.isControlledDrugMedication).trim().toLowerCase() === 'true') {
                            tableBodyForCD.appendChild(row);
                        }

                    });

                })
                .catch(error => {
                    console.error('Error fetching medicine details:', error);
                    alert(error);
                });
        }


     // ==============================================================================
     //       Open Model to copy previous medicine with the selected item detail
     // ===============================================================================
     async function loadMedicationDataFromEhrToTheModel(patientId, medicationId) {
              const form = document.getElementById('repeatePrescriptionOfPatient');
              form.reset();
               // assign current date to date field
              const dateInput = document.getElementById('M_startDateCD');
              if (!dateInput) return;
              const today = new Date().toISOString().split('T')[0]; // YYYY-MM-DD in local time
              dateInput.value = today;  // preselect today

             try {
                const resp = await fetch("get-medication-by-id", {
                  method: "POST",
                  headers: {
                    "Accept": "application/json",
                    "Content-Type": "application/json"
                  },
                  body: JSON.stringify({
                    patientId: patientId,
                    medicationId: medicationId
                  })
                });


                    // Parse response data
                    const raw = await resp.text();
                    if (!resp.ok) throw new Error(raw || `HTTP ${resp.status}`);
                    console.log("Raw response from backend:", raw); // Debug log to check raw response

                    // safe json parse
                    let data = {};
                    try {
                      data = raw ? JSON.parse(raw) : {};
                    } catch (e) {
                      throw new Error("Server did not return valid JSON.");
                    }

                    document.getElementById("M_rmedicationNameCD").value = data.medicationName || '';
                    document.getElementById("M_dosageCD").value = data.dosage || '';
                    document.getElementById("M_frequencyCD").value = data.frequency || '';
                    document.getElementById("M_quantityCD").value = data.quantityPerDispense || '';
                    document.getElementById("M_noOfRepeatCD").value = data.frequency || '';
                    document.getElementById("isControlledDrugMedication").value = data.isControlledDrugMedication;



                    //-- Based on input calculate date
                    calculateNextDispenseDateCD_model();

              } catch (err) {
                console.error("Error loading medication detail:", err);
                Swal.fire(
                  "Load Failed",
                  err?.message || "Could not load medication details from backend.",
                  "error"
                );
              }

               // Set the patientId in the hidden input field
               const model_name = new bootstrap.Modal(document.getElementById('prescriptionModel'));
               model_name.show();
     }





    function formatDate(dateString) {

        if (!dateString) return "";

        // Convert to Date object
        const date = new Date(dateString);

        // Check invalid date
        if (isNaN(date.getTime())) {
            return "";
        }

        const day = String(date.getDate()).padStart(2, '0');
        const month = String(date.getMonth() + 1).padStart(2, '0');
        const year = date.getFullYear();

        // Detect if original string contains time
        const hasTime = dateString.includes("T");

        // If no time part -> return only date
        if (!hasTime) {
            return `${day}/${month}/${year}`;
        }

        let hours = date.getHours();
        const minutes = String(date.getMinutes()).padStart(2, '0');

        const ampm = hours >= 12 ? 'pm' : 'am';

        hours = hours % 12;
        hours = hours ? hours : 12;

        const formattedHours = String(hours).padStart(2, '0');

        // If time is exactly midnight -> return only date
        if (
            date.getHours() === 0 &&
            date.getMinutes() === 0 &&
            date.getSeconds() === 0
        ) {
            return `${day}/${month}/${year}`;
        }

        return `${day}/${month}/${year} ${formattedHours}:${minutes} ${ampm}`;
    }


    //====================================================================================
    //
    //  THIS WILL REMOVE MEDICINE DATA FROM EHR AND THEN REFRESH THE TABLE AND PDF IN THE FRAME
    //
    //====================================================================================

     function removeMedicineFromTemp(medicationId,patientId) {
         // Confirmation dialog
         Swal.fire({
             title: 'Are you sure?',
             text: "This will remove the selected medicine from the list.",
             icon: 'warning',
             showCancelButton: true,
             confirmButtonColor: '#03c4eb',
             cancelButtonColor: '#d33',
             confirmButtonText: 'Yes'
         }).then((result) => {
             if (result.isConfirmed) {
                 // Show loading state
                 Swal.fire({
                     title: 'Removing...',
                     allowOutsideClick: false,
                     didOpen: () => Swal.showLoading(),
                 });

                 // Send DELETE request
                 fetch(`/remove-medicine-detail-from-ehr/${medicationId}/${patientId}`, {
                     method: 'DELETE',
                 })
                 .then(async (response) => {
                     const responseText = await response.text();
                     if (!response.ok) throw new Error(responseText);

                     Swal.fire({
                         title: 'Success!',
                         text: responseText || 'Medicine removed successfully.',
                         icon: 'success',
                         confirmButtonColor: '#03c4eb'
                     }).then(() => {
                         // Reload the medicine list
                         const patientId = document.getElementById('rdocumentUserId').value;
                         const createDate = document.getElementById('startDate').value;
                         loadMedicineDetailsToTable(patientId); // Refresh the table after deletion
                         //reloadUpdatedPrescriptionPdf(); // Refresh the PDF in the frame after deletion
                     });
                 })
                 .catch((error) => {
                     Swal.fire({
                         title: 'Failed!',
                         text: error.message || 'Could not remove medicine. Please try again.',
                         icon: 'error',
                         confirmButtonColor: '#d33'
                     });
                 });
             }
         });
     }



   function  reloadUpdatedPrescriptionPdf(){
       // Reload the PDF in the frame to reflect the updated medicine list after deletion
       const frame = document.getElementById("pdfFrame");
       const rpdfFileName = document.getElementById('rpdfFileName').value;
       frame.src = `view-document-admin?fileName=`+rpdfFileName;
   }





   //====================================================================================
   //
   //  THIS WILL ADD MEDICINE DATA TO PDF AND CREATE PDF AND THEN DISPLAY THE PDF IN THE FRAME
   //
   //====================================================================================

    function createPdfFileFromEhr() {

        // Collect form data
        const formData = {
            pharmacyDetail: document.getElementById('pharmacyDetail').value,
            rpdfFileName: document.getElementById('rpdfFileName').value,
            rdocumentUserId: document.getElementById('rdocumentUserId').value,
            medicationIds: Array.from(document.querySelectorAll('.medicine-checkbox:checked')).map(cb => cb.value)
        };


        // Validate required fields
        if (!formData.pharmacyDetail || formData.pharmacyDetail.trim() === "") {
            Swal.fire({
                title: 'Required!',
                text: 'Pharmacy detail is required.',
                icon: 'warning',
                confirmButtonColor: '#d33',
                confirmButtonText: 'OK'
            });
            document.getElementById('pharmacyDetail').focus();
            return;
        }


        // ✅ Validation: at least one medicine must be selected
        if (!formData.medicationIds || formData.medicationIds.length === 0) {
            Swal.fire({
                title: 'Validation',
                text: 'Please select at least one medicine.',
                icon: 'warning',
                confirmButtonColor: '#f0ad4e'
            });
            return;
        }


        // Confirmation dialog
        Swal.fire({
            title: 'Are you sure?',
            text: "This will create a repeat prescription.",
            icon: 'warning',
            showCancelButton: true,
            confirmButtonColor: '#03c4eb',
            cancelButtonColor: '#d33',
            confirmButtonText: 'Yes'
        }).then((result) => {
            if (result.isConfirmed) {
                // Show loading state
                Swal.fire({
                    title: 'In progress...',
                    allowOutsideClick: false,
                    didOpen: () => Swal.showLoading(),
                });

                // Send POST request
                fetch('/create-repeat-prescription-pdf', {
                    method: 'POST',
                    headers: { 'Content-Type': 'application/json' },
                    body: JSON.stringify(formData)
                })
                .then(async (response) => {
                    const responseText = await response.text();
                    if (!response.ok) throw new Error(responseText);

                    Swal.fire({
                        title: 'Success!',
                        text: responseText || 'Repeat prescription created successfully.',
                        icon: 'success',
                        confirmButtonColor: '#03c4eb'
                    }).then(() => {
                       var viewPdfButton = document.getElementById('rpdfFile');
                       viewPdfButton.style.display = "block";

                       //-- Extract PDF file names from the response text (if any)
                       const pdfFiles = responseText.match(/[^:\s]+\.pdf/g);
                       // ["PRES_PAT_28032026_438362.pdf", "PRES_PAT_28032026_438333.pdf"]
                       //-- If there is file name in the response then load the PDF in the frame
                       if (pdfFiles) {
                           loadMultiplePdfInFrame(pdfFiles);
                       }

                    });
                })
                .catch((error) => {
                    Swal.fire({
                        title: 'Failed!',
                        text: error.message || 'Could not create repeat prescription. Please try again.',
                        icon: 'error',
                        confirmButtonColor: '#d33'
                    });
                });
            }
        });
    }


    function loadMultiplePdfInFrame(fileNames) {
        const container = document.getElementById('rpdfContainer');
        if (!container) {
            console.error('PDF container not found.');
            return;
        }

        // Clear existing iframes
        container.innerHTML = '';

        // Make the container visible
        container.style.display = 'block';

        // Split filenames if it's a comma-separated string
        const filesArray = Array.isArray(fileNames) ? fileNames : fileNames.split(':');

        // Remove any whitespace from filenames
        const cleanedFiles = filesArray.map(file => file.trim());

        // Create iframe for each file
        cleanedFiles.forEach((fileName, index) => {
            // Create wrapper div for each PDF
            const pdfWrapper = document.createElement('div');
            pdfWrapper.className = 'pdf-wrapper';
            pdfWrapper.style.cssText = `
                margin-bottom: 20px;
                border: 1px solid #ddd;
                padding: 10px;
                border-radius: 5px;
            `;

            // Add filename header
            const header = document.createElement('div');
            //header.textContent = `Document ${index + 1}: ${fileName}`;
            header.style.cssText = `
                font-weight: bold;
                margin-bottom: 10px;
                color: #333;
                font-size: 14px;
            `;
            pdfWrapper.appendChild(header);

            // Create iframe
            const iframe = document.createElement('iframe');
            iframe.id = `pdfPreview_${index}`;
            iframe.name = `pdfPreview_${fileName}`;
            iframe.style.cssText = `
                width: 100%;
                height: 500px;
                border: none;
            `;

            // Build URL with cache-busting param
            const url = "view-document-admin?fileName="+fileName + "&cb=" + new Date().getTime()+index;

            // Load PDF
            iframe.src = url;

            pdfWrapper.appendChild(iframe);
            container.appendChild(pdfWrapper);
        });
    }


    /// This function will calculate the next dispense date based on the start date, number of repeats, and frequency
    function calculateNextDispenseDate() {
        try {
            // Parse inputs
            const startDate = new Date(document.getElementById('startDate').value);
            const repeats = parseInt(document.getElementById('noOfRepeat').value, 10);
            const freqDays = parseInt(document.getElementById('frequency').value, 10);

            if (isNaN(startDate.getTime()) || isNaN(repeats) || isNaN(freqDays)) {
                throw new Error("Invalid input");
            }

            // Calculate next dispense date
            const totalDaysToAdd = repeats * freqDays;

            const nextDate = new Date(startDate);
            nextDate.setDate(startDate.getDate() + totalDaysToAdd);

            // Format as yyyy-MM-dd
            const formattedDate = nextDate.toISOString().split("T")[0];

            document.getElementById('endDate').value = formattedDate;



        } catch (e) {
            console.error(e);
            return null;
        }
    }


   //====================================================================================
   //
   //  THIS WILL SEND PDF FILE TO THE PHARMACY AND NOTIFY THE PATIENT
   //
   //====================================================================================

    function sendRepeatPrescription() {
        // Collect form data
        const formData = {
            pdfFileName: document.getElementById('rpdfFileName').value,
            rpdfFileNameCD: document.getElementById('rpdfFileNameCD').value,
            patientId: document.getElementById('rdocumentUserId').value,
            pharmacyDetail: document.getElementById('pharmacyDetail').value
        };

        // Validate required fields
        if (!formData.pharmacyDetail || formData.pharmacyDetail.trim() === "") {
            Swal.fire({
                title: 'Required!',
                text: 'Pharmacy detail is required.',
                icon: 'warning',
                confirmButtonColor: '#d33',
                confirmButtonText: 'OK'
            });
            document.getElementById('pharmacyDetail').focus();
            return;
        }

        // Confirmation dialog
        Swal.fire({
            title: 'Are you sure?',
            text: "This will send the repeat prescription to the pharmacy.",
            icon: 'warning',
            showCancelButton: true,
            confirmButtonColor: '#03c4eb',
            cancelButtonColor: '#d33',
            confirmButtonText: 'Yes'
        }).then((result) => {
            if (result.isConfirmed) {
                // Show loading state
                Swal.fire({
                    title: 'Sending...',
                    allowOutsideClick: false,
                    didOpen: () => Swal.showLoading(),
                });

                // Send POST request
                fetch('/send-repeat-prescription', {
                    method: 'POST',
                    headers: { 'Content-Type': 'application/json' },
                    body: JSON.stringify(formData)
                })
                .then(async (response) => {
                    const responseText = await response.text();
                    if (!response.ok) throw new Error(responseText);

                    Swal.fire({
                        title: 'Success!',
                        text: responseText || 'Prescription sent successfully.',
                        icon: 'success',
                        confirmButtonColor: '#03c4eb'
                    });
                })
                .catch((error) => {
                    Swal.fire({
                        title: 'Failed!',
                        text: error.message || 'Could not send prescription. Please try again.',
                        icon: 'error',
                        confirmButtonColor: '#d33'
                    });
                });
            }
        });
    }




   //====================================================================================
   //
   //  THIS WILL ADD CONTROLLED DRUG MEDICINE DATA TO PT EHR
   //
   //====================================================================================
   function  addCDMedicineToEhr(){

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
           isControlledDrug: document.getElementById('isControlledDrugMedicationCD').value
           //nextDispense: document.getElementById('nextDispense').value
       };

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
               title: 'Required!',
               html: 'Please fill in all required fields. <br><br><strong style="color:#7F22FE;">Medication Name <br>Dosage<br>Frequency<br>Quantity<br>Start Date </strong><br><br> are mandatory data.!!!!',
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
              loadMedicineDetailsToTable(formData.rdocumentUserId);

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




   //=================================================================================================
   //
   //  THIS WILL ADD MEDICINE DATA TO PDF AND CREATE PDF AND THEN DISPLAY MULTIPLE PDF IN THE FRAME
   //
   //=================================================================================================

    async function createPdfFileFromEhrCD() {

        // -----------------------------
        // Collect form data
        // -----------------------------
        const pharmacyDetail = document.getElementById('pharmacyDetail').value.trim();
        const medicationIds = Array.from(
            document.querySelectorAll('.medicine-checkbox:checked')
        ).map(cb => cb.value);

        const formData = {
            pharmacyDetail,
            rpdfFileName: document.getElementById('rpdfFileName').value,
            rdocumentUserId: document.getElementById('rdocumentUserId').value,
            medicationIds,
            isControlledDrug: "YES"
        };

        // -----------------------------
        // Validation
        // -----------------------------

        // Pharmacy validation
        if (!pharmacyDetail) {
            Swal.fire({
                title: 'Required!',
                text: 'Pharmacy detail is required.',
                icon: 'warning',
                confirmButtonColor: '#d33'
            });

            document.getElementById('pharmacyDetail').focus();
            return;
        }

        // No medicine selected
        if (medicationIds.length === 0) {
            Swal.fire({
                title: 'Validation',
                text: 'Please select at least one medicine.',
                icon: 'warning',
                confirmButtonColor: '#f0ad4e'
            });
            return;
        }

        // -----------------------------
        // Confirmation dialog
        // -----------------------------
        const result = await Swal.fire({
            title: 'Are you sure?',
            text: 'This will create a repeat prescription.',
            icon: 'warning',
            showCancelButton: true,
            confirmButtonColor: '#03c4eb',
            cancelButtonColor: '#d33',
            confirmButtonText: 'Yes'
        });

        if (!result.isConfirmed) return;

        // -----------------------------
        // Loading state
        // -----------------------------
        Swal.fire({
            title: 'In progress...',
            allowOutsideClick: false,
            didOpen: () => Swal.showLoading(),
        });

        try {

            // -----------------------------
            // API Request
            // -----------------------------
            const response = await fetch('/create-repeat-prescription-pdf', {
                method: 'POST',
                headers: {
                    'Content-Type': 'application/json'
                },
                body: JSON.stringify(formData)
            });

            const responseText = await response.text();

            if (!response.ok) {
                throw new Error(responseText);
            }

            // -----------------------------
            // Success Message
            // -----------------------------
            await Swal.fire({
                title: 'Success!',
                text: 'Controlled Drug Repeat prescription created successfully.',
                icon: 'success',
                confirmButtonColor: '#03c4eb'
            });

            // Show PDF button
            document.getElementById('rpdfFileCD').style.display = 'block';

            // Extract PDF names
            const pdfFiles = responseText.match(/[^:\s]+\.pdf/g);

            if (pdfFiles && pdfFiles.length > 0) {
                document.getElementById('rpdfFileNameCD').value = pdfFiles.join(',');

                loadMultipleCDPdfInFrame(pdfFiles);
            }

        } catch (error) {

            // -----------------------------
            // Error Message
            // -----------------------------
            Swal.fire({
                title: 'Failed!',
                text: error.message || 'Could not create repeat prescription. Please try again.',
                icon: 'error',
                confirmButtonColor: '#d33'
            });
        }
    }


    function loadMultipleCDPdfInFrame(fileNames) {
        const container = document.getElementById('pdfContainerCD');
        if (!container) {
            console.error('PDF container not found.');
            return;
        }

        // Clear existing iframes
        container.innerHTML = '';

        // Make the container visible
        container.style.display = 'block';

        // Split filenames if it's a comma-separated string
        const filesArray = Array.isArray(fileNames) ? fileNames : fileNames.split(':');

        // Remove any whitespace from filenames
        const cleanedFiles = filesArray.map(file => file.trim());

        // Create iframe for each file
        cleanedFiles.forEach((fileName, index) => {
            // Create wrapper div for each PDF
            const pdfWrapper = document.createElement('div');
            pdfWrapper.className = 'pdf-wrapper';
            pdfWrapper.style.cssText = `
                margin-bottom: 20px;
                border: 1px solid #ddd;
                padding: 10px;
                border-radius: 5px;
            `;

            // Add filename header
            const header = document.createElement('div');
            //header.textContent = `Document ${index + 1}: ${fileName}`;
            header.style.cssText = `
                font-weight: bold;
                margin-bottom: 10px;
                color: #333;
                font-size: 14px;
            `;
            pdfWrapper.appendChild(header);

            // Create iframe
            const iframe = document.createElement('iframe');
            iframe.id = `pdfPreview_${index}`;
            iframe.name = `pdfPreview_${fileName}`;
            iframe.style.cssText = `
                width: 100%;
                height: 300px;
                border: none;
            `;

            // Build URL with cache-busting param
            const url = "view-document-admin?fileName="+fileName + "&cb=" + new Date().getTime()+index;

            // Load PDF
            iframe.src = url;

            pdfWrapper.appendChild(iframe);
            container.appendChild(pdfWrapper);
        });
    }

