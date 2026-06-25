  <%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
  <footer id="footer" class="footer dark-background">
    <div class="container">
      <div class="row gy-3">
        <div class="col-lg-3 col-md-6 d-flex">
          <i class="bi bi-geo-alt icon"></i>
          <div class="address">
            <h4>Address</h4>
            <p>GP4Less Medical centre, Wellington Court</p>
            <p>,Wellington street upper</p>
            <p>D07VFP5</p>
          </div>
        </div>

        <div class="col-lg-3 col-md-6 d-flex">
          <i class="bi bi-envelope-arrow-up icon"></i>
          <div>
            <h4>Contact</h4>
            <p>
               <strong> <a href="mailto:support@GP4Less.ie" >support@GP4Less.ie </a> </strong>
               <br><a href="${pageContext.request.contextPath}/home#contact"> <strong> Submit Query Online </strong> <span> </a></span>
            </p>
          </div>
        </div>

        <div class="col-lg-3 col-md-6 d-flex">
          <i class="bi bi-clock icon"></i>
          <div>
            <h4>Opening Hours</h4>
            <p align="left">
              <strong>Mon-Friday:</strong> <span>9AM - 6PM</span><br>
              <strong>Sunday and All bank holidays </strong>: <span>Closed</span>
            </p>
          </div>
        </div>

        <div class="col-lg-3 col-md-6 d-flex">
          <i class="bi bi-info-circle icon"></i>
          <div>
            <h4>Useful Links</h4>
            <p align="left">
              <strong > <a href="terms-condition" target="_blank" rel="noopener noreferrer" >Terms and condition </a></strong> <br>
              <strong> <a href="help-faq"  rel="noopener noreferrer" > Faq | Help | Support  </a></strong><br>
              <strong> <a href="how-it-works"  rel="noopener noreferrer" > How this work  </a></strong>
            </p>


          </div>
        </div>
    </div>

    <div class="container copyright text-center mt-4">
      <p> © <span>Copyright</span> <strong class="px-1 sitename">   <a href="${pageContext.request.contextPath}/home"> GP4Less </a>  </strong> <span>All Rights Reserved</span></p>
    </div>

  </footer>

  <!-- Scroll Top -->
  <a href="#" id="scroll-top" class="scroll-top d-flex align-items-center justify-content-center"><i class="bi bi-arrow-up-short"></i></a>

  <!-- Preloader -->
  <div id="preloader"></div>

  <!-- Vendor JS Files -->
  <script src="assets/vendor/bootstrap/js/bootstrap.bundle.min.js"></script>
  <script src="assets/vendor/php-email-form/validate.js"></script>
  <script src="assets/vendor/aos/aos.js"></script>
  <script src="assets/vendor/typed.js/typed.umd.js"></script>
  <script src="assets/vendor/glightbox/js/glightbox.min.js"></script>
  <script src="assets/vendor/imagesloaded/imagesloaded.pkgd.min.js"></script>
  <script src="assets/vendor/isotope-layout/isotope.pkgd.min.js"></script>
  <script src="assets/vendor/swiper/swiper-bundle.min.js"></script>

  <!-- Main JS File -->
  <script src="assets/js/main.js"></script>
  <script src="assets/js/gp4less.js"></script>

  <script>
    //--- This method will do autoresize of the text area
    function autoResize(textarea) {
      textarea.style.height = 'auto';         // Reset height
      textarea.style.height = textarea.scrollHeight + 'px'; // Set new height based on content
    }
  </script>



    <!--  This part will only execute when user is logged on -->
    <c:if test="${not fn:contains(USER_SESSION.logonStatus, 'VALIDATED')}">

        <script>
          // Set inactivity time in milliseconds (15 minutes)
          var inactivityTime = 15 * 60 * 1000;
          var inactivityTimer;

          function resetInactivityTimer() {
            clearTimeout(inactivityTimer);
            inactivityTimer = setTimeout(handleInactivity, inactivityTime);
          }

          function handleInactivity() {
            logoutUser();
          }

          function logoutUser() {
            window.location.href = '${pageContext.request.contextPath}/logout';
          }

          // Events considered as user activity
          ['load', 'mousemove', 'keydown', 'click', 'scroll', 'touchstart'].forEach(function (eventName) {
            window.addEventListener(eventName, resetInactivityTimer, { passive: true });
          });


          //-- Read any message been sent to the user
          getAllMessageForUser('${USER_SESSION.patientAccount.userId}');

          // Set second function to run every 60 seconds
          // setInterval(getAllMessageForUser, 60000);

          //--- This method will read message data from database and render to the element


          function getAllMessageForUser(patientId){
             $.ajax({
                 type : 'GET',
                 url : 'get-message-for-user-from-db',
                 dataType : 'json',
                 contentType : 'application/json',
                 success : function(result) {
                     var messageBody = '';
                     for (var i = 0; i < result.length; i++) {
                         messageBody += "<li class='message-item'>";

                         if(result[i].requestType === 'Sick Note'){
                             messageBody += "<a href=${pageContext.request.contextPath}/view-sick-note?requestNo="+result[i].requestId+"&messageId="+result[i].messageId+">";
                         }

                         if(result[i].requestType === 'Prescription'){
                            messageBody += '<a href=${pageContext.request.contextPath}/view-prescription?requestNo='+result[i].requestId+'&messageId='+result[i].messageId+'>';
                         }

                         if(result[i].requestType === 'GP Message'){
                            messageBody += "<a href='${pageContext.request.contextPath}/view-message?patientId="+patientId+"'>You have "+ i +" new message </a>";
                         }

                         messageBody += '<div> From : '+ result[i].messageFrom;
                         messageBody += '<br>'+getTimeDifference(result[i].createDate);
                         messageBody += '</div></a></li>';
                         messageBody += '<li><hr class="dropdown-divider"></li>';
                     }

                    //-- If there is notification available then render detail on the bell icon
                    if(i > 0){
                        document.getElementById("messageCount").innerHTML=i+" New ";
                        document.getElementById("messageWithNumber_1").innerHTML="<a href='Javascript:void(0)' onClick='viewMessages(\""+patientId+"\")'>You have "+ i +" new message </a>";

                    }
                    else{
                        document.getElementById("messageCount").innerHTML="Message";
                        document.getElementById("messageWithNumber_1").innerHTML="<a href='Javascript:void(0)' onClick='viewMessages(\""+patientId+"\")'>View all message </a>";
                    }
                 }
             });//-- End of ajax cal
            } //--- End of function



             function getTimeDifference(dateString){
                 const givenDate = new Date(dateString); // Parse the given date
                 const currentDate = new Date(); // Get the current date and time
                 // Calculate the difference in milliseconds
                 const differenceInMs = currentDate - givenDate;
                 // Convert milliseconds to hours
                 const differenceInHours = Math.round(differenceInMs / (1000 * 60 * 60));
                 return differenceInHours + " hrs. ago";
             }


            function viewMessages(patientId) {
                  const form = document.createElement('form');
                  form.method = 'POST';
                  form.action = 'view-message'; // endpoint should accept POST
                  form.style.display = 'none';

                  const input = document.createElement('input');
                  input.type = 'hidden';
                  input.name = 'userId';
                  input.value = patientId;
                  form.appendChild(input);
                  document.body.appendChild(form);
                  form.submit();
            }

        </script>
    </c:if>
