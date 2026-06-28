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
              <li class="breadcrumb-item">Admin  </li>
              <li class="breadcrumb-item active">Staff Account / List  </li>
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
                                <h5 class="card-title mb-0"> <i class="bi bi-people" style="font-size:1.4em;color: #FF1493;"> </i> Clinic Staff list </h5>
                                <button type="button" class="btn btn-info" onclick="addNewItem();"><i class="bi bi-plus-circle" style="font-size:1.2em;"></i> Add New   </button>
                            </div>
                        </div>
                        <br>
                          <table class="table table-borderless datatable">
                            <thead>
                              <tr>
                                <th scope="col"> Name  </th>
                                <th scope="col"> Role   </th>
                                <th scope="col"> Email   </th>
                                <th scope="col"> Phone  </th>
                                <th scope="col"> Update </th>
                                <th scope="col"> Remove </th>
                              </tr>
                            </thead>
                            <tbody>
                                 <c:forEach var="dataObject" items="${clinicUserList}">
                                      <tr>
                                        <td align="left">${dataObject.firstName}  ${dataObject.lastName}</td>
                                        <td> ${dataObject.accountType} </td>
                                        <td> ${dataObject.emailId} </td>
                                        <td> ${dataObject.phoneNumber}</td>
                                        <td>
                                            <a href="Javascript:void();" onClick="updateThisItem('${dataObject.userId}');">
                                                <i class="bi bi-pencil-square" style="color:blue"></i>
                                                <span style="color:blue"> Update </span>
                                            </a>
                                        </td>
                                        <td>
                                            <a href="Javascript:void();" onClick="removeThisItem('${dataObject.userId}');">
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
                    text: "You are about to delete this !? ",
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
                            html: 'Please wait while we remove .',
                            allowOutsideClick: false,
                            didOpen: () => {
                                Swal.showLoading();
                            }
                        });

                        // Redirect to the delete action
                        window.location.href = "manage-clinic-user?delUserId="+itemId;
                    }
                });
            }

            function updateThisItem(itemId) {
               window.location.href = "manage-clinic-user?updateUserId=" + itemId;
            }

            function addNewItem() {
               window.location.href = "manage-clinic-user";
            }

      </script>





    </jsp:attribute>
</t:admin_layout>
