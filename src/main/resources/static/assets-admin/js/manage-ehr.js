
   function alertUnderConstruction() {
     Swal.fire({
       title: 'Under Construction',
       text: 'This feature is currently under development.',
       icon: 'info',
       confirmButtonText: 'OK'
     });
   } //  End of function alertUnderConstruction



    // =====================================================
    // SELECT CURRENT DATE AND NOT ALLOWED FUTURE DATE
    // =====================================================
   document.addEventListener('DOMContentLoaded', () => {
     const dateInput = document.getElementById('DetailDateOfDiagnosis');
     if (!dateInput) return;
     const today = new Date().toISOString().split('T')[0]; // YYYY-MM-DD in local time
     dateInput.value = today;  // preselect today
     dateInput.max = today;    // disallow future dates
   });



    // ==================================================================================
    // LOAD ALL ICSD DATA WITH CODE TO THE SELECTION BOX FOR PROBLEM DETAIL IN THE MODAL
    // ====================================================================================

    async function loadICDDataProblemList() {
      const select = document.getElementById('problemDetail');
      if (!select) return;

      // Keep the first default option and remove any others
      select.length = 1;

      try {
        const resp = await fetch('all_icd_code'); // adjust path if needed
        if (!resp.ok) throw new Error(`HTTP ${resp.status}`);
        const data = await resp.json(); // expect an array of ICD_Data_Bank objects

        data.forEach(item => {
          const opt = document.createElement('option');
          opt.value = item.icd10Code; // choose your preferred value
          opt.textContent = item.localGpCode + " - " +item.localDescription;
          select.appendChild(opt);
        });

      } catch (err) {
        console.error('Failed to load ICD data:', err);
      }
    }

    async function loadICDDataProblemListWithSelection(problemCode) {
      const select = document.getElementById('problemDetail');
      if (!select) return;

      // Keep the first default option and remove any others
      select.length = 1;

      try {
        const resp = await fetch('all_icd_code'); // adjust path if needed
        if (!resp.ok) throw new Error(`HTTP ${resp.status}`);
        const data = await resp.json(); // expect an array of ICD_Data_Bank objects

        data.forEach(item => {
          const opt = document.createElement('option');

          opt.value = item.icd10Code; // choose your preferred value
          opt.textContent = item.localGpCode + " - " +item.localDescription;
          select.appendChild(opt);
         if(problemCode == item.icd10Code){
           opt.selected = true;
         }
        });

      } catch (err) {
        console.error('Failed to load ICD data:', err);
      }
    }


    // =====================================================
    // SAVE HEALTH PROBLEM DETAIL TO THE PATIENT EHR FILE
    // =====================================================
    async function saveProblemDetailDataToPatientEhr() {

      const saveToEhr      = document.getElementById("saveToEhr");
      const problemSelect     = document.getElementById("problemDetail");
      const dateInput         = document.getElementById("DetailDateOfDiagnosis");
      const severitySelect    = document.getElementById("severity");
      const cronicSelect      = document.getElementById("cronic");
      const noteTextarea      = document.getElementById("problemNoteToPatient");
      const patientIdInput    = document.getElementById("patientId");
      const actionCode    = document.getElementById("actionCode");



      const messageBody = problemNoteToPatient ? problemNoteToPatient.value : "";
      const problemCode = problemSelect?.value || "";
      const diagnosisDate = dateInput?.value || "";
      const severity = severitySelect?.value || "";
      const cronic = cronicSelect?.value || "";
      const note = noteTextarea?.value || "";
      const patientId = patientIdInput?.value || "";

      // Validate required fields
      if (!problemCode || problemCode === "All") {
        Swal.fire("Missing Problem", "Please select a problem.", "warning");
        return;
      }

      // Confirmation
      const result = await Swal.fire({
        title: "Are you sure?",
        text: "Do you want to update patient EHR ?",
        icon: "question",
        showCancelButton: true,
        confirmButtonColor: "#3085d6",
        cancelButtonColor: "#d33",
        confirmButtonText: "Yes, please !",
      });

      if (!result.isConfirmed) return;

      // Disable button
      saveToEhr.disabled = true;

      // Build payload
      const requestData = {
        patientId: document.getElementById("userId").value,
        problemDetail: problemCode,
        dateOfDiagnosis: diagnosisDate,
        severity: severity,
        cronic: cronic,
        noteToPatient: note,
        conditionStatus: 'Active',
        actionCode: actionCode.value,
        // admin details
        adminName: "${ADMIN_SESSION.firstName} ${ADMIN_SESSION.lastName}",
        adminId: "${ADMIN_SESSION.userId}",
      };

      try {
        const resp = await fetch("update-patient-ehr-problem-detail", {
          method: "POST",
          headers: { "Content-Type": "application/json" },
          body: JSON.stringify(requestData),
        });

        const respText = await resp.text();
        if (!resp.ok) throw new Error(respText || `HTTP ${resp.status}`);

        await Swal.fire("EHR Updated ! ", respText, "success");
       // Close modal
        const modalElement = document.getElementById("problemModel");
        if (modalElement) {
          const bootstrapModal = bootstrap.Modal.getInstance(modalElement);
          if (bootstrapModal) bootstrapModal.hide();
          // This method will fetch the updated problems section and replace the HTML, without a full page reload
          await reloadEhrPageForPatient(patientId);

           // Reopen Accordion after update (if needed)
           //openAccordion('collapseTwo'); // Replace 'headingTwo' with the ID of the accordion header
            //openAccordion('headingTwo');
        }
      } catch (err) {
        console.error("Error:", err);
        Swal.fire(
          "Not updated !",
          err?.message || "An error occurred while updating EHR . Please try again.",
          "error"
        );
      } finally {
         saveToEhr.disabled = false;
      }
    }



    async function reloadEhrPageForPatient(patientId) {
      const resp = await fetch('get-updated-ehr?patientId='+patientId);
      const html = await resp.text();
      document.getElementById("problemsContainer").innerHTML = html;
    }



   // FUNCTION TO OPEN THE ACCORDION PROGRAMMATICALLY
    function openAccordion(accordionId) {
        const el = document.getElementById(accordionId);
        if (!el) return;

        let bsCollapse = bootstrap.Collapse.getInstance(el);
        if (!bsCollapse) {
            bsCollapse = new bootstrap.Collapse(el, { toggle: false });
        }

        bsCollapse.show();
    }

    // =====================================================
    // ADD NEW  ALLERGY DETAIL TO THE PATIENT EHR FILE
    // =====================================================
    async function saveAllergyDetailToPatientEhr() {

       const saveToEhr = document.getElementById("saveToEhr");
       const patientId = document.getElementById("userId").value;

       // Which tab is active?
       const activeTab = document.querySelector("#allergyTabs .nav-link.active")?.id;

       // Medicine fields
       const medData = {
         allergen: document.getElementById("allergen-meds").value.trim(),
         reaction: document.getElementById("reaction-meds").value.trim(),
         severity: document.getElementById("severity-meds").value,
         dateOfDiagnosis: document.getElementById("diagnosedDate-meds").value,
         notes: document.getElementById("note-meds").value.trim(),
         operation: "add",
         type: "Medicine"
       };

       // General fields
       const genData = {
         allergen: document.getElementById("allergen-general").value,
         reaction: document.getElementById("reaction-general").value.trim(),
         severity: document.getElementById("severity-general").value,
         dateOfDiagnosis: document.getElementById("diagnosedDate-general").value,
         notes: document.getElementById("note-general").value.trim(),
         operation: "add",
         type: "General"
       };

       const isMedTab = activeTab === "medicine-tab";
       const payload = {
         patientId: String(patientId),
         ...(isMedTab ? medData : genData),
         adminName: "${ADMIN_SESSION.firstName} ${ADMIN_SESSION.lastName}",
         adminId: "${ADMIN_SESSION.userId}"
       };

       // Basic validation: require allergen on active tab
       if (!payload.allergen) {
         Swal.fire("Missing allergy information", "Please select or enter an allergen.", "warning");
         return;
       }

       if (!payload.dateOfDiagnosis) {
         Swal.fire("Missing date information", "Please select or enter an Date .", "warning");
         return;
       }

       const result = await Swal.fire({
         title: "Are you sure?",
         text: "Do you want to update patient EHR?",
         icon: "question",
         showCancelButton: true,
         confirmButtonColor: "#3085d6",
         cancelButtonColor: "#d33",
         confirmButtonText: "Yes, please!"
       });
       if (!result.isConfirmed) return;

       saveToEhr.disabled = true;

       try {
         const resp = await fetch("update-patient-ehr-allergy-detail", {
           method: "POST",
           headers: { "Content-Type": "application/json" },
           body: JSON.stringify(payload),
         });
         const respText = await resp.text();
         if (!resp.ok) throw new Error(respText || `HTTP ${resp.status}`);

         await Swal.fire("EHR Updated!", respText, "success");
         const modalElement = document.getElementById("allergyModel");
         if (modalElement) {
           const bootstrapModal = bootstrap.Modal.getInstance(modalElement);
           if (bootstrapModal) bootstrapModal.hide();
             // This method will fetch the updated problems section and replace the HTML, without a full page reload
             reloadEhrPageForPatient(patientId);
         }
       } catch (err) {
         console.error("Error:", err);
         Swal.fire("Not updated!", err?.message || "An error occurred while updating EHR. Please try again.", "error");
       } finally {
         saveToEhr.disabled = false;
       }
     }



    // =====================================================
    // UPDATE MEDICINE ALLERGY DETAIL TO THE PATIENT EHR FILE
    // =====================================================
    async function updateMedicineAllergyDetailToPatientEhr() {

       const saveToEhr = document.getElementById("saveToEhr");
       const patientId = document.getElementById("userId").value;

       // Which tab is active?
       const activeTab = document.querySelector("#allergyTabs .nav-link.active")?.id;

       // Medicine fields
       const medData = {
         allergen: document.getElementById("allergen-meds-update").value.trim(),
         reaction: document.getElementById("reaction-meds-update").value.trim(),
         severity: document.getElementById("severity-meds-update").value,
         dateOfDiagnosis: document.getElementById("diagnosedDate-meds-update").value,
         notes: document.getElementById("note-meds-update").value.trim(),
         operation: "update",
         type: "Medicine"
       };

       const isMedTab = activeTab === "medicine-tab";
       const payload = {
         patientId: String(patientId),
         ...(isMedTab ? medData : medData),
         adminName: "${ADMIN_SESSION.firstName} ${ADMIN_SESSION.lastName}",
         adminId: "${ADMIN_SESSION.userId}"
       };

       // Basic validation: require allergen on active tab
       if (!payload.allergen) {
         Swal.fire("Missing allergy information", "Please select or enter an allergen.", "warning");
         return;
       }

       if (!payload.dateOfDiagnosis) {
         Swal.fire("Missing date information", "Please select or enter an Date .", "warning");
         return;
       }

       const result = await Swal.fire({
         title: "Are you sure?",
         text: "Do you want to update patient EHR?",
         icon: "question",
         showCancelButton: true,
         confirmButtonColor: "#3085d6",
         cancelButtonColor: "#d33",
         confirmButtonText: "Yes, please!"
       });
       if (!result.isConfirmed) return;

       saveToEhr.disabled = true;

       try {
         const resp = await fetch("update-patient-ehr-allergy-detail", {
           method: "POST",
           headers: { "Content-Type": "application/json" },
           body: JSON.stringify(payload),
         });
         const respText = await resp.text();
         if (!resp.ok) throw new Error(respText || `HTTP ${resp.status}`);

         await Swal.fire("EHR Updated!", respText, "success");
         const modalElement = document.getElementById("updateMedicineAllergyModel");
         if (modalElement) {
           const bootstrapModal = bootstrap.Modal.getInstance(modalElement);
           if (bootstrapModal) bootstrapModal.hide();
             // This method will fetch the updated problems section and replace the HTML, without a full page reload
             reloadEhrPageForPatient(patientId);
         }
       } catch (err) {
         console.error("Error:", err);
         Swal.fire("Not updated!", err?.message || "An error occurred while updating EHR. Please try again.", "error");
       } finally {
         saveToEhr.disabled = false;
       }
     }


   // =====================================================
    // UPDATE GENERAL  ALLERGY DETAIL TO THE PATIENT EHR FILE
    // =====================================================
    async function updateGeneralAllergyDetailToPatientEhr() {

       const saveToEhr = document.getElementById("saveToEhr");
       const patientId = document.getElementById("userId").value;

       // Which tab is active?
       const activeTab = document.querySelector("#allergyTabs .nav-link.active")?.id;

       // General fields
       const genData = {
         allergen: document.getElementById("allergen-general-update").value,
         reaction: document.getElementById("reaction-general-update").value,
         severity: document.getElementById("severity-general-update").value,
         dateOfDiagnosis: document.getElementById("diagnosedDate-general-update").value,
         notes: document.getElementById("note-general-update").value,
         operation: "update",
         type: "General"
       };

       const isMedTab = activeTab === "general-tab";
       const payload = {
         patientId: String(patientId),
         ...(genData ? genData : genData),
         adminName: "${ADMIN_SESSION.firstName} ${ADMIN_SESSION.lastName}",
         adminId: "${ADMIN_SESSION.userId}"
       };

       // Basic validation: require allergen on active tab
       if (!payload.allergen) {
         Swal.fire("Missing allergy information", "Please select or enter an allergen.", "warning");
         return;
       }

       if (!payload.dateOfDiagnosis) {
         Swal.fire("Missing date information", "Please select or enter an Date .", "warning");
         return;
       }

       const result = await Swal.fire({
         title: "Are you sure?",
         text: "Do you want to update patient EHR?",
         icon: "question",
         showCancelButton: true,
         confirmButtonColor: "#3085d6",
         cancelButtonColor: "#d33",
         confirmButtonText: "Yes, please!"
       });
       if (!result.isConfirmed) return;

       saveToEhr.disabled = true;

       try {
         const resp = await fetch("update-patient-ehr-allergy-detail", {
           method: "POST",
           headers: { "Content-Type": "application/json" },
           body: JSON.stringify(payload),
         });
         const respText = await resp.text();
         if (!resp.ok) throw new Error(respText || `HTTP ${resp.status}`);

         await Swal.fire("EHR Updated!", respText, "success");
         const modalElement = document.getElementById("updateGeneralAllergyModel");
         if (modalElement) {
           const bootstrapModal = bootstrap.Modal.getInstance(modalElement);
           if (bootstrapModal) bootstrapModal.hide();
             // This method will fetch the updated problems section and replace the HTML, without a full page reload
             reloadEhrPageForPatient(patientId);
         }
       } catch (err) {
         console.error("Error:", err);
         Swal.fire("Not updated!", err?.message || "An error occurred while updating EHR. Please try again.", "error");
       } finally {
         saveToEhr.disabled = false;
       }
     }



    // =====================================================
    // SAVE PRESCRIPTION DETAIL TO THE PATIENT EHR FILE
    // =====================================================
     async function saveRepeatMedicationToEhr() {

           const saveToEhr = document.getElementById("saveToEhr");
           const patientId = document.getElementById("userId").value;

           // Medicine fields
           const payload = {
             patientId: String(patientId),
             quantity: document.getElementById("quantity").value.trim(),
             medicationId: document.getElementById("medicationId").value.trim(),
             medicationName: document.getElementById("medicationName").value.trim(),
             dosage: document.getElementById("dosage").value,
             startFromDate: document.getElementById("startFromDate").value,
             operationMedication: document.getElementById("operationMedication").value,
             adminName: "${ADMIN_SESSION.firstName} ${ADMIN_SESSION.lastName}",
             adminId: "${ADMIN_SESSION.userId}"
           };


           // Basic validation
           if (!payload.quantity) {
             Swal.fire("Missing Qty !!", "Please enter Qty.", "warning");
             return;
           }
           // Basic validation
           if (!payload.medicationName) {
             Swal.fire("Missing medication detail  !!", "Please enter medication .", "warning");
             return;
           }
           // Basic validation
           if (!payload.dosage) {
             Swal.fire("Missing dosage !!", "Please enter dosage.", "warning");
             return;
           }
           // Basic validation
           if (!payload.startFromDate) {
             Swal.fire("Missing from date !!", "Please enter from date.", "warning");
             return;
           }

           const result = await Swal.fire({
             title: "Are you sure?",
             text: "Do you want to update patient EHR?",
             icon: "question",
             showCancelButton: true,
             confirmButtonColor: "#3085d6",
             cancelButtonColor: "#d33",
             confirmButtonText: "Yes, please!"
           });
           if (!result.isConfirmed) return;

           saveToEhr.disabled = true;

           try {
             const resp = await fetch("update-patient-ehr-medication-detail", {
               method: "POST",
               headers: { "Content-Type": "application/json" },
               body: JSON.stringify(payload),
             });
             const respText = await resp.text();
             if (!resp.ok) throw new Error(respText || `HTTP ${resp.status}`);

             await Swal.fire("EHR Updated!", respText, "success");
             const modalElement = document.getElementById("prescriptionModel");
             if (modalElement) {
               const bootstrapModal = bootstrap.Modal.getInstance(modalElement);
               if (bootstrapModal) bootstrapModal.hide();
                 // This method will fetch the updated problems section and replace the HTML, without a full page reload
                 reloadEhrPageForPatient(patientId);
             }
           } catch (err) {
             console.error("Error:", err);
             Swal.fire("Not updated!", err?.message || "An error occurred while updating EHR. Please try again.", "error");
           } finally {
             saveToEhr.disabled = false;
           }
     }





    //----- ADD REMOVE CODE GENERAL ALLERGY  TO PATIENT HCR -------------
    function updateGeneralAllergytoEhr(checkbox) {

       const value = checkbox.value;     // "Peanuts"
       const isChecked = checkbox.checked; // true or false
       if(isChecked == true){
          operation = "add";
        } else {
          operation = "remove";
        }

        const data = {
            patientId: document.getElementById("userId").value,
            allergyName: value,
            operation: operation
        };
        fetch('manage-general-allergy', {
            method: 'POST',
            headers: { 'Content-Type': 'application/json' },
            body: JSON.stringify(data)
        });
    }



    // =====================================================
    //  REMOVE PROBLEM ITEM FROM EHR XML FILE
    // =====================================================
    function removeThisItemOnEhr(mainCategory, patientId) {
      Swal.fire({
        title: 'Are you sure?',
        text: "You want to remove this entry from patient EHR ?",
        icon: 'warning',
        showCancelButton: true,
        confirmButtonColor: '#3085d6',
        cancelButtonColor: '#d33',
        width: '600px',
        confirmButtonText: 'Yes, Remove it!'
      }).then((result) => {
        if (!result.isConfirmed) return;

        const itemId = document.getElementById("problemOfPatient_codeName")?.value || "";

        fetch('remove-problem-item-from-ehr', {
          method: 'POST',
          headers: { 'Content-Type': 'application/json' },
          body: JSON.stringify({
            mainCategory,
            patientId,
            itemId,
            adminName: "${ADMIN_SESSION.firstName} ${ADMIN_SESSION.lastName}",
            adminId: "${ADMIN_SESSION.userId}",
          })
        })
        .then(async (response) => {
          const text = await response.text();
          if (!response.ok) throw new Error(text || `HTTP ${response.status}`);

          await Swal.fire("Updated!", text, "success");

          // 1) Close bootstrap modal
          const modalEl = document.getElementById("problemModel");
          if (modalEl) {
            const modalInstance = bootstrap.Modal.getInstance(modalEl) || bootstrap.Modal.getOrCreateInstance(modalEl);
            modalInstance.hide();
          }

          // 2) Hard cleanup in case backdrop remains
          document.querySelectorAll('.modal-backdrop').forEach(el => el.remove());
          document.body.classList.remove('modal-open');
          document.body.style.removeProperty('padding-right');

          // 3) Reload section
          reloadEhrPageForPatient(patientId);
        })
        .catch(err => {
          console.error(err);
          Swal.fire("Not updated!", err.message, "error");
        });
      });
    }

     // =====================================================
    //  REMOVE ALLERGY ITEM FROM EHR XML FILE
    // =====================================================
    function removeAllergyItemFromEhr(allergyFieldName) {

      const patientId = document.getElementById("userid-update")?.value || "";
      const allergyName = document.getElementById(allergyFieldName)?.value || "";
      Swal.fire({
        title: 'Are you sure?',
        text: "You want to remove this entry from patient EHR ?",
        icon: 'warning',
        showCancelButton: true,
        confirmButtonColor: '#3085d6',
        cancelButtonColor: '#d33',
        width: '600px',
        confirmButtonText: 'Yes, Remove it!'
      }).then((result) => {
        if (!result.isConfirmed) return;

        fetch('remove-allergy-item-from-ehr', {
          method: 'POST',
          headers: { 'Content-Type': 'application/json' },
          body: JSON.stringify({
            patientId,
            allergyName,
            adminName: "${ADMIN_SESSION.firstName} ${ADMIN_SESSION.lastName}",
            adminId: "${ADMIN_SESSION.userId}",
          })
        })
        .then(async (response) => {
          const text = await response.text(); // or await response.json()
          if (!response.ok) throw new Error(text || `HTTP ${response.status}`);
          await Swal.fire("Updated!", text, "success");

        // 1) Close bootstrap modal
        const modalEl = document.getElementById("updateMedicineAllergyModel");
        if (modalEl) {
          const modalInstance = bootstrap.Modal.getInstance(modalEl) || bootstrap.Modal.getOrCreateInstance(modalEl);
          modalInstance.hide();
        }

        const modalEl1 = document.getElementById("updateGeneralAllergyModel");
        if (modalEl1) {
          const modalInstance1 = bootstrap.Modal.getInstance(modalEl1) || bootstrap.Modal.getOrCreateInstance(modalEl1);
          modalInstance1.hide();
        }

          reloadEhrPageForPatient(patientId);
        })
        .catch(err => {
          console.error(err);
          Swal.fire("Not updated!", err.message, "error");
        });
      });
    }


     // =====================================================
    //  REMOVE REPEAT MEDICATION ITEM FROM EHR XML FILE
    // =====================================================
    function removeMedicationItemFromEhr() {
      Swal.fire({
        title: 'Are you sure?',
        text: "You want to remove this entry from patient EHR ?",
        icon: 'warning',
        showCancelButton: true,
        confirmButtonColor: '#3085d6',
        cancelButtonColor: '#d33',
        width: '600px',
        confirmButtonText: 'Yes, Remove it!'
      }).then((result) => {
        if (!result.isConfirmed) return;

        fetch('remove-repeat-medication-item-from-ehr', {
          method: 'POST',
          headers: { 'Content-Type': 'application/json' },
          body: JSON.stringify({
            patientId: document.getElementById("userId").value,
            medicationId:document.getElementById("medicationId").value,
            adminName: "${ADMIN_SESSION.firstName} ${ADMIN_SESSION.lastName}",
            adminId: "${ADMIN_SESSION.userId}",
          })
        })
        .then(async (response) => {
          const text = await response.text(); // or await response.json()
          if (!response.ok) throw new Error(text || `HTTP ${response.status}`);
          await Swal.fire("Updated!", text, "success");

          // 1) Close bootstrap modal
          const modalEl = document.getElementById("prescriptionModel");
          if (modalEl) {
            const modalInstance = bootstrap.Modal.getInstance(modalEl) || bootstrap.Modal.getOrCreateInstance(modalEl);
            modalInstance.hide();
          }
          reloadEhrPageForPatient(document.getElementById("userId").value);
        })
        .catch(err => {
          console.error(err);
          Swal.fire("Not updated!", err.message, "error");
        });
      });
    }




