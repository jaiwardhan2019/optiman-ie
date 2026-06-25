<%@ page contentType="text/html;charset=UTF-8" language="java" pageEncoding="UTF-8" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags" %>

  <!-- Fonts -->
  <link href="https://fonts.googleapis.com" rel="preconnect">
  <link href="https://fonts.gstatic.com" rel="preconnect" crossorigin>
  <link href="https://fonts.googleapis.com/css2?family=Roboto:ital,wght@0,100;0,300;0,400;0,500;0,700;0,900;1,100;1,300;1,400;1,500;1,700;1,900&family=Open+Sans:ital,wght@0,300;0,400;0,500;0,600;0,700;0,800;1,300;1,400;1,500;1,600;1,700;1,800&family=Raleway:ital,wght@0,100;0,200;0,300;0,400;0,500;0,600;0,700;0,800;0,900;1,100;1,200;1,300;1,400;1,500;1,600;1,700;1,800;1,900&display=swap" rel="stylesheet">

  <!-- Vendor CSS Files -->
  <link href="assets/vendor/bootstrap/css/bootstrap.min.css" rel="stylesheet">
  <link href="assets/vendor/bootstrap-icons/bootstrap-icons.css" rel="stylesheet">
  <link href="assets/vendor/aos/aos.css" rel="stylesheet">
  <link href="assets/vendor/glightbox/css/glightbox.min.css" rel="stylesheet">
  <link href="assets/vendor/swiper/swiper-bundle.min.css" rel="stylesheet">

  <!-- Main CSS File -->
  <link href="assets/css/main.css" rel="stylesheet">
  <link href="assets/css/gp4less.css" rel="stylesheet">

  <!-- font-awesome CSS File -->
  <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0-beta3/css/all.min.css">
  <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.1/font/bootstrap-icons.css">
  <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.css">



  <!-- =======================================================
  * Template Name: Imperial
  * Template URL: https://bootstrapmade.com/imperial-free-onepage-bootstrap-theme/
  * Updated: Oct 08 2024 with Bootstrap v5.3.3
  * Author: BootstrapMade.com
  * License: https://bootstrapmade.com/license/
  ======================================================== -->

  <!-- For google analytic  -->
  <meta name="google-site-verification" content="scpQJpU_-M7ymtKfVIHF7dMHOA_bc7-n_7p-LxKgB_w" />

  <meta name="viewport" content="width=device-width, initial-scale=1.0">

    <head>
        <!-- Primary Meta Tags -->
        <title>GPForLess - Affordable low cost GP Services online in Dublin, Ireland</title>
        <meta name="description" content="GPForLess offers trusted low cost GP services in Dublin and across Ireland. Discover affordable GP services online with GP For Less—your partner in accessible healthcare.">

        <!-- Open Graph / Social Media Meta Tags (Optional) -->
        <meta property="og:title" content="GPForLess - Affordable GP Services in Dublin, Ireland">
        <meta property="og:description" content="GPForLess offers trusted low cost GP services in Dublin and across Ireland. Discover affordable GP services with GP For Less—your partner in accessible healthcare.">
        <meta property="og:url" content="https://www.gp4less.ie/">
        <meta property="og:type" content="website">
    </head>




<!-- For google analytic  -->
<script async src="https://www.googletagmanager.com/gtag/js?id=G-LPSJSHE7QF"></script>
<script>
  window.dataLayer = window.dataLayer || [];
  function gtag(){dataLayer.push(arguments);}
  gtag('js', new Date());
  gtag('config', 'G-LPSJSHE7QF');
</script>
<!-- End of google analytic  -->


<script src="https://cdn.jsdelivr.net/npm/sweetalert2@11"></script>  <!-- Sweet Alert .. -->


