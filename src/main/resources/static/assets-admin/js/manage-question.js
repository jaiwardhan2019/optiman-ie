
    //--- OPEN MODEL TO ENTER DATA
    function openModelToEnterData(modelName){

      resetQuestionForm(); // Clear form fields before showing the modal

      //-- Add selected header to the question detail modal so that when user click add question, it will show the correct header in the dropdown
      const dropdown = document.getElementById('questionHeader');
      document.getElementById("illnessId").value = dropdown ? dropdown.value : '';

      const modalElement = document.getElementById(modelName);
      const model_name = new bootstrap.Modal(modalElement);
      model_name.show();
    }



    function closeModelToEnterData(modelName){
     const model_name = new bootstrap.Modal(document.getElementById(modelName));
     model_name.show();
    }


    // FETCH HEADER DATA AND POPULATE THE MODAL FIELDS, THEN SHOW THE MODAL
    async function loadHeaderDataToModel(headerId) {
      if (!headerId) return;

      try {
        const res = await fetch('/health-question-headers/'+headerId, {
          method: 'GET',
          headers: { 'Accept': 'application/json' }
        });
        if (!res.ok) throw new Error(`Failed to load header ${headerId}`);
        const data = await res.json();

        // Map response fields to modal controls
        document.getElementById('headerId').value = data.questionHeaderId ?? '';
        document.getElementById('groupName_c').value = data.qusGroup ?? 'All';
        document.getElementById('mainCategoryName_c').value = data.mainCategory ?? 'Sick Note';
        document.getElementById('illnessName_c').value = data.illnessName ?? '';

        // Show modal (Bootstrap 5)
        const modal = new bootstrap.Modal(document.getElementById('questionModel_c'));
        modal.show();
      } catch (err) {
        Swal.fire("Error", err.message || "Failed to load header data.", "error");
      }
    }


    // REMOVE HEADER DATA WITH CONFIRMATION, THEN REDIRECT
    async function removeHeaderDataToModel() {
      const headerId = document.getElementById("headerId")?.value?.trim();
      if (!headerId) return;

      // Confirm deletion
      const result = await Swal.fire({
        title: "Are you sure?",
        text: "This will permanently delete the header. All associated questions will also be removed. This action cannot be undone.",
        icon: "warning",
        width: "650px",
        showCancelButton: true,
        confirmButtonText: "Yes, delete it",
        cancelButtonText: "Cancel",
        reverseButtons: true,
        focusCancel: true,
      });

      if (!result.isConfirmed) return;

      try {
        const res = await fetch(`/delete-question-header/${headerId}`, {
          method: "DELETE",
          headers: { Accept: "application/json" },
        });

        if (!res.ok) throw new Error(`Failed to delete header ${headerId}`);

        const message = (await res.text()) || "Header deleted successfully.";

        await Swal.fire("Deleted", message, "success");
        window.location.href = "setup-medical-question";
      } catch (err) {
        Swal.fire("Error", err?.message || "Failed to delete header.", "error");
      }
    }


    // REMOVE QUESTION WITH CONFIRMATION, THEN REDIRECT
    async function removeQuestion() {
      const questionId = document.getElementById("questionId")?.value?.trim();
      if (!headerId) return;

      // Confirm deletion
      const result = await Swal.fire({
        title: "Are you sure?",
        text: "This will permanently delete this question All associated form and file will be affected. This action cannot be undone.",
        icon: "warning",
        width: "650px",
        showCancelButton: true,
        confirmButtonText: "Yes, delete it",
        cancelButtonText: "Cancel",
        reverseButtons: true,
        focusCancel: true,
      });

      if (!result.isConfirmed) return;

      try {
        const res = await fetch(`/delete-question/${questionId}`, {
          method: "DELETE",
          headers: { Accept: "application/json" },
        });

        if (!res.ok) throw new Error(`Failed to delete Question ID :  ${questionId}`);

        const message = (await res.text()) || "Header deleted successfully.";

        await Swal.fire("Deleted", message, "success");
        sessionStorage.setItem("showScheduleTab", "1");
        window.location.href = "setup-medical-question?headerId=" + document.getElementById("illnessId").value;
      } catch (err) {
        Swal.fire("Error", err?.message || "Failed to delete header.", "error");
      }
    }



    function saveQuestionHeader() {

      const headerId = document.getElementById("headerId")?.value?.trim();
      const mainCategoryName_c = document.getElementById("mainCategoryName_c")?.value?.trim();
      const illnessName_c = document.getElementById("illnessName_c")?.value?.trim();
      const groupName_c = document.getElementById("groupName_c")?.value; // if needed
      if (!illnessName_c) {
        Swal.fire("Missing Problem", "Illness Name is required.", "warning");
        const illnessInput = document.getElementById("illnessName_c");
        if (illnessInput) illnessInput.focus();
        return;
      }

      const payload = {
        headerId,
        mainCategoryName_c,
        illnessName_c,
        groupName_c
      };

      fetch("/update-question-header", {
        method: "POST",
        headers: {
          "Content-Type": "application/json"
        },
        body: JSON.stringify(payload)
      })
        .then(async (response) => {
          if (!response.ok) {
            const errorText = await response.text();
            throw new Error(errorText || `Failed to save question. Status: ${response.status}`);
          }
          return response.text();
        })
        .then((message) => {
          Swal.fire("Success", message || "New category added successfully.", "success").then(() => {
            document.getElementById("questionForPatient_c")?.reset();
            closeModelToEnterData("questionModel_c");
            // Consider removing the reload if not necessary
            window.location.href = "setup-medical-question";
          });
        })
        .catch((error) => {
          console.error("Error saving question:", error);
          Swal.fire("Error", error.message || "Something went wrong while saving.", "error");
        });
    }





    //** ==== SAVE QUESTION DETAILS WITH VALIDATION AND ERROR HANDLING ==== **//
    function saveQuestionDetail() {

      const selected = document.querySelector('input[name="questionType"]:checked');
      const answerType = selected ? selected.value : ""; // or return
      const questionId = document.getElementById("questionId")?.value?.trim();
      const illnessId = document.getElementById("illnessId")?.value?.trim();
      const questionDisplayOrder = document.getElementById("questionDisplayOrder")?.value?.trim();
      const isMandatory = document.getElementById("isMandatory")?.value?.trim();

      const questionDetail = document.getElementById("questionDetail")?.value?.trim();
      const questionOptions1 = document.getElementById("questionOptions1").value?.trim();
      const requiredOption1 = document.getElementById("requiredOption1").checked;
      const questionOptions2 = document.getElementById("questionOptions2").value?.trim();
      const requiredOption2 = document.getElementById("requiredOption2").checked;
      const questionOptions3 = document.getElementById("questionOptions3").value?.trim();
      const requiredOption3 = document.getElementById("requiredOption3").checked;
      const questionOptions4 = document.getElementById("questionOptions4").value?.trim();
      const requiredOption4 = document.getElementById("requiredOption4").checked;

      if (!illnessId) {
        Swal.fire("Missing Problem", "Illness Name is required.", "warning");
        const illnessInput = document.getElementById("illnessId");
        if (illnessInput) illnessInput.focus();
        return;
      }

        if (!questionDetail) {
          Swal.fire("Missing Problem", "Question Detail is required.", "warning").then(() => {
            const detailInput = document.getElementById("questionDetail");
            if (detailInput) detailInput.focus();
          });
          return;
        }

      const payload = {
        answerType,
        questionId,
        questionDisplayOrder,
        isMandatory,
        illnessId,
        questionDetail,
        questionOptions1,
        requiredOption1,
        questionOptions2,
        requiredOption2,
        questionOptions3,
        requiredOption3,
        questionOptions4,
        requiredOption4
      };

      fetch("/update-question", {
        method: "POST",
        headers: {
          "Content-Type": "application/json"
        },
        body: JSON.stringify(payload)
      })
        .then(async (response) => {
          if (!response.ok) {
            const errorText = await response.text();
            throw new Error(errorText || `Failed to save question. Status: ${response.status}`);
          }
          return response.text();
        })
        .then((message) => {
          Swal.fire("Success", message || "Question added successfully.", "success").then(() => {
            document.getElementById("questionForPatient")?.reset();
            closeModelToEnterData("questionModel");
            // Consider removing the reload if not necessary
            window.location.href = "setup-medical-question?headerId=" + illnessId;
            sessionStorage.setItem("showScheduleTab", "1");
          });
        })
        .catch((error) => {
          console.error("Error saving question:", error);
          Swal.fire("Error", error.message || "Something went wrong while saving.", "error");
        });
    }

    //---- SHOW SCHEDULE TAB AFTER REDIRECTING BACK TO THE PAGE
    document.addEventListener("DOMContentLoaded", () => {
      if (sessionStorage.getItem("showScheduleTab") === "1") {
        const tabEl = document.getElementById("schedule-tab");
        if (tabEl) {
          bootstrap.Tab.getOrCreateInstance(tabEl).show();
        }
        sessionStorage.removeItem("showScheduleTab");
      }
    });




    // Call this after the modal/form is rendered.
    function enforceSingleMustClickCheckbox(containerSelector = '#optionsContainer') {
      const container = document.querySelector(containerSelector);
      if (!container) return;

      const checkboxes = Array.from(
        container.querySelectorAll('input[type="checkbox"][id^="requiredOption"]')
      );

      checkboxes.forEach(cb => {
        cb.addEventListener('change', () => {
          // If the user just checked this box, ensure all others are unchecked.
          if (cb.checked) {
            const alreadyChecked = checkboxes.filter(c => c !== cb && c.checked);
            if (alreadyChecked.length > 0) {
             Swal.fire("Only One Required Option", "Only one option can be marked as required. Please uncheck the other required option first.", "warning");
              cb.checked = false; // revert
              return;
            }
            // Uncheck any stragglers just in case.
            checkboxes.forEach(other => {
              if (other !== cb) other.checked = false;
            });
          }
        });
      });
    }

    // Example: run once the modal content is ready
    document.addEventListener('DOMContentLoaded', () => {
      enforceSingleMustClickCheckbox('#optionsContainer');
    });




    // FETCH HEADER DATA AND POPULATE THE MODAL FIELDS, THEN SHOW THE MODAL
     async function loadQuestionDataToModel(questionId) {
       try {
         const response = await fetch(`/health-question-detail/${questionId}`, {
           method: "GET",
           headers: { "Accept": "application/json" }
         });

         if (!response.ok) {
           if (response.status === 404) {
             alert("Question not found.");
             return;
           }
           throw new Error(`Failed to load question. Status: ${response.status}`);
         }

         const data = await response.json();

         // 1) Hidden question id
         document.getElementById("questionId").value = data.questionId ?? "";

         // 2) Illness dropdown (questionHeaderId -> illnessId select)
         document.getElementById("illnessId").value = data.questionHeaderId ?? "";

         // 3) Question detail textarea
         const detailEl = document.getElementById("questionDetail");
         detailEl.value = data.questionDetail ?? "";
         detailEl.style.height = "auto";
         detailEl.style.height = "160px";

        // 3.1) Question display order and mandatory status
        document.getElementById("questionDisplayOrder").value = data.questionDisplayOrder ?? "";
        document.getElementById("isMandatory").value = data.isMandatory;

         // 4) Question type radio
        if (data.answerType != "TEXT_TYPE" ) {
            const radio = document.querySelector(`input[name="questionType"][value="${data.answerType}"]`);
            if (radio) radio.checked = true;
            toggleOptionsSection(); // Show/hide options based on type
        } else if (data.answerType === "TEXT_TYPE") {
          document.getElementById("questionTypeText").checked = true;
          toggleOptionsSection(); // Show/hide options based on type
        }

         // 5) Fill options (questionOptions1..4 + requiredOption1..4)
         for (let i = 1; i <= 4; i++) {
           const optionInput = document.getElementById("questionOptions"+i);
           const requiredCheckbox = document.getElementById("requiredOption"+i);

           // clear defaults first
           if (optionInput) optionInput.value = "";
           if (requiredCheckbox) requiredCheckbox.checked = false;
           const option = data.options && data.options[i - 1] ? data.options[i - 1] : null;
           //console.log(`Loading option ${i}:`, option);

           //--- Mark check box as checked if optionRequired is true (boolean or string)
           if (option != null) {
               // option.optionText is not null or empty
               document.getElementById("questionOptions"+i).value = option.optionText ?? "";
               if (option.optionRequired === 'true' || option.optionRequired === true) {
                   document.getElementById("requiredOption"+i).checked = true;
               }
           }
         }

         // 7) Open modal
         const modalEl = document.getElementById("questionModel");
         const modal = bootstrap.Modal.getOrCreateInstance(modalEl);
         modal.show();

       } catch (error) {
         console.error("Error loading question detail:", error);
         Swal.fire("Error", error.message || "Unable to load question details. Please try again.", "error");
       }
     }


    //==== ****** SEARCH QUESTION FROM THE LIST ****** ====
    /**
     * Calls GET /setup-medical-question?headerId=... and loads the returned HTML
     * into the Manage Questions tab (#schedule-meeting-tab).
     *
     * Assumptions:
     * - Endpoint returns a full HTML page (ModelAndView). We extract only the tab content.
     * - The returned page contains an element with id="schedule-meeting-tab".
     *
     * Usage:
     *   onQuestionHeaderChange(); // from select onchange
     *   // OR
     *   loadQuestionsByHeaderId("123");
     */

    async function loadQuestionsByHeaderId(headerId) {
      const tabContainer = document.getElementById("schedule-meeting-tab");
      if (!tabContainer) {
        console.error("schedule-meeting-tab not found in DOM");
        return;
      }

      // keep selected header
      const currentSelect = document.getElementById("questionHeader");
      const selectedToKeep = headerId ?? currentSelect?.value ?? "All";

      const url = new URL("setup-medical-question", window.location.origin);
      if (selectedToKeep && selectedToKeep !== "All") {
        url.searchParams.set("headerId", selectedToKeep);
      } else {
        url.searchParams.delete("headerId");
      }

      const previousHtml = tabContainer.innerHTML;
      tabContainer.innerHTML = `<div class="p-3">Loading questions...</div>`;

      try {
        const resp = await fetch(url.toString(), {
          method: "GET",
          headers: { "X-Requested-With": "XMLHttpRequest" }
        });
        if (!resp.ok) throw new Error(`HTTP ${resp.status} calling ${url}`);

        const htmlText = await resp.text();
        const doc = new DOMParser().parseFromString(htmlText, "text/html");
        const newTabContent = doc.getElementById("schedule-meeting-tab");
        if (!newTabContent) {
          throw new Error("Response HTML did not contain #schedule-meeting-tab");
        }

        // replace tab content
        tabContainer.innerHTML = newTabContent.innerHTML;

        // restore dropdown value and event
        const ddl = document.getElementById("questionHeader");
        if (ddl) {
          ddl.value = selectedToKeep;
          const opt = ddl.querySelector(`option[value="${CSS.escape(String(selectedToKeep))}"]`);
          if (opt) opt.selected = true;
        }

        // IMPORTANT: re-bind answer-type radios because DOM was replaced
        bindQuestionTypeEvents();

        // If modal exists and has data-* attributes from server row, hydrate it
        hydrateQuestionFormFromDataset();
      } catch (err) {
        console.error(err);
        tabContainer.innerHTML = previousHtml;
        alert("Failed to load questions. Please try again.");
      }
    }

    /** Rebind radio change handlers after DOM replacement */
    function bindQuestionTypeEvents() {
      const radios = document.querySelectorAll('input[name="questionType"]');
      radios.forEach(r => {
        r.removeEventListener("change", toggleOptionsSection);
        r.addEventListener("change", toggleOptionsSection);
      });
      toggleOptionsSection(); // set initial section state
    }

    /**
     * Optional helper:
     * If your modal/form carries values in data-* attrs, load them into fields.
     * Example supported attrs:
     *   #questionForPatient[data-question-id]
     *   [data-illness-id], [data-question-detail], [data-is-mandatory],
     *   [data-question-display-order], [data-question-type],
     *   [data-question-option-1..4], [data-required-option-1..4]
     */
    function hydrateQuestionFormFromDataset() {
      const form = document.getElementById("questionForPatient");
      if (!form) return;

      const ds = form.dataset;
      if (!Object.keys(ds).length) return; // nothing to load

      setValue("questionId", ds.questionId);
      setValue("illnessId", ds.illnessId);
      setValue("questionDetail", ds.questionDetail);
      setValue("isMandatory", ds.isMandatory);
      setValue("questionDisplayOrder", ds.questionDisplayOrder);

      // select question type radio
      if (ds.questionType) {
        const target = document.querySelector(`input[name="questionType"][value="${CSS.escape(ds.questionType)}"]`);
        if (target) target.checked = true;
      }

      // options + required flags
      for (let i = 1; i <= 4; i++) {
        setValue(`questionOptions${i}`, ds[`questionOption${i}`]);
        setChecked(`requiredOption${i}`, ds[`requiredOption${i}`] === "YES");
      }

      toggleOptionsSection();
    }

    function setValue(id, value) {
      if (value == null) return;
      const el = document.getElementById(id);
      if (el) el.value = value;
    }

    function setChecked(id, checked) {
      const el = document.getElementById(id);
      if (el) el.checked = !!checked;
    }















    function clickSecondTab() {
        const secondTab = document.querySelector('[data-bs-target="#schedule-meeting-tab"]');
        if (secondTab) {
            secondTab.click();
        } else {
            console.error("Second tab not found.");
        }
    }




    function onQuestionHeaderChange() {
      const ddl = document.getElementById("questionHeader");
      const headerId = ddl ? ddl.value : "All";
      loadQuestionsByHeaderId(headerId);


      //-- Update selected header to the question detail modal (if open) so that when user click edit question, it will show the correct header in the dropdown
        const illnessIdInput = document.getElementById("illnessId");
        if (illnessIdInput) {
            illnessIdInput.value = headerId;
        }

    }

    //** ==== DYNAMICALLY SHOW/HIDE OPTIONS SECTION BASED ON QUESTION TYPE ==== **//
    // Show options only for Radio Button / Checkbox types
    function toggleOptionsSection() {
      const selected = document.querySelector('input[name="questionType"]:checked');
      const optionsSection = document.getElementById("optionsSection");
      if (!selected || !optionsSection) return;

      const typesWithOptions = [
        "MULTIPLE_OPTION_RADION_BUTTON",
        "MULTIPLE_OPTION_SELECTION_CHECKBOX"
      ];

      optionsSection.style.display = typesWithOptions.includes(selected.value) ? "block" : "none";
    }

    // bind once when modal/page is ready
    document.addEventListener("DOMContentLoaded", function () {
      const radios = document.querySelectorAll('input[name="questionType"]');
      radios.forEach(r => r.addEventListener("change", toggleOptionsSection));

      // set correct initial state
      toggleOptionsSection();
    });



    function removeOption(button) {
        button.parentElement.remove();
    }

    function autoResize(textarea) {
        alert(textarea.scrollHeight);
        textarea.style.height = 'auto';
        textarea.style.height = textarea.scrollHeight + 'px';
    }

    window.onload = function () {
        toggleOptionsSection();
    }



      function resetQuestionForm() {
        const form = document.getElementById('questionForPatient');

        // 1) Reset all normal form controls to their initial HTML values
        form.reset();

        // 2) Clear hidden field explicitly (form.reset() restores original value, not always blank)
        document.getElementById('questionId').value = '';

        // 3) Set defaults you want after reset
        document.getElementById('isMandatory').value = 'YES';
        document.getElementById('questionDisplayOrder').value = 1;
        document.getElementById('questionTypeMultiple').checked = true;

        // 4) Clear option textboxes and checkboxes explicitly (safe for edit mode)
        for (let i = 1; i <= 4; i++) {
          const opt = document.getElementById('questionOptions' + i);
          const req = document.getElementById('requiredOption' + i);
          if (opt) opt.value = '';
          if (req) req.checked = false;
        }

        // 5) Re-apply show/hide logic for options section
        if (typeof toggleOptionsSection === 'function') {
          toggleOptionsSection();
        }
      }