// =====================================================
// LOAD HEALTH PROBLEM DETAIL FROM BACKEND INTO MODAL
// Parameters: mainCategory, patientId, itemId
// =====================================================
async function loadProblemDetailDataFromBackend(mainCategory, patientId, itemId) {
  const problemSelect   = document.getElementById("problemDetail");
  const dateInput       = document.getElementById("DetailDateOfDiagnosis");
  const severitySelect  = document.getElementById("severity");
  const cronicSelect    = document.getElementById("cronic");
  const noteTextarea    = document.getElementById("problemNoteToPatient");
  const patientIdInput  = document.getElementById("patientId");
  const headerLabel     = document.getElementById("headerLabel");
  const saveBtn         = document.getElementById("saveToEhr");
  const problemOfPatient_codeName         = document.getElementById("problemOfPatient_codeName");
  document.getElementById("actionCode").value = "UPDATE"; // Set action code to "update" for this modal
  document.getElementById("problemDetail").disabled = true;

  // Optional UI setup
  if (headerLabel) headerLabel.textContent = mainCategory || "Problem";
  if (patientIdInput) patientIdInput.value = patientId || "";

  try {
    if (saveBtn) saveBtn.disabled = true;
    // Example endpoint (change if your backend URL is different)
    const resp = await fetch('get-patient-ehr-problem-detail', {
      method: "POST",
      headers: { "Accept": "application/json", "Content-Type": "application/json"},
        body: JSON.stringify({
            mainCategory: mainCategory,
            patientId: patientId,
            itemId: itemId
        })
    });

    if (!resp.ok) {
      const errText = await resp.text();
      throw new Error(errText || `HTTP ${resp.status}`);
    }

    const data = await resp.json();
    //alert("Data loaded from backend: " + JSON.stringify(data)); // Debug alert
    problemOfPatient_codeName.value = data.codeName || ""; // Store codeName in hidden input for later use
    loadICDDataProblemListWithSelection(data.codeName); // Load ICD data into select before showing modal select option box

    if (dateInput)      dateInput.value = data.diagnosedDate || "";
    if (severitySelect) severitySelect.value = data.severity || "low";
    if (cronicSelect)   cronicSelect.value = data.isChronic || "No";
    if (noteTextarea)   noteTextarea.value = data.notes || "";

    // Open modal after data is rendered
    const modalElement = document.getElementById("problemModel");
    if (modalElement) {
      const modal = bootstrap.Modal.getOrCreateInstance(modalElement);
      modal.show();
    }

  } catch (err) {
    console.error("Error loading problem detail:", err);
    Swal.fire(
      "Load Failed",
      err?.message || "Could not load problem details from backend.",
      "error"
    );
  } finally {
    if (saveBtn) saveBtn.disabled = false;
  }
}

