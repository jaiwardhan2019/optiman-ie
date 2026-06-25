  <%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
  <footer id="footer" class="footer">
    <div class="copyright">
      &copy; Copyright <strong><span> GP4Less  </span></strong>. All Rights Reserved
    </div>
  </footer><!-- End Footer -->

  <a href="#" class="back-to-top d-flex align-items-center justify-content-center"><i class="bi bi-arrow-up-short"></i></a>
  <!-- Vendor JS Files -->
  <script src="assets-admin/vendor/apexcharts/apexcharts.min.js"></script>
  <script src="assets-admin/vendor/bootstrap/js/bootstrap.bundle.min.js"></script>
  <script src="assets-admin/vendor/chart.js/chart.umd.js"></script>
  <script src="assets-admin/vendor/echarts/echarts.min.js"></script>
  <script src="assets-admin/vendor/quill/quill.js"></script>
  <script src="assets-admin/vendor/simple-datatables/simple-datatables.js"></script>
  <script src="assets-admin/vendor/tinymce/tinymce.min.js"></script>
  <script src="assets-admin/vendor/php-email-form/validate.js"></script>

  <!-- For all alerts and confirmation model-->
  <script src="https://cdn.jsdelivr.net/npm/sweetalert2@11"></script>

  <!-- Template Main JS File -->
  <script src="assets-admin/js/main.js"></script>

  <script>
    //--- This method will do autoresize of the text area
    function autoResize(textarea) {
      textarea.style.height = 'auto';         // Reset height
      textarea.style.height = textarea.scrollHeight + 'px'; // Set new height based on content
    }
  </script>


    <!-- For all ajax cal  -->
    <script src="https://code.jquery.com/jquery-1.6.2.min.js"> </script>

    <c:if test="${not empty ADMIN_SESSION.logonStatus or not fn:contains(ADMIN_SESSION.logonStatus, 'VALIDATED')}">

        <script>

            // Set first function to run every 520 seconds
            setInterval(updateServiceNotification, 520000);

            // Set second function to run every 520 seconds
            //setInterval(updateMessageFromPaitent, 520000);

            // Run them immediately on page load too
            updateServiceNotification();
            updateMessageFromPaitent();


              //--- Fetch Notification top 15 on every 60 second
             async function updateServiceNotification(){
                    $.ajax({
                                type : 'GET',
                                url : 'get-notification',
                                dataType : 'json',
                                contentType : 'application/json',
                                success : function(result) {
                                    var s = '';
                                    for (var i = 0; i < result.length; i++) {

                                        if(result[i].requestType === 'Sick Note'){
                                            s += '<a href=${pageContext.request.contextPath}/view-request-sicknote?requestNo='+result[i].requestId+'&messageId='+result[i].messageId+'>';
                                        }

                                        if(result[i].requestType === 'Prescription'){
                                           s += '<a href=${pageContext.request.contextPath}/view-request-prescription?requestNo='+result[i].requestId+'&messageId='+result[i].messageId+'>';
                                        }

                                       if(result[i].requestType === 'Clinic task'){
                                           s += '<a href=${pageContext.request.contextPath}/view-task-detail?refNumber='+result[i].requestId+'>';
                                        }

                                        s += '<li class="notification-item"> <i class="bi bi-check-circle text-success"></i><div>';
                                        s += '<h4>'+ result[i].requestType+'</h4>';
                                        s += '<p>'+ result[i].requestFrom+'</p>';
                                        s += '<p>'+ getTimeDifference(result[i].createDate)+'</p>';
                                        s += '</div></li> ';
                                        s += '<li><hr class="dropdown-divider"> </li>';
                                        s += '</a>';
                                    }

                                   //-- If there is notification available then render detail on the bell icon
                                   if(i > 0){
                                       document.getElementById("notificationCount").innerHTML=i;
                                       document.getElementById("messageWithNumber").innerHTML="You have "+ i +" new service request";
                                       document.getElementById("liContent").innerHTML=s;
                                   }

                                }
                    }); //--- End of ajax cal

              } //-- End of function





              //--- Fetch patient message on every 15 second
             async function updateMessageFromPaitent(){
                    $.ajax({
                                type : 'GET',
                                url : 'get-message-for-user-from-db?userId=${ADMIN_SESSION.userId}',
                                dataType : 'json',
                                contentType : 'application/json',
                                success : function(result) {
                                    var messageBody = '';
                                    for (var i = 0; i < result.length; i++) {
                                        messageBody += '<li class="message-item">';

                                        if(result[i].requestType === 'Sick Note'){
                                            messageBody += '<a href=${pageContext.request.contextPath}/view-request-sicknote?requestNo='+result[i].requestId+'&messageId='+result[i].messageId+'>';
                                        }

                                        if(result[i].requestType === 'Prescription'){
                                           messageBody += '<a href=${pageContext.request.contextPath}/view-request-prescription?requestNo='+result[i].requestId+'&messageId='+result[i].messageId+'>';
                                        }

                                        messageBody += '<div style="margin-left:25px"> <h4 >'+ result[i].messageFrom+'</h4>';
                                        messageBody += '<p>'+result[i].messageBody+'</p>';
                                        messageBody += '<p>'+getTimeDifference(result[i].createDate)+'</p>';
                                        messageBody += '</div></a></li>';
                                        messageBody += '<li><hr class="dropdown-divider"></li>';
                                    }

                                   //-- If there is notification available then render detail on the bell icon
                                   if(i > 0){
                                       document.getElementById("messageCount").innerHTML=i;
                                       document.getElementById("messageWithNumber_1").innerHTML="You have "+ i +" new message";
                                       document.getElementById("messageContent").innerHTML=messageBody;
                                   }
                                }
                    });//-- End of ajax cal

              } // -- End of function


            function openFileInNewWindow(fileName) {
                const url = '/view-document-admin?fileName='+fileName;
                window.open(
                    url,
                    '_blank',
                    'toolbar=no,location=no,status=no,menubar=no,scrollbars=yes,resizable=yes,width=1200,height=1000,top=100,left=100'
                );
            }

            function alertUnderConstruction() {
              Swal.fire({
                title: 'Under Construction',
                text: 'This feature is currently under development.',
                icon: 'info',
                confirmButtonText: 'OK'
              });
            } //  End of function alertUnderConstruction




        //--------THIS METHOD WILL RELOAD EHR LOG -------------------------------
        async function reloadEhrLogPageForPatient(patientId) {
          const resp = await fetch('get-updated-ehr-log?patientId='+patientId);
          const html = await resp.text();
          document.getElementById("ehrLogContainer").innerHTML = html;
        }


        //--- Disable right click
        document.addEventListener('contextmenu', function (event) {
           event.preventDefault();
        });


        </script>
    </c:if>

    </body>

</html>