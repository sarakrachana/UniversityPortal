package com.portal.controller;

import java.io.IOException;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import com.portal.dao.DBConnection;

@WebServlet("/LoginServlet")
public class LoginServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    // Handles Direct URL access / Page Refresh safely without throwing 404
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        response.sendRedirect("login.jsp");
    }

    // Handles Login Form Submission
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        String loginInput = request.getParameter("username");
        String passwordInput = request.getParameter("password");

        if (loginInput != null) loginInput = loginInput.trim();
        if (passwordInput != null) passwordInput = passwordInput.trim();

        try (Connection con = DBConnection.getConnection()) {
            // Check matching credentials against either 'username' OR 'full_name'
            String sql = "SELECT * FROM users WHERE (username = ? OR full_name = ?) AND password = ?";
            PreparedStatement ps = con.prepareStatement(sql);
            ps.setString(1, loginInput);
            ps.setString(2, loginInput);
            ps.setString(3, passwordInput);

            ResultSet rs = ps.executeQuery();

            if (rs.next()) {
                HttpSession session = request.getSession();
                session.setAttribute("userId", rs.getInt("id"));
                session.setAttribute("fullName", rs.getString("full_name"));
                session.setAttribute("username", rs.getString("username"));
                session.setAttribute("major", rs.getString("major"));

                response.sendRedirect("dashboard.jsp");
            } else {
                response.sendRedirect("login.jsp?error=invalid");
            }

        } catch (Exception e) {
            e.printStackTrace();
            response.sendRedirect("login.jsp?error=server");
        }
    }
}