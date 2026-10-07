
package com.portal.util;

public class GPACalculator {

    /**
     * Converts a letter grade string into grade point scale (4.0 Max)
     */
    public static double convertGradeToPoint(String grade) {
        if (grade == null) return 0.0;

        switch (grade.toUpperCase().trim()) {
            case "A":  return 4.0;
            case "B+": return 3.5;
            case "B":  return 3.0;
            case "C+": return 2.5;
            case "C":  return 2.0;
            case "D":  return 1.0;
            default:   return 0.0;
        }
    }

    /**
     * Computes cumulative GPA based on total points and total accumulated credits
     */
    public static double calculateGPA(double totalPoints, int totalCredits) {
        if (totalCredits <= 0) return 0.0;
        double rawGpa = totalPoints / totalCredits;
        return Math.round(rawGpa * 100.0) / 100.0;
    }
}