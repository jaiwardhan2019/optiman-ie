<%@taglib prefix="t" tagdir="/WEB-INF/tags" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
<%@ page contentType="text/html; charset=UTF-8" %>
<%@taglib prefix="t" tagdir="/WEB-INF/tags" %>

<t:admin_layout title=" GP Home ">
    <jsp:attribute name="body_area">

      <main id="main" class="main">

        <div class="pagetitle">
          <nav>
            <ol class="breadcrumb">
               <li class="breadcrumb-item">Setup Data Template </li>
                <li class="breadcrumb-item active">Update / Create  Template </li>
                </ol>
          </nav>
        </div><!-- End Page Title -->


        <section class="section dashboard">

          <div class="row">

            <!-- Left side columns -->
            <div class="col-lg-12">

              <div class="row">

                <!-- Recent Sales -->
                <div class="col-12">
                  <div class="card recent-sales overflow-auto">
                    <div class="card-body">
                        <div class="card-body">
                            <div class="d-flex justify-content-between align-items-center">
                                <h5 class="card-title mb-0"> <i class="bi bi-file-earmark-richtext" style="font-size:1.4em;color: #FF1493;"> </i> Add | Update templates </h5>
                            </div>
                            <!-- Rest of your content (table, etc.) -->
                        </div>


                            <form name="actionForm" id="actionForm" >
                                   <input  type="hidden" name="templateId" id="templateId" type="text" value="${templateHeaderObj.tempHeaderId}"  maxlength="100">
                                      <hr>
                                       <div class="row" style="margin-top:15px;">
                                              <div class="col-3" align="center">
                                              </div>
                                              <div class="col-6" align="center">
                                                  <label for="email" class="text-primary mb-1"> <b> Template Name  </b></label>
                                                  <input name="templateHeader" id="templateHeader" type="text" class="form-control" value="${templateHeaderObj.headingName}" required="" maxlength="100">
                                              </div>
                                       </div>
                                       <br>
                                       <div class="row" style="margin-top:15px;">
                                              <div class="col-12" align="center">
                                                 <button type="button"  class="btn btn-info" onClick="backToList();"> <i class="fa fa-list" aria-hidden="true"> </i> Back To List  </button>
                                                 &nbsp;&nbsp;
                                                 <button id="updateReport" name="updateReport" type="button" onClick="updateTemplate();" class="btn btn-primary"> <i class="bi bi-floppy2"></i> &nbsp; Save Template  </button>
                                           </div>
                                        </div>
                                   </div> <!-- End of row  -->
                            </form>


                    </div> <!-- End of card body  -->



                  </div>
                </div><!-- End Recent Sales -->
              </div>
            </div><!-- End Left side columns -->
          </div>
        </section>
      </main><!-- End #main -->



      <script>


        function removeThisItem(itemId) {
            Swal.fire({
                title: 'Are you sure?',
                text: "You are about to delete this !?",
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
                    window.location.href = "manage_templates?delTemplateId=" + itemId;
                }
            });

        } //  end of removeThisItem



        function updateTemplate() {

           var templateHeaderElem = document.getElementById("templateHeader");
           var templateHeader = templateHeaderElem ? templateHeaderElem.value : '';

           // Null and empty check for dataCategory
           if (templateHeader === null || templateHeader === undefined || templateHeader.trim() === "") {
                Swal.fire({
                    title: 'Validation Error',
                    text: 'Template name cannot be empty . Please fill in the required field.',
                    icon: 'warning',
                    confirmButtonText: 'OK',
                    confirmButtonColor: '#d33'
                }).then(() => {
                    dataCategoryElem.focus();
                });
                return;
           }


            var data = {
                templateId: document.getElementById("templateId").value,
                templateHeader: document.getElementById("templateHeader").value
            };

            Swal.fire({
                title: 'Are you sure?',
                text: "You are about to save this detail !?",
                icon: 'warning',
                showCancelButton: true,
                confirmButtonColor: '#3085d6',
                cancelButtonColor: '#d33',
                confirmButtonText: 'Yes, save it!',
                cancelButtonText: 'Cancel',
                allowOutsideClick: false
            }).then((result) => {
                if (result.isConfirmed) {
                    Swal.fire({
                        title: 'Saving...',
                        html: 'Please wait while we are saving detail.',
                        allowOutsideClick: false,
                        didOpen: () => {
                            Swal.showLoading();
                        }
                    });

                    // Simulate fetch, replace with your real API endpoint
                    fetch('update-template-header', {
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
                            confirmButtonColor: '#03c4eb'
                        }).then(() => {
                            afterOkFunction();
                        });
                    })
                    .catch(error => {
                        Swal.fire({
                            title: 'Error!',
                            text: error.toString(),
                            icon: 'error',
                            confirmButtonText: 'OK',
                            confirmButtonColor: '#d33'
                        }).then(() => {
                            afterOkFunction();
                        });
                    });
                }
            });
        }



            // This function will be called after user clicks "OK" on the last modal
            function afterOkFunction() {
                    window.location.href = '${pageContext.request.contextPath}/manage_templates';
            }


            function updateThisItem(itemId) {
               window.location.href = "manage_templates?updateTemplateId=" + itemId;
            }

            function backToList() {
                 window.location.href = '${pageContext.request.contextPath}/manage_templates';
            }


            function addNewPatientMessage() {
               window.location.href = "${pageContext.request.contextPath}/patient_message?addTemplateId=YES";
            }


            function addNewLabResultAdvise() {
               window.location.href = "${pageContext.request.contextPath}/manage_templates?addTemplateId=YES";
            }

            function addNewItem() {
               window.location.href = "${pageContext.request.contextPath}/manage_templates?addTemplateId=YES";
            }


      </script>


    </jsp:attribute>
</t:admin_layout>


