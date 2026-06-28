<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
<head>
    <!-- Include CSS files -->
    <link href="assets-admin/css/ehr-viewer.css" rel="stylesheet">
    <link href="assets-admin/css/ehr-compact-viewer.css" rel="stylesheet">
</head>


   <!-- ===========START OF FIRST ACCORDIAN =========== -->
     <div class="accordion" id="accordionExample">
       <div class="accordion-item" style="box-shadow:2px 4px 8px rgba(0, 0, 0, 0.1);">
         <h2 class="accordion-header" id="headingDemo">
           <button class="accordion-button" type="button" data-bs-toggle="collapse" data-bs-target="#collapseDemo" aria-expanded="false" aria-controls="collapseDemo">
             <h5> <i class="bi bi-person-vcard" style="font-size:1.4em;color:#FF1493;"> </i> <b> Update Patient Demography </b> </h5>
           </button>
         </h2>
           <div id="collapseDemo" class="accordion-collapse collapse show" aria-labelledby="headingDemo" data-bs-parent="#accordionExample">
               <div class="accordion-body">

                    <form name="patientProfile" id="patientProfile" method="POST">
                        <input type="hidden" name="Sex" id="Sex" value="<c:out value='${patientDetail.sex}'/>">
                        <input type="hidden" name="userId" id="userId" value="<c:out value='${patientDetail.userId}'/>">
                        <input type="hidden" name="patientFullName" id="patientFullName" value="<c:out value='${patientDetail.getFullName()}'/>">

                        <!-- Row 1: First & Last Name -->
                        <div class="row mb-3">
                          <div class="col-md-4">
                            <label for="firstName" class="col-form-label fw-bold" >First Name</label>
                            <span class="text-danger">*</span>
                            <input name="firstName" id="firstName" type="text" class="form-control"
                                   value="<c:out value='${patientDetail.firstName}'/>" required maxlength="100">
                          </div>
                          <div class="col-md-4">
                            <label for="firstName" class="col-form-label fw-bold" >Last Name</label>
                            <span class="text-danger">*</span>
                            <input name="lastName" id="lastName" type="text" class="form-control"
                                   value="<c:out value='${patientDetail.lastName}'/>" required maxlength="100">
                          </div>

                          <div class="col-md-4">
                            <label for="firstName" class="col-form-label fw-bold" >Date of Birth</label>
                            <span class="text-danger">*</span>
                            <input type="date" class="form-control" id="birthDate" name="birthDate"
                                   value="<c:out value='${patientDetail.getDateOfBirthForForm()}'/>" required>
                          </div>

                        </div>

                        <!-- Row 2: Date of Birth & Sex -->
                        <div class="row mb-3">
                          <div class="col-md-4">
                            <label for="firstName" class="col-form-label fw-bold" >Sex at the time of birth</label>
                            <span class="text-danger">*</span>
                            <div class="form-group">
                              <div class="form-check form-check-inline">
                                <input class="form-check-input" type="radio" name="options" id="option1" value="Male"
                                  <c:if test="${fn:contains(patientDetail.sex, 'Male')}">checked</c:if> required>
                                <label class="form-check-label" for="option1">Male</label>
                              </div>
                              <div class="form-check form-check-inline">
                                <input class="form-check-input" type="radio" name="options" id="option2" value="Female"
                                  <c:if test="${fn:contains(patientDetail.sex, 'Female')}">checked</c:if>>
                                <label class="form-check-label" for="option2">Female</label>
                              </div>
                              <div class="form-check form-check-inline">
                                <input class="form-check-input" type="radio" name="options" id="option3" value="Other"
                                  <c:if test="${fn:contains(patientDetail.sex, 'Other')}">checked</c:if>>
                                <label class="form-check-label" for="option3">Other</label>
                              </div>
                            </div>
                          </div>

                          <div class="col-md-4">
                            <label for="firstName" class="col-form-label fw-bold" >Email Id</label>
                            <span class="text-danger">*</span>
                            <input type="text" class="form-control" id="patientEmailId" name="patientEmailId"
                                   value="<c:out value='${patientDetail.emailId}'/>" required maxlength="100">
                          </div>

                          <div class="col-md-4">
                            <label for="firstName" class="col-form-label fw-bold" >Phone Number</label>
                            <span class="text-danger">*</span>
                            <input type="text" class="form-control" name="phoneNumber" id="phoneNumber"
                                   value="<c:out value='${patientDetail.phoneNumber}'/>" required maxlength="20">
                          </div>

                        </div>

                        <!-- Row 3: Email ,  PPS Number -->
                        <div class="row mb-3">
                          <div class="col-md-3">
                               <label for="phoneNumber" class="col-form-label fw-bold">PPS Number</label>
                               <input type="text" class="form-control" name="ppsNumber" id="ppsNumber" value="<c:out value='${patientDetail.ppsNumber}'/>" required maxlength="20">
                          </div>

                          <!-- Patient Type  -->
                          <div class="col-md-3">
                                  <label for="phoneNumber" class="col-form-label fw-bold">Patient Type </label>
                                  <select class="form-control form-select" id="patientType" name="patientType" required>
                                    <option value="Private Patient" selected> Private Patient </option>
                                    <option value="Medical Card" <c:if test="${fn:contains(patientDetail.accountType, 'Medical Card')}"> selected  </c:if> >  Medical Card  </option>
                                    <option value="GP Visit Card" <c:if test="${fn:contains(patientDetail.accountType, 'GP Visit Card')}"> selected  </c:if> > GP Visit Card  </option>
                                    <option value="EU Health Card" <c:if test="${fn:contains(patientDetail.accountType, 'EU Health Card')}"> selected  </c:if> > EU Health Card  </option>
                                  </select>
                          </div>

                          <!-- Medical / GP Visit / EU Card  -->
                          <div class="col-md-3">
                            <label for="medicalCardNumber" class="col-form-label fw-bold">Medical Card / GSM Number </label>
                            <input type="text" class="form-control" id="gismNumber" name="gismNumber"
                                   value="<c:out value='${patientDetail.gismNumber}'/>" maxlength="30">
                          </div>

                          <!-- Medical / GP Visit / EU Card  -->
                          <div class="col-md-3">
                            <label for="firstName" class="col-form-label fw-bold" >GP Visit Card </label>
                            <input type="text" class="form-control" id="gpVisitCard" name="gpVisitCard"
                                   value="<c:out value='${patientDetail.gpVisitCard}'/>" maxlength="30">
                          </div>


                        </div>

                        <!-- Row 4: Address & EIR Code -->
                        <div class="row mb-3">
                          <div class="col-md-6">
                            <label for="firstName" class="col-form-label fw-bold" >Home Address</label>
                            <input type="text" class="form-control" id="fullAddress" name="fullAddress"
                                   placeholder="Full address." value="<c:out value='${patientDetail.fullAddress}'/>"
                                   required maxlength="250">
                          </div>

                          <div class="col-md-3">
                            <label for="firstName" class="col-form-label fw-bold" >EIR - Code</label>
                            <input type="text" class="form-control" id="eirCode" name="eirCode"
                                   placeholder="Eir Code."
                                   value="<c:out value='${patientDetail.eirCode}'/>"
                                   required maxlength="15">
                          </div>

                          <div class="col-md-3">
                            <label for="activeStatus" class="form-label" style="color:blue;"><b>Active Status</b></label>
                            <select class="form-select" id="userIsActive" name="userIsActive" required>
                              <option value="true" <c:if test="${patientDetail.userIsActive}">selected</c:if>>Active</option>
                              <option value="false" <c:if test="${not patientDetail.userIsActive}">selected</c:if>> Disable </option>
                            </select>
                          </div>

                        </div>

                        <div class="text-center">
                          <button type="button" class="btn btn-primary" onclick="updatePatientDetail();"> <i class="bi bi-database"> </i> Update </button>
                        </div>
                      </form>

               </div>
           </div>
       </div>
     </div>
   <!-- ===========END OF FIRST ACCORDIAN =========== -->
   <br>



