<%@ page contentType="text/html;charset=UTF-8" language="java" pageEncoding="UTF-8" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
<html lang="en">
<head>
  <meta charset="utf-8">
  <meta content="width=device-width, initial-scale=1.0" name="viewport">

  <title>Dashboard - GP4Less    </title>
  <meta content="" name="description">
  <meta content="" name="keywords">

  <!-- Favicons -->
  <link href="assets-admin/img/" rel="icon">
  <link href="assets-admin/img/apple-touch-icon.png" rel="apple-touch-icon">

  <!-- Google Fonts -->
  <link href="https://fonts.gstatic.com" rel="preconnect">
  <link href="https://fonts.googleapis.com/css?family=Open+Sans:300,300i,400,400i,600,600i,700,700i|Nunito:300,300i,400,400i,600,600i,700,700i|Poppins:300,300i,400,400i,500,500i,600,600i,700,700i" rel="stylesheet">

  <!-- Vendor CSS Files -->
  <link href="assets-admin/vendor/bootstrap/css/bootstrap.min.css" rel="stylesheet">
  <link href="assets-admin/vendor/bootstrap-icons/bootstrap-icons.css" rel="stylesheet">
  <link href="assets-admin/vendor/boxicons/css/boxicons.min.css" rel="stylesheet">
  <link href="assets-admin/vendor/quill/quill.snow.css" rel="stylesheet">
  <link href="assets-admin/vendor/quill/quill.bubble.css" rel="stylesheet">
  <link href="assets-admin/vendor/remixicon/remixicon.css" rel="stylesheet">
  <link href="assets-admin/vendor/simple-datatables/style.css" rel="stylesheet">

  <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0-beta3/css/all.min.css">
  <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.1/font/bootstrap-icons.css">

  <!-- Template Main CSS File -->
  <link href="assets-admin/css/style.css" rel="stylesheet">

  <!-- =======================================================
  * Template Name: NiceAdmin
  * Template URL: https://bootstrapmade.com/nice-admin-bootstrap-admin-html-template/
  * Updated: Apr 20 2024 with Bootstrap v5.3.3
  * Author: BootstrapMade.com
  * License: https://bootstrapmade.com/license/
  ======================================================== -->
