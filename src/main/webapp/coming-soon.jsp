<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%
    if (session == null || session.getAttribute("userId") == null) {
        response.sendRedirect("login.jsp");
        return;
    }

    String featureName = request.getParameter("feature");
    if (featureName == null || featureName.trim().isEmpty()) {
        featureName = "Requested Module";
    }
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title><%= featureName %> - Under Construction</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <style>
        body {
            background-color: #120e1d;
            color: #f3e8ff;
            font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
            display: flex;
            align-items: center;
            justify-content: center;
            min-height: 100vh;
            margin: 0;
        }
        .card-custom {
            background: rgba(30, 24, 46, 0.85);
            border: 1px solid rgba(244, 114, 182, 0.25);
            border-radius: 20px;
            padding: 40px;
            text-align: center;
            max-width: 500px;
            box-shadow: 0 10px 30px rgba(0,0,0,0.5);
        }
        .icon-large {
            font-size: 64px;
            margin-bottom: 20px;
        }
    </style>
</head>
<body>

<div class="card-custom">
    <div class="icon-large">🚀</div>
    <h3 class="fw-bold text-white mb-2"><%= featureName %></h3>
    <p class="text-muted mb-4">This module is currently under active development and will be available in the next release.</p>
    <a href="dashboard.jsp" class="btn px-4 py-2" style="background-color: #f472b6; color: #120e1d; font-weight: 600; border-radius: 10px;">
        ← Back to Dashboard
    </a>
</div>

</body>
</html>