<br>
<hr>



<!-- MODAL STRUCTURE FOR ADDING NEW PROBLEM    -->
<form name="problemOfPatient" id="problemOfPatient">
  <input type="hidden" name="patientId" id="patientId" value="${patientEhr.patientDetail.patientId}">
  <input type="hidden" name="problemOfPatient_codeName" id="problemOfPatient_codeName" value="">
  <input type="hidden" name="actionCode" id="actionCode" value="ADD">
  <div class="modal fade" id="problemModel" aria-labelledby="problemModel" aria-hidden="true">
    <div class="modal-dialog modal-dialog-centered" style="max-width:1000px;max-height:100px;">
      <div class="modal-content">
        <div class="modal-header">
          <h5 class="modal-title"><strong><i class="bi  bi-heart-pulse" style="font-size:1.4em;color: #FF1493;"></i> Add <span id="headerLabel"> </span></strong></h5>
          <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
        </div>

        <div class="modal-body" id="modelBodyContent" align="left">
          <div class="row text-start">
            <div class="card border-0">
              <div class="card-body">

                <div class="row" style="margin-top:15px;">
                  <div class="col-lg-4 col-md-6" style="text-align:left;">
                     <label class="text-primary mb-1"><strong>Select Problem </strong></label>
                     <select class="form-control form-select" id="problemDetail" name="problemDetail" onChange="loadProblemDetail();">
                       <option value="All">--- Select ---</option>
                    </select>
                  </div>

                    <div class="col-lg-3 col-md-6" style="text-align:left;">
                        <label class="text-primary mb-1"><strong>Date of Diagnosis </strong></label>
                        <input type="date" class="form-control" id="DetailDateOfDiagnosis" name="DetailDateOfDiagnosis" >
                    </div>

                    <div class="col-lg-3 col-md-6" style="text-align:left;">
                        <label class="text-primary mb-1"><strong> Severity </strong></label>
                        <select class="form-control form-select" id="severity" name="severity">
                             <option value="low"> LOW </option>
                             <option value="Moderate">MODERATE</option>
                             <option value="High">HIGH</option>
                        </select>
                    </div>

                    <div class="col-lg-2 col-md-6" style="text-align:left;">
                        <label class="text-primary mb-1"><strong> Is Cronic  </strong></label>
                        <select class="form-control form-select" id="cronic" name="cronic">
                             <option value="No"> No </option>
                             <option value="Yes"> Yes</option>
                        </select>
                    </div>

                </div>

                <div class="row" style="margin-top:15px;">
                    <div class="col-12">
                        <label class="text-primary mb-1"><strong> Comment /  Note</strong></label>
                        <textarea oninput="autoResize(this)"
                                  style="box-shadow:2px 4px 8px rgba(0,0,0,0.1);"
                                  class="form-control"
                                  id="problemNoteToPatient"
                                  name="problemNoteToPatient"
                                  rows="5"></textarea>
                    </div>
                </div>

              </div> <!-- End of card body -->
            </div> <!-- End of card -->
          </div> <!-- End of row -->
        </div>

        <div class="modal-footer" align="center">
          <button type="button" id="closeModelButton" name="closeModelButton" class="btn btn-warning" data-bs-dismiss="modal">
            <i class="fa fa-times" aria-hidden="true"></i> Cancel
          </button>
          &nbsp; &nbsp;
          <button type="button" id="saveToEhr" class="btn btn-danger" onClick="removeThisItemOnEhr('MedicalCondition','${patientEhr.patientDetail.patientId}');">
                <i class="bi bi-trash"  title="Remove this entry"> </i> Delete
          </button>
          &nbsp; &nbsp;
          <button type="button" id="saveToEhr" class="btn btn-info" onClick="saveProblemDetailDataToPatientEhr();">
            <i class="bi bi-database"></i> Save
          </button>
        </div>
      </div>
    </div>
  </div>