</head>

  <!-- ======= Header ======= -->
  <header id="header" class="header fixed-top d-flex align-items-center">

    <div class="d-flex align-items-center justify-content-between">
      <a href="Javascript:void();" onClick="openAdminUrl('admin-dashboard');" class="logo d-flex align-items-center">
        <span class="d-none d-lg-block">GP4Less - Admin</span>
      </a>
      <i class="bi bi-list toggle-sidebar-btn"></i>
    </div><!-- End Logo -->

    <div class="search-bar">
      <form class="search-form d-flex align-items-center" method="GET" action="render-under-construction-page">
        <input type="text" name="query" placeholder="Search" title="Enter search keyword">
        <button type="submit" onSubmit="openAdminUrl('render-under-construction-page')" title="Search"> <i class="bi bi-search"></i></button>
      </form>
    </div><!-- End Search Bar -->

    <nav class="header-nav ms-auto">
      <ul class="d-flex align-items-center">

        <li class="nav-item d-block d-lg-none">
          <a class="nav-link nav-icon search-bar-toggle " href="#">
            <i class="bi bi-search"></i>
          </a>
        </li><!-- End Search Icon-->



        <li class="nav-item dropdown">

          <a class="nav-link nav-icon" href="#" data-bs-toggle="dropdown">
            <i class="bi bi-chat-left-text"></i>
            <span class="badge bg-success badge-number" id="messageCount"> </span>
          </a>

          <ul class="dropdown-menu dropdown-menu-end dropdown-menu-arrow messages">
            <li class="dropdown-header">
              <span id="messageWithNumber_1"> </span>
              <span class="badge rounded-pill bg-primary p-2 ms-2">See below</span>
            </li>
            <li>
              <hr class="dropdown-divider">
            </li>

           <!-- Load data from backend -->
           <span id="messageContent"> </span>

          </ul><!-- End Messages Dropdown Items -->

        </li><!-- End Messages Nav -->






         <!-- Notification bell icon -->
        <li class="nav-item dropdown">
          <a class="nav-link nav-icon" href="#" data-bs-toggle="dropdown">
            <i class="bi bi-bell"></i>
            <span class="badge bg-primary badge-number" id="notificationCount"></span>
          </a><!-- End Notification Icon -->

          <ul class="dropdown-menu dropdown-menu-end dropdown-menu-arrow notifications">
            <li class="dropdown-header">
              <span id="messageWithNumber"> You have new service request </span>
               <a href="Javascript:void();" onClick="openAdminUrl('patient-all-request');">
                <span class="badge rounded-pill bg-primary p-2 ms-2">View all</span>
               </a>
            </li>
            <li>
              <hr class="dropdown-divider">
            </li>
            <span id="liContent"> </span>
            <li class="dropdown-footer">
               <a href="Javascript:void();" onClick="openAdminUrl('patient-all-request');">
               Show all notifications
               </a>
            </li>

          </ul><!-- End Notification Dropdown Items -->

        </li><!-- End Notification Nav -->




        <li class="nav-item dropdown pe-3">

          <a class="nav-link nav-profile d-flex align-items-center pe-0" href="#" data-bs-toggle="dropdown">
            <img src="${pageContext.request.contextPath}/admin-image/${ADMIN_SESSION.profileImageName}" alt="Profile" class="rounded-circle">
            <span class="d-none d-md-block dropdown-toggle ps-2">${ADMIN_SESSION.lastName}</span>
          </a><!-- End Profile Iamge Icon -->

          <ul class="dropdown-menu dropdown-menu-end dropdown-menu-arrow profile">
            <li class="dropdown-header">
              <h6 id="systemUserName">${ADMIN_SESSION.firstName} ${ADMIN_SESSION.lastName}</h6>
              <span>GP Consultant </span>
            </li>
            <li>
              <hr class="dropdown-divider">
            </li>

            <li>
              <a class="dropdown-item d-flex align-items-center" href="Javascript:void()" onClick="openAdminUrl('render-under-construction-page')">
                <i class="bi bi-person"></i>
                <span>My Profile</span>
              </a>
            </li>

            <li>
              <hr class="dropdown-divider">
            </li>

           <li>
              <a class="dropdown-item d-flex align-items-center" href="Javascript:void()" onClick="openAdminUrl('render-under-construction-page')">
                <i class="bi bi-gear"></i>
                <span>Account Settings</span>
              </a>
            </li>
            <li>
              <hr class="dropdown-divider">
            </li>

            <li>
              <a class="dropdown-item d-flex align-items-center" href="Javascript:void()" onClick="openAdminUrl('render-under-construction-page')">
                <i class="bi bi-question-circle"></i>
                <span>Need Help?</span>
              </a>
            </li>
            <li>
              <hr class="dropdown-divider">
            </li>

            <li>
              <a class="dropdown-item d-flex align-items-center" href="${pageContext.request.contextPath}/adminlogout">
                <i class="bi bi-box-arrow-right"></i>
                <span>Sign Out</span>
              </a>
            </li>

          </ul><!-- End Profile Dropdown Items -->
        </li><!-- End Profile Nav -->

      </ul>
    </nav><!-- End Icons Navigation -->
  </header><!-- End Header -->


  <!-- ======= Sidebar ======= -->
  <aside id="sidebar" class="sidebar">

    <ul class="sidebar-nav" id="sidebar-nav">

      <li class="nav-item">
        <a class="nav-link " href="Javascript:void();" onClick="openAdminUrl('admin-dashboard');" >
          <i class="bi bi-grid"></i>
          <span>Dashboard</span>
        </a>
      </li><!-- End Dashboard Nav -->

<!--
      <li class="nav-item">
        <a class="nav-link " href="Javascript:void();" onClick="openAdminUrl('clinic-booking-dashboard');" >
          <i class="bi bi-calendar2-check"></i>
          <span>Appointments </span>
        </a>
      </li>