// =====================================================
// LOAD MEDICINE ALLERGY DATA FROM BACKEND INTO MODAL
// Params: patientId, allergyGroup, allergyName
// =====================================================
async function loadMedicAllergyDataFromBackendToTheModel(patientId, allergyGroup, allergyName) {

  //alert(allergyGroup + " - " + allergyName); // Debug alert to check parameters
  const saveBtn = document.getElementById("saveToEhr");

  // form fields (medicine tab)
  const allergenInput = document.getElementById("allergen-meds-update");
  const reactionInput = document.getElementById("reaction-meds-update");
  const severitySelect = document.getElementById("severity-meds-update");
  const diagnosedDateInput = document.getElementById("diagnosedDate-meds-update");
  const noteTextarea = document.getElementById("note-meds-update");

  // optional hidden/user field
  const userIdInput = document.getElementById("userId");
  if (userIdInput && patientId) userIdInput.value = patientId;

  try {
    if (saveBtn) saveBtn.disabled = true;

    const resp = await fetch("get-patient-ehr-allergy-detail", {
      method: "POST",
      headers: {
        "Accept": "application/json",
        "Content-Type": "application/json"
      },
      body: JSON.stringify({
        patientId: patientId,
        allergyGroup: allergyGroup,
        allergyName: allergyName
      })
    });

    const raw = await resp.text();
    if (!resp.ok) throw new Error(raw || `HTTP ${resp.status}`);

    // safe json parse
    let data = {};
    try {
      data = raw ? JSON.parse(raw) : {};
    } catch (e) {
      throw new Error("Server did not return valid JSON.");
    }

    // render to modal fields
    if (allergenInput) allergenInput.value = data.allergen || allergyName || "";
    if (reactionInput) reactionInput.value = data.reaction || "";
    if (noteTextarea) noteTextarea.value = data.notes || "";
    if (diagnosedDateInput) diagnosedDateInput.value = data.diagnosedDate || "";

    if (severitySelect) {
      const sev = (data.severity || "low").toLowerCase();
      // valid options in your form: low, moderate, high
      severitySelect.value = ["low", "moderate", "high"].includes(sev) ? sev : "low";
    }

    // Open modal after rendering
    const modalElement = document.getElementById("updateMedicineAllergyModel");
    if (modalElement) {
      const modal = bootstrap.Modal.getOrCreateInstance(modalElement);
      modal.show();
    }

  } catch (err) {
    console.error("Error loading allergy detail:", err);
    Swal.fire(
      "Load Failed",
      err?.message || "Could not load allergy details from backend.",
      "error"
    );
  } finally {
    if (saveBtn) saveBtn.disabled = false;
  }
}


