<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>University Portal Login</title>
    <style>
        * { box-sizing: border-box; margin: 0; padding: 0; font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif; }
        
        body { 
            background: #181524; 
            color: #f3e8ff; 
            min-height: 100vh; 
            display: flex;
            justify-content: center;
            align-items: center;
            position: relative; 
            overflow: hidden; 
        }
        body::before, body::after { 
            content: ''; 
            position: absolute; 
            width: 450px; 
            height: 450px; 
            border-radius: 50%; 
            filter: blur(120px); 
            z-index: -1; 
            opacity: 0.55; 
        }
        body::before { background: #f472b6; top: -100px; left: -100px; } 
        body::after { background: #c084fc; bottom: -100px; right: -100px; } 

        .login-card {
            background: rgba(35, 29, 51, 0.75);
            backdrop-filter: blur(16px);
            border: 1px solid rgba(244, 114, 182, 0.25);
            padding: 40px 32px;
            border-radius: 20px;
            width: 380px;
            box-shadow: 0 10px 40px rgba(0, 0, 0, 0.4);
            text-align: center;
        }

        .login-card h2 {
            font-size: 22px;
            font-weight: 700;
            background: linear-gradient(135deg, #f472b6, #c084fc);
            -webkit-background-clip: text;
            -webkit-text-fill-color: transparent;
            margin-bottom: 24px;
        }

        .user-icon {
            width: 70px;
            height: 70px;
            background: rgba(244, 114, 182, 0.15);
            border: 1px solid rgba(244, 114, 182, 0.3);
            border-radius: 50%;
            display: flex;
            align-items: center;
            justify-content: center;
            margin: 0 auto 24px auto;
        }

        .user-icon svg {
            width: 36px;
            height: 36px;
            fill: #f472b6;
        }

        .error-alert {
            background: rgba(244, 63, 94, 0.15);
            border: 1px solid rgba(244, 63, 94, 0.4);
            color: #fca5a5;
            padding: 10px 14px;
            border-radius: 10px;
            font-size: 13px;
            margin-bottom: 20px;
        }

        .input-group {
            margin-bottom: 18px;
            text-align: left;
        }

        .input-group input {
            width: 100%;
            padding: 12px 16px;
            background: rgba(20, 16, 32, 0.8);
            border: 1px solid rgba(244, 114, 182, 0.3);
            color: #fff;
            border-radius: 10px;
            font-size: 14px;
            outline: none;
            transition: border-color 0.2s;
        }

        .input-group input:focus {
            border-color: #f472b6;
        }

        .options-row {
            display: flex;
            align-items: center;
            margin-bottom: 24px;
            font-size: 13px;
            color: #d8b4fe;
        }

        .options-row input[type="checkbox"] {
            margin-right: 8px;
            accent-color: #ec4899;
            cursor: pointer;
        }

        .login-btn {
            width: 100%;
            padding: 12px;
            background: linear-gradient(135deg, #ec4899, #a855f7);
            color: white;
            border: none;
            border-radius: 10px;
            font-size: 15px;
            font-weight: 600;
            cursor: pointer;
            transition: transform 0.2s, box-shadow 0.2s;
            box-shadow: 0 4px 15px rgba(236, 72, 153, 0.35);
        }

        .login-btn:hover {
            transform: translateY(-2px);
            box-shadow: 0 6px 20px rgba(236, 72, 153, 0.5);
        }
    </style>
</head>
<body>

    <div class="login-card">
        <h2>University Portal Login 💕</h2>
        
        <div class="user-icon">
            <svg viewBox="0 0 24 24">
                <path d="M12 12c2.21 0 4-1.79 4-4s-1.79-4-4-4-4 1.79-4 4 1.79 4 4 4zm0 2c-2.67 0-8 1.34-8 4v2h16v-2c0-2.66-5.33-4-8-4z"/>
            </svg>
        </div>

        <%
            String error = request.getParameter("error");
            if ("invalid".equals(error)) {
        %>
            <div class="error-alert">⚠️ Invalid username or password!</div>
        <%
            } else if ("server".equals(error)) {
        %>
            <div class="error-alert">⚠️ Database connection error. Please try again.</div>
        <%
            }
        %>

        <form action="LoginServlet" method="POST">
            <div class="input-group">
                <input type="text" name="username" placeholder="Username" required autocomplete="off">
            </div>
            
            <div class="input-group">
                <input type="password" name="password" placeholder="Password" required>
            </div>

            <div class="options-row">
                <label>
                    <input type="checkbox" name="remember"> Remember Me
                </label>
            </div>

            <button type="submit" class="login-btn">Login</button>
        </form>
    </div>

</body>
</html>