</form>
<!-- END OF MODAL STRUCTURE FOR ADDING NEW PROBLEM  -->


<!-- MODAL STRUCTURE FOR ADDING ALLERGIES -->
<form name="allergyOfPatient" id="allergyOfPatient">
  <input type="hidden" name="userId" id="userId" value="${patientEhr.patientDetail.patientId}">
  <div class="modal fade" id="allergyModel" aria-labelledby="manageDataOfEhr" aria-hidden="true">
    <div class="modal-dialog modal-dialog-centered" style="max-width:1000px;">
      <div class="modal-content">
        <div class="modal-header">
          <h5 class="modal-title">
            <strong>
              <i class="bi bi-lungs" style="font-size:1.4em;color: #FF1493;"></i>
              Add <span id="headerLabel"> Allergies & Intolerances </span>
            </strong>
          </h5>
          <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
        </div>

        <div class="modal-body" id="modelBodyContent" align="left">
          <ul class="nav nav-tabs" id="allergyTabs" role="tablist">
            <li class="nav-item" role="presentation">
              <button class="nav-link active" id="medicine-tab" data-bs-toggle="tab" data-bs-target="#medicine-pane" type="button" role="tab" aria-controls="medicine-pane" aria-selected="true">
                <i class="bi bi-capsule-pill" style="font-size:1.2em;color: #FF1493;"></i> <b>Medicine Allergy</b>
              </button>
            </li>
            <li class="nav-item" role="presentation">
              <button class="nav-link" id="general-tab" data-bs-toggle="tab" data-bs-target="#general-pane" type="button" role="tab" aria-controls="general-pane" aria-selected="false">
                <i class="bi bi-lungs" style="font-size:1.2em;color: #FF1493;"></i><b> General Allergy </b>
              </button>
            </li>
          </ul>

          <div class="tab-content pt-3">
            <!-- Medicine Tab -->
            <div class="tab-pane fade show active" id="medicine-pane" role="tabpanel" aria-labelledby="medicine-tab">
              <div class="row gy-3">
                <div class="col-lg-4 col-md-6">
                  <label class="text-primary mb-1"><strong>Medicine Name</strong></label>
                  <input type="text" class="form-control" id="allergen-meds" name="allergen-meds" placeholder="e.g., Amoxicillin">
                </div>

                <div class="col-lg-4 col-md-6">
                  <label class="text-primary mb-1"><strong>Reaction</strong></label>
                  <input type="text" class="form-control" id="reaction-meds" name="reaction-meds" placeholder="e.g., Rash, swelling">
                </div>

                <div class="col-lg-2 col-md-4">
                  <label class="text-primary mb-1"><strong>Severity</strong></label>
                  <select class="form-control form-select" id="severity-meds" name="severity-meds">
                    <option value="low">LOW</option>
                    <option value="moderate">MODERATE</option>
                    <option value="high">HIGH</option>
                  </select>
                </div>

                <div class="col-lg-2 col-md-4">
                  <label class="text-primary mb-1"><strong>Since Date</strong></label>
                  <input type="date" class="form-control" id="diagnosedDate-meds" name="diagnosedDate-meds">
                </div>

                <div class="col-12">
                  <label class="text-primary mb-1"><strong>Comment / Note</strong></label>
                  <textarea oninput="autoResize(this)" class="form-control" id="note-meds" name="note-meds" rows="4" style="box-shadow:2px 4px 8px rgba(0,0,0,0.1);"></textarea>
                </div>
              </div>
            </div>

            <!-- General Tab -->
            <div class="tab-pane fade" id="general-pane" role="tabpanel" aria-labelledby="general-tab">
              <div class="row gy-3">
                <div class="col-lg-4 col-md-6">
                  <label class="text-primary mb-1"><strong>Select Allergies from list</strong></label>
                  <select class="form-control form-select" id="allergen-general" name="allergen-general">
                    <option value="">--- Select ---</option>
                    <option value="Peanuts">Peanuts</option>
                    <option value="Hay Fever">Hay Fever</option>
                    <option value="Dust Mites">Dust Mites</option>
                    <option value="Milk">Milk</option>
                    <option value="Egg">Egg</option>
                    <option value="Fish">Fish</option>
                    <option value="Shellfish">Shellfish</option>
                    <option value="Tree Nuts">Tree Nuts</option>
                    <option value="Wheat">Wheat</option>
                    <option value="Soy">Soy</option>
                    <option value="Insect Stings">Insect Stings</option>
                    <option value="Latex">Latex</option>
                    <option value="Pet Dander">Pet Dander</option>
                    <option value="Mold">Mold</option>
                  </select>
                </div>

                <div class="col-lg-4 col-md-6">
                  <label class="text-primary mb-1"><strong>Reaction</strong></label>
                  <input type="text" class="form-control" id="reaction-general" name="reaction-general" placeholder="e.g., Rash, swelling">
                </div>

                <div class="col-lg-2 col-md-4">
                  <label class="text-primary mb-1"><strong>Severity</strong></label>
                  <select class="form-control form-select" id="severity-general" name="severity-general">
                    <option value="low">LOW</option>
                    <option value="moderate">MODERATE</option>
                    <option value="high">HIGH</option>
                  </select>
                </div>

                <div class="col-lg-2 col-md-4">
                  <label class="text-primary mb-1"><strong>Since Date</strong></label>
                  <input type="date" class="form-control" id="diagnosedDate-general" name="diagnosedDate-general">
                </div>

                <div class="col-12">
                  <label class="text-primary mb-1"><strong>Comment / Note</strong></label>
                  <textarea oninput="autoResize(this)" class="form-control" id="note-general" name="note-general" rows="4" style="box-shadow:2px 4px 8px rgba(0,0,0,0.1);"></textarea>
                </div>
              </div>
            </div> <!-- End General Tab -->
          </div>
        </div>

        <div class="modal-footer" align="center">
          <div class="row gy-3">
            <div class="col-12" align="center" style="margin-top:35px;">
              <button type="button" id="closeModelButton" name="closeModelButton" class="btn btn-danger" data-bs-dismiss="modal">
                <i class="fa fa-times" aria-hidden="true"></i> Cancel
              </button>
              &nbsp; &nbsp;
              <button type="button" id="saveToEhr" class="btn btn-info" onClick="saveAllergyDetailToPatientEhr();">
                <i class="bi bi-database"></i> Save
              </button>
            </div>
          </div>
        </div>

      </div>
    </div>
  </div>
