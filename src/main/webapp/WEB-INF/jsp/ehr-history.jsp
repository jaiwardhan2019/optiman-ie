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
      <h2 class="accordion-header" id="headingOne">
        <button class="accordion-button" type="button" data-bs-toggle="collapse" data-bs-target="#collapseOne" aria-expanded="false" aria-controls="collapseOne">
          <h5> <i class="bi bi-file-medical" style="font-size:1.4em;color:#FF1493;"> </i> <b> Health  summary </b> </h5>
        </button>
      </h2>
        <div id="collapseOne" class="accordion-collapse collapse" aria-labelledby="headingOne" data-bs-parent="#accordionExample">
            <div class="accordion-body">
                    <!-- START OF FIRST ROW  -->
                    <div class="row g-3">

                      <div class="col-md-4" style="border-right:1px solid #ddd;">
                        <label class="mb-1"  style="color: #1C398E;"><i class="bi  bi-heart-pulse"> </i> <strong> Problem </strong></label>
                            <hr>
                            <div oninput="autoResize(this)">
                             <small style="color:blue;font-size:0.8em;">
                              <table style="font-size:0.8em;" width="100%">
                                  <c:forEach var="mc" items="${patientEhr.patientDetail.medicalConditions}">
                                     <tr>
                                       <td width="80%">- ${fn:trim(mc.conditionName)}</td>
                                       <td align="left">${fn:trim(mc.status)}</td>
                                     </tr>
                                  </c:forEach>
                              </table>
                            </small>
                            </div>
                      </div>

                      <div class="col-md-4" style="border-right:1px solid #ddd;">
                        <label class="mb-1" style="color: #1C398E;"><i class="bi bi-virus2"> </i> <strong> Allergies </strong></label>
                            <hr>
                            <div oninput="autoResize(this)">
                             <small style="color:blue;font-size:0.8em;">
                              <table style="font-size:0.8em;" width="100%">
                              <table>
                                  <c:forEach var="mc" items="${patientEhr.patientDetail.allergies}">
                                     <tr>
                                       <td width="90%">- ${fn:trim(mc.mainGroup)} / ${fn:trim(mc.allergen)}</td>
                                       <td align="left">&nbsp;${fn:trim(mc.severity)}</td>
                                     </tr>
                                  </c:forEach>
                              </table>
                              </small>
                            </div>
                      </div>

                      <div class="col-md-4" style="border-right:1px solid #ddd;">
                        <label class="mb-1"  style="color: #1C398E;"><i class="bi bi-capsule-pill"> </i> <strong> Repeat Medications </strong></label>
                            <hr>
                            <div oninput="autoResize(this)">
                             <small style="color:blue;font-size:0.8em;">
                              <table style="font-size:0.8em;" width="100%">
                              <table>
                                  <c:forEach var="mc" items="${patientEhr.patientDetail.repeatMedication}">
                                     <tr>
                                       <td>- ${fn:trim(mc.medicationName)}</td>
                                     </tr>
                                  </c:forEach>
                              </table>
                            </small>
                            </div>
                      </div>
                    </div>
                    <!-- END OF FIRST ROW  -->
               <hr/>

                    <!-- START OF SECOND ROW  -->
                    <div class="row g-3">

                      <div class="col-md-4" style="border-right:1px solid #ddd;">
                        <label class="mb-1"  style="color: #1C398E;"><i class="bi  bi-heart-pulse"> </i> <strong> Family Health </strong></label>
                            <hr>
                            <div oninput="autoResize(this)">
                              <table>
                                  <c:forEach var="mc" items="${patientEhr.patientDetail.medicalConditions}">
                                     <tr>
                                       <td width="80%"></td>
                                       <td align="left"></td>
                                     </tr>
                                  </c:forEach>
                              </table>
                            </div>
                      </div>

                      <div class="col-md-8" style="border-right:1px solid #ddd;">
                        <label class="mb-1" style="color: #1C398E;"><i class="bi bi-virus2"> </i> <strong> Past Surgical History </strong></label>
                            <hr>
                            <div oninput="autoResize(this)">
                              <table>
                                  <c:forEach var="mc" items="${patientEhr.patientDetail.allergies}">
                                     <tr>
                                       <td width="90%"></td>
                                       <td align="left">&nbsp;</td>
                                     </tr>
                                  </c:forEach>
                              </table>
                            </div>
                      </div>
                    </div>
                    <!-- END OF SECOND ROW  -->


            </div>
        </div>
    </div>
  </div>