<!-- For all ajax cal  -->
<script src="https://code.jquery.com/jquery-1.6.2.min.js"> </script>

  <header id="header" class="header d-flex align-items-center fixed-top">
    <div class="container-fluid container-xl position-relative d-flex align-items-center justify-content-between">

        <c:choose>
            <c:when test="${not empty USER_SESSION && fn:contains(USER_SESSION.logonStatus, 'VALIDATED')}">
                <a href="${pageContext.request.contextPath}/my_home" class="logo d-flex align-items-center">
            </c:when>
            <c:otherwise>
                <a href="${pageContext.request.contextPath}/home" class="logo d-flex align-items-center">
            </c:otherwise>
        </c:choose>

          <!-- Uncomment the line below if you also wish to use an image logo -->
           <img width="50%" src="assets/img/website-logo.png" alt="GP4Less Logo">
          <!-- <h1 class="sitename"> GP4less.ie </h1> -->
      </a>




      <nav id="navmenu" class="navmenu">
        <ul>


          <c:if test="${not empty USER_SESSION}">
                <c:if test="${fn:contains(USER_SESSION.logonStatus, 'VALIDATED')}">
                        <!-- Start of Messages Nav -->
                        <li class="nav-item dropdown">
                          <a class="nav-link nav-icon" href="#" data-bs-toggle="dropdown">
                            <i class="bi bi-chat-left-text" style="font-size:1.4em;"></i>
                            <span class="badge bg-success badge-number blinking" id="messageCount"> </span>
                          </a>
                            <ul class="dropdown-menu dropdown-menu-end dropdown-menu-arrow messages">
                                <li class="dropdown-header">
                                  <span id="messageWithNumber_1"> </span>
                                </li>
                                <li>
                                  <hr class="dropdown-divider">
                                </li>

                                <!-- Load data from backend -->
                                <span id="messageContent"></span>

                            </ul><!-- End Messages Dropdown Items -->
                        </li>
                        <!-- End Messages Nav -->


                  <li>
                     <a href="${pageContext.request.contextPath}/my_home" class="active">
                         <svg xmlns="http://www.w3.org/2000/svg" width="18" height="18" fill="currentColor" class="bi bi-house" viewBox="0 0 16 16">
                         <path d="M8.707 1.5a1 1 0 0 0-1.414 0L.646 8.146a.5.5 0 0 0 .708.708L2 8.207V13.5A1.5 1.5 0 0 0 3.5 15h9a1.5 1.5 0 0 0 1.5-1.5V8.207l.646.647a.5.5 0 0 0 .708-.708L13 5.793V2.5a.5.5 0 0 0-.5-.5h-1a.5.5 0 0 0-.5.5v1.293zM13 7.207V13.5a.5.5 0 0 1-.5.5h-9a.5.5 0 0 1-.5-.5V7.207l5-5z"/>
                         </svg>
                         &nbsp;My Home
                     </a>
                  </li>

                </c:if>
          </c:if>


          <li>
		     <a href="${pageContext.request.contextPath}/our-services" >
                    <svg xmlns="http://www.w3.org/2000/svg" width="18" height="18" fill="currentColor" class="bi bi-activity" viewBox="0 0 16 16">
                      <path fill-rule="evenodd" d="M6 2a.5.5 0 0 1 .47.33L10 12.036l1.53-4.208A.5.5 0 0 1 12 7.5h3.5a.5.5 0 0 1 0 1h-3.15l-1.88 5.17a.5.5 0 0 1-.94 0L6 3.964 4.47 8.171A.5.5 0 0 1 4 8.5H.5a.5.5 0 0 1 0-1h3.15l1.88-5.17A.5.5 0 0 1 6 2"/>
                    </svg>
                   &nbsp;Our Services
			 </a>
		  </li>

          <li>
		       <a href="<spring:url value='/sick-note'/>">
                <i class="bi bi-award" style="font-size:1.2em;"> </i>
				&nbsp; Sick Note
			  </a>
		  </li>

          <li>
		       <a href="<spring:url value='/order-prescription'/>">
	                <i class="bi bi-prescription2" style="font-size:1.2em;"> </i>
				&nbsp; Prescription
			  </a>
		  </li>


         <li>
		     <a href="<spring:url value='/help-faq'/>">
				<svg xmlns="http://www.w3.org/2000/svg" width="18" height="18" fill="currentColor" class="bi bi-info-circle" viewBox="0 0 16 16">
				  <path d="M8 15A7 7 0 1 1 8 1a7 7 0 0 1 0 14m0 1A8 8 0 1 0 8 0a8 8 0 0 0 0 16"/>
				  <path d="m8.93 6.588-2.29.287-.082.38.45.083c.294.07.352.176.288.469l-.738 3.468c-.194.897.105 1.319.808 1.319.545 0 1.178-.252 1.465-.598l.088-.416c-.2.176-.492.246-.686.246-.275 0-.375-.193-.304-.533zM9 4.5a1 1 0 1 1-2 0 1 1 0 0 1 2 0"/>
				</svg>
			 &nbsp; Faq | Help
			 </a>
		  </li>

           <!-- Once User is login this will display  -->

                <c:if test="${fn:contains(USER_SESSION.logonStatus, 'VALIDATED')}">
                    <li class="dropdown"><a href="#"><span><i class="bi bi-person-circle" style="font-size:1.4em;"></i>&nbsp;&nbsp;<u>${USER_SESSION.patientAccount.firstName} ${fn:substring(USER_SESSION.patientAccount.lastName, 0,1)}. </u></span> <i class="bi bi-chevron-down toggle-dropdown"></i></a>
                        <ul>
                          <li> <a href="${pageContext.request.contextPath}/update-user-detail"> Update Profile </a>  </li>
                          <li> <a href="${pageContext.request.contextPath}/logout"> Logout </a></li>
                        </ul>
                      </li>
                </c:if>


         <c:if test="${not fn:contains(USER_SESSION.logonStatus, 'VALIDATED')}">
              <li>
                   &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
                   <button type="button" class="btn btn-info" id="loginReg" name="loginReg" onclick="openLoginRegistrationPage('login-register')">
                    <svg  width="16" height="16" fill="currentColor" class="bi bi-box-arrow-in-right" viewBox="0 0 16 16">
                     <path fill-rule="evenodd" d="M6 3.5a.5.5 0 0 1 .5-.5h8a.5.5 0 0 1 .5.5v9a.5.5 0 0 1-.5.5h-8a.5.5 0 0 1-.5-.5v-2a.5.5 0 0 0-1 0v2A1.5 1.5 0 0 0 6.5 14h8a1.5 1.5 0 0 0 1.5-1.5v-9A1.5 1.5 0 0 0 14.5 2h-8A1.5 1.5 0 0 0 5 3.5v2a.5.5 0 0 0 1 0z"></path>
                     <path fill-rule="evenodd" d="M11.854 8.354a.5.5 0 0 0 0-.708l-3-3a.5.5 0 1 0-.708.708L10.293 7.5H1.5a.5.5 0 0 0 0 1h8.793l-2.147 2.146a.5.5 0 0 0 .708.708z"></path>
                     </svg>
                      Login &nbsp;
                     </button>
		      </li>

		</c:if>





		</ul>
        <i class="mobile-nav-toggle d-xl-none bi bi-list"></i>
      </nav>
    </div>

  </header>

  <script src="https://code.jquery.com/jquery-1.6.2.min.js"> </script>

  <script>

      //--- Disable right click
      document.addEventListener('contextmenu', function (event) {
         //event.preventDefault();
      });


       function openLoginRegistrationPage(endPointName){
          //--- Change button label to In progress
          const loginReg = document.getElementById("loginReg");
          loginReg.disabled = true;
          loginReg.innerHTML = '<i class="fa fa-spinner fa-pulse fa-lg"> </i> In progress..';
          openUrl(endPointName);
       }

        function openUrl(endpointName) {
            window.location.href = '${pageContext.request.contextPath}/'+endpointName;
        }


      function viewPdfDocument(fileName) {
           // Create a form dynamically
            var form = document.createElement('form');
            form.method = 'POST';
            form.action = 'view-my-document';
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



        function viewPatientDocument(fileName) {
            viewPdfDocument(fileName);
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


  </script>


    <style>

        @keyframes fade {
          from {
            opacity: 0;
            visibility: hidden;
            transform: translateY(50px);
          }
          to {
            opacity: 1;
            visibility: visible;
            transform: translateY(0);
          }
        }

        /* Cookie Consent Modal Styles */
        .cookie-consent-modal {
            display: none;
            position: fixed;
            top: 40%;
            left: 20%;
            transform: translate(-50%, -50%);
            background-color: #d4e6f1;
            padding: 25px;
            border-radius: 8px;
            box-shadow: 0 4px 20px rgba(0, 0, 0, 0.15);
            z-index: 9999;
            width: 90%;
            max-width: 800px;
            animation: fade 2s linear forwards;

        }

        .cookie-consent-content {
            max-width: 1000px;
            margin: 0 auto;
            display: flex;
            flex-wrap: wrap;
            align-items: center;
            justify-content: space-between;
        }

        .cookie-consent-text {
            flex: 1;
            min-width: 300px;
            margin-bottom: 15px;
        }

        .cookie-consent-buttons {
            display: flex;
            gap: 10px;
        }

        .cookie-consent-btn {
            padding: 8px 16px;
            border: none;
            border-radius: 4px;
            cursor: pointer;
            font-weight: bold;
        }

        .accept-btn {
            background-color: #4CAF50;
            color: white;
        }

        .decline-btn {
            background-color: #f44336;
            color: white;
        }

        .settings-btn {
            background-color: #e7e7e7;
            color: black;
        }


        .blink {
          animation: blink-animation 1s steps(2, start) infinite;
        }
        @keyframes blink-animation {
          to {
            visibility: hidden;
          }
        }
    </style>

    <!-- Cookie Consent Modal -->
    <div id="cookieConsentModal" class="cookie-consent-modal">
        <div class="cookie-consent-content">
            <div class="cookie-consent-text">
                <p>We use cookies to enhance your experience on our website. By clicking "Accept", you consent to the use of all cookies. You can also customize your preferences or decline non-essential cookies.</p>
            </div>
            <div class="cookie-consent-buttons">
                <button id="declineCookies" class="cookie-consent-btn decline-btn">Decline</button>
                <button id="acceptCookies" class="cookie-consent-btn accept-btn">Accept</button>
            </div>
        </div>
    </div>



    <!-- GENERIC ALERT MODEL -->
    <div class="modal fade" id="genAlertModal" tabindex="-1" aria-labelledby="genAlertModal" aria-hidden="true">
    <div class="modal-dialog modal-dialog-centered" style="max-width: 700px;">
       <div class="modal-content">
           <div class="modal-header">
               <h5 class="modal-title" id="noconfirmationmodel" style="color: red;">Alert !</h5>
               <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
           </div>
            <div class="modal-body" id="genAlertModalBodyContent" align="center">
           </div>
           <div class="modal-footer" align="center">
               <button type="button" style="width:100px" class="btn btn-info" data-bs-dismiss="modal"> <i class="fa-solid fa-check"></i> Ok </button>
           </div>
       </div>
    </div>
    </div>
    <!-- END OF GENERIC ALERT MODEL -->
