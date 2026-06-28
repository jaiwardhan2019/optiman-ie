<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
<%@ page contentType="text/html; charset=UTF-8" %>

  <!--Start of medical log book row -->
  <h5 class="card-title"> Medical Log book  </h5>
       <div class="row">
               <form name="ehrlog" id="ehrlog">
                <!-- First Row: Three small select boxes -->
                <div class="row mb-4">
                  <div class="col-md-4">
                    <select class="form-select form-select-sm" id="documentType" onChange="typeof searchEhrLogAndRender === 'function' && searchEhrLogAndRender('<c:out value='${patientDetail.userId}'/>');">
                        <c:forEach var="entry" items="${ehrUtility.getDocumentTypeMap()}">
                            <option value="<c:out value='${entry.key}'/>">     <c:out value='${entry.value}'/>       </option>
                        </c:forEach>
                    </select>
                  </div>

                  <div class="col-md-4">
                    <select class="form-select form-select-sm" id="serviceId" name="serviceId" onChange="searchEhrLogAndRender('<c:out value='${patientDetail.userId}'/>');">
                        <c:forEach var="entry" items="${ehrUtility.getServiceTypeMap()}">
                            <option value="<c:out value='${entry.key}'/>" <c:if test="${fn:contains(entry.key, 'All')}">selected</c:if> >
                                     <c:out value='${entry.value}'/>
                            </option>
                        </c:forEach>
                    </select>
                  </div>

                  <div class="col-md-4">
                    <select class="form-select form-select-sm" id="messageType" onChange="searchEhrLogAndRender('<c:out value='${patientDetail.userId}'/>');">
                        <c:forEach var="entry" items="${ehrUtility.getMessageTypeMap()}">
                            <option value="<c:out value='${entry.key}'/>">     <c:out value='${entry.value}'/>       </option>
                        </c:forEach>
                    </select>
                  </div>
                </div>
                <hr>
                <br>
               </form>

                <!-- Second Row: Tabular Report -->

                <div class="row">
                  <div class="col-12">
                    <div class="table-responsive">
                      <table class="table table-hover table-sm">
                          <tbody id="logTableBody">
                            <c:forEach var="log" items="${medicalLogs}">
                                <tr>
                                    <td height="60px" >

                                        <c:choose>
                                          <c:when test="${fn:contains(log.messageType, 'Patient Message') or fn:contains(log.messageType, 'Automated Message')}">
                                            <i class="bi bi-person-circle" style="color: #272EF5">  <c:out value='${log.doctorName}'/> </i>
                                          </c:when>
                                          <c:when test="${fn:contains(log.messageType, 'Doctor Message')}">
                                             <i class="fa-solid fa-user-doctor" style="font-size:1.2em;color: #FF1493;"></i>
                                              <span style="color: #FF1493;"> <c:out value='${log.doctorName}'/> &nbsp;</span>
                                          </c:when>

                                          <c:otherwise >
                                             <i class="fa-solid fa-user-doctor" style="font-size:1.2em;color: #FF1493;"></i>
                                              <span style="color: #FF1493;"> <c:out value='${log.doctorName}'/> &nbsp;</span>
                                          </c:otherwise>
                                        </c:choose>

                                        <c:out value='${log.formatLocalDateTime()}'/>. &nbsp;&nbsp;&nbsp;<c:out value="${log.notes}" escapeXml="false" />

                                        <c:choose>
                                          <c:when test="${not fn:contains(log.notes, '.pdf')}">
                                            <p align="right">
                                             <span style="color:blue;">
                                             <span style="color:black; background-color:lightgreen;">
                                               <c:out value='${log.ptViewDateTime}'/>
                                             </span>
                                               &nbsp;&nbsp;&nbsp;&nbsp; &nbsp;&nbsp;&nbsp;&nbsp;
                                               <a href="javascript:void();" onClick="removeItemFromEhrLog('<c:out value='${patientDetail.userId}'/>','<c:out value='${log.logId}'/>');" style="color:red;"> <i class="bi bi-trash"> Remove </i> </a>
                                             </p>
                                          </c:when>

                                          <c:when test="${fn:contains(log.notes, '.pdf')}">
                                             <br>
                                             <iframe id="pdfPreview_2" src="view-document-admin?fileName=<c:out value='${log.documentName}'/>"
                                               style="width:100%; min-height:300px;margin-top:15px;"></iframe>
                                             <br>
                                              <p align="right">
                                                 <span style="color:black; background-color:lightgreen;">
                                                   <c:out value='${log.ptViewDateTime}'/>
                                                 </span>
                                                   &nbsp;&nbsp;&nbsp;&nbsp; &nbsp;&nbsp;&nbsp;&nbsp;
                                                 <a href="javascript:void();" onClick="removeItemFromEhrLog('<c:out value='${patientDetail.userId}'/>','<c:out value='${log.logId}'/>');" style="color:red;"> <i class="bi bi-trash"> Remove </i> </a>
                                                    &nbsp;&nbsp;&nbsp;&nbsp;
                                                  <a href="javascript:void();" onClick="confirmPatientEmailAndResend('<c:out value='${patientDetail.userId}'/>','<c:out value='${log.documentName}'/>');"  style="color:blue;"> <i class="bi bi-envelope-check"> Resend </i> </a>
                                              </p>
                                          </c:when>
                                        </c:choose>

                                    </td>
                                </tr>
                            </c:forEach>
                        </tbody>
                      </table>
                    </div>
                  </div>
                </div>
       </div> <!--End of medical log book row -->


 <script src="assets-admin/js/manage-patient.js?v=101" defer></script>