-->


      <li class="nav-item">
        <a class="nav-link collapsed" data-bs-target="#components-nav" data-bs-toggle="collapse" href="#">
          <i class="bi bi-menu-button-wide"></i><span>Service Request </span><i class="bi bi-chevron-down ms-auto"></i>
        </a>
        <ul id="components-nav" class="nav-content collapse " data-bs-parent="#sidebar-nav">

          <li>
            <a href="Javascript:void();" onClick="openAdminUrl('patient-all-request');">
              <i class="bi bi-list-task" style="font-size:1.2em;"></i><span>All Request </span>
            </a>
          </li>
          <li>
            <a href="Javascript:void();" onClick="openAdminUrl('all-sicknote-request');">
              <i class="bi bi-award" style="font-size:1.2em;"></i><span>Sick Note</span>
            </a>
          </li>
          <li>
            <a href="Javascript:void();" onClick="openAdminUrl('all-prescription-request');">
              <i class="bi bi-prescription2" style="font-size:1.2em;"></i><span> Prescription </span>
            </a>
          </li>

          <li>
            <a href="Javascript:void();" onClick="openAdminUrl('consultation-list');">
              <i class="fa-sharp fa-solid fa-stethoscope" style="color:#FF1493; font-size:1.3em;"></i>
              <span> Consultation </span>
            </a>
          </li>

          <li>
            <a href="Javascript:void();" onClick="openAdminUrl('my-task-list');">
              <i class="bi bi-pencil-square" style="font-size:1.2em;"></i> <span> My Task  </span>
            </a>
          </li>
        </ul>
      </li><!-- End Components Nav -->



      <li class="nav-item">
        <a class="nav-link collapsed" data-bs-target="#patients-nav" data-bs-toggle="collapse" href="#">
          <i class="bi bi-people"></i><span> Patients </span><i class="bi bi-chevron-down ms-auto"></i>
        </a>
        <ul id="patients-nav" class="nav-content collapse " data-bs-parent="#sidebar-nav">
          <li>
            <a href="Javascript:void();" onClick="openAdminUrl('patient-list');">
              <i class="bi bi-people" style="font-size:1.3em;"></i><span> Patient List </span>
            </a>
          </li>
          <li>
            <a class="nav-link collapsed" href="Javascript:void()" onClick="openAdminUrl('manage-patient-documents')">
              <i class="bi bi-file-diff" style="font-size:1.3em;" ></i><span> Patient Documents </span>
            </a>
          </li>
          <li>
            <a class="nav-link collapsed" href="Javascript:void()" onClick="openAdminUrl('create-new-patient')">
              <i class="bi bi-person-plus" style="font-size:1.3em;" ></i><span> Create Patient </span>
            </a>
          </li>
        </ul>
      </li><!-- End Patient Nav -->



      <li class="nav-item">
        <a class="nav-link collapsed" data-bs-target="#tables-nav" data-bs-toggle="collapse" href="#">
          <i class="bi bi-layout-text-window-reverse"></i><span> Setup Data Template </span><i class="bi bi-chevron-down ms-auto"></i>
        </a>
        <ul id="tables-nav" class="nav-content collapse " data-bs-parent="#sidebar-nav">

          <li>
            <a class="nav-link collapsed" href="Javascript:void()" onClick="openAdminUrl('manage_templates')">
              <i class="bi bi-file-easel"style="font-size:1.2em;"></i><span> Setup Template </span>
            </a>
          </li>
          <li>
            <a class="nav-link collapsed" href="Javascript:void()" onClick="openAdminUrl('manage_data_templates')">
              <i class="bi bi-file-easel" style="font-size:1.2em;"></i><span> Setup Data Template </span>
            </a>
          </li>

          <li>
            <a class="nav-link collapsed" href="Javascript:void()" onClick="openAdminUrl('manage_ai_databank')">
              <i class="bi bi-file-easel" style="font-size:1.2em;"></i><span>AI-Advise (HealthLink XML) </span>
            </a>
          </li>

          <li>
            <a href="Javascript:void();" onClick="openAdminUrl('setup-medical-question')">
              <i class="bi bi-patch-question" style="font-size:1.2em;"></i><span> Medical Questions </span>
            </a>
          </li>

        </ul>
      </li>

        <c:if test="${ADMIN_SESSION.accountType == 'ADMIN'}">
              <li class="nav-item">
                <a class="nav-link collapsed" data-bs-target="#admin-nav" data-bs-toggle="collapse" href="#" style="color:red;">
                  <i class="bi bi-person-bounding-box" style="color:red;"></i> <span> Admin  </span><i class="bi bi-chevron-down ms-auto"></i>
                </a>
                <ul id="admin-nav" class="nav-content collapse " data-bs-parent="#sidebar-nav">

                     <li>
                       <a href="Javascript:void();" onClick="openAdminUrl('manage-booking-slots')">
                         <i class="bi bi-clock-history" style="font-size:1.2em;"></i> <span> Manage Booking Slots </span>
                       </a>
                     </li>


                  <li>
                    <a href="Javascript:void();" onClick="openAdminUrl('clinic-user-list')">
                      <i class="bi bi-people" style="font-size:1.2em;"></i><span> Staff Account </span>
                    </a>
                  </li>
                  <li>
                    <a href="Javascript:void();" onClick="openAdminUrl('all-task-list-admin')">
                      <i class="bi-list-task" style="font-size:1.2em;"></i><span> Task list </span>
                    </a>
                  </li>

                  <li>
                    <a href="Javascript:void();" onClick="openAdminUrl('manage-hospital')">
                      <i class="bi bi-hospital" style="font-size:1.2em;"></i> <span> Manage Hospital </span>
                    </a>
                  </li>

                  <li>
                    <a href="Javascript:void();" onClick="openAdminUrl('manage-pharmacy')">
                      <i class="bi bi-prescription2" style="font-size:1.2em;"></i> <span> Manage Pharmacy </span>
                    </a>
                  </li>

                  <li>
                    <a href="Javascript:void();" onClick="openAdminUrl('manage-icd-code?action=list')">
                      <i class="bi bi-file-medical" style="font-size:1.3em;color:#FF1493;"></i> <span> Manage ICD Code  </span>
                    </a>
                  </li>

                 <li>
                    <a href="Javascript:void();" onClick="openAdminUrl('manage-medicine?action=list')">
                      <i class="bi bi-capsule" style="font-size:1.3em;color:#FF1493;"></i> <span> Manage Medicine   </span>
                    </a>
                  </li>

                </ul>
              </li><!-- End Patient Nav -->
        </c:if>




      <li class="nav-heading">Pages</li>

        <li class="nav-item">
         <a class="nav-link collapsed" href="Javascript:void()" onClick="openAdminUrl('consultation-list')">
            <i class="fa-sharp fa-solid fa-stethoscope" style="font-size:1.1em;color:#FF1493;"></i>
            <span> Consultation </span>
          </a>
        </li><!-- End Profile Page Nav -->


        <li class="nav-item">
            <a class="nav-link collapsed" href="Javascript:void()" onClick="openAdminUrl('manage-executive-report');">
              <i class="bi bi-journal-medical" style="color:#FF1493; font-size:1.3em;"></i> </i>
              <span> Executive Test Report</span>
            </a>
        </li><!-- End Blank Page Nav -->




      <li class="nav-item">
       <a class="nav-link collapsed" href="Javascript:void()" onClick="openAdminUrl('manage-appointment')">
          <i class="bi bi-camera-video" style="font-size:1.2em;color:blue;"></i>
          <span>Quick Meeting Link</span>
        </a>
      </li><!-- End Profile Page Nav -->


      <li class="nav-item">
       <a class="nav-link collapsed" href="Javascript:void()" onClick="openAdminUrl('ai-voice-text')">
          <span><i class="bi bi-mic" style="font-size:1.2em;color:red;"></i>AI - Voice to text </span>
        </a>
      </li><!-- End Profile Page Nav -->

      <li class="nav-item">
        <a class="nav-link collapsed" href="Javascript:void()" onClick="openAdminUrlNewWindows('login-health-mail')">
            <img width="55%" src="assets/img/healthmail.png" alt="Get Health Mail Token" title="Get Health Mail Token">
        </a>
      </li>

      <li class="nav-item">
        <a class="nav-link collapsed" href="Javascript:void()" onClick="openAdminUrl('reception-tvlink')">
          <i class="bi bi-tv-fill"></i>
          <span>Reception / TV </span>
        </a>
      </li><!-- End Contact Page Nav -->


    </ul>
  </aside><!-- End Sidebar-->


