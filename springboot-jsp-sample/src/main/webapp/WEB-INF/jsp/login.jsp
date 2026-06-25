<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Login</title>
    <style>
        body { font-family: Arial, sans-serif; max-width: 500px; margin: 40px auto; }
        .card { border: 1px solid #ddd; border-radius: 8px; padding: 20px; }
        input { width: 100%; margin: 8px 0; padding: 10px; }
        button { padding: 10px 14px; }
    </style>
</head>
<body>
<div class="card">
    <h2>User Login</h2>
    <form method="post" action="${pageContext.request.contextPath}/login">
        <label>Username</label>
        <input type="text" name="username" required />

        <label>Password</label>
        <input type="password" name="password" required />

        <button type="submit">Validate</button>
    </form>
</div>
</body>
</html>
