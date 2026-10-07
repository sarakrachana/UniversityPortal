<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*, com.portal.dao.DBConnection" %>
<%
    // Session Guard
    if (session == null || session.getAttribute("userId") == null) {
        response.sendRedirect("login.jsp");
        return;
    }

    Integer userId = (Integer) session.getAttribute("userId");
    String fullName = (String) session.getAttribute("fullName");
    String major = (String) session.getAttribute("major");
    if (major == null) major = "Software Engineering";

    String msg = request.getParameter("msg");
    String error = request.getParameter("error");
%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Academic Dashboard - University Portal</title>
    <!-- Chart.js CDN -->
    <script src="https://cdn.jsdelivr.net/npm/chart.js"></script>
    <style>
        * { box-sizing: border-box; margin: 0; padding: 0; font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif; }
        
        body { 
            background: #120e1d; 
            color: #f3e8ff; 
            min-height: 100vh; 
            padding: 24px;
            transition: background 0.3s, color 0.3s;
            position: relative;
        }

        /* Top Navigation Bar */
        .navbar {
            display: flex;
            justify-content: space-between;
            align-items: center;
            background: rgba(30, 24, 46, 0.85);
            border: 1px solid rgba(244, 114, 182, 0.2);
            padding: 16px 28px;
            border-radius: 16px;
            margin-bottom: 24px;
            backdrop-filter: blur(12px);
            position: relative;
            z-index: 100;
        }

        .brand-title {
            font-size: 18px;
            font-weight: 700;
            color: #f472b6;
        }

        .nav-controls {
            display: flex;
            align-items: center;
            gap: 12px;
            position: relative;
        }

        .user-greeting {
            font-size: 14px;
            color: #d8b4fe;
            margin-right: 8px;
        }

        .btn {
            padding: 8px 14px;
            border-radius: 8px;
            font-size: 13px;
            font-weight: 600;
            cursor: pointer;
            border: none;
            transition: all 0.2s;
            text-decoration: none;
            display: inline-flex;
            align-items: center;
            gap: 6px;
        }

        .btn-export { background: #a855f7; color: white; }
        .btn-export:hover { background: #9333ea; }

        .btn-pwd { background: #06b6d4; color: white; }
        .btn-pwd:hover { background: #0891b2; }

        .btn-theme { background: #ec4899; color: white; }
        .btn-theme:hover { background: #db2777; }

        .btn-logout { background: #f43f5e; color: white; }
        .btn-logout:hover { background: #e11d48; }

        /* --------------------------------------------------
           1. PASTEL USER PROFILE SWITCHER MENU
        -------------------------------------------------- */
        .profile-menu-container {
            position: relative;
        }

        .profile-dropdown {
            position: absolute;
            right: 0;
            top: 45px;
            background: #ffffff;
            border-radius: 16px;
            padding: 12px;
            box-shadow: 0 10px 25px rgba(0, 0, 0, 0.25);
            display: none;
            flex-direction: column;
            gap: 8px;
            min-width: 170px;
            z-index: 1000;
        }

        .user-pill {
            display: flex;
            align-items: center;
            gap: 10px;
            padding: 10px 16px;
            border-radius: 12px;
            font-size: 14px;
            font-weight: 600;
            cursor: pointer;
            border: none;
            transition: transform 0.15s ease, opacity 0.15s ease;
            color: #1e293b;
        }

        .user-pill:hover {
            transform: translateY(-2px);
            opacity: 0.9;
        }

        .pill-yellow { background-color: #fef3c7; color: #b45309; }
        .pill-pink   { background-color: #fce7f3; color: #be185d; }
        .pill-blue   { background-color: #e0f2fe; color: #0369a1; }
        .pill-green  { background-color: #dcfce7; color: #15803d; }

        /* --------------------------------------------------
           2. HAMBURGER HEADER OPTIONS MENU
        -------------------------------------------------- */
        .nav-dropdown {
            position: absolute;
            right: 0;
            top: 45px;
            background: #1e182e;
            border: 1px solid rgba(244, 114, 182, 0.3);
            border-radius: 16px;
            padding: 16px;
            width: 230px;
            box-shadow: 0 12px 30px rgba(0,0,0,0.5);
            display: none;
            flex-direction: column;
            z-index: 1000;
        }

        .menu-section-title {
            font-size: 11px;
            text-transform: uppercase;
            color: #f472b6;
            letter-spacing: 1px;
            margin: 8px 0 6px 8px;
        }

        .menu-item {
            display: flex;
            align-items: center;
            gap: 10px;
            padding: 10px 12px;
            color: #f3e8ff;
            text-decoration: none;
            border-radius: 10px;
            font-size: 13px;
            transition: background 0.2s;
        }

        .menu-item:hover {
            background: rgba(168, 85, 247, 0.2);
        }

        .menu-divider {
            height: 1px;
            background: rgba(255, 255, 255, 0.1);
            margin: 8px 0;
        }

        /* --------------------------------------------------
           3. STICKY SIDEBAR FEEDBACK TAB
        -------------------------------------------------- */
        .floating-feedback-btn {
            position: fixed;
            right: 0;
            top: 50%;
            transform: translateY(-50%) rotate(-90deg);
            transform-origin: right bottom;
            background: #0f172a;
            color: #ffffff;
            padding: 8px 18px;
            border-radius: 8px 8px 0 0;
            font-size: 13px;
            font-weight: 600;
            cursor: pointer;
            border: 1px solid rgba(244, 114, 182, 0.3);
            border-bottom: none;
            box-shadow: -2px 0 10px rgba(0,0,0,0.3);
            z-index: 999;
        }

        .floating-feedback-btn:hover { background: #1e293b; }

        /* --------------------------------------------------
           4. FLOATING ACTION MENU (FAB)
        -------------------------------------------------- */
        .fab-container {
            position: fixed;
            bottom: 24px;
            right: 24px;
            display: flex;
            flex-direction: column-reverse;
            align-items: center;
            gap: 12px;
            z-index: 1000;
        }

        .fab-main {
            width: 52px;
            height: 52px;
            border-radius: 50%;
            background: #ec4899;
            color: white;
            font-size: 22px;
            border: none;
            cursor: pointer;
            box-shadow: 0 6px 16px rgba(236, 72, 153, 0.4);
            transition: transform 0.2s;
        }

        .fab-main:hover { transform: scale(1.08); }

        .fab-options {
            display: none;
            flex-direction: column;
            gap: 10px;
        }

        .fab-option-btn {
            width: 42px;
            height: 42px;
            border-radius: 50%;
            background: #1e182e;
            border: 1px solid #a855f7;
            color: white;
            cursor: pointer;
            display: flex;
            align-items: center;
            justify-content: center;
            box-shadow: 0 4px 12px rgba(0,0,0,0.3);
            font-size: 16px;
        }

        /* Banner Notifications */
        .alert-banner {
            padding: 12px 18px;
            border-radius: 12px;
            font-size: 14px;
            margin-bottom: 20px;
            display: flex;
            align-items: center;
            justify-content: space-between;
        }
        .alert-success { background: rgba(74, 222, 128, 0.15); border: 1px solid #4ade80; color: #4ade80; }
        .alert-danger { background: rgba(244, 63, 94, 0.15); border: 1px solid #f43f5e; color: #fca5a5; }

        /* Announcements & Stats Cards */
        .announcement-card, .welcome-card, .stat-card, .table-container, .chart-container {
            background: rgba(30, 24, 46, 0.6);
            border: 1px solid rgba(244, 114, 182, 0.15);
            border-radius: 20px;
            padding: 24px;
            margin-bottom: 24px;
        }

        .announcement-item {
            background: rgba(18, 14, 29, 0.6);
            padding: 12px 16px;
            border-radius: 10px;
            border-left: 3px solid #a855f7;
            margin-top: 10px;
        }

        .welcome-card { display: flex; justify-content: space-between; align-items: center; }

        .stats-grid {
            display: grid;
            grid-template-columns: repeat(3, 1fr);
            gap: 20px;
            margin-bottom: 24px;
        }

        .stat-card { text-align: center; margin-bottom: 0; }
        .stat-card h4 { font-size: 12px; color: #f472b6; letter-spacing: 1px; margin-bottom: 8px; text-transform: uppercase; }
        .stat-card .value { font-size: 28px; font-weight: 800; color: #fff; }

        .dashboard-grid { display: grid; grid-template-columns: 2fr 1fr; gap: 24px; }
        .table-header-row { display: flex; justify-content: space-between; align-items: center; margin-bottom: 18px; }

        .search-course-input {
            background: rgba(18, 14, 29, 0.8);
            border: 1px solid rgba(244, 114, 182, 0.3);
            color: #fff;
            padding: 8px 14px;
            border-radius: 8px;
            outline: none;
            font-size: 13px;
            width: 200px;
        }

        table { width: 100%; border-collapse: collapse; text-align: left; }
        th { color: #f472b6; font-size: 12px; text-transform: uppercase; padding: 12px 16px; border-bottom: 1px solid rgba(244, 114, 182, 0.2); }
        td { padding: 14px 16px; border-bottom: 1px solid rgba(255, 255, 255, 0.05); font-size: 14px; }

        .grade-badge {
            display: inline-block;
            background: rgba(168, 85, 247, 0.2);
            border: 1px solid #a855f7;
            color: #e9d5ff;
            padding: 2px 10px;
            border-radius: 12px;
            font-weight: 600;
            font-size: 12px;
        }

        /* Modal Overlay */
        .modal-overlay {
            display: none;
            position: fixed;
            top: 0; left: 0; width: 100%; height: 100%;
            background: rgba(0, 0, 0, 0.75);
            justify-content: center;
            align-items: center;
            z-index: 2000;
        }

        .modal-box {
            background: #1e182e;
            padding: 28px;
            border-radius: 16px;
            width: 350px;
            border: 1px solid rgba(244, 114, 182, 0.3);
        }

        .modal-box input {
            width: 100%;
            padding: 10px 14px;
            margin-bottom: 14px;
            background: #120e1d;
            border: 1px solid rgba(244, 114, 182, 0.3);
            color: #fff;
            border-radius: 8px;
            outline: none;
        }

        /* Light Mode Theme */
        body.light-mode { background: #f8fafc; color: #0f172a; }
        body.light-mode .navbar, 
        body.light-mode .welcome-card, 
        body.light-mode .stat-card, 
        body.light-mode .announcement-card, 
        body.light-mode .table-container, 
        body.light-mode .chart-container,
        body.light-mode .nav-dropdown {
            background: #ffffff;
            border-color: #cbd5e1;
            box-shadow: 0 4px 12px rgba(0,0,0,0.05);
            color: #0f172a;
        }
        body.light-mode .stat-card .value, body.light-mode th, body.light-mode td, body.light-mode .menu-item { color: #0f172a; }
        body.light-mode .search-course-input { background: #f1f5f9; color: #0f172a; border-color: #94a3b8; }
        body.light-mode .announcement-item { background: #f8fafc; }

        @media print {
            body { background: #ffffff !important; color: #000000 !important; padding: 0 !important; }
            .navbar, .btn, .search-course-input, .announcement-card, .chart-container, .modal-overlay, .floating-feedback-btn, .fab-container { display: none !important; }
            .dashboard-grid { display: block !important; }
            .welcome-card, .stat-card, .table-container { background: #ffffff !important; border: 1px solid #ccc !important; box-shadow: none !important; color: #000000 !important; }
            .stat-card .value, th, td { color: #000000 !important; }
        }
    </style>
</head>
<body>

    <!-- Sticky Sidebar Feedback Button -->
    <button class="floating-feedback-btn" onclick="alert('Feedback form opened!')">Feedback</button>

    <!-- Floating Action Menu (FAB) -->
    <div class="fab-container">
        <button class="fab-main" onclick="toggleFab()">⚙️</button>
        <div id="fabOptions" class="fab-options">
            <button class="fab-option-btn" title="Filter Grades" onclick="document.querySelector('.search-course-input').focus()">🔍</button>
            <button class="fab-option-btn" title="Print Transcript" onclick="window.print()">📄</button>
            <button class="fab-option-btn" title="Refresh Page" onclick="location.reload()">🔄</button>
        </div>
    </div>

    <!-- Top Navigation Bar -->
    <div class="navbar">
        <div class="brand-title">The University of Cambodia (UC)</div>
        
        <div class="nav-controls">
            <span class="user-greeting">Welcome, <strong><%= fullName %></strong></span>

            <!-- Pastel Student Switcher Dropdown -->
            <div class="profile-menu-container">
                <button onclick="toggleProfileMenu()" class="btn btn-export">👥 Students</button>
                <div id="profileDropdown" class="profile-dropdown">
                    <div class="user-pill pill-yellow" onclick="alert('Switching to Max')">👤 Max</div>
                    <div class="user-pill pill-pink" onclick="alert('Switching to Julia')">👤 Julia</div>
                    <div class="user-pill pill-blue" onclick="alert('Switching to Andy')">👤 Andy</div>
                    <div class="user-pill pill-green" onclick="alert('Switching to Sarah')">👤 Sarah</div>
                </div>
            </div>

            <button onclick="toggleTheme()" id="themeBtn" class="btn btn-theme">☀️ Light Mode</button>

            <!-- Hamburger Options Menu -->
            <div style="position: relative;">
                <button onclick="toggleNavMenu()" class="btn btn-pwd">Menu ☰</button>
                <div id="navDropdown" class="nav-dropdown">
                    <div class="menu-section-title">Academic Modules</div>
                    <a href="#" class="menu-item">📚 My Courses</a>
                    <a href="#" class="menu-item">📊 Grade Reports</a>
                    <a href="#" class="menu-item">📅 Exam Schedule</a>

                    <div class="menu-divider"></div>

                    <div class="menu-section-title">Account Settings</div>
                    <a href="javascript:void(0)" onclick="document.getElementById('pwdModal').style.display='flex'" class="menu-item">🔑 Change Password</a>
                    <a href="LogoutServlet" class="menu-item" style="color: #f87171;">🚪 Logout</a>
                </div>
            </div>
        </div>
    </div>

    <!-- Alert Banners -->
    <% if ("password_updated".equals(msg)) { %>
        <div class="alert-banner alert-success">
            <span>✅ Password changed successfully!</span>
            <button onclick="this.parentElement.style.display='none'" style="background:none; border:none; color:#4ade80; cursor:pointer;">✕</button>
        </div>
    <% } else if ("invalid_current_password".equals(error)) { %>
        <div class="alert-banner alert-danger">
            <span>⚠️ Current password was incorrect. Please try again.</span>
            <button onclick="this.parentElement.style.display='none'" style="background:none; border:none; color:#fca5a5; cursor:pointer;">✕</button>
        </div>
    <% } %>

    <!-- Notice Board -->
    <div class="announcement-card">
        <h3 style="color: #f472b6; font-size: 15px; display: flex; align-items: center; gap: 8px;">
            📢 University Announcements
        </h3>
        <%
            try (Connection con = DBConnection.getConnection()) {
                String sqlAnn = "SELECT * FROM announcements ORDER BY posted_date DESC LIMIT 2";
                Statement stmtAnn = con.createStatement();
                ResultSet rsAnn = stmtAnn.executeQuery(sqlAnn);
                while (rsAnn.next()) {
        %>
            <div class="announcement-item">
                <h4 style="font-size: 14px; color: #a855f7;"><%= rsAnn.getString("title") %></h4>
                <p style="font-size: 13px; margin-top: 4px; opacity: 0.9;"><%= rsAnn.getString("content") %></p>
            </div>
        <%
                }
            } catch (Exception e) {
                e.printStackTrace();
            }
        %>
    </div>

    <!-- Welcome Header Card -->
    <div class="welcome-card">
        <div>
            <h2 style="font-size: 24px; margin-bottom: 6px;">Hello, <%= fullName %>! 👋</h2>
            <p style="color: #a78bfa; font-size: 14px;">Welcome back to your academic portal dashboard.</p>
        </div>
        <div>
            <label style="font-size: 13px; color: #d8b4fe; margin-right: 8px;">Major:</label>
            <span style="background: rgba(244, 114, 182, 0.15); border: 1px solid rgba(244, 114, 182, 0.3); padding: 6px 14px; border-radius: 8px; font-weight: 600;">
                <%= major %>
            </span>
        </div>
    </div>

    <%
        int totalCredits = 0;
        int enrolledCourses = 0;
        double totalPoints = 0.0;

        try (Connection con = DBConnection.getConnection()) {
            String sql = "SELECT * FROM grades WHERE user_id = ?";
            PreparedStatement ps = con.prepareStatement(sql);
            ps.setInt(1, userId);
            ResultSet rs = ps.executeQuery();

            while (rs.next()) {
                int credits = rs.getInt("credits");
                String grade = rs.getString("grade");
                
                enrolledCourses++;
                totalCredits += credits;

                double point = 0.0;
                if ("A".equalsIgnoreCase(grade)) point = 4.0;
                else if ("B+".equalsIgnoreCase(grade)) point = 3.5;
                else if ("B".equalsIgnoreCase(grade)) point = 3.0;
                else if ("C+".equalsIgnoreCase(grade)) point = 2.5;
                else if ("C".equalsIgnoreCase(grade)) point = 2.0;
                else if ("D".equalsIgnoreCase(grade)) point = 1.0;

                totalPoints += (point * credits);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }

        double calculatedGPA = totalCredits == 0 ? 0.0 : Math.round((totalPoints / totalCredits) * 100.0) / 100.0;
    %>

    <!-- Metrics Grid -->
    <div class="stats-grid">
        <div class="stat-card">
            <h4>Cumulative GPA</h4>
            <div class="value"><%= String.format("%.2f", calculatedGPA) %></div>
        </div>
        <div class="stat-card">
            <h4>Total Credits</h4>
            <div class="value"><%= totalCredits %></div>
        </div>
        <div class="stat-card">
            <h4>Enrolled Courses</h4>
            <div class="value"><%= enrolledCourses %></div>
        </div>
    </div>

    <!-- Main Content Split Grid -->
    <div class="dashboard-grid">
        <!-- Results Table -->
        <div class="table-container">
            <div class="table-header-row">
                <h3 style="font-size: 18px;">Academic Results</h3>
                <input type="text" class="search-course-input" placeholder="Search course...">
            </div>

            <table>
                <thead>
                    <tr>
                        <th>Course Code</th>
                        <th>Course Name</th>
                        <th>Credits</th>
                        <th>Grade</th>
                        <th>Attendance</th>
                    </tr>
                </thead>
                <tbody>
                    <%
                        try (Connection con = DBConnection.getConnection()) {
                            String sql = "SELECT * FROM grades WHERE user_id = ?";
                            PreparedStatement ps = con.prepareStatement(sql);
                            ps.setInt(1, userId);
                            ResultSet rs = ps.executeQuery();

                            while (rs.next()) {
                                int attendanceVal = 95;
                                try { attendanceVal = rs.getInt("attendance"); } catch(Exception ex) {}
                    %>
                    <tr>
                        <td style="font-weight: 600; color: #f472b6;"><%= rs.getString("course_code") %></td>
                        <td><%= rs.getString("course_name") %></td>
                        <td><%= rs.getInt("credits") %></td>
                        <td><span class="grade-badge"><%= rs.getString("grade") %></span></td>
                        <td style="color: #4ade80; font-weight: 600;"><%= attendanceVal %>%</td>
                    </tr>
                    <%
                            }
                        } catch (Exception e) {
                            e.printStackTrace();
                        }
                    %>
                </tbody>
            </table>
        </div>

        <!-- Grade Chart -->
        <div class="chart-container">
            <h3 style="font-size: 16px; margin-bottom: 16px;">Grade Overview</h3>
            <div style="max-width: 260px; margin: 0 auto;">
                <canvas id="gradeChart"></canvas>
            </div>
        </div>
    </div>

    <!-- Password Modal -->
    <div id="pwdModal" class="modal-overlay">
        <div class="modal-box">
            <h3 style="color: #f472b6; margin-bottom: 16px;">Change Password</h3>
            <form action="ChangePasswordServlet" method="POST">
                <input type="password" name="currentPassword" placeholder="Current Password" required>
                <input type="password" name="newPassword" placeholder="New Password" required>
                <div style="display: flex; gap: 10px;">
                    <button type="submit" class="btn btn-export" style="flex:1; justify-content:center;">Update</button>
                    <button type="button" onclick="document.getElementById('pwdModal').style.display='none'" class="btn btn-logout" style="flex:1; justify-content:center;">Cancel</button>
                </div>
            </form>
        </div>
    </div>

    <!-- Interactive Menu Scripts -->
    <script>
        // Toggle User Profile Pill Dropdown
        function toggleProfileMenu() {
            const menu = document.getElementById('profileDropdown');
            const navMenu = document.getElementById('navDropdown');
            navMenu.style.display = 'none'; // Close other menu
            menu.style.display = menu.style.display === 'flex' ? 'none' : 'flex';
        }

        // Toggle Hamburger Navigation Dropdown
        function toggleNavMenu() {
            const navMenu = document.getElementById('navDropdown');
            const profileMenu = document.getElementById('profileDropdown');
            profileMenu.style.display = 'none'; // Close other menu
            navMenu.style.display = navMenu.style.display === 'flex' ? 'none' : 'flex';
        }

        // Toggle Bottom FAB Menu
        function toggleFab() {
            const fab = document.getElementById('fabOptions');
            fab.style.display = fab.style.display === 'flex' ? 'none' : 'flex';
        }

        // Toggle Dark/Light Theme
        function toggleTheme() {
            const body = document.body;
            const btn = document.getElementById('themeBtn');
            body.classList.toggle('light-mode');
            btn.textContent = body.classList.contains('light-mode') ? '🌙 Dark Mode' : '☀️ Light Mode';
        }

        // Close dropdowns on window click outside
        window.onclick = function(e) {
            if (!e.target.matches('.btn-export') && !e.target.matches('.btn-pwd') && !e.target.matches('.fab-main')) {
                const profileMenu = document.getElementById('profileDropdown');
                const navMenu = document.getElementById('navDropdown');
                if (profileMenu) profileMenu.style.display = 'none';
                if (navMenu) navMenu.style.display = 'none';
            }
        };

        // Live Course Search & Chart.js Initialization
        document.addEventListener('DOMContentLoaded', function() {
            const searchInput = document.querySelector('.search-course-input');
            const tableRows = document.querySelectorAll('table tbody tr');

            if (searchInput && tableRows.length > 0) {
                searchInput.addEventListener('keyup', function(e) {
                    const query = e.target.value.toLowerCase().trim();
                    tableRows.forEach(row => {
                        row.style.display = row.textContent.toLowerCase().includes(query) ? '' : 'none';
                    });
                });
            }

            const ctx = document.getElementById('gradeChart');
            if (ctx) {
                let countA = 0, countB = 0, countC = 0;
                tableRows.forEach(row => {
                    const gradeText = row.children[3].textContent.trim();
                    if (gradeText.includes('A')) countA++;
                    else if (gradeText.includes('B')) countB++;
                    else countC++;
                });

                new Chart(ctx.getContext('2d'), {
                    type: 'doughnut',
                    data: {
                        labels: ['Grade A / A-', 'Grade B / B+', 'Grade C / Lower'],
                        datasets: [{
                            data: [countA, countB, countC],
                            backgroundColor: ['#a855f7', '#ec4899', '#06b6d4'],
                            borderWidth: 0
                        }]
                    },
                    options: {
                        plugins: {
                            legend: { 
                                position: 'bottom',
                                labels: { color: '#d8b4fe', font: { size: 11 } } 
                            }
                        }
                    }
                });
            }
        });
    </script>

</body>
</html>