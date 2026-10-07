<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*, com.portal.dao.DBConnection" %>
<%
    // Session Guard
    if (session == null || session.getAttribute("userId") == null) {
        response.sendRedirect("login.jsp");
        return;
    }

    Integer userId = (Integer) session.getAttribute("userId");

    String fullName = "";
    String email = "";
    String studentId = "STU-" + userId;
    String major = "Computer Science & IT";
    String phone = "Not provided";

    // Fetch user details from database
    try (Connection conn = DBConnection.getConnection()) {
        String sql = "SELECT * FROM users WHERE id = ?";
        try (PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, userId);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                fullName = rs.getString("full_name");
                email = rs.getString("email");
            }
        }
    } catch (Exception e) {
        e.printStackTrace();
    }

    if (fullName == null || fullName.isEmpty()) {
        fullName = (String) session.getAttribute("fullName");
    }
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>Student Profile</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <style>
        body {
            background-color: #120e1d;
            color: #f3e8ff;
            font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
            padding: 30px;
        }
        .card-custom {
            background: rgba(30, 24, 46, 0.85);
            border: 1px solid rgba(244, 114, 182, 0.2);
            border-radius: 16px;
            padding: 24px;
            backdrop-filter: blur(12px);
        }
        .text-pink { color: #f472b6; }
        .avatar-circle {
            width: 90px;
            height: 90px;
            background: linear-gradient(135deg, #a855f7, #ec4899);
            border-radius: 50%;
            display: flex;
            align-items: center;
            justify-content: center;
            font-size: 36px;
            color: #fff;
            margin: 0 auto 16px;
            box-shadow: 0 4px 15px rgba(168, 85, 247, 0.4);
        }
        .info-label {
            color: #9ca3af;
            font-size: 0.85rem;
            text-transform: uppercase;
            font-weight: 600;
        }
        .info-value {
            color: #ffffff;
            font-size: 1.05rem;
            font-weight: 500;
            margin-bottom: 16px;
        }
    </style>
</head>
<body>

<div class="container" style="max-width: 600px;">
    
    <div class="card-custom">
        <div class="d-flex justify-content-between align-items-center mb-4">
            <h4 class="m-0 text-pink fw-bold">👤 Student Profile</h4>
            <a href="dashboard.jsp" class="btn btn-sm btn-outline-light">Back to Dashboard</a>
        </div>

        <div class="text-center mb-4">
            <div class="avatar-circle">
                <%= (fullName != null && !fullName.isEmpty()) ? fullName.substring(0, 1).toUpperCase() : "S" %>
            </div>
            <h4 class="fw-bold mb-1"><%= fullName %></h4>
            <span class="badge bg-purple px-3 py-2" style="background: rgba(168, 85, 247, 0.2); border: 1px solid #a855f7; color: #e9d5ff;">
                Student Account
            </span>
        </div>

        <hr style="border-color: rgba(244, 114, 182, 0.2);" class="my-4">

        <div class="row">
            <div class="col-6">
                <div class="info-label">Student ID</div>
                <div class="info-value text-pink"><%= studentId %></div>
            </div>
            <div class="col-6">
                <div class="info-label">Major</div>
                <div class="info-value"><%= major %></div>
            </div>
            <div class="col-12">
                <div class="info-label">Email Address</div>
                <div class="info-value"><%= email %></div>
            </div>
        </div>

        <div class="mt-3 text-end">
            <a href="dashboard.jsp" class="btn btn-pink px-4" style="background-color: #ec4899; color: white; border: none; border-radius: 8px;">Edit Profile</a>
        </div>
    </div>

</div>

</body>
</html>