// =====================================================
// LOAD GENERAL ALLERGY DATA FROM BACKEND INTO MODAL
// Params: patientId, allergyGroup, allergyName
// =====================================================
async function loadGeneralAllergyDataFromBackendToTheModel(patientId, allergyGroup, allergyName) {

  //alert(allergyGroup + " - " + allergyName); // Debug alert to check parameters
  const saveBtn = document.getElementById("saveToEhr");

  // form fields (medicine tab)
  const allergenInput = document.getElementById("allergen-general-update");
  const reactionInput = document.getElementById("reaction-general-update");
  const severitySelect = document.getElementById("severity-general-update");
  const diagnosedDateInput = document.getElementById("diagnosedDate-general-update");
  const noteTextarea = document.getElementById("note-general-update");

  // optional hidden/user field
  const userIdInput = document.getElementById("userId");
  if (userIdInput && patientId) userIdInput.value = patientId;

  try {
    if (saveBtn) saveBtn.disabled = true;

    const resp = await fetch("get-patient-ehr-allergy-detail", {
      method: "POST",
      headers: {
        "Accept": "application/json",
        "Content-Type": "application/json"
      },
      body: JSON.stringify({
        patientId: patientId,
        allergyGroup: allergyGroup,
        allergyName: allergyName
      })
    });

    const raw = await resp.text();
    if (!resp.ok) throw new Error(raw || `HTTP ${resp.status}`);

    // safe json parse
    let data = {};
    try {
      data = raw ? JSON.parse(raw) : {};
    } catch (e) {
      throw new Error("Server did not return valid JSON.");
    }

    // render to modal fields
    if (allergenInput) allergenInput.value = data.allergen || allergyName || "";
    if (reactionInput) reactionInput.value = data.reaction || "";
    if (noteTextarea) noteTextarea.value = data.notes || "";
    if (diagnosedDateInput) diagnosedDateInput.value = data.diagnosedDate || "";

    if (severitySelect) {
      const sev = (data.severity || "low").toLowerCase();
      // valid options in your form: low, moderate, high
      severitySelect.value = ["low", "moderate", "high"].includes(sev) ? sev : "low";
    }

    // Open modal after rendering
    const modalElement = document.getElementById("updateGeneralAllergyModel");
    if (modalElement) {
      const modal = bootstrap.Modal.getOrCreateInstance(modalElement);
      modal.show();
    }

  } catch (err) {
    console.error("Error loading allergy detail:", err);
    Swal.fire(
      "Load Failed",
      err?.message || "Could not load allergy details from backend.",
      "error"
    );
  } finally {
    if (saveBtn) saveBtn.disabled = false;
  }
}


