<%@taglib prefix="t" tagdir="/WEB-INF/tags" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
<%@ page contentType="text/html; charset=UTF-8" %>


<t:admin_layout title=" GP Home ">
    <jsp:attribute name="body_area">


        <!-- Custom Styles -->
        <style>
        .nav-tabs-custom {
          border-bottom: 2px solid #dee2e6;
        }

        .nav-tabs-custom .nav-link {
          display: flex;
          align-items: center;
          gap: 6px;
          border: none;
          color: #6c757d;
          font-weight: 500;
          padding: 10px 16px;
          transition: all 0.3s ease;
        }

        .nav-tabs-custom .nav-link i {
          font-size: 1rem;
        }

        /* Hover effect */
        .nav-tabs-custom .nav-link:hover {
          color: #0d6efd;
          background-color: #f8f9fa;
          border-radius: 6px;
        }

        /* Active tab */
        .nav-tabs-custom .nav-link.active {
          border-bottom: 3px solid;
          font-weight: 600;
          background-color: transparent;
        }

        /* Individual colors */
        .nav-tabs-custom .nav-link.all.active {
          color: #0d6efd;
          border-color: #0d6efd;
        }

        .nav-tabs-custom .nav-link.unprocessed.active {
          color: #F54927;
          border-color: #F54927;
        }

        .nav-tabs-custom .nav-link.my-assigned.active {
          color: #FF1FE9;
          border-color: #FF1FE9;
        }

        .nav-tabs-custom .nav-link.pending.active {
          color: #E12AFB;
          border-color: #E12AFB;
        }

        .nav-tabs-custom .nav-link.completed.active {
          color: #198754;
          border-color: #198754;
        }
        </style>


      <main id="main" class="main">

        <div class="pagetitle">
          <nav>
            <ol class="breadcrumb">
              <li class="breadcrumb-item"> <a href="admin-home"> Home </a> </li>
              <li class="breadcrumb-item active">Patient Documents </li>
            </ol>
          </nav>
        </div><!-- End Page Title -->


    <div class="card">
        <div class="card-body pt-3">

            <!--FIRST ROW FOR THE ADDING XML AND PDF FILE  -->
            <div class="row">
               <div class="col-12">


                        <form name="patientDocument" id="patientDocument" action="manage-patient-documents" method="post" enctype="multipart/form-data" >

                            <div class="card-body d-flex justify-content-between align-items-center">
                                <h5 class="card-title mb-0"><i class="bi bi-file-earmark-pdf" style="font-size:1.4em;color: #FF1493;"> </i> Manage Patient Documents</h5>
                                <div>
                                    <button type="button" class="btn btn-info btn-sm me-3" onclick="document.getElementById('fileUpload').click()">
                                        <i class="bi bi-plus-circle" style="font-size:1.2em;"></i> Add Health link XML
                                    </button>
                                    <input type="file" id="fileUpload" name="cfile" multiple accept=".pdf,.xml" style="display: none;" onchange="handleFiles(this.files)" >
                                     <button type="button" class="btn btn-warning btn-sm" onclick="document.getElementById('OfficefileUpload').click()">
                                        <i class="bi bi-printer" style="font-size:1.2em;"></i> Add Document | Scanner (PDF)
                                    </button>
                                </div>
                            </div>

                        </form>

               </div>
           </div>
           <!--END OF FIRST ROW FOR THE ADDING XML AND PDF FILE  -->




           <!--START OF MULTIPLE TAB TO RENDER DOCUMENT LIST  -->
           <div class="row">
                <div class="col-xl-12">


                            <!-- Tabs -->
                            <ul class="nav nav-tabs nav-tabs-custom" role="tablist">

                              <li class="nav-item me-4">
                                <button class="nav-link active all" data-bs-toggle="tab" data-bs-target="#all-documents">
                                  <i class="bi bi-folder2-open" style="font-size:1.6em;"></i> All Documents
                                </button>
                              </li>

                             <li class="nav-item me-4">
                                <button class="nav-link my-assigned" data-bs-toggle="tab" data-bs-target="#my-assigned">
                                  <i class="bi bi-pencil-square" style="font-size:1.6em;"></i> My Assigned
                                </button>
                              </li>

                             <li class="nav-item me-4">
                                <button class="nav-link unprocessed" data-bs-toggle="tab" data-bs-target="#un-processed">
                                  <i class="bi bi-file-earmark-minus" style="font-size:1.6em;"></i> Unprocessed
                                </button>
                              </li>

                              <li class="nav-item me-4">
                                <button class="nav-link pending" data-bs-toggle="tab" data-bs-target="#pending-review">
                                  <i class="bi bi-hourglass-split" style="font-size:1.6em;"></i> GP - Pending Review
                                </button>
                              </li>

                              <li class="nav-item me-4">
                                <button class="nav-link completed" data-bs-toggle="tab" data-bs-target="#completed">
                                  <i class="bi bi-check-circle" style="font-size:1.6em;"></i> Completed
                                </button>
                              </li>

                            </ul>

                            <div class="tab-content pt-2">

                                <!--START OF FIRST TAB  -->
                                <div class="tab-pane fade show active all-documents" id="all-documents">
                                        <table class="table table-borderless datatable">
                                            <thead>
                                              <tr>
                                                <th scope="col"> Patient detail </th>
                                                <th scope="col"> Type   </th>
                                                <th scope="col"> Added On   </th>
                                                <th scope="col"> Assign To </th>
                                                <th scope="col"> Status  </th>
                                                <th scope="col"> Action Date </th>
                                                <!-- <th scope="col"> Update </th> -->
                                                <th scope="col"> Action Plan   </th>
                                                <th scope="col"> Remove </th>
                                              </tr>
                                            </thead>
                                              <tbody>
                                                <c:forEach var="dataObject" items="${documentList}" begin="0" end="10000">
                                                    <tr>

                                                        <td align="left"> <a  href="Javascript:void();" onclick="openUpdateDocumentPage('${dataObject.documentId}');"> <img src="assets/img/pdf.png"> &nbsp;${dataObject.firstName}  ${dataObject.lastName}  </a> </td>
                                                        <td> <i class="fa fa-flask" style="color:blue"></i> <a  href="Javascript:void();" onclick="openUpdateDocumentPage('${dataObject.documentId}');">  &nbsp;${dataObject.testType} </a></td>
                                                        <td> <a  href="Javascript:void();" onclick="openUpdateDocumentPage('${dataObject.documentId}');">  ${dataObject.getCreateDateFormatted()} </a></td>
                                                        <td> ${dataObject.gpName}</td>
                                                        <td>
                                                            <c:if test="${dataObject.requestStatus.contains('New')}">
                                                              <span class="badge bg-info">
                                                               <i class="bi bi-exclamation-circle" style="font-size:1.3em;"></i> New
                                                              </span>
                                                            </c:if>

                                                            <c:if test="${dataObject.requestStatus.contains('In Process')}">
                                                               <span class="badge" style="background-color:#F54927;color:white;">
                                                                 <i class="bi bi-file-earmark-minus" style="font-size:1.3em;"></i> Un Processed
                                                               </span>
                                                            </c:if>

                                                            <c:if test="${dataObject.requestStatus.contains('Assigned to GP')}">
                                                               <span class="badge" style="background-color:#E12AFB;color:white;">
                                                                 <i class="bi bi-hourglass-split" style="font-size:1.3em;"></i> GP - Pending Review
                                                               </span>
                                                            </c:if>

                                                            <c:if test="${dataObject.requestStatus.contains('Completed')}">
                                                               <span class="badge bg-success">
                                                                 <i class="bi bi-check-circle" style="font-size:1.3em;"></i> Completed
                                                               </span>
                                                            </c:if>

                                                            <c:if test="${dataObject.requestStatus.contains('Processed')}">
                                                               <span class="badge bg-success">
                                                                 <i class="bi bi-check-circle" style="font-size:1.3em;"></i> Completed
                                                               </span>
                                                            </c:if>

                                                        </td>

                                                        <td> ${dataObject.getActionDateFormatted()}</td>

                                                        <td >
                                                            <a href="Javascript:void();" onclick="openActionPlanPage('${dataObject.documentId}')">
                                                             <i class="bi bi-pencil-square"  style="color:blue"> </i>
                                                             <span  style="color:blue"> Action Plan </span>
                                                            </a>
                                                        </td>

                                                        <td >
                                                            <a href="Javascript:void();" onClick="removeThisDocument('${dataObject.documentId}');">
                                                            <i class="bi bi-trash3" style="color:red"></i>
                                                            <span style="color:red"> Rem </span>
                                                            </a>
                                                        </td>
                                                    </tr>

                                                </c:forEach>
                                                </tbody>
                                        </table>
                                </div>
                                <!-- END OF FIRST TAB -->





                                 <!-- START OF MY ASSIGNED  TAB -->
                                <div class="tab-pane fade my-assigned" id="my-assigned">
                                        <table class="table table-borderless datatable">
                                            <thead>
                                              <tr>
                                                <th scope="col"> Patient detail </th>
                                                <th scope="col"> Type   </th>
                                                <th scope="col"> Added On   </th>
                                                <th scope="col"> Assign To </th>
                                                <th scope="col"> Status  </th>
                                                <th scope="col"> Action Date </th>
                                                <th scope="col"> Action Plan   </th>

                                              </tr>
                                            </thead>
                                              <tbody>
                                                    <c:forEach var="dataObject" items="${documentList}" begin="0" end="10000">

                                                      <c:if test="${dataObject.requestStatus.contains('Assigned to GP') && fn:toLowerCase(dataObject.gpName).contains(fn:toLowerCase(ADMIN_SESSION.getFullName()))}">

                                                              <tr>
                                                                <td align="left"> <a  href="Javascript:void();" onclick="openUpdateDocumentPage('${dataObject.documentId}');"> <img src="assets/img/pdf.png"> &nbsp;${dataObject.firstName}  ${dataObject.lastName}  </a> </td>
                                                                <td> <i class="fa fa-flask" style="color:blue"></i> <a  href="Javascript:void();" onclick="openUpdateDocumentPage('${dataObject.documentId}');">  &nbsp;${dataObject.testType} </a></td>
                                                                <td> ${dataObject.getCreateDateFormatted()}</td>
                                                                <td> ${dataObject.gpName}</td>
                                                                <td>
                                                                   <span class="badge" style="background-color:#E12AFB;color:white;">
                                                                     <i class="bi bi-hourglass-split" style="font-size:1.3em;"></i> GP - Pending Review
                                                                   </span>
                                                                </td>
                                                                <td> ${dataObject.getActionDateFormatted()}</td>
                                                                <td >
                                                                    <a href="Javascript:void();" onclick="openActionPlanPage('${dataObject.documentId}')">
                                                                     <i class="bi bi-pencil-square"  style="color:blue"> </i>
                                                                     <span  style="color:blue"> Action Plan </span>
                                                                    </a>
                                                                </td>
                                                            </tr>
                                                    </c:if>

                                                    </c:forEach>
                                                </tbody>
                                        </table>

                                </div>
                                 <!-- END OF MY ASSIGNED TAB -->


                                 <!-- START OF SECOND  TAB -->
                                <div class="tab-pane fade un-processed" id="un-processed">
                                        <table class="table table-borderless datatable">
                                            <thead>
                                              <tr>
                                                <th scope="col"> Patient detail </th>
                                                <th scope="col"> Type   </th>
                                                <th scope="col"> Added On   </th>
                                                <th scope="col"> Assign To </th>
                                                <th scope="col"> Status  </th>
                                                <th scope="col"> Action Date </th>
                                                <th scope="col"> Action Plan   </th>

                                              </tr>
                                            </thead>
                                              <tbody>
                                                <c:forEach var="dataObject" items="${documentList}" begin="0" end="10000">

                                                     <c:if test="${dataObject.requestStatus.contains('New') || dataObject.requestStatus.contains('In Process')}">

                                                        <tr>
                                                            <td align="left"> <a  href="Javascript:void();" onclick="openUpdateDocumentPage('${dataObject.documentId}');"> <img src="assets/img/pdf.png"> &nbsp;${dataObject.firstName}  ${dataObject.lastName}  </a> </td>
                                                            <td> <i class="fa fa-flask" style="color:blue"></i> <a  href="Javascript:void();" onclick="openUpdateDocumentPage('${dataObject.documentId}');">  &nbsp;${dataObject.testType} </a></td>
                                                            <td> ${dataObject.getCreateDateFormatted()}</td>
                                                            <td> ${dataObject.gpName}</td>
                                                            <td>
                                                                <c:if test="${dataObject.requestStatus.contains('New')}">
                                                                  <span class="badge bg-info">
                                                                   <i class="bi bi-exclamation-circle" style="font-size:1.3em;"></i> New
                                                                  </span>
                                                                </c:if>

                                                                <c:if test="${dataObject.requestStatus.contains('In Process')}">
                                                                   <span class="badge" style="background-color:#F54927;color:white;">
                                                                     <i class="bi bi-file-earmark-minus" style="font-size:1.3em;"></i> Un Processed
                                                                   </span>
                                                                </c:if>
                                                            </td>

                                                            <td> ${dataObject.getActionDateFormatted()}</td>

                                                            <td >
                                                                <a href="Javascript:void();" onclick="openActionPlanPage('${dataObject.documentId}')">
                                                                 <i class="bi bi-pencil-square"  style="color:blue"> </i>
                                                                 <span  style="color:blue"> Action Plan </span>
                                                                </a>
                                                            </td>
                                                        </tr>
                                                     </c:if>

                                                </c:forEach>
                                                </tbody>
                                        </table>

                                </div>
                                 <!-- END OF SECOND TAB -->




                                <!-- START OF THIRD TAB -->
                                <div class="tab-pane fade pending-review" id="pending-review">
                                        <table class="table table-borderless datatable">
                                            <thead>
                                              <tr>
                                                <th scope="col"> Patient detail </th>
                                                <th scope="col"> Type   </th>
                                                <th scope="col"> Added On   </th>
                                                <th scope="col"> Assign To </th>
                                                <th scope="col"> Status  </th>
                                                <th scope="col"> Action Date </th>
                                                <th scope="col"> Action Plan   </th>

                                              </tr>
                                            </thead>
                                              <tbody>
                                                <c:forEach var="dataObject" items="${documentList}" begin="0" end="10000">

                                                     <c:if test="${dataObject.requestStatus.contains('Assigned to GP')}">

                                                        <tr>
                                                            <td align="left"> <a  href="Javascript:void();" onclick="openUpdateDocumentPage('${dataObject.documentId}');"> <img src="assets/img/pdf.png"> &nbsp;${dataObject.firstName}  ${dataObject.lastName}  </a> </td>
                                                            <td> <i class="fa fa-flask" style="color:blue"></i> <a  href="Javascript:void();" onclick="openUpdateDocumentPage('${dataObject.documentId}');">  &nbsp;${dataObject.testType} </a></td>
                                                            <td> ${dataObject.getCreateDateFormatted()}</td>
                                                            <td> ${dataObject.gpName}</td>
                                                            <td>
                                                               <span class="badge" style="background-color:#E12AFB;color:white;">
                                                                 <i class="bi bi-hourglass-split" style="font-size:1.3em;"></i> GP - Pending Review
                                                               </span>
                                                            </td>
                                                            <td> ${dataObject.getActionDateFormatted()}</td>
                                                            <td >
                                                                <a href="Javascript:void();" onclick="openActionPlanPage('${dataObject.documentId}')">
                                                                 <i class="bi bi-pencil-square"  style="color:blue"> </i>
                                                                 <span  style="color:blue"> Action Plan </span>
                                                                </a>
                                                            </td>
                                                        </tr>
                                                     </c:if>

                                                </c:forEach>
                                                </tbody>
                                        </table>

                                </div>
                                <!-- END OF THIRD TAB -->



                                <!-- START OF FOURTH TAB -->
                                <div class="tab-pane fade completed" id="completed">
                                        <table class="table table-borderless datatable">
                                            <thead>
                                              <tr>
                                                <th scope="col"> Patient detail </th>
                                                <th scope="col"> Type   </th>
                                                <th scope="col"> Added On   </th>
                                                <th scope="col"> Assign To </th>
                                                <th scope="col"> Status  </th>
                                                <th scope="col"> Action Date </th>
                                              </tr>
                                            </thead>
                                              <tbody>
                                                <c:forEach var="dataObject" items="${documentList}" begin="0" end="10000">

                                                     <c:if test="${dataObject.requestStatus.contains('Completed')}">

                                                        <tr>
                                                            <td align="left"> <a  href="Javascript:void();" onclick="openUpdateDocumentPage('${dataObject.documentId}');"> <img src="assets/img/pdf.png"> &nbsp;${dataObject.firstName}  ${dataObject.lastName}  </a> </td>
                                                            <td> <i class="fa fa-flask" style="color:blue"></i> <a  href="Javascript:void();" onclick="openUpdateDocumentPage('${dataObject.documentId}');">  &nbsp;${dataObject.testType} </a></td>
                                                            <td> ${dataObject.getCreateDateFormatted()}</td>
                                                            <td> ${dataObject.gpName}</td>
                                                            <td>
                                                               <span class="badge bg-success">
                                                                 <i class="bi bi-check-circle" style="font-size:1.3em;"></i> Completed
                                                               </span>
                                                            </td>
                                                            <td> ${dataObject.getActionDateFormatted()}</td>
                                                        </tr>
                                                     </c:if>

                                                </c:forEach>
                                                </tbody>
                                        </table>

                                </div>
                                <!-- END OF FOURTH TAB -->

                        </div>
                </div>
           </div>
          </div>
          <!--END  OF MULTIPLE TAB TO RENDER DOCUMENT LIST  -->




  </div>
 </div>






      </main><!-- End #main -->

    <!-- Form to upload office documents (PDF) -->
    <form name="officeDocument" id="officeDocument" action="add-office-documents" method="post" enctype="multipart/form-data">
       <input  type="file" id="OfficefileUpload"   name="OfficefileUpload" multiple accept=".pdf" style="display: none;"   onchange="addClinicPdfFile(this.files)" >
    </form>

    <c:if test="${not empty error}">
        <script>
            document.addEventListener("DOMContentLoaded", function() {
                Swal.fire({
                    title: 'Upload Error',
                    text: '${fn:escapeXml(error)}',
                    icon: 'error',
                    confirmButtonText: 'OK'
                });
            });
        </script>
    </c:if>



      <script>
            // Existing button click listener
            document.getElementById('customSearchBtn').addEventListener('click', function() {
               // Show spinner loader
               var searchBtn = document.getElementById('customSearchBtn');
               searchBtn.innerHTML = '<span class="spinner"></span> &nbsp; Searching...';
               searchBtn.disabled = true; // prevent double-clicks


                var searchValue = document.getElementById('customSearchBox').value.trim();
                if (searchValue) {
                    window.location.href = "manage-patient-documents?search=" + searchValue;
                } else {
                    window.location.href = "manage-patient-documents"; // Redirect to the default page if search is empty
                }
            });

            // Add Enter key listener for the search box
            document.getElementById('customSearchBox').addEventListener('keydown', function(event) {
                if (event.key === 'Enter') {
                    var searchValue = this.value.trim();
                    if (searchValue) {
                        window.location.href = "manage-patient-documents?search=" + searchValue;
                    } else {
                        window.location.href = "manage-patient-documents"; // Redirect to the default page if search is empty
                    }
                }
            });





            function removeThisDocument(documentId) {
                Swal.fire({
                    title: 'Are you sure?',
                    text: "You are about to delete this document!",
                    icon: 'warning',
                    showCancelButton: true,
                    confirmButtonColor: '#3085d6',
                    cancelButtonColor: '#d33',
                    confirmButtonText: 'Yes, delete it!',
                    cancelButtonText: 'Cancel',
                    allowOutsideClick: false
                }).then((result) => {
                    if (result.isConfirmed) {
                        Swal.fire({
                            title: 'Deleting...',
                            html: 'Please wait while we remove the document.',
                            allowOutsideClick: false,
                            didOpen: () => {
                                Swal.showLoading();
                            }
                        });

                        // Redirect to the delete action
                        window.location.href = "manage-patient-documents?delDocumentId=" + documentId;
                    }
                });
            }

            function handleFiles(files) {
                if (files.length > 0) {
                    // Validate file types (only allow PDF)
                    const invalidFiles = Array.from(files).filter(file =>
                        (file.type !== 'text/xml' && !file.name.toLowerCase().endsWith('.xml'))
                    );

                    if (invalidFiles.length > 0) {
                        Swal.fire({
                            title: 'Invalid File Type',
                            text: 'Only XML files are allowed. Please select XML files only.',
                            icon: 'error',
                            confirmButtonText: 'OK'
                        });
                        // Clear selected files
                        document.getElementById('fileUpload').value = '';
                        return;
                    }

                    Swal.fire({
                        title: 'Are you sure?',
                        text: "You are about to upload " + files.length + " XML file !",
                        icon: 'question',
                        showCancelButton: true,
                        confirmButtonColor: '#3085d6',
                        cancelButtonColor: '#d33',
                        confirmButtonText: 'Yes, upload!',
                        cancelButtonText: 'Cancel',
                        allowOutsideClick: false
                    }).then((result) => {
                        if (result.isConfirmed) {
                            Swal.fire({
                                title: 'Uploading...',
                                html: 'Please wait while we process your XML files.',
                                allowOutsideClick: false,
                                didOpen: () => {
                                    Swal.showLoading();
                                }
                            });

                            document.patientDocument.method = "POST";
                            document.patientDocument.action = "manage-patient-documents";
                            document.patientDocument.submit();
                        } else {
                            document.getElementById('fileUpload').value = '';
                        }
                    });
                }
            }

            //-- ADD SCANNER DOCUMENT --//
            function addClinicPdfFile(files) {
                if (files.length > 0) {
                    // Validate file types (only allow PDF)
                    const invalidFiles = Array.from(files).filter(file =>
                        (file.type !== 'text/xml' && !file.name.toLowerCase().endsWith('.pdf'))
                    );

                    if (invalidFiles.length > 0) {
                        Swal.fire({
                            title: 'Invalid File Type',
                            text: 'Only PDF files are allowed. Please select PDF files only.',
                            icon: 'error',
                            confirmButtonText: 'OK'
                        });
                        // Clear selected files
                        document.getElementById('fileUpload').value = '';
                        return;
                    }

                    Swal.fire({
                        title: 'Are you sure?',
                        text: "You are about to upload " + files.length + " PDF file !",
                        icon: 'question',
                        showCancelButton: true,
                        confirmButtonColor: '#3085d6',
                        cancelButtonColor: '#d33',
                        confirmButtonText: 'Yes, upload!',
                        cancelButtonText: 'Cancel',
                        allowOutsideClick: false
                    }).then((result) => {
                        if (result.isConfirmed) {
                            Swal.fire({
                                title: 'Uploading...',
                                html: 'Please wait while we process your PDF files.',
                                allowOutsideClick: false,
                                didOpen: () => {
                                    Swal.showLoading();
                                }
                            });

                            document.officeDocument.method = "POST";
                            document.officeDocument.action = "add-office-documents";
                            document.officeDocument.submit();
                        } else {
                            document.getElementById('OfficefileUpload').value = '';
                        }
                    });
                }
            }




        //** RENDER PAGE WHERE YOU CAN UPDATE DOCUMENT DETAIL *****//
        function openUpdateDocumentPage(documentId){
             const form = document.createElement('form');
             form.method = 'POST';
             form.action = 'update-manually-added-document';
             const documentIdInput = document.createElement('input');
             documentIdInput.type = 'hidden';
             documentIdInput.name = 'documentId';
             documentIdInput.value = documentId;
             form.appendChild(documentIdInput);
             document.body.appendChild(form);
             form.submit();
        }


        //** RENDER PAGE WHERE YOU CAN PERFORM VARIOUS ACTION  *****//
        function openActionPlanPage(documentId){
             const form = document.createElement('form');
             form.method = 'POST';
             form.action = 'paitent-document-analysis';
             const documentIdInput = document.createElement('input');
             documentIdInput.type = 'hidden';
             documentIdInput.name = 'documentId';
             documentIdInput.value = documentId;
             form.appendChild(documentIdInput);
             document.body.appendChild(form);
             form.submit();
        }

      </script>


        <script>
        (function () {
          function activateRequestedTab() {
            var targetId = window.location.hash; // e.g. #pending-review
            console.log("hash =", targetId);

            if (!targetId) return;

            var trigger = document.querySelector(
              '[data-bs-toggle="tab"][data-bs-target="' + targetId + '"]'
            );

            console.log("trigger =", trigger);

            if (!trigger) return;

            // Bootstrap 5 safe init
            var tab = bootstrap.Tab.getOrCreateInstance(trigger);
            tab.show();
          }

          // Run now (in case DOM already loaded) and on DOMContentLoaded
          if (document.readyState === "loading") {
            document.addEventListener("DOMContentLoaded", activateRequestedTab);
          } else {
            activateRequestedTab();
          }

          // Also run on full load (fallback if content is injected late)
          window.addEventListener("load", activateRequestedTab);
        })();
        </script>

     <!-- Hide default search box from data table   -->
     <style>

            .spinner {
                        width: 18px;
                        height: 18px;
                        border: 3px solid #ccc;
                        border-top: 3px solid #007bff;
                        border-radius: 50%;
                        display: inline-block;
                        animation: spin 0.8s linear infinite;
                        vertical-align: middle;
                    }
                    @keyframes spin {
                        100% { transform: rotate(360deg); }
                    }

     </style>

    </jsp:attribute>
</t:admin_layout>