</form>
<!-- END OF MODAL STRUCTURE FOR ADDING NEW ALLERGY  -->

<!-- MODAL STRUCTURE FOR UPDATE MEDICINE ALLERGY  -->
<form name="updateAllergyOfPatient" id="updateAllergyOfPatient">
  <input type="hidden" name="userid-update" id="userid-update" value="${patientEhr.patientDetail.patientId}">
  <div class="modal fade" id="updateMedicineAllergyModel" aria-labelledby="manageDataOfEhr" aria-hidden="true">
    <div class="modal-dialog modal-dialog-centered" style="max-width:1000px;">
      <div class="modal-content">
        <div class="modal-header">
          <h5 class="modal-title">
            <strong>
              <i class="bi bi-lungs" style="font-size:1.4em;color: #FF1493;"></i>
              Update <span id="headerLabel"> Allergies & Intolerances </span>
            </strong>
          </h5>
          <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
        </div>

        <div class="modal-body" id="modelBodyContent" align="left">
          <ul class="nav nav-tabs" id="allergyTabs" role="tablist">
            <li class="nav-item" role="presentation">
              <button class="nav-link active" id="medicine-tab" data-bs-toggle="tab" data-bs-target="#medicine-pane" type="button" role="tab" aria-controls="medicine-pane" aria-selected="true">
                <i class="bi bi-capsule-pill" style="font-size:1.2em;color: #FF1493;"></i> <b>Medicine Allergy</b>
              </button>
            </li>
          </ul>

          <div class="tab-content pt-3">
            <!-- Medicine Tab -->
            <div class="tab-pane fade show active" id="medicine-pane" role="tabpanel" aria-labelledby="medicine-tab">
              <div class="row gy-3">
                <div class="col-lg-4 col-md-6">
                  <label class="text-primary mb-1"><strong>Medicine Name</strong></label>
                  <input type="text" class="form-control" id="allergen-meds-update" name="allergen-meds-update" readonly>
                </div>

                <div class="col-lg-4 col-md-6">
                  <label class="text-primary mb-1"><strong>Reaction</strong></label>
                  <input type="text" class="form-control" id="reaction-meds-update" name="reaction-meds-update" placeholder="e.g., Rash, swelling">
                </div>

                <div class="col-lg-2 col-md-4">
                  <label class="text-primary mb-1"><strong>Severity</strong></label>
                  <select class="form-control form-select" id="severity-meds-update" name="severity-meds-update">
                    <option value="low">LOW</option>
                    <option value="moderate">MODERATE</option>
                    <option value="high">HIGH</option>
                  </select>
                </div>

                <div class="col-lg-2 col-md-4">
                  <label class="text-primary mb-1"><strong>Since Date</strong></label>
                  <input type="date" class="form-control" id="diagnosedDate-meds-update" name="diagnosedDate-meds-update">
                </div>

                <div class="col-12">
                  <label class="text-primary mb-1"><strong>Comment / Note</strong></label>
                  <textarea oninput="autoResize(this)" class="form-control" id="note-meds-update" name="note-meds-update" rows="4" style="box-shadow:2px 4px 8px rgba(0,0,0,0.1);"></textarea>
                </div>
              </div>
            </div> <!-- End of Medicine Tab -->

            </div>
        </div>

        <div class="modal-footer" align="center">
          <div class="row gy-3">
            <div class="col-12" align="center" style="margin-top:35px;">
              <button type="button" id="closeModelButton" name="closeModelButton" class="btn btn-warning" data-bs-dismiss="modal">
                <i class="fa fa-times" aria-hidden="true"></i> Cancel
              </button>
              &nbsp; &nbsp;
              <button type="button" id="saveToEhr" class="btn btn-danger" onClick="removeAllergyItemFromEhr('allergen-meds-update');">
                    <i class="bi bi-trash"  title="Remove this entry"> </i> Delete
              </button>
              &nbsp; &nbsp;
              <button type="button" id="saveToEhr" class="btn btn-info" onClick="updateMedicineAllergyDetailToPatientEhr();">
                <i class="bi bi-database"></i> Update
              </button>
            </div>
          </div>
        </div>

      </div>
    </div>
  </div>