// =====================================================
// LOAD MEDICATION  DATA FROM BACKEND INTO MODAL
//
// =====================================================
async function loadMedicationDataFromBackendToTheModel(patientId, medicationId) {


  const saveBtn = document.getElementById("saveToEhr");

  // Form fields
  const quantityInput = document.getElementById("quantity");
  const medicationNameInput = document.getElementById("medicationName");
  const dosageInput = document.getElementById("dosage");
  const startFromDateInput = document.getElementById("startFromDate");
  const medicationIdInput = document.getElementById("medicationId");
  document.getElementById("operationMedication").value = "UPDATE"; // Set operation to "update" for this modal

  try {
    if (saveBtn) saveBtn.disabled = true;
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



    // Populate form fields
    if (quantityInput) quantityInput.value = data.quantityPerDispense || "";
    if (medicationNameInput) medicationNameInput.value = data.medicationName || "";
    if (dosageInput) dosageInput.value = data.dosage || "";
    if (startFromDateInput) startFromDateInput.value = data.startDate || "";
    if (medicationIdInput) medicationIdInput.value = data.medicationId || "";

    // Open modal after rendering
    const modalElement = document.getElementById("prescriptionModel");
    if (modalElement) {
      const modal = bootstrap.Modal.getOrCreateInstance(modalElement);
      modal.show();
    }

  } catch (err) {
    console.error("Error loading medication detail:", err);
    Swal.fire(
      "Load Failed",
      err?.message || "Could not load medication details from backend.",
      "error"
    );
  } finally {
    if (saveBtn) saveBtn.disabled = false;
  }
}