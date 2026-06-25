<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="x" uri="jakarta.tags.xml" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<%@ taglib prefix="fn" uri="jakarta.tags.functions" %>
<%@ taglib prefix="sql" uri="jakarta.tags.sql" %>
<!DOCTYPE html>
<%@tag description="Simple Template" pageEncoding="UTF-8"%>
<%@attribute name="title"%>
<%@attribute name="head_area" fragment="true" %>
<%@attribute name="body_area" fragment="true" %>
<%@attribute name="foot_area" fragment="true" %>
<html>
 <title>${title}</title>
      <jsp:include page="../include/one-page-header.jsp"/>
         <body id="bodyPart">
             <jsp:invoke fragment="body_area"/>
         </body>
      <!-- <jsp:include page="../include/admin-footer.jsp"/>
</html>