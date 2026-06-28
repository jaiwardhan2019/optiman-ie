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
              <li class="breadcrumb-item active" > <a href="clinic-user-list">  Staff Account </a>  </li>
              <li class="breadcrumb-item active" > Create new  </li>
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
                                 <h5 class="card-title mb-0">
                                    <i class="bi bi-people" style="font-size:1.4em;color: #FF1493;"> </i> Create / Update Clinic User
                                  </h5>

                        </div>

                        <div style="width:650px;align:center;">
                              <form id="clinicUserForm" onsubmit="return createClinicUser();">
                                <input type="hidden" name="userId" id="userId" value="${clinicUser.userId}">

                                <div class="row mb-3">
                                    <div class="col-md-6">
                                        <label for="role" class="col-form-label fw-bold">Role</label>
                                        <select name="accountType" id="accountType" class="form-select" required>
                                            <option value=""> --------- Select Role --------</option>
                                            <c:forEach var="entry" items="${accountTypeList}">
                                                <option value="${entry.key}" <c:if test="${clinicUser.accountType == entry.key}"> selected </c:if>>${entry.value}</option>
                                            </c:forEach>
                                        </select>
                                    </div>
                                    <div class="col-md-6">
                                        <label for="roomNumber" class="col-form-label fw-bold">Room Number</label>
                                        <input name="roomNumber" id="roomNumber" type="text" class="form-control" value="${clinicUser.roomNumber}" maxlength="10">
                                    </div>
                                </div>

                                <div class="row mb-3">
                                    <div class="col-md-6">
                                        <label for="firstName" class="col-form-label fw-bold">First Name</label>
                                        <input name="firstName" id="firstName" type="text" class="form-control" value="${clinicUser.firstName}" required maxlength="100">
                                    </div>
                                    <div class="col-md-6">
                                        <label for="lastName" class="col-form-label fw-bold">Last Name</label>
                                        <input name="lastName" id="lastName" type="text" class="form-control" value="${clinicUser.lastName}" required maxlength="100">
                                    </div>
                                </div>

                                <div class="row mb-3">
                                    <div class="col-md-6">
                                        <label for="gsmNumber" class="col-form-label fw-bold">GMS Number</label>
                                        <input name="gsmNumber" id="gsmNumber" type="text" class="form-control" value="${clinicUser.gsmNumber}" maxlength="20">
                                    </div>
                                    <div class="col-md-6">
                                        <label for="mcrNumber" class="col-form-label fw-bold">MCR Number</label>
                                        <input name="mcrNumber" id="mcrNumber" type="text" class="form-control" value="${clinicUser.mcrNumber}" maxlength="50">
                                    </div>
                                </div>


                                <div class="row mb-3">
                                    <label for="qualifiCation" class="col-form-label fw-bold">Qualification</label>
                                    <div class="col-md-8 col-lg-9">
                                        <input name="qualifiCation" id="qualifiCation" type="text" class="form-control" value="${clinicUser.qualifiCation}" required maxlength="100">
                                    </div>
                                </div>

                                <div class="row mb-3">
                                    <div class="col-md-6">
                                        <label for="emailId" class="col-form-label fw-bold">Email ID</label>
                                        <input name="emailId" id="emailId" type="email" class="form-control" value="${clinicUser.emailId}" required maxlength="150">
                                    </div>
                                    <div class="col-md-6">
                                        <label for="phoneNumber" class="col-form-label fw-bold">Phone Number (08617XXXXX)</label>
                                        <input name="phoneNumber" id="phoneNumber" type="text" class="form-control" value="${clinicUser.phoneNumber}" required maxlength="15" minlength="10">
                                    </div>
                                </div>
                                <c:if test="${empty updateUserId}">  <!-- Display only for create new request  -->
                                    <div class="row mb-3">
                                        <label for="password" class="col-form-label fw-bold">Password</label>
                                        <div class="col-md-8 col-lg-9">
                                            <input name="password" id="password" type="password" class="form-control" value="" required maxlength="255">
                                        </div>
                                    </div>
                                </c:if>



                                <div class="text-center mb-3">
                                  &nbsp; &nbsp;&nbsp; &nbsp; &nbsp;
                                  <button type="button" class="btn btn-info" onclick="openAdminUrl('clinic-user-list');"><i class="bi bi-list-ul" style="font-size:1.1em;"></i> Back to List  </button>
                                   &nbsp; &nbsp;
                                  <button type="submit"  class="btn btn-primary" > <i class="bi bi-floppy" style="font-size:1.1em;"></i>  Save / Update   </button>
                                </div>

                                <c:if test="${not empty updateUserId}">  <!-- Display only for update  request  -->
                                      <hr>
                                        <div class="row mb-3">
                                            <label for="password" class="col-form-label fw-bold">Password</label>
                                            <div class="col-md-8 col-lg-9">
                                                <input name="password" id="password" type="password" class="form-control" value=""  maxlength="255">
                                            </div>
                                        </div>
                                        <div class="row mb-3">
                                            <label for="password" class="col-form-label fw-bold">Confrm Password</label>
                                            <div class="col-md-8 col-lg-9">
                                                <input name="Cpassword" id="Cpassword" type="password" class="form-control" value=""  maxlength="255">
                                            </div>
                                        </div>
                                      <div class="text-center">
                                         &nbsp; &nbsp;&nbsp; &nbsp; &nbsp;
                                         <button type="button" class="btn btn-info" onclick="openAdminUrl('clinic-user-list');"><i class="bi bi-list-ul" style="font-size:1.1em;"></i> Back to List  </button>
                                         &nbsp; &nbsp;
                                         <button type="button" onclick="createClinicUser()" class="btn btn-primary" > <i class="bi bi-floppy" style="font-size:1.1em;"></i>  Update Password </button>
                                     </div>

                                </c:if>
                          </form>

                        </div>

                    </div> <!-- End of card body  -->

                  </div>
                </div><!-- End Recent Sales -->
              </div>
            </div><!-- End Left side columns -->
          </div>
        </section>
      </main><!-- End #main -->



      <script>


            function createClinicUser(event) {
                if (event) event.preventDefault();

                const form = document.getElementById('clinicUserForm');
                const data = {
                    userId: form.userId.value,
                    accountType: form.accountType.value,
                    firstName: form.firstName.value,
                    lastName: form.lastName.value,
                    roomNumber: form.roomNumber.value,
                    gsmNumber: form.gsmNumber.value,
                    mcrNumber: form.mcrNumber.value,
                    qualifiCation: form.qualifiCation.value,
                    emailId: form.emailId.value,
                    phoneNumber: form.phoneNumber.value,
                    password: form.password.value
                };

                Swal.fire({
                    title: 'Are you sure?',
                    text: 'Do you want to go ahead !!',
                    icon: 'warning',
                    showCancelButton: true,
                    confirmButtonText: 'Yes, please ..',
                    cancelButtonText: 'No, cancel',
                    confirmButtonColor: '#3085d6',
                    cancelButtonColor: '#d33'
                }).then((result) => {
                    if (result.isConfirmed) {
                        fetch('update-clinic-user', {
                            method: 'POST',
                            headers: {
                                'Content-Type': 'application/json'
                            },
                            body: JSON.stringify(data)
                        })
                        .then(response => {
                            if (!response.ok) {
                                return response.text().then(text => { throw new Error(text); });
                            }
                            return response.text();
                        })
                        .then(text => {
                            Swal.fire({
                                title: 'Updated!',
                                text: 'Detail updated !!.',
                                icon: 'success',
                                confirmButtonText: 'OK'
                            }).then(() => {
                                // Replace the URL below with your desired destination
                               afterOkFunction();
                            });
                        })
                        .catch(error => {
                            Swal.fire({
                                title: 'Error!',
                                text: error.message,
                                icon: 'error',
                                confirmButtonText: 'OK',
                                confirmButtonColor: '#d33'
                            }).then(() => {
                                afterOkFunction();
                            });
                        });
                    }
                    // else, do nothing if cancelled
                });

                return false;
            }


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
                        window.location.href = "manage_templates?delTemplateId=" + itemId;
                    }
                });
            }

            function updateThisItem(itemId) {
               window.location.href = "manage_templates?updateTemplateId=" + itemId;
            }

            function addNewItem() {
               window.location.href = "manage_templates?addTemplateId=YES";
            }



            // This function will be called after user clicks "OK" on the last modal
            function afterOkFunction() {
                    window.location.href = "clinic-user-list";
            }

      </script>

    </jsp:attribute>
</t:admin_layout>