</form>
<!-- END OF MODAL STRUCTURE FOR UPDATE MEDICINE ALLERGY  -->



<!-- MODAL STRUCTURE FOR GENERAL ALLERGIES -->
<form name="allergyOfPatient" id="allergyOfPatient">
  <input type="hidden" name="userId" id="userId" value="${patientEhr.patientDetail.patientId}">
  <div class="modal fade" id="updateGeneralAllergyModel" aria-labelledby="manageDataOfEhr" aria-hidden="true">
    <div class="modal-dialog modal-dialog-centered" style="max-width:1000px;">
      <div class="modal-content">
        <div class="modal-header">
          <h5 class="modal-title">
            <strong>
              <i class="bi bi-lungs" style="font-size:1.4em;color: #FF1493;"></i>
              Update <span id="headerLabel"> Allergies & Intolerances </span>
            </strong>
          </h5>
          <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
        </div>

        <div class="modal-body" id="modelBodyContent" align="left">
          <ul class="nav nav-tabs" id="allergyTabs" role="tablist">
            <li class="nav-item" role="presentation">
              <button class="nav-link active"
                      id="general-tab"
                      data-bs-toggle="tab"
                      data-bs-target="#general-pane"
                      type="button"
                      role="tab"
                      aria-controls="general-pane"
                      aria-selected="true">
                <i class="bi bi-lungs" style="font-size:1.2em;color: #FF1493;"></i><b> General Allergy </b>
              </button>
            </li>
          </ul>

          <div class="tab-content pt-3">
            <!-- General Tab -->
            <div class="tab-pane fade show active"
                 id="general-pane"
                 role="tabpanel"
                 aria-labelledby="general-tab">
              <div class="row gy-3">

                <div class="col-lg-4 col-md-6">
                  <label class="text-primary mb-1"><strong>Selected Allergies </strong></label>
                   <input type="text" class="form-control" id="allergen-general-update" name="allergen-general-update" readonly>
                </div>

                <div class="col-lg-4 col-md-6">
                  <label class="text-primary mb-1"><strong>Reaction</strong></label>
                  <input type="text" class="form-control" id="reaction-general-update" name="reaction-general-update" placeholder="e.g., Rash, swelling">
                </div>

                <div class="col-lg-2 col-md-4">
                  <label class="text-primary mb-1"><strong>Severity</strong></label>
                  <select class="form-control form-select" id="severity-general-update" name="severity-general-update">
                    <option value="low">LOW</option>
                    <option value="moderate">MODERATE</option>
                    <option value="high">HIGH</option>
                  </select>
                </div>

                <div class="col-lg-2 col-md-4">
                  <label class="text-primary mb-1"><strong>Since Date</strong></label>
                  <input type="date" class="form-control" id="diagnosedDate-general-update" name="diagnosedDate-general-update">
                </div>

                <div class="col-12">
                  <label class="text-primary mb-1"><strong>Comment / Note</strong></label>
                  <textarea oninput="autoResize(this)" class="form-control" id="note-general-update" name="note-general-update" rows="4" style="box-shadow:2px 4px 8px rgba(0,0,0,0.1);"></textarea>
                </div>
              </div>
            </div>
            <!-- End General Tab -->
          </div>
        </div>

        <div class="modal-footer" align="center">
          <button type="button" id="closeModelButton" name="closeModelButton" class="btn btn-warning" data-bs-dismiss="modal">
            <i class="fa fa-times" aria-hidden="true"></i> Cancel
          </button>
          &nbsp; &nbsp;
            <button type="button" id="saveToEhr" class="btn btn-danger" onClick="removeAllergyItemFromEhr('allergen-general-update');">
                  <i class="bi bi-trash"  title="Remove this entry"> </i> Delete
            </button>
          &nbsp; &nbsp;
          <button type="button" id="saveToEhr" class="btn btn-info" onClick="updateGeneralAllergyDetailToPatientEhr();">
            <i class="bi bi-database"></i> Save
          </button>
        </div>

      </div>
    </div>
  </div>