<!--Confirmation  Modal Structure Confirmation -->
 <div class="modal fade" id="confirmationModal" tabindex="-1" aria-labelledby="confirmationModalLabel" aria-hidden="true">
     <div class="modal-dialog modal-dialog-centered">
         <div class="modal-content">
             <div class="modal-header">
                 <h5 class="modal-title" id="confirmationModalLabel">Confirm Action</h5>
                 <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
             </div>
             <div class="modal-body" id="modelBodyContent" align="center">

             </div>
             <div class="modal-footer">
                 <button type="button" class="btn btn-danger" data-bs-dismiss="modal"> <i class="bi bi-x"></i> Cancel </button>
                 <button type="button" class="btn btn-info" onclick="confirmAction()"> <i class="bi bi-check2-all"></i>  OK  </button>
             </div>

             <p align="center">
                <button type="button" id="closeButton" class="btn btn-primary" data-bs-dismiss="modal" style="display:none;"> <i class="bi bi-x"></i> CLose </button>
             </p>

         </div>
     </div>
 </div>
<!-- End of Confirmation  Modal Structure Confirmation -->
<script src="https://code.jquery.com/jquery-1.6.2.min.js"> </script>



//--- Check session onject with the login status and if session expited then logout.
<c:if test="${empty ADMIN_SESSION.logonStatus or not fn:contains(ADMIN_SESSION.logonStatus, 'VALIDATED')}">
    <script>
        // Example: Force logout if session is invalid
        window.location.href = "${pageContext.request.contextPath}/adminlogout";
    </script>
