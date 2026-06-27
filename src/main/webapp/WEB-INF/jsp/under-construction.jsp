<%@taglib prefix="t" tagdir="/WEB-INF/tags" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>

<t:main_layout title=" Under construction  ">
    <jsp:attribute name="body_area">


      <main class="main" align="center">
        <div class="page-title dark-background"> </div>
        <div class="container">

              <section id="contact" class="contact section">
                    <div class="container">
                          <br>
                          <br>
                          <h1 style="font-size: 3rem;color: #28a1f1;"> <i class="bi bi-cone-striped" style="color: #d35400; font-size:1.4em;" ></i>  Page Under Construction !! </h1>
                          <p style="font-size: 1.2rem;">We're working hard to bring this service online. Stay tuned!</p>
                          <p style="font-size: 1.2rem;"> Register your interest here so that we can notify you once this service is online</p>
                          <p style="font-size: 1.2rem;">
                              <a href="${pageContext.request.contextPath}/my_home"> My Dashboard </a>
                          </p>
                          <hr>
                    </div>
              </section>

              <br>
              <br>
              <br>
              <br>
              <br>
        </div>
      </main>


<style>
        body {
            font-family: Arial, sans-serif;
            text-align: center;
            color: #333;
            margin: 0;
            padding: 0;
        }
        .container {
            display: flex;
            flex-direction: column;
            justify-content: center;
            align-items: center;
        }

    </style>


    </jsp:attribute>
</t:main_layout>