</form>
<!-- END OF MODAL STRUCTURE FOR UPDATE GENERAL ALLERGY -->


<!-- MODAL STRUCTURE FOR REPEAT PRESCRIPTION -->
<form name="repeatePrescriptionOfPatient" id="repeatePrescriptionOfPatient">
  <input type="hidden" name="userId" id="userId" value="${patientEhr.patientDetail.patientId}">
  <input type="hidden" name="medicationId" id="medicationId" value="">
  <input type="hidden" name="operationMedication" id="operationMedication" value="ADD">
  <div class="modal fade" id="prescriptionModel" aria-labelledby="prescriptionModel" aria-hidden="true">
    <div class="modal-dialog modal-dialog-centered" style="max-width:1000px;">
      <div class="modal-content">
        <div class="modal-header">
          <h5 class="modal-title">
            <strong>
              <i class="bi bi-capsule-pill" style="font-size:1.4em;color: #FF1493;"></i>
              Update <span id="headerLabel"> Repeat Medications </span>
            </strong>
          </h5>
          <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
        </div>

        <div class="modal-body" id="modelBodyContent" align="left">
          <div class="row gy-3">
            <div class="col-lg-2 col-md-6">
              <label class="text-primary mb-1"><strong>Qty </strong></label>
              <input type="text" class="form-control" id="quantity" name="quantity" placeholder="e.g., 30">
            </div>

            <div class="col-lg-5 col-md-6 position-relative">
              <label class="text-primary mb-1"><strong>Prescription </strong></label>
              <input type="text" class="form-control" id="medicationName" name="medicationName" placeholder="e.g., Amoxicillin" autocomplete="off">
              <div id="medicationSuggestions" class="autocomplete-list"></div>
              <input type="hidden" id="medicationId" name="medicationId">
            </div>

            <div class="col-lg-2 col-md-4">
              <label class="text-primary mb-1"><strong> Dosage </strong></label>
              <input type="text" class="form-control" id="dosage" name="dosage" placeholder="1 tab daily ">
            </div>

            <div class="col-lg-2 col-md-4">
              <label class="text-primary mb-1"><strong> Start From Date </strong></label>
              <input type="date" class="form-control" id="startFromDate" name="startFromDate">
            </div>
          </div>
        </div>

        <div class="modal-footer" align="center">
          <div class="row gy-3">
            <div class="col-12" align="center" style="margin-top:35px;">
              <button type="button" id="closeModelButton" name="closeModelButton" class="btn btn-warning" data-bs-dismiss="modal">
                <i class="fa fa-times" aria-hidden="true"></i> Cancel
              </button>
            &nbsp; &nbsp;
              <button type="button" id="saveToEhr" class="btn btn-danger" onclick="removeMedicationItemFromEhr();">
                    <i class="bi bi-trash"  title="Remove this entry"> </i> Delete
              </button>
              &nbsp; &nbsp;
              <button type="button" id="saveToEhr" class="btn btn-info" onClick="saveRepeatMedicationToEhr();">
                <i class="bi bi-database"></i> Save
              </button>
            </div>
          </div>
        </div>
      </div>
    </div>
  </div>
