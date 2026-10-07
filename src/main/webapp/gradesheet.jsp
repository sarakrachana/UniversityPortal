<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*, java.util.*, com.portal.dao.DBConnection" %>
<%
    // Check if user is logged in
    if (session == null || session.getAttribute("userId") == null) {
        response.sendRedirect("login.jsp");
        return;
    }

    Integer userId = (Integer) session.getAttribute("userId");
    String fullName = (String) session.getAttribute("fullName");

    String selectedTerm = request.getParameter("term");
    if (selectedTerm == null) selectedTerm = "all";

    int totalCredits = 0;
    double totalPoints = 0.0;
    List<Map<String, Object>> gradesList = new ArrayList<>();

    // Read directly from MySQL Database
    try (Connection conn = DBConnection.getConnection()) {
        String sql = "SELECT * FROM grades WHERE user_id = ?";
        if (!selectedTerm.equals("all")) {
            sql += " AND term = ?";
        }
        
        try (PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, userId);
            if (!selectedTerm.equals("all")) {
                ps.setInt(2, Integer.parseInt(selectedTerm));
            }

            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                Map<String, Object> row = new HashMap<>();
                row.put("term", rs.getInt("term"));
                row.put("code", rs.getString("course_code"));
                row.put("name", rs.getString("course_name"));
                row.put("credits", rs.getInt("credits"));
                row.put("grade", rs.getString("grade"));
                gradesList.add(row);

                // Convert letter grade to GPA points
                String g = rs.getString("grade");
                double pts = 0.0;
                if (g.equalsIgnoreCase("A")) pts = 4.0;
                else if (g.equalsIgnoreCase("B+")) pts = 3.5;
                else if (g.equalsIgnoreCase("B")) pts = 3.0;
                else if (g.equalsIgnoreCase("C+")) pts = 2.5;
                else if (g.equalsIgnoreCase("C")) pts = 2.0;

                int cr = rs.getInt("credits");
                totalCredits += cr;
                totalPoints += (pts * cr);
            }
        }
    } catch (Exception e) {
        e.printStackTrace();
    }

    double gpa = totalCredits == 0 ? 0.0 : Math.round((totalPoints / totalCredits) * 100.0) / 100.0;
%>
<!DOCTYPE html>
<html>
<head>
    <title>GradeSheet</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <style>
        body { background: #120e1d; color: #f3e8ff; padding: 24px; font-family: 'Segoe UI', sans-serif; }
        .card-custom { background: rgba(30, 24, 46, 0.85); border: 1px solid rgba(244, 114, 182, 0.2); border-radius: 16px; padding: 20px; }
        .text-pink { color: #f472b6; }
        table { color: #f3e8ff; }
        th { color: #f472b6; text-transform: uppercase; font-size: 12px; }
    </style>
</head>
<body>
    <div class="container">
        <div class="card-custom mb-4 d-flex justify-content-between align-items-center">
            <h3 class="m-0 text-pink">📊 Academic Study Record</h3>
            <a href="dashboard.jsp" class="btn btn-sm btn-outline-light">Back to Dashboard</a>
        </div>

        <!-- Metric Summary -->
        <div class="row mb-4 text-center">
            <div class="col-md-4">
                <div class="card-custom">
                    <small class="text-pink fw-bold">GPA</small>
                    <h2 class="mt-2"><%= String.format("%.2f", gpa) %></h2>
                </div>
            </div>
            <div class="col-md-4">
                <div class="card-custom">
                    <small class="text-pink fw-bold">TOTAL CREDITS</small>
                    <h2 class="mt-2"><%= totalCredits %></h2>
                </div>
            </div>
            <div class="col-md-4">
                <div class="card-custom">
                    <small class="text-pink fw-bold">SUBJECTS</small>
                    <h2 class="mt-2"><%= gradesList.size() %></h2>
                </div>
            </div>
        </div>

        <!-- Grade Table -->
        <div class="card-custom">
            <div class="d-flex justify-content-between align-items-center mb-3">
                <h5>Course Results</h5>
                <form method="get" action="gradesheet.jsp">
                    <select name="term" class="form-select form-select-sm bg-dark text-white border-secondary" onchange="this.form.submit()">
                        <option value="all" <%= "all".equals(selectedTerm) ? "selected" : "" %>>All Terms</option>
                        <option value="1" <%= "1".equals(selectedTerm) ? "selected" : "" %>>Term 1</option>
                        <option value="2" <%= "2".equals(selectedTerm) ? "selected" : "" %>>Term 2</option>
                        <option value="3" <%= "3".equals(selectedTerm) ? "selected" : "" %>>Term 3</option>
                        <option value="4" <%= "4".equals(selectedTerm) ? "selected" : "" %>>Term 4</option>
                    </select>
                </form>
            </div>

            <table class="table table-dark table-hover">
                <thead>
                    <tr>
                        <th>Term</th>
                        <th>Code</th>
                        <th>Course Title</th>
                        <th>Credits</th>
                        <th>Grade</th>
                    </tr>
                </thead>
                <tbody>
                    <% if (gradesList.isEmpty()) { %>
                        <tr><td colspan="5" class="text-center text-muted">No records found.</td></tr>
                    <% } else { 
                        for (Map<String, Object> r : gradesList) { %>
                        <tr>
                            <td>Term <%= r.get("term") %></td>
                            <td class="text-pink fw-bold"><%= r.get("code") %></td>
                            <td><%= r.get("name") %></td>
                            <td><%= r.get("credits") %></td>
                            <td><span class="badge bg-purple"><%= r.get("grade") %></span></td>
                        </tr>
                    <%  } 
                       } %>
                </tbody>
            </table>
        </div>
    </div>
</body>
</html>