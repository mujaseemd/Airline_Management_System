package airlinemanagement;

import java.awt.Color;
import java.awt.Cursor;
import javax.swing.*;
import java.awt.event.*;
import java.sql.*;

public class CalculateRevenueForm extends JFrame {

    private JTextField flightCodeField;
    private JTextArea resultArea;
    private JButton submitButton;
    private JLabel jLabelBack;  // Declare JLabel for the back button

    // Constructor
    public CalculateRevenueForm() {
        setTitle("Calculate Total Revenue");
        setSize(400, 300);
        setDefaultCloseOperation(JFrame.DISPOSE_ON_CLOSE);
        getContentPane().setBackground(new Color(45, 35, 99));

        // Initialize components
        flightCodeField = new JTextField(30);
        resultArea = new JTextArea(10, 30);
        resultArea.setEditable(false);
        submitButton = new JButton("Calculate Revenue");
        jLabelBack = new JLabel("BACK");  // Initialize JLabel for back button
        jLabelBack.setForeground(Color.WHITE);  // Set label text color to white
        jLabelBack.setCursor(new Cursor(Cursor.HAND_CURSOR));  // Set cursor to hand icon

        // Layout setup
        JPanel panel = new JPanel();
        panel.setBackground(new Color(45, 35, 99));
        panel.setLayout(new BoxLayout(panel, BoxLayout.Y_AXIS));

        JLabel flightCodeLabel = new JLabel("Flight Code:");
        flightCodeLabel.setForeground(Color.WHITE);

        // Add components to panel
        panel.add(flightCodeLabel);
        panel.add(flightCodeField);
        panel.add(submitButton);
        panel.add(new JScrollPane(resultArea));
        panel.add(Box.createVerticalStrut(10));  // Add space between result area and back label
        panel.add(jLabelBack);  // Add JLabel back button to panel

        add(panel);

        // Action listener for the submit button
        submitButton.addActionListener(new ActionListener() {
            public void actionPerformed(ActionEvent e) {
                calculateTotalRevenue();  // Fetch and display total revenue
            }
        });

        // Mouse click event listener for jLabelBack
        jLabelBack.addMouseListener(new MouseAdapter() {
            public void mouseClicked(MouseEvent evt) {
                jLabelBackMouseClicked(evt);  // Call the back navigation method
            }
        });

        setLocationRelativeTo(null);
        setVisible(true);
    }

    // Method to calculate total revenue
    private void calculateTotalRevenue() {
        String flightCode = flightCodeField.getText();

        try (Connection conn = DriverManager.getConnection("jdbc:mysql://localhost:4306/airline_management_system", "root", "")) {
            // Call stored procedure
            String query = "{CALL CalculateTotalRevenue(?)}";
            CallableStatement stmt = conn.prepareCall(query);
            stmt.setString(1, flightCode);

            ResultSet rs = stmt.executeQuery();
            resultArea.setText("");  // Clear any previous results

            if (rs.next()) {
                String message = rs.getString("message");
                resultArea.append(message);  // Display the result message
            }

            rs.close();
            stmt.close();
        } catch (SQLException ex) {
            JOptionPane.showMessageDialog(this, "Database error: " + ex.getMessage(), "Error", JOptionPane.ERROR_MESSAGE);
        }
    }

    // Method to handle the back navigation event
    private void jLabelBackMouseClicked(MouseEvent evt) {
        dashboard obj = new dashboard();  // Open the Dashboard form
        obj.setVisible(true);  // Show the dashboard
        dispose();  // Close the current form
    }

    public static void main(String[] args) {
        new CalculateRevenueForm();
    }
}
