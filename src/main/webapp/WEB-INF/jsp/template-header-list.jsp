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
              <li class="breadcrumb-item active">Setup Template </li>
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
                                <h5 class="card-title mb-0"><i class="bi bi-file-earmark-richtext" style="font-size:1.4em;color: #FF1493;"> </i> Template Category List </h5>
                                <button type="button" class="btn btn-info" onclick="addNewItem();"><i class="bi bi-plus-circle" style="font-size:1.2em;"></i> Add New Category   </button>
                            </div>
                            <!-- Rest of your content (table, etc.) -->

                        <br>
                          <table class="table table-borderless datatable">
                            <thead>
                              <tr>
                                <th scope="col"> Template Category Name </th>
                                <th scope="col"> Added by  </th>
                                <th scope="col"> Added Date </th>
                                <th scope="col"> Update </th>
                                <th scope="col"> Remove </th>
                              </tr>
                            </thead>
                            <tbody>
                             <c:forEach var="dataObject" items="${templateList}" begin="0" end="10000">
                                  <tr>
                                    <td align="left">${dataObject.headingName} </td>
                                    <td> ${dataObject.createBy} </td>
                                    <td> ${dataObject.getCreatedDate()}</td>
                                    <td>
                                        <a href="Javascript:void();" onClick="updateThisItem('${dataObject.tempHeaderId}');">
                                            <i class="bi bi-pencil-square" style="color:blue"></i>
                                            <span style="color:blue"> Update </span>
                                        </a>
                                    </td>
                                    <td>
                                        <a href="Javascript:void();" onClick="removeThisItem('${dataObject.tempHeaderId}');">
                                            <i class="bi bi-trash3" style="color:red"></i>
                                            <span style="color:red"> Delete </span>
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
                        window.location.href = "manage_templates_header?delTemplateId=" + itemId;
                    }
                });
            }

            function updateThisItem(itemId) {
               window.location.href = "manage_templates_header?updateTemplateId=" + itemId;
            }

            function addNewItem() {
               window.location.href = "manage_templates_header?addTemplateId=YES";
            }

      </script>





    </jsp:attribute>
</t:admin_layout>


