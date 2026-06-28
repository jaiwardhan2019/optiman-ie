<%@taglib prefix="t" tagdir="/WEB-INF/tags" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
<%@ page contentType="text/html; charset=UTF-8" %>
<t:admin_layout title=" GP Home | Patient Detail">
    <jsp:attribute name="body_area">

  <main id="main" class="main">

    <div class="pagetitle">

      <nav>
        <ol class="breadcrumb">
          <li class="breadcrumb-item"><a href="admin-dashboard"> Dashboard  </a>  </li>
          <li class="breadcrumb-item"> <a href="patient-list"> Patient </a></li>
          <li class="breadcrumb-item active"> Patient Profile</li>
          <li style="margin-left:500px">
             <span style="color: #00008B;"><a href="Javascript:void();" onClick="viewPatientProfile('<c:out value='${patientDetail.userId}'/>');"><i class="bi bi-arrow-repeat" style="font-size:1.3em;"> </i>  Refresh Screen </a></span>
          </li>
        </ol>
      </nav>

    </div><!-- End Page Title -->


    <section class="section profile">
      <div class="row">

        <div class="col-xl-12">

          <div class="card">

            <div class="card-body pt-3">
              <!-- Bordered Tabs -->
                    <ul class="nav nav-tabs nav-tabs-bordered" role="tablist">
                      <li class="nav-item me-4" role="presentation">
                        <button style="color:#B504CD;" class="nav-link active" data-bs-toggle="tab" data-bs-target="#profile-overview" aria-selected="false" type="button" role="tab">
                           <i class="bi bi-file-medical" style="font-size:1.2em;"></i> View Profile
                        </button>
                      </li>

                      <li class="nav-item me-4" role="presentation">
                        <button style="color:#1447E6;" class="nav-link" data-bs-toggle="tab" data-bs-target="#profile-edit" style="color:#1244C4;" aria-selected="false" type="button" role="tab">
                          <i class="bi bi-pencil-square" style="font-size:1.2em;"></i> Update Profile
                        </button>
                      </li>

                      <li class="nav-item me-4" role="presentation">
                        <button class="nav-link" data-bs-toggle="tab" data-bs-target="#action-plan" style="color:#C7322E;" aria-selected="true" type="button" role="tab">
                          <i class="fa-solid fa-user-doctor" style="font-size:1.2em;"></i> Action Items
                        </button>
                      </li>

                    </ul>
              <!-- End of Bordered Tabs -->



             <!-- =========================== -->
             <!-- START OF PROFILE OVERVIEW TAB -->
             <!-- =========================== -->
              <div class="tab-content pt-2">
                <div class="tab-pane fade  profile-overview  show active" id="profile-overview">
                  <h5 class="card-title">Demography</h5>
                  <div class="row">
                    <div class="col-lg-2 col-md-4 label">Summary </div>
                    <div class="col-lg-6 col-md-10">
                        <c:out value='${patientDetail.getFullName()}'/> ,
                        <c:out value='${patientDetail.sex}'/>,
                        <c:out value='${patientDetail.getDateOfBirthFormatted()}'/>,
                        <b><c:out value='${patientDetail.getAge()}'/></b>
                    </div>

                  </div>

                  <div class="row">
                    <div class="col-lg-2 col-md-4 label">Address</div>
                    <div class="col-lg-9 col-md-8"><c:out value='${patientDetail.fullAddress}'/> , <c:out value='${patientDetail.eirCode}'/> </div>
                  </div>

                  <div class="row">
                    <div class="col-lg-2 col-md-4 label">Contact detail  </div>
                    <div class="col-lg-3"  id="phoneNumber_1"><c:out value='${patientDetail.phoneNumber}'/></div>
                    <div  class="col-lg-2" id="copyDivPhone"> <a href="Javascript:void(0);" onclick="copyPhoneNumberToClipBoard()"> <i class="bi bi-copy"></i> Copy Phone </a></div>
                    <div  class="col-lg-3" id="emailId"> <c:out value='${patientDetail.emailId}'/> </div>
                    <div  class="col-lg-2" id="copyDiv"> <a href="Javascript:void(0);" onclick="copyEmailToClipBoard()"> <i class="bi bi-copy"></i> Copy email </a></div>
                  </div>

                  <div class="row">
                    <div class="col-lg-2 col-md-4 label">PPS Number   </div>
                    <div class="col-lg-3"  id="phoneNumber_1"><c:out value='${patientDetail.ppsNumber}'/></div>

                    <c:if test="${not empty patientDetail.gismNumber}">
                      <div class="col-lg-4 col-md-4 label">Medical Card Number (GMS)</div>
                      <div class="col-lg-3" id="emailId"><c:out value="${patientDetail.gismNumber}"/></div>
                    </c:if>
                  </div>

                  <div class="row">
                    <div class="col-lg-2 col-md-4 label">Registration Date</div>
                    <div class="col-lg-3 col-md-8"><c:out value='${patientDetail.getRegistrationDate()}'/> </div>
                    <div class="col-lg-4 col-md-2 label">
                         <c:if test="${fn:contains(patientDetail.subscriptionType, 'Free')}">
                           Subscription Status &nbsp; &nbsp;
                           <span class="badge bg-warning" style="font-size: 1.1rem; padding: 0.3em 1.3em;"> <c:out value='${patientDetail.subscriptionType}'/> </span>
                         </c:if>
                         <c:if test="${fn:contains(patientDetail.subscriptionType, 'Basic')}">
                            Subscription Status &nbsp; &nbsp;
                           <span class="badge bg-success" style="font-size: 1.1rem; padding: 0.3em 1.3em;"> <c:out value='${patientDetail.subscriptionType}'/> </span>
                         </c:if>
                    </div>

                  </div>


                </div>
                <!-- END OF PROFILE OVERVIEW TAB -->


                <!-- =========================== -->
                <!-- START OF UPDATE DETAIL TAB -->
                <!-- =========================== -->
                <div class="tab-pane fade" id="profile-edit">
                  <h5 class="card-title"> <c:out value='${patientDemo}'/> &nbsp; ,  <c:out value='${patientDetail.fullAddress}'/></h5>
                  <hr/>
                     <!-- START OF EHR EDIT FILE -->
                  <div id="problemsContainer">
                      <jsp:include page="/WEB-INF/jsp/ehr-history-update.jsp" />
                  </div>
                </div>
                <!-- END OF UPDATE DETAIL TAB -->




            <!-- =========================== -->
            <!-- START ACTION ITEM  TAB -->
            <!-- =========================== -->
             <div class="tab-pane fade action-plan" id="action-plan">
                  <h5 class="card-title"> <c:out value='${patientDemo}'/> &nbsp; ,  <c:out value='${patientDetail.fullAddress}'/></h5>
                  <hr/>

                  <div class="row" style="margin-top:25px;">

                       <div class="col-lg-3" align="left">
                              <button type="button" class="btn" onClick="alertUnderConstruction();" style="margin-right:10px; background-color: #07DBB8;">
                                 <i class="bi bi-award" style="font-size:1.3em;"></i> Create Sick Note
                              </button>
                       </div>

                       <div class="col-lg-3" align="left">
                              <button type="button" class="btn" style="margin-right:10px; background-color: #FF637E; color:#fff;" onClick="alertUnderConstruction();"> <i class="bi bi-graph-up-arrow"></i> Trend Analysis </button>
                       </div>

                        <div class="col-lg-3" align="left">
                            <button type="button" onClick="RetestReminder();" class="btn btn-warning">
                              <i class="bi bi-alarm"></i> Setup Retest Reminder
                            </button>
                        </div>

                      <div class="col-lg-3" align="left">
                          <button type="button" class="btn " onClick="openCreateDocumentPage('<c:out value='${patientIdEncrypted}'/>');" style="margin-right:10px; background-color: #D4D4D8; color:#black;">
                             <i class="bi bi-file-earmark-pdf" style="font-size:1.3em;color:#E6230E;"></i> Create Document
                          </button>
                      </div>

                  </div> <!--End of row -->



                  <div class="row" style="margin-top:25px;">

                    <div class="col-lg-3" align="left">
                             <button type="button" onclick="openHl7DocumentUploadModel();" class="btn btn-info">
                                  <i class="bi bi-filetype-xml"></i> Add Health Link XML
                             </button>
                   </div>

                       <div class="col-lg-3" align="left">
                           <button type="button" onclick="openDocumentUploadModel();" class="btn btn-info">
                                <i class="bi bi-database-add"></i> Add document
                           </button>
                       </div>

                       <div class="col-lg-3" align="left">
                              <button type="button" class="btn" onClick="openInvoicePage('<c:out value='${patientDetail.userId}'/>');" style="margin-right:10px; background-color: #07DBB8;">
                                 <i class="bi bi-currency-euro" style="font-size:1.3em;"></i> Invoice / Receipt
                              </button>
                       </div>

                       <div class="col-lg-3" align="left">
                              <button type="button" class="btn" onClick="openSendMessageToPatient('<c:out value='${patientDetail.userId}'/>');" style="margin-right:10px; background-color: #07DBB8;">
                                 <i class="bi bi-chat-left-dots" style="font-size:1.3em;"></i>  Message Patient
                              </button>
                       </div>

                  </div>





                  <hr/>
             </div>
            <!-- =========================== -->
            <!-- END OF ACTION ITEM  TAB -->
            <!-- =========================== -->



            <!-- =========================== -->
            <!-- START MEDICAL LOG BOOK -->
            <!-- =========================== -->
             <div id="ehrLogContainer"">
                     <jsp:include page="/WEB-INF/jsp/ehr-log.jsp" />
             </div>

            <!-- =========================== -->
            <!-- END MEDICAL LOG BOOK -->
            <!-- =========================== -->



            </div>
          </div>

        </div>
      </div>
    </section>

  <!-- Modal Structure for codeDiagnosisForm   -->
    <input type="hidden" name="documentId" id="documentId" value="<c:out value='${documentId}'/>">
    <div class="modal fade" id="codeDiagnosisModel"  aria-labelledby="codeDiagnosisModel" aria-hidden="true">
       <div class="modal-dialog modal-dialog-centered" style="max-width:1000px;max-height:1000px;">

           <div class="modal-content">
              <form name="codeDiagnosisForm" id="codeDiagnosisForm" >
               <div class="modal-header">
                   <h5 class="modal-title"> <strong><i class="bi bi-pencil-square"></i>  ICPC - Classification  </strong> </h5>
                   <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
               </div>

                   <div class="modal-body" id="modelBodyContent" align="left">
                        <div class="row" style="margin-bottom: 10px;" ><p align="center"><b> <c:out value='${patientDemo}'/> </b></p></div>
                        <div class="row text-start" >
                                <div class="card border-0">
                                    <div class="card-body">
                                        <div class="row">
                                            <div class="col-lg-12 col-md-12" style="text-align:left;margin-top: 25px;">

                                                <div class="row mb-3">
                                                  <div class="col-sm-10">
                                                        <div class="form-check">
                                                          <input class="form-check-input" type="checkbox" id="gridCheck1" name="classification[]" value="A#General and unspecified" onClick="updateCodeToPatientHcr(this)">
                                                          <label class="form-check-label" for="gridCheck1">
                                                             <b> A </b> General and unspecified
                                                          </label>
                                                        </div>
                                                        <div class="form-check">
                                                          <input class="form-check-input" type="checkbox" id="gridCheck2" name="classification[]" value="B# Blood, blood forming organs, lymphatics, spleen" onClick="updateCodeToPatientHcr(this)">
                                                          <label class="form-check-label" for="gridCheck2">
                                                            <b> B </b> Blood, blood forming organs, lymphatics, spleen
                                                          </label>
                                                        </div>
                                                        <div class="form-check">
                                                          <input class="form-check-input" type="checkbox" id="gridCheck3" name="classification[]" value="D#Digestive" onClick="updateCodeToPatientHcr(this)">
                                                          <label class="form-check-label" for="gridCheck3">
                                                            <b> D</b> Digestive
                                                          </label>
                                                        </div>

                                                        <div class="form-check">
                                                          <input class="form-check-input" type="checkbox" id="gridCheck4" name="classification[]" value="F#Eye"     onClick="updateCodeToPatientHcr(this)">
                                                          <label class="form-check-label" for="gridCheck4">
                                                            <b> F </b> Eye
                                                          </label>
                                                        </div>

                                                        <div class="form-check">
                                                          <input class="form-check-input" type="checkbox" id="gridCheck5" name="classification[]" value="H#Ear" onClick="updateCodeToPatientHcr(this)">
                                                          <label class="form-check-label" for="gridCheck5">
                                                            <b> H </b> Ear
                                                          </label>
                                                        </div>

                                                       <div class="form-check">
                                                          <input class="form-check-input" type="checkbox" id="gridCheck6" name="classification[]" value="K#Circulatory" onClick="updateCodeToPatientHcr(this)">
                                                          <label class="form-check-label" for="gridCheck6">
                                                            <b> K  </b> Circulatory
                                                          </label>
                                                        </div>

                                                       <div class="form-check">
                                                          <input class="form-check-input" type="checkbox" id="gridCheck7" name="classification[]" value="L#Musculoskeletal" onClick="updateCodeToPatientHcr(this)">
                                                          <label class="form-check-label" for="gridCheck7">
                                                            <b> L </b> Musculoskeletal
                                                          </label>
                                                        </div>

                                                       <div class="form-check">
                                                          <input class="form-check-input" type="checkbox" id="gridCheck8" name="classification[]" value="N#Neurological" onClick="updateCodeToPatientHcr(this)">
                                                          <label class="form-check-label" for="gridCheck8">
                                                            <b> N </b>  Neurological
                                                          </label>
                                                        </div>

                                                        <div class="form-check">
                                                          <input class="form-check-input" type="checkbox" id="gridCheck9" name="classification[]" value="P#Psychological" onClick="updateCodeToPatientHcr(this)">
                                                          <label class="form-check-label" for="gridCheck9">
                                                            <b> P </b> Psychological
                                                          </label>
                                                        </div>

                                                        <div class="form-check">
                                                          <input class="form-check-input" type="checkbox" id="gridCheck10" name="classification[]" value="R#Respiratory" onClick="updateCodeToPatientHcr(this)">
                                                          <label class="form-check-label" for="gridCheck10">
                                                            <b> R </b>  Respiratory
                                                          </label>
                                                        </div>


                                                        <div class="form-check">
                                                          <input class="form-check-input" type="checkbox" id="gridCheck11" name="classification[]" value="S#Skin" onClick="updateCodeToPatientHcr(this)">
                                                          <label class="form-check-label" for="gridCheck11">
                                                            <b> S </b> Skin
                                                          </label>
                                                        </div>


                                                        <div class="form-check">
                                                          <input class="form-check-input" type="checkbox" id="gridCheck12" name="classification[]" value="T#Endocrine, metabolic and nutritional" onClick="updateCodeToPatientHcr(this)">
                                                          <label class="form-check-label" for="gridCheck12">
                                                            <b> T </b> Endocrine, metabolic and nutritional
                                                          </label>
                                                        </div>


                                                        <div class="form-check">
                                                          <input class="form-check-input" type="checkbox" id="gridCheck13" name="classification[]" value="U#Urology" onClick="updateCodeToPatientHcr(this)">
                                                          <label class="form-check-label" for="gridCheck13">
                                                            <b> U </b> Urology
                                                          </label>
                                                        </div>


                                                        <div class="form-check">
                                                          <input class="form-check-input" type="checkbox" id="gridCheck14" name="classification[]" value="W#Pregnancy, childbirth, family planning" onClick="updateCodeToPatientHcr(this)">
                                                          <label class="form-check-label" for="gridCheck14">
                                                            <b> W </b> Pregnancy, childbirth, family planning
                                                          </label>
                                                        </div>


                                                        <div class="form-check">
                                                          <input class="form-check-input" type="checkbox" id="gridCheck15" name="classification[]" value="X#Female genital system and breast" onClick="updateCodeToPatientHcr(this)">
                                                          <label class="form-check-label" for="gridCheck15">
                                                            <b> P </b> X Female genital system and breast
                                                          </label>
                                                        </div>

                                                        <div class="form-check">
                                                          <input class="form-check-input" type="checkbox" id="gridCheck16" name="classification[]" value="Y#Male genital system" onClick="updateCodeToPatientHcr(this)">
                                                          <label class="form-check-label" for="gridCheck16">
                                                            <b> Y </b> Male genital system
                                                          </label>
                                                        </div>

                                                        <div class="form-check">
                                                          <input class="form-check-input" type="checkbox" id="gridCheck17" name="classification[]" value="Z#Social problems" onClick="updateCodeToPatientHcr(this)">
                                                          <label class="form-check-label" for="gridCheck17">
                                                            <b> Z </b> Social problems
                                                          </label>
                                                        </div>

                                                  </div>
                                                </div>

                                             </div>
                                        </div>
                                    </div> <!-- End of card body  -->
                                </div> <!-- End of card border  -->
                        </div>  <!-- End of row -->


                            <!-- This code block will do auto check the foem field based on previous selection -->
                            <script>
                              // 1. Read the Java-rendered string
                              var medicalConditionStr = '<c:out value="${patientEhr.medicalConditions}"/>';

                              // 2. Extract codeNames with regex
                              var codeNames = [];
                              var regex = /codeName=([^,)\s]*)/g;
                              var match;
                              while ((match = regex.exec(medicalConditionStr)) !== null) {
                                codeNames.push(match[1]);
                              }

                              // If you want only unique codes:
                              codeNames = [...new Set(codeNames)];

                              // 3. Check checkboxes in the form if the code is present
                              document.addEventListener("DOMContentLoaded", function() {
                                var checkboxes = document.querySelectorAll('input[name="classification[]"]');
                                checkboxes.forEach(function(checkbox) {
                                  // Each checkbox value is like "A#General and unspecified"
                                  var code = checkbox.value.split('#')[0];
                                  if (codeNames.includes(code)) {
                                    checkbox.checked = true;
                                  } else {
                                    checkbox.checked = false; // optional: uncheck if not in the list
                                  }
                                });
                              });
                            </script>

                   </div> <!-- End of modal-body -->

                   <div class="modal-footer" align="center">
                       <button type="button" id="closeModelButton" name="closeModelButton" class="btn btn-danger" data-bs-dismiss="modal"> <i class="fa fa-times" aria-hidden="true"></i> Cancel</button>

                   </div>
               </form>
           </div> <!-- End of modal-content -->

       </div> <!-- End of modal-dialog -->
    </div> <!-- End of modal fade -->

  <!-- End of Modal Structure for codeDiagnosisForm -->



  <!-- Modal Structure for adding document to EHR  -->
    <form name="fileUpload" id="fileUpload" enctype="multipart/form-data">
      <input type="hidden" name="patientId" id="patientId" value="<c:out value='${patientDetail.userId}'/>">
      <div class="modal fade" id="addDocumentToEhr" aria-labelledby="addDocumentToEhr" aria-hidden="true">
        <div class="modal-dialog modal-dialog-centered" style="max-width:800px;max-height:800px;">
          <div class="modal-content">
            <div class="modal-header">
              <h5 class="modal-title"><strong><i class="bi bi-database-add" style="font-size:1.2em;color: #FF1493;"> </i> Add document to patient EHR Log</strong></h5>
              <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
            </div>

            <div class="modal-body" id="modelBodyContent" align="left">
              <div class="row text-start">
                <div class="card border-0">
                  <div class="card-body">
                    <div class="row">
                      <div class="col-lg-6 col-md-6" style="text-align:center;">
                        <select class="form-control form-select" id="documentType_1" name="documentType_1">
                          <option value="All">--- Select Document Type ---</option>
                          <c:forEach var="entry" items="${allDocumentType}">
                            <option value="<c:out value='${entry.key}'/>"><c:out value='${entry.value}'/></option>
                          </c:forEach>
                        </select>
                      </div>

                      <div class="col-lg-6 col-md-6" style="text-align:left;">
                        <input class="form-control" type="file" id="PatientfileUpload" name="PatientfileUpload" multiple accept=".pdf" required />
                      </div>
                    </div>

                    <!-- Share / Do Not Share (inline radios) -->
                    <div class="row mt-3">
                      <div class="col-12 d-flex align-items-center justify-content-center gap-4">
                        <div class="form-check form-check-inline d-flex align-items-center gap-2">
                          <input class="form-check-input" type="radio" name="shareWithPatient" id="shareYes" value="yes" >
                          <label class="form-check-label d-flex align-items-center gap-2 text-success fw-bold" for="shareYes">
                            Share with patient <i class="bi bi-check-circle" style="font-size:1.2em;"> </i>
                          </label>
                        </div>
                        <div class="form-check form-check-inline d-flex align-items-center gap-2">
                          <input class="form-check-input" type="radio" name="shareWithPatient" id="shareNo" value="no" checked>
                          <label class="form-check-label d-flex align-items-center gap-2 text-danger fw-bold" for="shareNo">
                            Do not share with patient <i class="bi bi-x-circle" style="font-size:1.2em;"> </i>
                          </label>
                        </div>
                      </div>
                    </div>
                  </div> <!-- End of card body -->
                </div> <!-- End of card -->
              </div> <!-- End of row -->
            </div>

            <div class="modal-footer" align="center">
              <button type="button" id="closeModelButton" name="closeModelButton" class="btn btn-danger" data-bs-dismiss="modal">
                <i class="fa fa-times" aria-hidden="true"></i> Cancel
              </button>
              &nbsp; &nbsp;
              <button type="button" class="btn btn-info" onClick="addFiletoPatientEhr();">
                <i class="bi bi-floppy-fill"></i> Save File
              </button>
            </div>
          </div>
        </div>
      </div>
    </form>
    <!-- END OF MODAL STRUCTURE FOR ADDING DOCUMENT TO EHR -->



  <!-- Modal Structure for adding health link xml to EHR  -->
    <form name="fileUpload_2" id="fileUpload_2" enctype="multipart/form-data">
      <input type="hidden" name="patientId" id="patientId" value="<c:out value='${patientDetail.userId}'/>">
      <div class="modal fade" id="addXmlToEhr" aria-labelledby="addXmlToEhr" aria-hidden="true">
        <div class="modal-dialog modal-dialog-centered" style="max-width:800px;max-height:800px;">
          <div class="modal-content">
            <div class="modal-header">
              <h5 class="modal-title"><strong><i class="bi bi-database-add" style="font-size:1.2em;color: #FF1493;"> </i> Add Health link XML to patient EHR Log</strong></h5>
              <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
            </div>

            <div class="modal-body" id="modelBodyContent" align="left">
              <div class="row text-start">
                <div class="card border-0">
                  <div class="card-body">
                    <div class="row">
                      <div class="col-lg-6 col-md-6" style="text-align:center;">
                        <select class="form-control form-select" id="documentType_2" name="documentType_2">
                          <option value="All">--- Select Document Type ---</option>
                          <c:forEach var="entry" items="${allDocumentType}">
                            <option value="<c:out value='${entry.key}'/>"><c:out value='${entry.value}'/></option>
                          </c:forEach>
                        </select>
                      </div>

                      <div class="col-lg-6 col-md-6" style="text-align:left;">
                        <input class="form-control" type="file" id="PatientfileUpload_2" name="PatientfileUpload_2"  required />
                      </div>
                    </div>

                    <!-- Share / Do Not Share (inline radios) -->
                    <div class="row mt-3">
                      <div class="col-12 d-flex align-items-center justify-content-center gap-4">
                        <div class="form-check form-check-inline d-flex align-items-center gap-2">
                          <input class="form-check-input" type="radio" name="shareWithPatient_2" id="shareYes" value="yes" >
                          <label class="form-check-label d-flex align-items-center gap-2 text-success fw-bold" for="shareYes">
                            Share with patient <i class="bi bi-check-circle" style="font-size:1.2em;"> </i>
                          </label>
                        </div>
                        <div class="form-check form-check-inline d-flex align-items-center gap-2">
                          <input class="form-check-input" type="radio" name="shareWithPatient_2" id="shareNo" value="no" checked>
                          <label class="form-check-label d-flex align-items-center gap-2 text-danger fw-bold" for="shareNo">
                            Do not share with patient <i class="bi bi-x-circle" style="font-size:1.2em;"> </i>
                          </label>
                        </div>
                      </div>
                    </div>
                  </div> <!-- End of card body -->
                </div> <!-- End of card -->
              </div> <!-- End of row -->
            </div>

            <div class="modal-footer" align="center">
              <button type="button" id="closeModelButton" name="closeModelButton" class="btn btn-danger" data-bs-dismiss="modal">
                <i class="fa fa-times" aria-hidden="true"></i> Cancel
              </button>
              &nbsp; &nbsp;
              <button type="button" class="btn btn-info" onClick="addxMLFiletoPatientEhr();">
                <i class="bi bi-floppy-fill"></i> Save File
              </button>
            </div>
          </div>
        </div>
      </div>
    </form>
    <!-- END OF MODAL STRUCTURE FOR ADDING DOCUMENT TO EHR -->



  <!-- MODAL STRUCTURE FOR SEND MESSAGE TO PATIENT   -->
    <form name="messageToPatient" id="messageToPatient">
      <input type="hidden" name="patientId" id="patientId" value="<c:out value='${patientDetail.userId}'/>">
      <div class="modal fade" id="sendMessage" aria-labelledby="addDocumentToEhr" aria-hidden="true">
        <div class="modal-dialog modal-dialog-centered" style="max-width:800px;max-height:800px;">
          <div class="modal-content">
            <div class="modal-header">
              <h5 class="modal-title"><strong><i class="bi bi-chat-left-dots" style="font-size:1.2em;color: #FF1493;"> </i> Send message to patient</strong></h5>
              <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
            </div>

            <div class="modal-body" id="modelBodyContent" align="left">
              <div class="row text-start">
                <div class="card border-0">
                  <div class="card-body">

                    <div class="row" style="margin-top:15px;">
                      <div class="col-lg-6 col-md-6" style="text-align:left;">
                        <select class="form-control form-select" id="messageTemplate" name="messageTemplate" onChange="loadMessageTemplateContentToTextArea();">
                          <option value="All">--- Select Template ---</option>
                          <c:forEach var="entry" items="${messageSnippet}">
                            <option value="<c:out value='${entry.id}'/>"  data-content="<c:out value='${fn:escapeXml(entry.contentDetail)}' escapeXml="false"/>"><c:out value='${entry.headingName}'/></option>
                          </c:forEach>
                        </select>
                      </div>
                    </div>

                    <div class="row" style="margin-top:15px;">
                        <div class="col-12">
                            <label class="text-primary mb-1"><strong>Message to patient</strong></label>
                            <textarea oninput="autoResize(this)"
                                      style="box-shadow:2px 4px 8px rgba(0,0,0,0.1);"
                                      class="form-control"
                                      id="DetailMessageToPatient"
                                      name="DetailMessageToPatient"
                                      rows="10" maxlength="6000"></textarea>
                        </div>
                    </div>

                  </div> <!-- End of card body -->
                </div> <!-- End of card -->
              </div> <!-- End of row -->
            </div>

            <div class="modal-footer" align="center">
              <button type="button" id="closeModelButton" name="closeModelButton" class="btn btn-danger" data-bs-dismiss="modal">
                <i class="fa fa-times" aria-hidden="true"></i> Cancel
              </button>
              &nbsp; &nbsp;
              <button type="button" id="sendButton" class="btn btn-info" onClick="sendMessageToPatientAccount();">
                <i class="bi bi-send"></i> Send
              </button>
            </div>
          </div>
        </div>
      </div>
    </form>
    <!-- END OF MODAL STRUCTURE FOR SEND MESSAGE TO PATIENT  -->



  <!-- MODAL STRUCTURE FOR CREATE TASK TO THE RECEPTION -->
    <form name="receptionTaskForm" id="receptionTaskForm">
      <div class="modal fade" id="createTaskModel" aria-labelledby="createTaskModel" aria-hidden="true">
        <div class="modal-dialog modal-dialog-centered" style="max-width:1000px;max-height:1000px;">
          <div class="modal-content">
            <div class="modal-header">
              <h5 class="modal-title"><strong><i class="bi bi-pencil-square" style="font-size:1.2em;color: #FF1493;"></i> Create task for staff</strong></h5>
              <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
            </div>
            <div class="modal-body" id="modelBodyContent" align="left">
              <div class="row" style="margin-bottom: 10px;">
                <p align="left"><b>${patientDemo}</b></p>
              </div>
              <div class="row text-start">
                <div class="card border-0">
                  <div class="card-body">
                    <div class="row">
                      <div class="col-lg-6 col-md-6" style="text-align:left;">
                        <select class="form-select form-select" id="actionId" name="actionId" onChange="addTaskToMessageBox()">
                            <option value="" selected>----------- Select Action -----------</option>
                            <!-- Details are loaded from java script  -->
                        </select>
                      </div>
                      <div class="col-lg-5 col-md-5" style="text-align:center;">
                        <select class="form-select form-select" id="staffId" name="staffId">
                          <option value="" selected>----------- Select Staff -----------</option>
                          <c:forEach var="entry" items="${receptionistList}">
                            <option value="${entry.userId}">${entry.fullName}</option>
                          </c:forEach>
                        </select>
                      </div>
                    </div>
                    <div class="row">
                      <div class="col-lg-12 col-md-12" style="text-align:left;margin-top: 25px;">
                        <textarea oninput="autoResize(this)" style="box-shadow:2px 4px 8px rgba(0, 0, 0, 0.1);" class="form-control" id="receptionTask" name="receptionTask" rows="10" maxlength="4000"></textarea>
                      </div>
                    </div>
                  </div> <!-- End of card body  -->
                </div> <!-- End of card  -->
              </div>  <!-- End of row -->
            </div>
            <div class="modal-footer" align="center">
              <button type="button" id="closeModelButton" name="closeModelButton" class="btn btn-danger" data-bs-dismiss="modal">
                <i class="fa fa-times" aria-hidden="true"></i> Cancel
              </button>
              &nbsp; &nbsp;
              <button type="button" class="btn btn-info" onClick="createTaskForStaff()">
                <i class="bi bi-pencil-square"></i> Create
              </button>
            </div>
          </div>
        </div>
      </div>
    </form>
    <!-- END OF MODAL STRUCTURE FOR CREATE TASK TO THE RECEPTION -->



    <!-- MODAL STRUCTURE FOR RETEST REMINDER -->
    <form name="retestReminderForm" id="retestReminderForm">
      <div class="modal fade" id="retestReminder" aria-labelledby="retestReminder" aria-hidden="true">
        <div class="modal-dialog modal-dialog-centered" style="max-width:1000px;max-height:1000px;">
          <div class="modal-content">
            <div class="modal-header">
              <h5 class="modal-title"><strong><i class="bi bi-alarm" style="font-size:1.2em;color: #FF1493;"></i>&nbsp;Create Retest Reminder for patient</strong></h5>
              <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
            </div>
            <div class="modal-body" id="modelBodyContent" align="left">
              <div class="row" style="margin-bottom: 10px;">
                <p align="left"><b>${patientDemo}</b></p>
              </div>
              <div class="row text-start">
                <div class="card border-0">
                  <div class="card-body">
                    <div class="row">
                      <div class="col-lg-3 col-md-3" style="text-align:left;">
                        <label class="text-primary mb-1"><strong>Number of</strong></label>
                        <input type="text" class="form-control" id="retestAfter" name="retestAfter" placeholder="">
                      </div>
                      <div class="col-lg-3 col-md-3" style="text-align:left;">
                        <label class="text-primary mb-1"><strong>Weeks / Month</strong></label>
                        <select class="form-select form-select" id="weeksMonth" name="weeksMonth">
                          <option value="" selected>---- Select----</option>
                          <option value="DAYS">Days</option>
                          <option value="WEEK">Week</option>
                          <option value="MONTH">Month</option>
                        </select>
                      </div>
                      <div class="col-lg-5 col-md-5" style="text-align:left;">
                        <label class="text-primary mb-1"><strong>Type of test</strong></label>
                        <select class="form-select form-select" id="testType" name="testType" onChange="addTestTypeContentToTextBox();">
                          <c:forEach var="entry" items="${testTypeSnippet.getTestTypeList()}">
                            <option value="${entry.key}">${entry.value}</option>
                          </c:forEach>
                        </select>
                      </div>
                    </div>
                    <div class="row">
                      <div class="col-lg-12 col-md-12" style="text-align:left;margin-top: 25px;">
                        <label class="text-primary mb-1"><strong>Email Notification Content</strong></label>
                        <textarea oninput="autoResize(this)" style="box-shadow:2px 4px 8px rgba(0, 0, 0, 0.1);" class="form-control" id="emailContent" name="emailContent" rows="8" maxlength="4000"></textarea>
                      </div>
                    </div>
                  </div> <!-- End of card body  -->
                </div> <!-- End of card  -->
              </div>  <!-- End of row -->
            </div>
            <div class="modal-footer" align="center">
              <button type="button" id="closeModelButton" name="closeModelButton" class="btn btn-danger" data-bs-dismiss="modal">
                <i class="fa fa-times" aria-hidden="true"></i> Cancel
              </button>
              &nbsp; &nbsp;
                 <button type="button" class="btn btn-info" onClick="createTestReminder()">
                <i class="bi bi-alarm"></i> Create Reminder
              </button>
            </div>
          </div>
        </div>
      </div>
    </form>
    <!-- END OF MODAL STRUCTURE FOR RETEST REMINDER  -->


    <!-- MODAL STRUCTURE FOR BOOK APPOINTMENT  -->
    <form name="bookAppointmentForm" id="bookAppointmentForm">
     <input type="hidden" name="patientUserId" id="patientUserId" value="<c:out value='${patientDetail.userId}'/>">
      <input type="hidden" name="patientName" id="patientName" value="<c:out value='${patientDetail.getFullName()}'/>">
      <input type="hidden" name="patientPhone" id="patientPhone" value="<c:out value='${patientDetail.phoneNumber}'/>">
      <input type="hidden" name="patientEmail" id="patientEmail" value="<c:out value='${patientDetail.emailId}'/>">
      <div class="modal fade" id="bookAppointment" aria-labelledby="retestReminder" aria-hidden="true">
        <div class="modal-dialog modal-dialog-centered" style="max-width:1300px;">
          <div class="modal-content">
            <div class="modal-header">
              <h5 class="modal-title"><strong><i class="bi bi-alarm" style="font-size:1.2em;color: #FF1493;"></i>&nbsp;Book Appointment for patient &nbsp; (${patientDemo})</strong></h5>
              <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
            </div>
            <div class="modal-body" id="modelBodyContent" align="left">
              <div class="row text-start">
                <div class="card border-0">
                  <div class="card-body">
                    <div class="row">
                      <div class="col-lg-5 col-md-3" style="text-align:left;">
                        <label class="text-primary mb-1"><strong>Service Type</strong></label>
                            <select class="form-select" id="serviceIdForBooking" name="serviceIdForBooking" disabled>>
                              <option value="">---- Select a Service ----</option>
                              <c:forEach var="svc" items="${clinicServices}">
                                <option value="${svc.id}"
                                    <c:if test="${fn:contains(svc.serviceCode, 'GP_VIDEO_CONSULTATION')}"> selected </c:if>  >
                                   ${svc.serviceName}
                                 </option>
                              </c:forEach>
                            </select>

                      </div>

                      <div class="col-lg-3 col-md-3" style="text-align:left;">
                        <label class="text-primary mb-1"><strong>Service Mode </strong></label>
                        <select class="form-select form-select" id="serviceMode" name="serviceMode" disabled>
                          <option value="Online" selected> Online </option>
                          <option value="In-Clinic"> In-Clinic</option>
                        </select>
                      </div>

                      <div class="col-lg-4 col-md-5" style="text-align:left;">
                        <label class="text-primary mb-1"><strong> GP Name </strong></label>
                        <select class="form-select form-select" id="staffName" name="staffName" onChange="onDateChange()">
                              <option value="" selected>----------- Select -----------</option>
                                <c:forEach items="${gpUserList}" var="s">
                                    <option value="${s.userId}">
                                        ${s.firstName} ${s.lastName}
                                    </option>
                                </c:forEach>
                        </select>
                      </div>
                    </div>


                    <div class="row">
                        <div class="col-lg-2 col-md-6" style="text-align:left;margin-top: 25px;">
                            <label class="text-primary mb-1"><strong>Appointment Date </strong></label>
                            <input type="date" class="form-control" id="appointmentDate" name="appointmentDate" onChange="onDateChange()">
                        </div>

                        <!--
                        <div class="col-lg-3 col-md-6" style="text-align:left;margin-top: 25px;">
                            <label class="text-primary mb-1"><strong>Appointment Time </strong></label>
                            <input type="time" class="form-control" id="appointmentTime" name="appointmentTime" >
                        </div>
                        -->

                        <div class="col-lg-1 col-md-6" style="text-align:left;margin-top: 25px;">
                            <label class="text-primary mb-1"><strong>   </strong></label>
                            <input type="text" class="form-control" id="notifyPatient" name="notifyPatient" value="10" >
                        </div>

                        <div class="col-lg-3 col-md-6" style="text-align:left;margin-top: 25px;">
                            <label class="text-primary mb-1"><strong> <i class="bi bi-bell"></i> Reminder (Email/SMS)</strong></label>
                            <select class="form-select form-select" id="dayMinutes" name="dayMinutes" >
                                  <option value="minutes"> Minutes - Before </option>
                                  <option value="hours">   Hours - Before </option>
                                  <option value="day"> Day - Before </option>
                            </select>
                        </div>

                      <div class="col-lg-6 col-md-12" style="text-align:left;margin-top: 25px;">
                        <label class="text-primary mb-1"><strong>Note | Comment </strong></label>
                        <input class="form-control" type="text" id="noteComment" name="noteComment" value="" >
                      </div>

                    </div>

                    <div id="slotContainer" class="row mt-5">
                      <div class="col-12 text-danger" align="center" style="font-size: 20px;"> Select a Staff / Clinician  to load available slots.</div>
                    </div>

                  </div> <!-- End of card body  -->
                </div> <!-- End of card  -->
              </div>  <!-- End of row -->
            </div>
            <div class="modal-footer" align="center">
              <button type="button" id="closeModelButton" name="closeModelButton" class="btn btn-danger" data-bs-dismiss="modal">
                <i class="fa fa-times" aria-hidden="true"></i> Cancel
              </button>
              &nbsp; &nbsp;
                 <button type="button" class="btn btn-info" onClick="createBooking()">
                <i class="bi bi-alarm"></i> Create Booking
              </button>
            </div>
          </div>
        </div>
      </div>
    </form>
    <!-- END OF MODAL STRUCTURE BOOK APPOINTMENT  -->

  </main><!-- End #main -->



 <!-- In head, with defer -->
 <script src="assets-admin/js/manage-patient.js?v=101" defer></script>
 <script src="assets-admin/js/manage-patient_1.js?v=121" defer></script>


 <script>
     //- This code will make the slot selected on the booking page
      let selectedSlot = null;


      function selectSlot(el) {
        document.querySelectorAll('.slot-box').forEach(function (box) {
          box.classList.remove('selected');
        });
        el.classList.add('selected');
        selectedSlot = { slotid: el.getAttribute('id'), start: el.getAttribute('data-start'), end: el.getAttribute('data-end') };
       }



     //- This code will make current date selected on the booking page
      document.addEventListener('DOMContentLoaded', function () {
        const dateInput = document.getElementById('appointmentDate');
        const today = new Date();
        const yyyy = today.getFullYear();
        const mm = String(today.getMonth() + 1).padStart(2, '0');
        const dd = String(today.getDate()).padStart(2, '0');
        const todayStr = yyyy + '-' + mm + '-' + dd;
        dateInput.value = todayStr;
        dateInput.min = todayStr;
      });

        //*== HANDLE DATE CHANGE TO RELOAD SLOTS ==*//
        function onDateChange() {
            selectedSlot = null; // reset any previous selection
            fetchSlots();
        }



      //*== FETCH AVAILABLE SLOTS BASED ON FILTERS ==*//
      function fetchSlots() {

        const dateVal = document.getElementById('appointmentDate').value;
        const serviceId = document.getElementById('serviceIdForBooking').value;
        const staffUserId = document.getElementById('staffName').value;

        if (!dateVal) {
          document.getElementById('slotContainer').innerHTML = '<div class="col-12 text-danger" align="center" style="font-size: 20px;">Select a date first.</div>';
          document.getElementById('dateVal').focus();
          return;
        }

        if (!staffUserId) {
          document.getElementById('slotContainer').innerHTML = '<div class="col-12 text-danger" align="center" style="font-size: 20px;">Select clinician / Staff first.</div>';
          document.getElementById('staffName').focus();
          return;
        }

        selectedSlot = null; // reset selection
        document.getElementById('slotContainer').innerHTML = '<div class="col-12 text-danger" align="center" style="font-size: 20px;">Loading slots...</div>';

        // Build OffsetDateTime-friendly parameters (UTC)
        const startParam = dateVal + 'T00:00:00Z';
        const endParam   = dateVal + 'T23:59:59Z';

        const params = new URLSearchParams();
        params.append('start', startParam);
        params.append('end', endParam);

        if (serviceId) params.append('serviceId', serviceId);
        if (staffUserId) params.append('staffUserId', staffUserId);

        const url = '<c:url value="/admin/appointment-slots" />' + '?' + params.toString();

        fetch(url, { method: 'GET' })
          .then(function (resp) {
            if (!resp.ok) throw new Error('HTTP ' + resp.status);
            return resp.json();
          })
          .then(function (data) {
            renderSlots(data);
          })
          .catch(function (err) {
            console.error(err);
            document.getElementById('slotContainer').innerHTML =
              '<div class="col-12 text-danger" align="center" style="font-size: 20px;"> Failed to load slots. !!!</div>';
          });
      }



     //*== THIS WILL RENDER THE SLOTS ==*//
    function renderSlots(slots) {
      const container = document.getElementById('slotContainer');
      if (!slots || slots.length === 0) {
        container.innerHTML = '<div class="col-12 text-danger" align="center" style="font-size: 20px;">Sorry, no booking slots available for this Service / Staff ->  date. !!! </div>';
        return;
      }

      // Sort ascending by slotStart
      const sorted = slots.slice().sort(function (a, b) {
        return new Date(a.slotStart) - new Date(b.slotEnd);
      });

      let html = '';
      sorted.forEach(function (slot) {
        const startLabel = slot.slotStart;
        const endLabel = slot.slotEnd;
        const slotId = slot.slotId;
        const slotStatus = slot.slotStatus || 'Available'; // Assuming slotStatus is provided in the response

        // Determine if the slot is booked
        const isBooked = slotStatus.toUpperCase() === 'BOOKED';

        // Set different styles and behavior based on slot status
        const slotClass = isBooked ? 'slot-box booked' : 'slot-box available';
        const clickHandler = isBooked ? '' : 'onclick="selectSlot(this)"';
        const cursorStyle = isBooked ? 'style="cursor: not-allowed;"' : '';
        const titleAttr = isBooked ? 'title="This slot is already booked"' : '';

        html +=
          '<div class="col-md-2">' +
            '<div class="' + slotClass + '" ' +
            'id="' + slotId + '" ' +
            'data-start="' + startLabel + '" ' +
            'data-end="' + endLabel + '" ' +
            'data-status="' + slotStatus + '" ' +
            clickHandler + ' ' +
            cursorStyle + ' ' +
            titleAttr + '>' +
              '<b>' + formatDateTime(startLabel) + ' - ' + formatDateTime(endLabel) + '</b>' +

            '</div>' +
          '</div>';
      });

      container.innerHTML = html;
    }



      function formatDateTime(dateStr) {
        const d = new Date(dateStr);
        let hours = d.getHours();
        const minutes = String(d.getMinutes()).padStart(2, '0');
        const ampm = hours >= 12 ? 'Pm' : 'Am';
        //const ampm = hours >= 12 ? '' : '';
        hours = hours % 12;
        hours = hours ? hours : 12; // 0 → 12
        return hours + ':' + minutes + ' ' + ampm;
      }






       function alertUnderConstruction() {
         Swal.fire({
           title: 'Under Construction',
           text: 'This feature is currently under development.',
           icon: 'info',
           confirmButtonText: 'OK'
         });
       } //  End of function alertUnderConstruction




  //*== CONFIRM BOOKING AND SUBMIT TO SERVER ==*//
       function createBooking() {

         const patientUserId   = document.getElementById('patientUserId').value;
         const serviceIdForBooking   = document.getElementById('serviceIdForBooking').value;
         const serviceMode   = document.getElementById('serviceMode').value;
         const staffId     = document.getElementById('staffName').value;
         const dateVal     = document.getElementById('appointmentDate').value;
         const name        = document.getElementById('patientName').value.trim();
         const phone       = document.getElementById('patientPhone').value.trim();
         const email       = document.getElementById('patientEmail').value.trim();
         const noteComment       = document.getElementById('noteComment').value.trim();

         if (!serviceId) return Swal.fire({ icon: 'warning', title: 'Missing service', text: 'Please select a service.' });
         if (!staffId) return Swal.fire({ icon: 'warning', title: 'Missing staff', text: 'Please select a staff member.' });
         if (!dateVal) return Swal.fire({ icon: 'warning', title: 'Missing date', text: 'Please pick a date.' });
         if (!selectedSlot) return Swal.fire({ icon: 'warning', title: 'Missing time slot', text: 'Please select a time slot.' });
         if (!name || !phone || !email) return Swal.fire({ icon: 'warning', title: 'Missing patient info', text: 'Please fill name, phone, and email.' });

         Swal.fire({
           title: 'Confirm Booking',
           html:
             '' +
               '<p><strong>Date:</strong> ' + dateVal + '</p>' +
               '<p><strong>Time:</strong> ' + (selectedSlot ? (selectedSlot.start + ' - ' + selectedSlot.end) : '') + '</p>' +
               '<p><strong>Patient Name:</strong> ' + name + '</p>' +
               '<p><strong>Phone:</strong> ' + phone + '</p>' +
               '<p><strong>Email:</strong> ' + email + '</p>' +
             '',
           icon: 'question',
           width: '650px',
           showCancelButton: true,
           confirmButtonText: 'Confirm',
           confirmButtonColor: '#03c4eb',
           cancelButtonColor: '#d33'
         }).then(function (result) {
           if (!result.isConfirmed) return;

           const data = {
             serviceId: serviceIdForBooking,
             serviceMode: serviceMode,
             staffId: staffId,
             date: dateVal,
             slotId: selectedSlot.slotid,
             startTime: selectedSlot.start,
             endTime: selectedSlot.end,
             patientUserId: patientUserId,
             patientName: name,
             patientPhone: phone,
             patientEmail: email,
             noteComment: noteComment
           };

           fetch('create-appointment-booking', {
             method: 'POST',
             headers: { 'Content-Type': 'application/json' },
             body: JSON.stringify(data)
           })
             .then(function (resp) {
               return resp.text().then(function (body) {
                 if (!resp.ok) {
                   // Show server message (500, etc.)
                   throw new Error(body || ('HTTP ' + resp.status));
                 }
                 return body; // booking_status from backend
               });
             })
             .then(function (bookingStatus) {

               Swal.fire('Booked!', bookingStatus || 'The appointment has been booked.', 'success')
               .then(() => {
                           // 🔥 CLOSE MODAL AFTER OK CLICK
                           const modalEl = document.getElementById('bookAppointment');
                           const modalInstance = bootstrap.Modal.getInstance(modalEl);
                           modalInstance.hide();
                           // Optional cleanup
                           document.getElementById("bookingDetail").style.display = "inline-block";
                           document.getElementById('bookingDetail').innerHTML = `<i class="bi bi-calendar-check" style="font-size:1.2em;"> </i> `+bookingStatus;
                         })
             })
             .catch(function (error) {
               Swal.fire('Error!', error.message || 'There was a problem booking the appointment.', 'error');
             });
         });
       }





   //*== SEND PATIENT MESSAGE TO THEIR ACCOUNT   ==*//

       //--- This function will send a message to the patient
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
                        messageFrom: "<c:out value='${ADMIN_SESSION.firstName} ${ADMIN_SESSION.lastName}'/>",
                        messageFromId: "<c:out value='${ADMIN_SESSION.userId}'/>",
                        messageTo: "<c:out value='${patientDetail.getFullName()}'/>",
                        messageToId: "<c:out value='${patientDetail.userId}'/>",
                        messageToEmailId: "<c:out value='${patientDetail.emailId}'/>",
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
                                reloadEhrLogPageForPatient('${patientDetail.userId}');
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





    // ================= VIEW  BOOKING  DETAIL =================
    function viewBookingDetail(bookingId) {
        const form = document.createElement('form');
        form.method = 'POST';
        form.action = 'view-clinic-booking-detail';
        const bookingIdInput = document.createElement('input');
        bookingIdInput.type = 'hidden';
        bookingIdInput.name = 'bookingId';
        bookingIdInput.value = bookingId;

        form.appendChild(bookingIdInput);
        document.body.appendChild(form);
        form.submit();
    }


    //=== CALL PATIENT TO THE ROOM ==//
    async function callPatient(patientInitialWithName ,patientName, roomNumber, accountType ,doctorName) {

       if(accountType === 'ADMIN'){
        accountType = 'Doctor';
       }

       Swal.fire({
         title: 'Loading...',
         text: 'Calling patient .',
         allowOutsideClick: false,
         didOpen: () => {
           Swal.showLoading();
         }
       });

        const payload = {
            patientInitialWithName,
            patientName,
            msgToBecalled:"\n Please Go Room Number  : " + roomNumber +
                " \n to see " + doctorName
        };

        try {

            const response = await fetch(
                "${pageContext.request.contextPath}/call-patient",
                {
                    method: "POST",
                    headers: {
                        "Content-Type": "application/json"
                    },
                    body: JSON.stringify(payload)
                }
            );

            const result = await response.text();

            Swal.fire({
                icon: 'success',
                title: 'Patient Called',
                text: result,
                timer: 4500,
                showConfirmButton: false
            });

        } catch (error) {

            Swal.fire({
                icon: 'error',
                title: 'Failed',
                text: 'Unable to call patient'
            });

            console.error(error);
        }
    }
  </script>




  <style>

        .btn {
            height: 42px;
            align-items: center;      /* Vertically centers the content */
            justify-content: center;  /* Horizontally centers the content (optional) */
        }


          .blinking {
            color: #0000FF;
            animation: blink 1s linear infinite;
          }

          @keyframes blink {
            0% { opacity: 1; }
            50% { opacity: 0.3; }
            100% { opacity: 1; }
          }



       //--  For the booking slots
      .stepper { list-style: none; padding: 0; }
      .step { display: flex; gap: 12px; margin-bottom: 30px; opacity: 0.5; }
      .step.active { opacity: 1; }
      .circle {
        width: 36px; height: 36px; border-radius: 50%;
        background: #e0e0e0; display: flex; align-items: center;
        justify-content: center; font-weight: bold;
      }
      .step.active .circle { background: #FF1493; color: #fff; }


        /* For booking slots */
        .slot-box {
          border: 1px solid #ddd;
          padding: 10px;
          margin-bottom: 10px;
          border-radius: 6px;
          cursor: pointer;
          text-align: center;
          box-shadow: 2px 4px 8px rgba(0,0,0,0.1);
          transition: all 0.3s ease;
        }

        /* Available slots - green color */
        .slot-box.available {
          background:  #D5F7E2; /* Light green background */
          border-color: #c3e6cb;
        }

        .slot-box.available:hover {
          background: #d4edda;
          border-color: #28a745;
          transform: translateY(-2px);
        }

        .slot-box.available.selected {
          background: #28a745;
          border-color: #1e7e34;
          color: white;
        }

        /* Booked slots - red color */
        .slot-box.booked {
          background: #F08989; /* Light red background */
          border-color: #f5c6cb;
          color: #721c24;
          cursor: not-allowed !important;
          opacity: 0.7;
        }

        .slot-box.booked:hover {
          background: #f8d7da; /* Keep same background on hover */
          transform: none; /* Remove hover effect */
        }



     /* Hover wave effect for all buttons */
      .btn {
        position: relative;
        overflow: hidden;
        transition: transform 0.2s ease, box-shadow 0.2s ease;
      }

      .btn:hover {
        transform: translateY(-1px);
        box-shadow: 0 6px 14px rgba(0, 0, 0, 0.15);
      }

      .btn::before {
        content: "";
        position: absolute;
        top: -120%;
        left: -40%;
        width: 30%;
        height: 300%;
        background: linear-gradient(
          120deg,
          rgba(255,255,255,0) 0%,
          rgba(255,255,255,0.35) 50%,
          rgba(255,255,255,0) 100%
        );
        transform: rotate(20deg);
        transition: all 0.0s;
        pointer-events: none;
      }

      .btn:hover::before {
        left: 120%;
        transition: left 0.7s ease;
      }

      /* Optional: accessibility - reduce motion */
      @media (prefers-reduced-motion: reduce) {
        .btn, .btn::before {
          transition: none !important;
          animation: none !important;
        }
      }



    </style>



    </jsp:attribute>
</t:admin_layout>