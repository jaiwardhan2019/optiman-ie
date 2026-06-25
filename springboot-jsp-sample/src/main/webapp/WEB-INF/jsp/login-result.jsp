<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Login Result</title>
</head>
<body style="font-family: Arial, sans-serif; max-width: 700px; margin: 40px auto;">
    <h2>Login Validation Result</h2>

    <c:choose>
        <c:when test="${isValid}">
            <p style="color: green;">Success: Username <b>${username}</b> is valid.</p>
        </c:when>
        <c:otherwise>
            <p style="color: red;">Invalid username or password.</p>
        </c:otherwise>
    </c:choose>

    <p><a href="${pageContext.request.contextPath}/login">Try again</a></p>
</body>
</html>
