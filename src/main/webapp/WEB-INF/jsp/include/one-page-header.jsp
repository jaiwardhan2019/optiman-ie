<%@ page contentType="text/html; charset=UTF-8" %>
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

<div class="d-flex align-items-center">
  <a href="" class="logo d-flex align-items-center">
    <span class="d-none d-lg-block">GP4Less - Admin</span>
  </a>
  &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
  &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
  &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
  &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
  <button type="button" class="btn btn-danger ms-auto" onclick="window.close();">
    <i class="bi bi-x-circle"></i> Close This Page
  </button>
</div>

  </header><!-- End Header -->


    <script>

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



          function viewPdfDocument(fileName) {
                //const pdfUrl = "view-my-document" + "?fileName=" + fileName;
               // window.open(pdfUrl, '_blank');
                //viewPatientDocument(fileName);
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



    </script>

  <body>