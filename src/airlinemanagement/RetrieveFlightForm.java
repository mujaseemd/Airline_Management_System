package airlinemanagement;

import java.awt.Color;
import java.awt.Cursor;
import javax.swing.*;
import java.awt.event.*;
import java.sql.*;

public class RetrieveFlightForm extends JFrame {

    private JTextField sourceField, destinationField;
    private JTextArea resultArea;
    private JButton submitButton;
    private JLabel jLabelBack;  // Declare the JLabel for back navigation

    // Constructor
    public RetrieveFlightForm() {
        // Initialize the Swing components
        setTitle("Retrieve Flight Info Between Cities");
        setSize(400, 300);
        setDefaultCloseOperation(JFrame.DISPOSE_ON_CLOSE);  // Close the form when the user closes it
        getContentPane().setBackground(new Color(45, 35, 99)); // Set background color of the content pane

        // Layout setup
        sourceField = new JTextField(30);
        destinationField = new JTextField(30);
        resultArea = new JTextArea(10, 30);
        resultArea.setEditable(false);  // Make result area read-only

        submitButton = new JButton("Retrieve Flights");
        
        jLabelBack = new JLabel("Back to Dashboard");  // Initialize JLabel for back button
        jLabelBack.setForeground(Color.WHITE);  // Set label text color to white
        jLabelBack.setCursor(new Cursor(Cursor.HAND_CURSOR));  // Set cursor to hand icon

        // Create panel to hold components
        JPanel panel = new JPanel();
        panel.setBackground(new Color(45, 35, 99));  // Set background color of the panel

        // Create labels and set their text color to white
        JLabel sourceLabel = new JLabel("Source City:");
        sourceLabel.setForeground(Color.WHITE);
        JLabel destinationLabel = new JLabel("Destination City:");
        destinationLabel.setForeground(Color.WHITE);

        // Add components to the panel
        panel.add(sourceLabel);
        panel.add(sourceField);
        panel.add(destinationLabel);
        panel.add(destinationField);
        panel.add(submitButton);
        panel.add(jLabelBack);  // Add JLabel back button to panel
        panel.add(new JScrollPane(resultArea));  // ScrollPane for resultArea

        // Add the panel to the frame's content pane
        add(panel);

        // Button action listener
        submitButton.addActionListener(new ActionListener() {
            public void actionPerformed(ActionEvent e) {
                retrieveFlightInfo();  // This method fetches and displays flight data
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

    // Method to retrieve flight information from the database
    private void retrieveFlightInfo() {
        String source = sourceField.getText();
        String destination = destinationField.getText();

        // JDBC connection to the database and retrieval of flight data
        try (Connection conn = DriverManager.getConnection("jdbc:mysql://localhost:4306/airline_management_system", "root", "")) {

            String query = "{CALL RetrieveFlightInfoBetweenCities(?, ?)}";  // Call the stored procedure
            CallableStatement stmt = conn.prepareCall(query);
            stmt.setString(1, source);  // Set the source city parameter
            stmt.setString(2, destination);  // Set the destination city parameter

            ResultSet rs = stmt.executeQuery();  // Execute the stored procedure

            resultArea.setText("");  // Clear any previous results

            if (!rs.isBeforeFirst()) {
                resultArea.append("No flights found between " + source + " and " + destination + ".\n");
            } else {
                while (rs.next()) {
                    String flightCode = rs.getString("flightcode");
                    String flightSource = rs.getString("source");
                    String flightDestination = rs.getString("destination");
                    String takeoff = rs.getString("takeoff");
                    int noOfSeats = rs.getInt("noofseat");

                    resultArea.append("Flight Code: " + flightCode + "\n");
                    resultArea.append("Source: " + flightSource + "\n");
                    resultArea.append("Destination: " + flightDestination + "\n");
                    resultArea.append("Takeoff Time: " + takeoff + "\n");
                    resultArea.append("Seats Available: " + noOfSeats + "\n\n");
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
        new RetrieveFlightForm(); 
    }
}