</c:if>


//-- Check 2 hr and logout after 2 hr of login time
<c:if test="${ADMIN_SESSION.logonStatus or fn:contains(ADMIN_SESSION.logonStatus, 'VALIDATED')}">

    <script>

         // Set inactivity time in milliseconds (120 minutes)
          var inactivityTime = 120 * 60 * 1000;
          var inactivityTimer;

          function resetInactivityTimer() {
            clearTimeout(inactivityTimer);
            inactivityTimer = setTimeout(handleInactivity, inactivityTime);
          }

          function handleInactivity() {
                Swal.fire({
                  title: 'You have been inactive for more then 2 hours.',
                  text: 'Do you want to stay logged in?',
                  icon: 'warning',
                  showCancelButton: true,
                  confirmButtonText: 'Stay Logged In',
                  cancelButtonText: 'Logout'
                }).then((result) => {
                  if (result.isConfirmed) {
                    resetInactivityTimer();
                  } else {
                    logoutAdminUser();
                  }
                });
          }

          function logoutAdminUser() {
            window.location.href = '${pageContext.request.contextPath}/adminlogout';
          }


          // Events considered as user activity
          ['load', 'mousemove', 'keydown', 'click', 'scroll', 'touchstart'].forEach(function (eventName) {
            window.addEventListener(eventName, resetInactivityTimer, { passive: true });
          });
    </script>