<!-- ===========END OF FIRST ACCORDIAN =========== -->
<br>


<!-- ===========START OF SECOND ACCORDIAN =========== -->
 <div class="accordion" id="accordionExample">
    <div class="accordion-item" style="box-shadow:2px 4px 8px rgba(0, 0, 0, 0.1);">
      <h2 class="accordion-header" id="headingTwo">
        <button class="accordion-button" type="button" data-bs-toggle="collapse" data-bs-target="#collapseTwo" aria-expanded="false" aria-controls="collapseTwo">
          <h5> <i class="bi bi-file-medical" style="font-size:1.4em;color:#FF1493;"> </i> <b> Health History </b> </h5>
        </button>
      </h2>

      <div id="collapseTwo" class="accordion-collapse collapse" aria-labelledby="headingTwo" data-bs-parent="#accordionExample">
        <div class="accordion-body">
             <!-- =========================== -->
             <!-- PROBLEMS SECTION -->
             <!-- =========================== -->
             <section class="ips-table-section">

                 <h2 class="ips-table-title"><i class="bi  bi-heart-pulse" style="font-size:1.4em;color: #FF1493;"></i>
                    Problems / Conditions
                    </h2>
                  <table class="ips-table">
                     <thead>
                         <tr>
                             <th>Condition Name</th>
                             <th>Severity</th>
                             <th>Is Cronic</th>
                             <th>Since</th>
                             <th>Status</th>
                             <th> Note | Comment </th>

                         </tr>
                     </thead>

                     <tbody>
                        <c:forEach var="mc" items="${patientEhr.patientDetail.medicalConditions}">
                         <tr>
                             <td>${mc.conditionName}</td>
                             <td> ${mc.severity} </td>
                             <td> ${mc.isChronic} </td>
                             <td>
                                     <script>
                                         function renderToDate(dateString) {
                                           if (!dateString) return '';
                                           const [y, m, d] = dateString.split('-');   // expects "yyyy-MM-dd"
                                           return d +'/'+ m +'/'+ y;
                                         }
                                         // Call the function
                                         document.write(renderToDate('${mc.diagnosedDate}'));
                                     </script>
                             </td>
                             <td> ${mc.status} </td>
                             <td>
                                 <a href="Javascript:void();" title="${mc.notes}">
                                     <span style="color:blue"> View  </span>
                                 </a>
                             </td>

                         </tr>
                        </c:forEach>

                        <c:if test="${empty patientEhr.patientDetail.medicalConditions}">
                            <tr>
                                 <td colspan="7" align="center"> No medical conditions recorded. !!!  </td>
                            </tr>
                        </c:if>


                     </tbody>
                 </table>
             </section>




            <!-- =========================== -->
            <!-- ALLERGIES SECTION -->
            <!-- =========================== -->
            <section class="ips-table-section">
                <h2 class="ips-table-title">
                    <i class="bi bi-virus2" style="font-size:1.4em;color: #5EA529;"></i>
                    Allergies & Intolerances
                </h2>

                <table class="ips-table">
                    <thead>
                        <tr>
                            <th>Group</th>
                            <th>Substance</th>
                            <th>Reaction</th>
                            <th>Criticality</th>
                            <th>Since</th>
                            <th>Note | Comment </th>
                        </tr>
                    </thead>
                    <tbody>
                     <c:forEach var="allergyObj" items="${patientEhr.patientDetail.allergies}">
                        <tr>
                            <td>
                                <c:if test="${allergyObj.mainGroup == 'Medicine'}">
                                    <i class="bi bi-capsule-pill" style="font-size:1.4em;color: #FF1493;"></i>
                                </c:if>
                                <c:if test="${allergyObj.mainGroup == 'General'}">
                                    <i class="bi bi-lungs" style="font-size:1.4em;color: #FF1493;"></i>
                                </c:if>
                               ${allergyObj.mainGroup}
                            </td>
                            <td>${allergyObj.allergen}</td>
                            <td>${allergyObj.reaction}</td>
                            <td>${allergyObj.severity}</td>
                            <td>
                              ${allergyObj.getFormattedAllergyDate()}
                            </td>

                                <td>
                                   <a href="Javascript:void();" title="${allergyObj.notes}">
                                        <span style="color:blue;"> View</span>
                                   </a>
                                </td>

                        </tr>
                     </c:forEach>

                    <c:if test="${empty patientEhr.patientDetail.allergies}">
                        <tr>
                            <td colspan="4" align="center"> No allergies recorded. !!! </td>
                        </tr>
                    </c:if>

                    </tbody>
                </table>
            </section>


            <!-- =========================== -->
            <!-- MEDICATIONS SECTION -->
            <!-- =========================== -->
            <section class="ips-table-section">

                <h2 class="ips-table-title"><i class="bi bi-capsule-pill" style="font-size:1.4em;color: #FF1493;"></i>
                    Repeat Medications
                 </h2>

                <table class="ips-table">
                    <thead>
                        <tr>
                            <th>Qty.</th>
                            <th>Prescription</th>
                            <th>Dosage</th>
                            <th>Start From Date </th>
                            <th> Date </th>
                            <th> Note | Comment </th>
                        </tr>
                    </thead>

                    <tbody>

                        <c:forEach var="medicationObj" items="${patientEhr.patientDetail.repeatMedication}">
                            <tr>
                                <td>${medicationObj.quantityPerDispense}</td>
                                <td>${medicationObj.medicationName}</td>
                                <td>${medicationObj.dosage}</td>
                                <td>${medicationObj.getFormattedStartDate()}</td>
                                <td>
                                    ${medicationObj.getFormattedCreatedDate()}
                                </td>
                                <td>
                                   <a href="Javascript:void();" title="${medicationObj.medicationName}">
                                        <span style="color:blue;"> View</span>
                                   </a>
                                </td>
                            </tr>
                        </c:forEach>

                        <c:if test="${empty patientEhr.patientDetail.repeatMedication}">
                            <tr>
                                <td colspan="5" align="center"> No repeat medications recorded. !!! Please use link above Add New. </td>
                            </tr>
                        </c:if>
                    </tbody>
                </table>
            </section>
        </div>
      </div>
    </div>
 </div>
 <br/>

 <!-- ===========START OF THIRD ACCORDIAN =========== -->
 <div class="accordion" id="accordionExample">
    <div class="accordion-item" style="box-shadow:2px 4px 8px rgba(0, 0, 0, 0.1);">
        <h2 class="accordion-header" id="headingThree">
            <button class="accordion-button" type="button" data-bs-toggle="collapse" data-bs-target="#collapseThree" aria-expanded="false" aria-controls="collapseThree">
                <h5> <i class="bi bi-graph-up-arrow" style="font-size:1.4em;color:#FF1493;"> </i> <b> Health Trends Report (BMI & Blood Pressure) </b> </h5>
            </button>
        </h2>
        <div id="collapseThree" class="accordion-collapse collapse" aria-labelledby="headingThree" data-bs-parent="#accordionExample">
            <div class="accordion-body">

                <!-- START OF FIRST ROW  -->
                <div class="row g-3">
                    <div class="col-lg-12 col-md-12">
                        <div id="bmiChart"></div>
                        <hr>
                        <div id="bpChart"></div>
                    </div>
                </div>
                <!-- END OF FIRST ROW  -->
            </div>
        </div>
    </div>
