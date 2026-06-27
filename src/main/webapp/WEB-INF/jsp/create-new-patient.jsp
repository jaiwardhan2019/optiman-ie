<%@taglib prefix="t" tagdir="/WEB-INF/tags" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
<%@ page contentType="text/html; charset=UTF-8" %>

<t:admin_layout title=" GP Home | Create Patient ">
    <jsp:attribute name="body_area">
      <main id="main" class="main">
        <div class="pagetitle">
          <nav>
            <ol class="breadcrumb">
              <li class="breadcrumb-item">Patients</li>
              <li class="breadcrumb-item"> <a href="patient-list">Patients List </a></li>
              <li class="breadcrumb-item active"> Create Patient </li>
            </ol>
          </nav>
        </div><!-- End Page Title -->

        <section class="section dashboard">
          <div class="row">
            <div class="col-lg-12">
              <div class="card recent-sales overflow-auto">
                <div class="card-body">
                  <div class="row">
                    <div class="col-lg-12">

                      <h5 class="card-title mb-0">
                        <i class="bi bi-person-plus" style="font-size:1.4em;color: #FF1493;"> </i> Create new patient
                      </h5>
                      <!-- Profile Edit Form -->
                      <form name="patientProfile" id="patientProfile" onsubmit="return createNewPatient();">
                        <input type="hidden" name="Sex" id="Sex" value="">
                        <input type="hidden" name="userId" id="userId" value="NA">

                        <!-- First Name | Last Name -->
                        <div class="row mb-3">
                          <div class="col-md-5">
                            <label for="firstName" class="col-form-label fw-bold">
                              <span class="text-danger">*</span> First Name
                            </label>
                            <input name="firstName" id="firstName" type="text" class="form-control"
                              value="" required maxlength="100">
                          </div>
                          <div class="col-md-5">
                            <label for="firstName" class="col-form-label fw-bold">
                              <span class="text-danger">*</span> Last Name
                            </label>
                            <input name="lastName" id="lastName" type="text" class="form-control"
                              value="" required maxlength="100">
                          </div>
                        </div>

                        <!-- Date of Birth | Sex -->
                        <div class="row mb-3">
                          <div class="col-md-5">
                            <label for="firstName" class="col-form-label fw-bold">
                               <span class="text-danger">*</span> Date Of Birth
                            </label>
                            <input type="date" class="form-control" id="birthDate" name="birthDate"
                              value="" required>
                          </div>
                          <div class="col-md-5">
                             <label for="firstName" class="col-form-label fw-bold">
                              <span class="text-danger">*</span> Sex at the time of birth
                            </label>
                            <div>
                              <div class="form-check form-check-inline">
                                <input class="form-check-input" type="radio" name="options" id="option1" value="Male" required>
                                <label class="form-check-label" for="option1">Male</label>
                              </div>
                              <div class="form-check form-check-inline">
                                <input class="form-check-input" type="radio" name="options" id="option2" value="Female">
                                <label class="form-check-label" for="option2">Female</label>
                              </div>
                              <div class="form-check form-check-inline">
                                <input class="form-check-input" type="radio" name="options" id="option3" value="Other">
                                <label class="form-check-label" for="option3">Other</label>
                              </div>
                            </div>
                          </div>
                        </div>

                        <!-- Phone Number | Email Id -->
                        <div class="row mb-3">
                          <div class="col-md-5">
                             <label for="firstName" class="col-form-label fw-bold">
                               <span class="text-danger">*</span> Phone Number
                            </label>
                            <input type="text" class="form-control" name="phoneNumber" id="phoneNumber"
                              value="" required maxlength="20" placeholder="086XXXXXX" />
                          </div>
                          <div class="col-md-5">
                             <label for="firstName" class="col-form-label fw-bold">
                                    <span class="text-danger">*</span> Email Id
                             </label>
                            <input type="text" class="form-control" id="patientEmailId" name="patientEmailId"
                              value="" required maxlength="250" />
                          </div>
                        </div>

                        <!-- Home Address | EIR Code -->
                        <div class="row mb-3">
                          <div class="col-md-5">
                            <label for="firstName" class="col-form-label fw-bold">
                                    <span class="text-danger">*</span> Full Address
                            </label>
                            <input type="text" class="form-control" id="fullAddress" name="fullAddress"
                              placeholder="Full address." value="" required maxlength="250" />
                          </div>
                          <div class="col-md-5">
                               <label for="firstName" class="col-form-label fw-bold">
                                        Eir Code
                               </label>
                            <input type="text" class="form-control" id="eirCode" name="eirCode"
                              placeholder="Eir Code." value="" maxlength="15" />
                          </div>
                        </div>
                        <div class="row mb-3">
                          <div class="col-md-5">
                            <label for="firstName" class="col-form-label fw-bold">
                                    <span class="text-danger">*</span> Patient Type
                            </label>
                              <select class="form-control form-select" id="patientType" name="patientType" required>
                                <option value="Private Patient" selected> Private Patient </option>
                                <option value="Medical Card"> Medical Card  </option>
                                <option value="GP Visit Card"> GP Visit Card  </option>
                                <option value="EU Health Card"> EU Health Card  </option>
                              </select>
                          </div>
                          <div class="col-md-5" style="margin-top: 32px;align-items: center;" align="center">
                             <button type="submit" class="btn btn-info">
                                  <i class="bi bi-person-plus" style="font-size:1.4em;"> </i> Create Patient</button>
                          </div>
                        </div>




                      </form>
                    </div>
                  </div>
                </div><!-- End of card-body -->
              </div>
            </div>
          </div>
        </section>
      </main><!-- End #main -->

      <script>

        function createNewPatient() {

          // Set the Sex value from selected radio button
          getRadioButtonValue();

          Swal.fire({
            title: 'Are you sure?',
            text: "You want to create this patient!",
            icon: 'warning',
            showCancelButton: true,
            confirmButtonColor: '#03c4eb',
            cancelButtonColor: '#d33',
            confirmButtonText: 'Yes, create patient.'
          }).then((result) => {

            if (!result.isConfirmed) return;

            const data = {
              userId: document.getElementById("userId").value,
              firstName: document.getElementById("firstName").value,
              lastName: document.getElementById("lastName").value,
              birthDate: document.getElementById("birthDate").value,
              patientSex: document.getElementById("Sex").value,
              phoneNumber: document.getElementById("phoneNumber").value,
              emailId: document.getElementById("patientEmailId").value,
              fullAddress: document.getElementById("fullAddress").value,
              eirCode: document.getElementById("eirCode").value,
              patientType: document.getElementById("patientType").value
            };

            fetch('create-new-patient-save', {
              method: 'POST',
              headers: { 'Content-Type': 'application/json' },
              body: JSON.stringify(data)
            })
            .then(response => response.text())
            .then(responseData => {

              if (responseData === 'success') {
                // SUCCESS ALERT
                Swal.fire({
                  title: 'Created!',
                  text: 'The patient has been created.',
                  icon: 'success',
                  confirmButtonColor: '#03c4eb'
                }).then(() => window.location.href = "patient-list");

              } else {
                // ANY OTHER RESPONSE = ERROR
                Swal.fire({
                  title: 'Error!',
                  text: responseData || 'There was a problem creating the patient.',
                  icon: 'error',
                  width : '700px',
                  confirmButtonColor: '#d33'
                });
              }

            })
            .catch(error => {
              // NETWORK OR UNEXPECTED ERROR
              Swal.fire({
                title: 'Error!',
                text: error.toString(),
                icon: 'error',
                confirmButtonColor: '#d33'
              });
            });

          });

          return false;
        } // End of createNewPatient function





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
      </script>
    </jsp:attribute>
</t:admin_layout>