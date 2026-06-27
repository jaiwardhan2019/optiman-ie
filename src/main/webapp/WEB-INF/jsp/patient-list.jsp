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
              <li class="breadcrumb-item"><a href="admin-dashboard"> Dashboard  </a>  </li>
              <li class="breadcrumb-item active">All Patient </li>
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

                    <div class="filter">
                      <a class="icon" href="#" data-bs-toggle="dropdown"><i class="bi bi-three-dots"></i></a>
                      <ul class="dropdown-menu dropdown-menu-end dropdown-menu-arrow">
                        <li class="dropdown-header text-start">
                          <h6>Filter</h6>
                        </li>

                        <li><a class="dropdown-item" href="#">Today</a></li>
                        <li><a class="dropdown-item" href="#">This Month</a></li>
                        <li><a class="dropdown-item" href="#">This Year</a></li>
                      </ul>
                    </div>

                    <div class="card-body">

                            <div class="d-flex justify-content-between align-items-center">
                                <h5 class="card-title mb-0"> <i class="bi bi-people" style="font-size:1.4em;color: #FF1493;"> </i> Patient list </h5>
                                <button type="button" class="btn btn-info" onclick="createNewPatient();"><i class="bi bi-plus-circle" style="font-size:1.2em;"></i> Create new patient   </button>
                            </div>

                      <table class="table table-borderless datatable">
                        <thead>
                          <tr>
                            <th scope="col">Name</th>
                            <th scope="col"> DOB , Sex  </th>
                            <th scope="col"> Address </th>
                            <th scope="col"> Phone   </th>
                            <th scope="col"> Email </th>
                            <th scope="col"> Last Actioned </th>
                          </tr>
                        </thead>

                        <tbody>
                         <c:forEach var="dataObject" items="${paitentList}">
                              <tr>
                                <td> <a href="Javascript:void();" onclick="viewPatient('${dataObject.userId}');">   ${dataObject.firstName} ${dataObject.lastName} </a></td>
                                <td> ${dataObject.getDateOfBirthFormatted()} , ${dataObject.sex} </td>
                                <td>
                                   <a href="Javascript:void();" onclick="viewPatient('${dataObject.userId}');">
                                       <c:if test="${not empty dataObject.fullAddress}">
                                           ${fn:substring(dataObject.fullAddress, 0, 50)}
                                       </c:if>, ${dataObject.eirCode}
                                   </a>
                                </td>
                                <td> ${dataObject.phoneNumber} </td>
                                <td> ${dataObject.emailId} </td>
                                <td> ${dataObject.getLastActionDateFormatted()} </td>
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

            function createNewPatient() {
                window.location.href = "${pageContext.request.contextPath}/create-new-patient";
            }

             function viewPatient(patientId) {
                    const form = document.createElement('form');
                    form.method = 'POST';
                    form.action = 'manage-patient'; // endpoint should accept POST
                    form.style.display = 'none';

                    const input = document.createElement('input');
                    input.type = 'hidden';
                    input.name = 'patientId';
                    input.value = patientId;
                    form.appendChild(input);
                    document.body.appendChild(form);
                    form.submit();
              }

        </script>

    </jsp:attribute>
</t:admin_layout>


