<%@taglib prefix="t" tagdir="/WEB-INF/tags" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
<%@ page contentType="text/html; charset=UTF-8" %>
<%@taglib prefix="t" tagdir="/WEB-INF/tags" %>

<t:admin_layout title=" GP Home ">
    <jsp:attribute name="body_area">

      <main id="main" class="main">

        <div class="pagetitle">
          <h1>Dashboard</h1>
          <nav>
            <ol class="breadcrumb">
              <li class="breadcrumb-item"><a href="admin-dashboard">Home</a></li>
              <li class="breadcrumb-item active">Dashboard</li>
            </ol>
          </nav>
        </div><!-- End Page Title -->

        <section class="section dashboard">

          <div class="row">
            <!-- Left side columns -->
            <div class="col-lg-12">

              <div class="row">

                    <!-- Patient Card -->
                    <div class="col-xxl-3 col-md-6">
                      <a href="Javascript:void();" onClick="openAdminUrl('patient-list');">
                          <div class="card info-card sales-card">
                            <div class="card-body" >
                              <h5 class="card-title">Patient </span></h5>
                              <div class="d-flex align-items-center">
                                <div class="card-icon rounded-circle d-flex align-items-center justify-content-center">
                                   <i class="bi bi-people" style="color:green;"></i>
                                </div>
                                <div class="ps-3">
                                  <h6>${AdminDashBoard.patientCount}</h6>
                                </div>
                              </div>
                            </div>
                          </div>
                      </a>
                    </div><!-- End Patient Card -->

                    <div class="col-xxl-3 col-md-6">
                      <a href="Javascript:void();" onClick="openAdminUrl('consultation-list')">
                          <div class="card info-card sales-card">
                            <div class="card-body">
                              <h5 class="card-title"> Consultation   </span></h5>
                              <div class="d-flex align-items-center">
                                <div class="card-icon rounded-circle d-flex align-items-center justify-content-center">
                                    <i class="fa-sharp fa-solid fa-stethoscope" style="font-size:1.1em;color:#FF1493;"></i>
                                </div>
                                <div class="ps-3">
                                  <h6>${AdminDashBoard.patientConsultationCount}</h6>
                                </div>
                              </div>
                            </div>
                          </div>
                      </a>
                    </div>


                    <div class="col-xxl-3 col-md-6">
                      <a href="Javascript:void();" onClick="openAdminUrl('clinic-booking-dashboard');">
                          <div class="card info-card sales-card">
                            <div class="card-body">
                              <h5 class="card-title"> Video | Appointment  </span></h5>
                              <div class="d-flex align-items-center">
                                <div class="card-icon rounded-circle d-flex align-items-center justify-content-center">
                                  <i class="bi bi-camera-video" style="color:#FF1493;"></i>
                                </div>
                                <div class="ps-3">
                                  <h6>${AdminDashBoard.bookingCount}</h6>
                                </div>
                              </div>
                            </div>
                          </div>
                      </a>
                    </div>



                    <!-- Service Request Card -->
                    <div class="col-xxl-3 col-md-6">
                      <a href="Javascript:void();" onClick="openAdminUrl('patient-all-request');">
                          <div class="card info-card sales-card">
                            <div class="card-body">
                              <h5 class="card-title">Service request </span></h5>
                              <div class="d-flex align-items-center">
                                <div class="card-icon rounded-circle d-flex align-items-center justify-content-center">
                                  <i class="bi bi-heart-pulse" style="color:#E62E35;"></i>
                                </div>
                                <div class="ps-3">
                                  <h6>${AdminDashBoard.service_request_count}</h6>
                                </div>
                              </div>
                            </div>
                          </div>
                      </a>
                    </div>

                    <!-- End Service Request Card -->




                    <!-- Clinic Documents Card -->
                    <div class="col-xxl-3 col-md-6">
                        <a href="Javascript:void();" onClick="openAdminUrl('manage-patient-documents');">
                          <div class="card info-card sales-card">
                            <div class="card-body">
                              <h5 class="card-title">Patient Documents </span></h5>
                              <div class="d-flex align-items-center">
                                <div class="card-icon rounded-circle d-flex align-items-center justify-content-center">
                                  <i class="bi bi-file-diff" style="color:#1447E6;"></i>
                                </div>
                                <div class="ps-3">
                                  <h6>${AdminDashBoard.patient_document_count}</h6>
                                </div>
                              </div>
                            </div>
                          </div>
                        </a>
                    </div><!-- End Clinic Documents Card -->



                    <!-- ==== Start Patient Checkin ===  -->
                    <div class="col-xxl-3 col-md-6">
                      <a href="Javascript:void();" onClick="openAdminUrl('clinic-patient-list');">
                          <div class="card info-card sales-card">
                            <div class="card-body">
                              <h5 class="card-title"> Patient Check-in | portal </span></h5>
                              <div class="d-flex align-items-center">
                                <div class="card-icon rounded-circle d-flex align-items-center justify-content-center">
                                  <i class="bi bi-person-walking" style="color:#FF1493;"> </i>
                                </div>
                                <div class="ps-3">
                                  <h6>${AdminDashBoard.patientCheckInCount}</h6>
                                </div>
                              </div>
                            </div>
                          </div>
                      </a>
                    </div>
                    <!-- ==== End Patient Checkin ===  -->



                    <!-- Clinic Task  Card
                    <div class="col-xxl-3 col-md-6">
                      <a href="Javascript:void();" onClick="openAdminUrl('my-task-list');">
                          <div class="card info-card sales-card">
                            <div class="card-body">
                              <h5 class="card-title">My Task  </span></h5>
                              <div class="d-flex align-items-center">
                                <div class="card-icon rounded-circle d-flex align-items-center justify-content-center">
                                  <i class="bi bi-pencil-square" style="color: #FF1493;"></i>
                                </div>
                                <div class="ps-3">
                                  <h6>${AdminDashBoard.mytask_count}</h6>
                                </div>
                              </div>
                            </div>
                          </div>
                      </a>
                    </div>

                    End Clinic Documents Card -->



              </div>

            </div>
          </div>





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
                  </div>
                </div><!-- End Recent Sales -->
              </div>
            </div><!-- End Left side columns -->
          </div>
        </section>

      </main><!-- End #main -->

    </jsp:attribute>
</t:admin_layout>