</c:if>



 <script>

          const baseUrl = '${pageContext.request.contextPath}/';
          function viewPdfDocument(fileName) {
                var form = document.createElement('form');
                form.method = 'POST';
                form.action = 'view-document-admin';
                form.target = 'DocumentWindow';

                // Create input for filename
                var input = document.createElement('input');
                input.type = 'hidden';
                input.name = 'fileName';  // your endpoint should look for this POST param
                input.value = fileName;

                form.appendChild(input);
                document.body.appendChild(form);

                // Open a new window
                window.open('', 'DocumentWindow', 'width=1300,height=800,left=150,top=100,toolbar=no,location=no,status=no,menubar=no,scrollbars=yes,resizable=yes');

                // Submit the form
                form.submit();

                // Remove the form afterwards
                document.body.removeChild(form);

          }



          function viewPatientAttachment(fileName) {
                //const pdfUrl = "view-patient-attachment" + "?fileName=" + fileName;
                //const pdfUrl = "viewfile";
                //window.open(pdfUrl, '_blank');
                var form = document.createElement('form');
                form.method = 'POST';
                form.action = 'view-patient-attachment';
                form.target = 'DocumentWindow';

                // Create input for filename
                var input = document.createElement('input');
                input.type = 'hidden';
                input.name = 'fileName';  // your endpoint should look for this POST param
                input.value = fileName;

                form.appendChild(input);
                document.body.appendChild(form);

                // Open a new window
                window.open('', 'DocumentWindow', 'width=1300,height=800,left=150,top=100,toolbar=no,location=no,status=no,menubar=no,scrollbars=yes,resizable=yes');

                // Submit the form
                form.submit();

                // Remove the form afterwards
                document.body.removeChild(form);
          }


          function openAdminUrl(endpointName) {
              window.location.href = '${pageContext.request.contextPath}/'+endpointName;
          }



        function openAdminUrlNewWindows(endpointName) {

            var width = 500;
            var height = 500;

            var left = (window.screen.width / 2) - (width / 2);
            var top = (window.screen.height / 2) - (height / 2);

            var url = '${pageContext.request.contextPath}/' + endpointName;

            var features = "width=" + width +
                           ",height=" + height +
                           ",top=" + top +
                           ",left=" + left +
                           ",resizable=yes,scrollbars=yes,toolbar=no,menubar=no,location=no,status=no";

            window.open(url, "adminWindow", features);
        }

          // Create a canvas element
          const canvas = document.createElement('canvas');
          canvas.width = 150; // Set the dimensions of the canvas
          canvas.height = 150;
          const context = canvas.getContext('2d');

          // Draw the text "GP" onto the canvas
          context.fillStyle = '#178bd8'; // Background color
          context.fillRect(5, 5, canvas.width, canvas.height); // Fill background
          context.fillStyle = 'white'; // Text color
          context.font = 'bold 68px Arial'; // Font size and style
          context.textAlign = 'center';
          context.textBaseline = 'middle';
          context.fillText('GP', canvas.width / 2, canvas.height / 2);

          // Convert the canvas to a data URL
          const faviconURL = canvas.toDataURL();

          // Dynamically set the favicon
          const favicon = document.createElement('link');
          favicon.rel = 'icon';
          favicon.href = faviconURL;
          document.head.appendChild(favicon);


        function getTimeDifference(dateString){
            const givenDate = new Date(dateString); // Parse the given date
            const currentDate = new Date(); // Get the current date and time
            // Calculate the difference in milliseconds
            const differenceInMs = currentDate - givenDate;
            // Convert milliseconds to hours
            const differenceInHours = Math.round(differenceInMs / (1000 * 60 * 60));
            return differenceInHours + " hrs. ago";
        }


         //-- Copy email text to clipboard
         function copyEmailToClipBoard() {
            // Get the text content from the div
            const emailText = document.getElementById('emailId').textContent.trim();

            // Create a temporary textarea element
            const textarea = document.createElement('textarea');
            textarea.value = emailText;

            // Make it invisible (but still selectable)
            textarea.style.position = 'fixed';
            textarea.style.opacity = 0;

            // Add to document
            document.body.appendChild(textarea);

            // Select and copy
            textarea.select();
            const successful = document.execCommand('copy');

            document.getElementById('copyDiv').innerHTML='<span style="color:blue"><i class="fa fa-check" aria-hidden="true"> </i> Email copied.! </span>';
            setTimeout(function() {
               document.getElementById('copyDiv').innerHTML='<a href="Javascript:void();" onclick="copyEmailToClipBoard()"> <i class="bi bi-copy"></i> Copy email </a>';
            }, 2000);
         }


         //-- Copy Phone number text to clipboard
         function copyPhoneNumberToClipBoard() {
            // Get the text content from the div
            const phoneText = document.getElementById('phoneNumber_1').textContent.trim();

            // Create a temporary textarea element
            const textarea = document.createElement('textarea');
            textarea.value = phoneText;

            // Make it invisible (but still selectable)
            textarea.style.position = 'fixed';
            textarea.style.opacity = 0;

            // Add to document
            document.body.appendChild(textarea);

            // Select and copy
            textarea.select();
            const successful = document.execCommand('copy');

            document.getElementById('copyDivPhone').innerHTML='<span style="color:blue"><i class="fa fa-check" aria-hidden="true"> </i> Phone copied.! </span>';
            setTimeout(function() {
               document.getElementById('copyDivPhone').innerHTML='<a href="Javascript:void();" onclick="copyPhoneNumberToClipBoard()"> <i class="bi bi-copy"></i> Copy Phone  </a>';
            }, 2000);
         }



        // Alternative simplified version if you prefer regex-based approach:
        function removeHtmlTagsFromString(htmlContent) {
            return htmlContent
                // Handle line breaks first
                .replace(/<br\s*\/?>/gi, '\n')
                .replace(/<\/p>/gi, '\n\n')
                .replace(/<\/div>/gi, '\n')
                .replace(/<\/h[1-6]>/gi, '\n\n')

                // Handle lists with bullet points
                .replace(/<li[^>]*>/gi, '• ')
                .replace(/<\/li>/gi, '\n')
                .replace(/<\/?ul[^>]*>/gi, '')
                .replace(/<\/?ol[^>]*>/gi, '')

                // Handle formatting tags
                //.replace(/<(strong|b)[^>]*>/gi, '*')
                //.replace(/<\/(strong|b)>/gi, '*')
                .replace(/<(em|i)[^>]*>/gi, '_')
                .replace(/<\/(em|i)>/gi, '_')
                .replace(/<u[^>]*>/gi, '_')
                .replace(/<\/u>/gi, '_')

                // Remove all other HTML tags
                .replace(/<[^>]*>/g, '')

                // Handle HTML entities
                .replace(/&nbsp;/g, ' ')
                .replace(/&amp;/g, '&')
                .replace(/&lt;/g, '<')
                .replace(/&gt;/g, '>')
                .replace(/&quot;/g, '"')
                .replace(/&apos;/g, "'")
                .replace(/&#39;/g, "'")

                // Clean up whitespace
                .replace(/\n\s+/g, '\n')      // Remove spaces after newlines
                .replace(/\s+\n/g, '\n')      // Remove spaces before newlines
                .replace(/\n{3,}/g, '\n\n')   // Limit consecutive newlines to 2
                .replace(/^\s+|\s+$/g, '')    // Trim
                .replace(/[ \t]{2,}/g, ' ');  // Replace multiple spaces/tabs with single space
        }

 </script>


    <style>
        #confirmationModal .modal-dialog {
            width: 45%; /* Adjust width as needed */
            max-width: 100%; /* Optional: prevents exceeding viewport */
            height: 80%; /* Optional: if you need to adjust height */
          }


        /* Style setting for the Search button on the every table on this project admin side  */

        /* Center the search container */
       .datatable-search {
          width: 50%;
          text-align: center;
          margin: 0px 0; /* Add vertical spacing */
        }

        /* Style the search input */
        .datatable-input {
          width: 65% !important;  /* Adjust width as needed (50%, 70%, etc.) */
          max-width: 600px;      /* Maximum width */
          padding: 6px 10px;    /* Increase padding for better appearance */
          font-size: 16px;       /* Larger font size */
          border: 2px solid #ddd;
          border-radius: 5px;
          transition: all 0.3s ease;
        }

        /* Optional: Focus effect */
        .datatable-input:focus {
          outline: none;
          border-color: #4285f4;
          box-shadow: 0 0 15px rgba(66, 133, 244, 0.5);
        }
    </style>



  <body>