</form>

<style>

    /* Simple error highlighting */
    .field-error {
        border: 1px solid red !important;
    }

    /* Wrap your sex radio group in a container with this class */
    .sex-group-error {
        border: 1px solid red;
        padding: 8px;
        border-radius: 4px;
    }


        #medicationSuggestions {
            border: 1px solid #ccc;
            max-height: 380px;
            overflow-y: auto;
            position: absolute;
            background-color: white;
            width: 100%;
            z-index: 1000;
            top: 100%;
            left: 0;
            display: none;
        }
        #medicationSuggestions div {
            padding: 8px;
            cursor: pointer;
        }
        #medicationSuggestions div:hover {
            background-color: #ddd;
        }
</style>


<!-- In head, with defer -->
<script src="assets-admin/js/manage-ehr.js?v=105" defer></script>



<script>

  const items = ${medicationList}; // e.g.,
  const searchInput = document.getElementById("medicationName");
  const suggestionsBox = document.getElementById("medicationSuggestions");

      searchInput.addEventListener("input", function () {
        const tokens = this.value
          .toLowerCase()
          .trim()
          .split(/\s+/)
          .filter(Boolean); // remove empty tokens

        suggestionsBox.innerHTML = "";

        if (tokens.length === 0) {
          suggestionsBox.style.display = "none";
          return;
        }

        const filteredItems = items.filter((raw) => {
          const item = raw.toLowerCase();
          return tokens.every((t) => item.includes(t)); // AND match on all words
        });

        if (filteredItems.length === 0) {
          suggestionsBox.style.display = "none";
          return;
        }

        filteredItems.forEach((item) => {
          const div = document.createElement("div");
          // Use textContent to avoid HTML injection and to handle &nbsp; automatically
          div.textContent = item.replace(/&nbsp;/g, " ");
          div.addEventListener("click", function () {
            searchInput.value = div.textContent;
            suggestionsBox.style.display = "none";
          });
          suggestionsBox.appendChild(div);
        });

        suggestionsBox.style.display = "block";
      });

      // Hide suggestions if clicked outside
      document.addEventListener("click", function (event) {
        if (event.target !== searchInput) {
          suggestionsBox.style.display = "none";
        }
      });




    // =====================================================
    // OPEN ALL TYPE OF  MODEL TO ADD NEW ENTRY IN
    // =====================================================
    window.openDataEntryModel = function (modelName, patientId, labelDetail) {

        //-- Load ICD data for problem list when opening the problem modal
        if(modelName == 'problemModel'){
            // Load ICD data for problem list when opening the problem modal
            loadICDDataProblemList();
            //--- If disable from previous cal enable it when open the model again
            document.getElementById("problemDetail").disabled = false;
            // assign currect date to date field
            preselectCurrentDate('DetailDateOfDiagnosis');
        }

        //-- Load ICD data for problem list when opening the problem modal
        if(modelName == 'allergyModel'){
            // assign currect date to date field
             preselectCurrentDate('diagnosedDate-general');
             preselectCurrentDate('diagnosedDate-meds');
        }

        //-- Update Allergy Model
        if(modelName == 'updateMedicineAllergyModel'){
           // TODO
        }

        //-- Load prescriptionModel modal date field
        if(modelName == 'prescriptionModel'){
            const form = document.getElementById('repeatePrescriptionOfPatient');
            form.reset();
            // assign current date to date field
             preselectCurrentDate('startFromDate');
        }

        // Set the patientId in the hidden input field
         const model_name = new bootstrap.Modal(document.getElementById(modelName));
         document.getElementById('headerLabel').innerHTML = labelDetail;
         model_name.show();
    }



    function preselectCurrentDate(dateFieldName) {
        const dateInput = document.getElementById(dateFieldName);
        if (!dateInput) return;
        const today = new Date().toISOString().split('T')[0]; // YYYY-MM-DD in local time
        dateInput.value = today;  // preselect today
    }


</script>

