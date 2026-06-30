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
              <li class="breadcrumb-item active">Lab Report Advise </li>
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

                            <div class="d-flex justify-content-between align-items-center">
                                <h5 class="card-title mb-0"> <i class="bi bi-file-earmark-richtext" style="font-size:1.4em;color: #FF1493;"> </i>Update Lab report advise templates </h5>
                                       <button type="button" class="btn btn-info" onclick="addNewItem();"><i class="bi bi-plus-circle" style="font-size:1.2em;"></i> Add New Template  </button>
                            </div>
                            <!-- Rest of your content (table, etc.) -->



                            <form name="actionForm" id="actionForm">
                                <input type="hidden" name="templateId" id="templateId" value="${dataTemplate.id}" maxlength="100">
                                <hr>
                                <div class="header-row row" style="margin-bottom: 20px; text-align: left;">
                                    <div class="col-lg-4 col-md-4 label" style="text-align: left;">
                                        <label for="email" class="text-primary mb-1"><b>Template Category</b></label>
                                        <select class="form-select form-select" id="dataCategory" name="dataCategory" onChange="addMessageToCommentBox()">
                                            <option value="">----- Select Template -----</option>
                                            <c:forEach var="entry" items="${templatesSnippet}">
                                                <option value="${entry.tempHeaderId}" <c:if test="${entry.tempHeaderId eq dataTemplate.templateHeader.tempHeaderId}">selected</c:if>>
                                                  ${entry.headingName}
                                                 </option>

                                            </c:forEach>

                                        </select>
                                    </div>
                                    <div class="col-lg-4 col-md-4 label" style="text-align:left;">
                                        <label for="email" class="text-primary mb-1"><b>Heading Name</b></label>
                                        <input name="templateHeader" id="templateHeader" type="text" class="form-control" value="${dataTemplate.headingName}" required  maxlength="100">
                                    </div>
                                </div>

                                <div class="row" style="margin-top:15px;">
                                    <div class="col-12" align="left">
                                        <label for="templateContent" class="text-primary mb-1"><b>Template Description</b></label>
                                        <!-- Quill Editor Container -->
                                        <div
                                            style="box-shadow:2px 4px 8px rgba(0, 0, 0, 0.1);"
                                            class="quill-editor-default"
                                            id="templateContent"
                                            name="templateContent"
                                            rows="15">
                                            ${dataTemplate.contentDetail}
                                        </div>
                                    </div>
                                </div>
                                <div class="row" style="margin-top:115px;">
                                    <div class="col-10" align="center">
                                        &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
                                        <button type="button" class="btn btn-info" onClick="backToList();"><i class="fa fa-list" aria-hidden="true"></i> Back To List</button>
                                        &nbsp;&nbsp;&nbsp;&nbsp;
                                        <button id="updateReport" name="updateReport" type="button" onClick="updateTemplate();" class="btn btn-primary"><i class="bi bi-floppy2"></i> &nbsp; Save Template</button>
                                    </div>
                                    <div class="col-2" align="left" id="copyDiv">
                                        <a href="Javascript:void();" onclick="copyContentToClipBoard()"><i class="bi bi-copy"></i> <b>Copy Content</b></a>
                                    </div>
                                </div>
                            </form>

                    </div> <!-- End of card body  -->

                  </div>
                </div><!-- End Recent Sales -->
              </div>
            </div><!-- End Left side columns -->
          </div>
        </section>
      </main><!-- End #main -->

const templateContent =

      <script>

        //-- Copy the text to clipboard
        function copyContentToClipBoard() {

            // Extract the text content from the div
            const textToCopy = removeHtmlTagsFromString(document.querySelector('#templateContent .ql-editor').innerHTML);


            // Use the Clipboard API to copy the text
            navigator.clipboard.writeText(textToCopy).then(() => {
             document.getElementById('copyDiv').innerHTML='<span style="color:blue"><i class="fa fa-check" aria-hidden="true"> </i> <b>Content copied.! </b></span>';
                setTimeout(function() {
                     document.getElementById('copyDiv').innerHTML='<a href="Javascript:void();" onclick="copyContentToClipBoard()"> <i class="bi bi-copy"></i> <b>Copy Content </b></a>';
                }, 1500);
            }).catch(err => {
               console.error('Failed to copy text: ', err);
            });
        } //  End of function



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
                    window.location.href = "manage_data_templates?delTemplateId=" + itemId;
                }
            });
        } //  end of removeThisItem



        function updateTemplate() {


           var dataCategoryElem = document.getElementById("dataCategory");
           var dataCategory = dataCategoryElem ? dataCategoryElem.value : '';

           // Null and empty check for dataCategory
           if (dataCategory === null || dataCategory === undefined || dataCategory.trim() === "") {
                Swal.fire({
                    title: 'Validation Error',
                    text: 'Template Category cannot be empty . Please fill in the required field.',
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
                dataCategory: document.getElementById("dataCategory").value,
                templateHeader: document.getElementById("templateHeader").value,
                templateContent: document.querySelector('#templateContent .ql-editor').innerHTML
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
                    fetch('update-template-data-backend', {
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
                            //afterOkFunction();
                        });
                    });
                }
            });
        }



            // This function will be called after user clicks "OK" on the last modal
            function afterOkFunction() {
                    loading();
                    window.location.href = '${pageContext.request.contextPath}/manage_template_data';
            }


            function updateThisItem(itemId) {
               window.location.href = "manage_data_templates?updateTemplateId=" + itemId;
            }

            function backToList() {
                 //window.location.href = '${pageContext.request.contextPath}/manage_data_templates';
                 history.back()
            }


            function addNewPatientMessage() {
               window.location.href = "${pageContext.request.contextPath}/patient_message?addTemplateId=YES";
            }


            function addNewLabResultAdvise() {
               window.location.href = "${pageContext.request.contextPath}/manage_data_templates?addTemplateId=YES";
            }

            function addNewItem() {
               window.location.href = "manage_template_data?addTemplateId=YES";
            }



      </script>

    </jsp:attribute>
</t:admin_layout>


