package com.portal.dao;

import java.sql.Connection;
import java.sql.DriverManager;

public class DBConnection {
    public static Connection getConnection() throws Exception {
        Class.forName("com.mysql.cj.jdbc.Driver");
        // Ensure database name is 'university_db'
        return DriverManager.getConnection("jdbc:mysql://localhost:3306/university_db?useSSL=false&allowPublicKeyRetrieval=true", "root", "@imnoturnana123$");
    }
}