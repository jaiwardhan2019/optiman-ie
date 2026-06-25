  <%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
  <footer id="footer" class="footer">
    <div class="copyright">
      &copy; Copyright <strong><span> Optiman  </span></strong>. All Rights Reserved
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
           //event.preventDefault();
        });


        </script>
    </c:if>

    </body>

</html>