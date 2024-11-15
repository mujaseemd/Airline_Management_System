package airlinemanagement;

import java.awt.Color;
import java.awt.Cursor;
import javax.swing.*;
import java.awt.event.*;
import java.sql.*;

public class GetPassengersForm extends JFrame {

    private JTextField flightCodeField;
    private JTextArea resultArea;
    private JButton submitButton;
    private JLabel jLabelBack;  // Declare JLabel for the back button

    // Constructor
    public GetPassengersForm() {
        // Initialize the Swing components
        setTitle("Retrieve Passengers for a Flight");
        setSize(400, 300);
        setDefaultCloseOperation(JFrame.DISPOSE_ON_CLOSE);  // Close the form when the user closes it
        getContentPane().setBackground(new Color(45, 35, 99));  // Set background color of the content pane

        // Layout setup
        flightCodeField = new JTextField(30);
        resultArea = new JTextArea(10, 30);
        resultArea.setEditable(false);  // Make the result area non-editable
        submitButton = new JButton("Retrieve Passengers");
        jLabelBack = new JLabel("BACK");  // Initialize JLabel for back button
        jLabelBack.setForeground(Color.WHITE);  // Set label text color to white
        jLabelBack.setCursor(new Cursor(Cursor.HAND_CURSOR));  // Set cursor to hand icon

        // Create panel to hold components
        JPanel panel = new JPanel();
        panel.setBackground(new Color(45, 35, 99));  // Set background color of the panel
        panel.setLayout(new BoxLayout(panel, BoxLayout.Y_AXIS));  // Use vertical box layout

        // Create labels and set their text color to white
        JLabel flightCodeLabel = new JLabel("Flight Code:");
        flightCodeLabel.setForeground(Color.WHITE);  // Set label text color to white

        // Add components to the panel
        panel.add(flightCodeLabel);
        panel.add(flightCodeField);
        panel.add(submitButton);
        panel.add(new JScrollPane(resultArea));  // Add result area with scroll pane
        panel.add(Box.createVerticalStrut(10));  // Add space between result area and back label
        panel.add(jLabelBack);  // Add JLabel back button to panel

        // Add the panel to the frame's content pane
        add(panel);

        // Button action listener
        submitButton.addActionListener(new ActionListener() {
            public void actionPerformed(ActionEvent e) {
                getPassengersForFlight();  // This method retrieves passengers for a flight
            }
        });

        // Mouse click event listener for jLabelBack
        jLabelBack.addMouseListener(new MouseAdapter() {
            public void mouseClicked(MouseEvent evt) {
                jLabelBackMouseClicked(evt);  // Call the back navigation method
            }
        });

        setLocationRelativeTo(null);  // Center the form
        setVisible(true);  // Make the form visible
    }

    // Method to retrieve passengers for the given flight
    private void getPassengersForFlight() {
        String flightCode = flightCodeField.getText();

        // JDBC connection to the database and retrieval of passengers
        try (Connection conn = DriverManager.getConnection("jdbc:mysql://localhost:4306/airline_management_system", "root", "")) {

            // Call the stored procedure to retrieve passengers for the flight
            String query = "{CALL GetAllPassengersForFlight(?)}";  // Stored procedure to get passengers for a flight
            CallableStatement stmt = conn.prepareCall(query);
            stmt.setString(1, flightCode);  // Set the flight code parameter

            ResultSet rs = stmt.executeQuery();
            resultArea.setText("");  // Clear any previous results

            // Check if there are passengers before starting the loop
            if (!rs.isBeforeFirst()) {
                resultArea.append("No passengers found for this flight.\n");
            } else {
                while (rs.next()) {
                    String name = rs.getString("name");
                    String gender = rs.getString("gender");
                    String nationality = rs.getString("nationality");
                    String passportNumber = rs.getString("passportnumber");

                    // Append passenger details to the result area
                    resultArea.append("Name: " + name + "\n");
                    resultArea.append("Gender: " + gender + "\n");
                    resultArea.append("Nationality: " + nationality + "\n");
                    resultArea.append("Passport Number: " + passportNumber + "\n\n");
                }
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
        // Run the form
        new GetPassengersForm();
    }
}
