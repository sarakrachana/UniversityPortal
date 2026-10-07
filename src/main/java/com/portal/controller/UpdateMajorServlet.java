package com.portal.controller;

import com.portal.dao.DBConnection;
import java.io.IOException;
import java.sql.Connection;
import java.sql.PreparedStatement;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;

@WebServlet("/UpdateMajorServlet")
public class UpdateMajorServlet extends HttpServlet {
    protected void doPost(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        HttpSession session = request.getSession();
        Integer userId = (Integer) session.getAttribute("userId");
        String newMajor = request.getParameter("major");

        if (userId != null && newMajor != null) {
            try (Connection con = DBConnection.getConnection()) {
                String sql = "UPDATE users SET major = ? WHERE id = ?";
                PreparedStatement ps = con.prepareStatement(sql);
                ps.setString(1, newMajor);
                ps.setInt(2, userId);
                
                int rowsUpdated = ps.executeUpdate();
                if (rowsUpdated > 0) {
                    session.setAttribute("major", newMajor); // Update session value
                    response.getWriter().write("success");
                    return;
                }
            } catch (Exception e) {
                e.printStackTrace();
            }
        }
        response.getWriter().write("error");
    }
}