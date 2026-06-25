<%@ page contentType="text/html; charset=UTF-8" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
<html lang="en">
<head>
  <meta charset="utf-8">
  <meta content="width=device-width, initial-scale=1.0" name="viewport">

  <title>GPDOC Medical center     </title>

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

  <script src="https://cdn.jsdelivr.net/npm/sweetalert2@11"></script>

  <!-- Template Main CSS File -->
  <link href="assets-admin/css/style.css" rel="stylesheet">

  <!-- =======================================================
  * Template Name: NiceAdmin
  * Template URL: https://bootstrapmade.com/nice-admin-bootstrap-admin-html-template/
  * Updated: Apr 20 2024 with Bootstrap v5.3.3
  * Author: BootstrapMade.com
  * License: https://bootstrapmade.com/license/
  * Purple (main “gpdoc.” text purple ): #782565
  * Green (subtitle “medical centre” text green ): #0A5934
  ======================================================== -->
</head>

  <!-- ======= Header ======= -->
    <header id="header" class="header fixed-top d-flex align-items-center">
        <div class="d-flex align-items-center justify-content-start">
            <a href="${pageContext.request.contextPath}/reception" >
                <img src="assets/img/clinic-logo.png" alt="Logo" style="width: 120px;">
            </a>
            <marquee style="margin-left: 20px; font-size: 20px; color:#0A5934; font-weight: 1000;">
                Welcome to gpdoc Medical Center. Wellington Court, Wellington Street Upper, Phibsborough, Dublin 7, D07VFP5
            </marquee>
        </div>
    </header>
