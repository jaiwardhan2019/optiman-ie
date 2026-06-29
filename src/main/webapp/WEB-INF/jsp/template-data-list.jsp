<%@taglib prefix="t" tagdir="/WEB-INF/tags" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
<%@ page contentType="text/html; charset=UTF-8" %>


<t:admin_layout title=" GP Home ">
    <jsp:attribute name="body_area">

      <main id="main" class="main">

        <div class="pagetitle">
          <nav>
            <ol class="breadcrumb">
              <li class="breadcrumb-item">Setup Data Template </li>
              <li class="breadcrumb-item active">Data Template </li>
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
                                <h5 class="card-title mb-0"> <i class="bi bi-file-earmark-richtext" style="font-size:1.4em;color: #FF1493;"> </i>Data templates list </h5>
                                <button type="button" class="btn btn-info" onclick="addNewItem();"><i class="bi bi-plus-circle" style="font-size:1.2em;"></i> Add New Template  </button>
                            </div>
                            <!-- Rest of your content (table, etc.) -->
                            <br>


                        <div style="display: flex; align-items: center; justify-content: center; gap: 20px;">
                              <div  class="col-lg-4 col-md-4" style="text-align:left;">
                                    <select   class="form-select form-select" id="tempId" name="tempId" onChange="addMessageToCommentBox()">
                                          <option value="" selected>----------- All Template Category  ----------- </option>
                                          <c:forEach var="entry" items="${templatesSnippet}">
                                                <option value="${entry.tempHeaderId}"
                                                  ${entry.tempHeaderId eq dataTemplate.tempHeaderId ? 'selected="selected"' : ''}>
                                                  ${entry.headingName}
                                                </option>
                                          </c:forEach>
                                     </select>
                              </div>
                              <div style="flex: 0 0 30%;">
                                <input type="text" class="form-control" id="customSearchBox" name="customSearchBox" placeholder="  Heading Name |  Data Content   ">
                              </div>
                              <div>
                                <button type="button" class="btn btn-secondary" id="customSearchBtn"> <i class="bi bi-search"></i> Search </button>
                              </div>
                        </div>
                        <br>

                          <table class="table table-borderless datatable">
                            <thead>
                              <tr>
                                <th scope="col"> Category </th>
                                <th scope="col"> Heading Name  </th>
                                <th scope="col"> Added by  </th>
                                <!-- <th scope="col"> Added Date </th> -->
                                <th scope="col"> View - Update </th>
                                <th scope="col"> Remove </th>
                              </tr>
                            </thead>
                            <tbody>
                             <c:forEach var="dataObject" items="${templateList}" begin="0" end="10000">
                                  <tr>
                                    <td align="left">${dataObject.templateHeader.headingName} </td>
                                    <td align="left">
                                      <div style="display:none;" id="${dataObject.id}"> ${fn:toLowerCase(dataObject.contentDetail)} </div>
                                      <a href="Javascript:void();" onClick="copyThisItem('${dataObject.id}');"> <i class="bi bi-copy font-size: 1.4rem;" style="color:blue;"></i> ${dataObject.headingName}</a>
                                    </td>
                                    <td> ${dataObject.createBy} </td>
                                    <!-- <td> ${dataObject.getCreatedDate()}</td> -->
                                    <td>
                                        <a href="Javascript:void();" onClick="updateThisItem('${dataObject.id}');">
                                            <i class="bi bi-pencil-square" style="color:blue"></i>
                                            <span style="color:blue"> View - Update </span>
                                        </a>
                                    </td>
                                    <td>
                                        <a href="Javascript:void();" onClick="removeThisItem('${dataObject.id}');">
                                            <i class="bi bi-trash3" style="color:red"></i>
                                            <span style="color:red"> Del</span>
                                        </a>
                                    </td>
                                  </tr>
                             </c:forEach>
                            </tbody>
                          </table>
                    </div> <!-- End of card body  -->



                  </div>
                </div><!-- End Recent Sales -->
              </div>
            </div><!-- End Left side columns -->
          </div>
        </section>
      </main><!-- End #main -->



      <script>

            // This will make all record displayed by default
            document.addEventListener("DOMContentLoaded", function() {
                var select = document.querySelector('.datatable-selector');
                select.value = "-1";
                // Trigger change event
                var event = new Event('change', { bubbles: true });
                select.dispatchEvent(event);
            });



          // Existing button click listener
          document.getElementById('customSearchBtn').addEventListener('click', function() {
             // Show spinner loader
             var searchBtn = document.getElementById('customSearchBtn');
             searchBtn.innerHTML = '<span class="spinner"></span> &nbsp; Searching...';
             searchBtn.disabled = true; // prevent double-clicks

              var searchValue = document.getElementById('customSearchBox').value.trim();
              var templateType = document.getElementById('tempId').value;

              if (searchValue && searchValue !== "" || templateType && templateType !== "") {
                  window.location.href = "search_data_template?searchKey=" + searchValue+"&templateType="+templateType;
              } else {
                  window.location.href = "search_data_template"; // Redirect to the default page if search is empty
              }
          });

          // Add Enter key listener for the search box
          document.getElementById('customSearchBox').addEventListener('keydown', function(event) {
              if (event.key === 'Enter') {
                  var searchValue = document.getElementById('customSearchBox').value.trim();
                  var templateType = document.getElementById('tempId').value;
                  if (searchValue && searchValue !== "" || templateType && templateType !== "") {
                      window.location.href = "search_data_template?searchKey=" + searchValue+"&templateType="+templateType;
                  } else {
                      window.location.href = "search_data_template"; // Redirect to the default page if search is empty
                  }
              }
          });





            function removeThisItem(itemId) {
                Swal.fire({
                    title: 'Are you sure?',
                    text: "You are about to delete this data template !? ",
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
                        window.location.href = "manage_template_data?delTemplateId=" + itemId;
                    }
                });
            }

            function updateThisItem(itemId) {
               window.location.href = "manage_template_data?updateTemplateId=" + itemId;
            }

            function addNewItem() {
               window.location.href = "manage_template_data?addTemplateId=YES";
            }



            function copyThisItem(divId) {

                // Find the div with the given ID
                const contentDiv = document.getElementById(divId);

                // Check if the div exists
                if (contentDiv) {

                    // Extract the text content from the div
                    const textToCopy = removeHtmlTagsFromString(contentDiv.innerHTML);

                    // Use the Clipboard API to copy the text
                    navigator.clipboard.writeText(textToCopy).then(() => {
                        // Show a centered, small-sized SweetAlert success message
                        Swal.fire({
                            position: 'center', // Center of the screen
                            icon: 'success',    // Success icon
                            title: 'Copied!',   // Short title
                            text: 'Content copied to clipboard', // Optional descriptive text
                            showConfirmButton: false, // No confirm button
                            timer: 750,        // Timeout in milliseconds (1.2 seconds)
                            customClass: {
                                popup: 'swal-small-popup' // Custom class for smaller size
                            }
                        });
                    }).catch(err => {
                        console.error('Failed to copy text: ', err);
                        Swal.fire({
                            position: 'center',
                            icon: 'error',
                            title: 'Error!',
                            text: 'Failed to copy content to clipboard.',
                            showConfirmButton: true
                        });
                    });
                } else {
                    console.error('Element with ID "' + divId + '" not found.');
                    Swal.fire({
                        position: 'center',
                        icon: 'error',
                        title: 'Error!',
                        text: 'Content not found to copy.',
                        showConfirmButton: true
                    });
                }
            }
      </script>



     <!-- Hide default search box from data table   -->
     <style>
            .datatable-search {
                display: none !important;
            }


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