</div>
<!-- ===========END OF THIRD ACCORDIAN =========== -->
<br>

 <!-- ===========START OF FOURTH ACCORDIAN =========== -->
 <div class="accordion" id="accordionExample">
    <div class="accordion-item" style="box-shadow:2px 4px 8px rgba(0, 0, 0, 0.1);">
        <h2 class="accordion-header" id="headingFour">
            <button class="accordion-button" type="button" data-bs-toggle="collapse" data-bs-target="#collapseFour" aria-expanded="false" aria-controls="collapseFour">
                <h5> <i class="bi bi-shield-check" style="font-size:1.4em;color:#FF1493;"> </i> <b> Patient Insurance Detail  </b> </h5>
            </button>
        </h2>
        <div id="collapseFour" class="accordion-collapse collapse" aria-labelledby="headingFour" data-bs-parent="#accordionExample">
            <div class="accordion-body">

                <!-- START OF FIRST ROW  -->
                <div class="row g-3">
                    <div class="col-lg-12 col-md-12">
                       <p> Insurance company detail &&  Communication </p>
                    </div>
                </div>
                <!-- END OF FIRST ROW  -->
            </div>
        </div>
    </div>
</div>
<!-- ===========END OF FOURTH ACCORDIAN =========== -->
<br>




<hr>

<script src="assets-admin/js/manage-ehr.js?v=105" defer></script>