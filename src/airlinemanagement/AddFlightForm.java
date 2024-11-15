package airlinemanagement;

import java.awt.Color;
import java.awt.Cursor;
import javax.swing.*;
import java.awt.event.*;
import java.sql.*;
import java.text.*;
import java.util.regex.*;

public class AddFlightForm extends JFrame {

    private JTextField flightCodeField, sourceField, destinationField, takeoffField, noOfSeatsField;
    private JButton submitButton;
    private JLabel jLabelBack;  // JLabel for the back button

    // Constructor
    public AddFlightForm() {
        setTitle("Add New Flight");
        setSize(400, 350);
        setDefaultCloseOperation(JFrame.DISPOSE_ON_CLOSE);
        getContentPane().setBackground(new Color(45, 35, 99));

        // Initialize components
        flightCodeField = new JTextField(30);
        sourceField = new JTextField(30);
        destinationField = new JTextField(30);
        takeoffField = new JTextField(30);
        noOfSeatsField = new JTextField(30);

        submitButton = new JButton("Add Flight");
        jLabelBack = new JLabel("BACK");  // Back button label
        jLabelBack.setForeground(Color.WHITE);
        jLabelBack.setCursor(new Cursor(Cursor.HAND_CURSOR));

        // Panel setup
        JPanel panel = new JPanel();
        panel.setBackground(new Color(45, 35, 99));
        panel.setLayout(new BoxLayout(panel, BoxLayout.Y_AXIS));

        // Labels with color set to white
        JLabel flightCodeLabel = new JLabel("Flight Code:");
        flightCodeLabel.setForeground(Color.WHITE);
        JLabel sourceLabel = new JLabel("Source City:");
        sourceLabel.setForeground(Color.WHITE);
        JLabel destinationLabel = new JLabel("Destination City:");
        destinationLabel.setForeground(Color.WHITE);
        JLabel takeoffLabel = new JLabel("Takeoff Time (MM/DD/YYYY):");
        takeoffLabel.setForeground(Color.WHITE);
        JLabel noOfSeatsLabel = new JLabel("No. of Seats:");
        noOfSeatsLabel.setForeground(Color.WHITE);

        // Adding components to the panel
        panel.add(flightCodeLabel);
        panel.add(flightCodeField);
        panel.add(Box.createVerticalStrut(10));

        panel.add(sourceLabel);
        panel.add(sourceField);
        panel.add(Box.createVerticalStrut(10));

        panel.add(destinationLabel);
        panel.add(destinationField);
        panel.add(Box.createVerticalStrut(10));

        panel.add(takeoffLabel);
        panel.add(takeoffField);
        panel.add(Box.createVerticalStrut(10));

        panel.add(noOfSeatsLabel);
        panel.add(noOfSeatsField);
        panel.add(Box.createVerticalStrut(10));

        panel.add(submitButton);
        panel.add(Box.createVerticalStrut(10));
        panel.add(jLabelBack);  // Adding back button to the panel

        // Ensure panel updates correctly
        panel.revalidate();
        panel.repaint();

        // Adding panel to frame
        add(panel);

        // Action listeners
        submitButton.addActionListener(new ActionListener() {
            public void actionPerformed(ActionEvent e) {
                addNewFlight();
            }
        });

        // Mouse click listener for back button
        jLabelBack.addMouseListener(new MouseAdapter() {
            public void mouseClicked(MouseEvent evt) {
                jLabelBackMouseClicked(evt);
            }
        });

        setLocationRelativeTo(null);
        setVisible(true);
    }

    // Method to insert new flight into the database
    private void addNewFlight() {
        String flightCode = flightCodeField.getText();
        String source = sourceField.getText();
        String destination = destinationField.getText();
        String takeoff = takeoffField.getText();
        String noOfSeats = noOfSeatsField.getText();

        // Input validation
        if (flightCode.isEmpty() || source.isEmpty() || destination.isEmpty() || takeoff.isEmpty() || noOfSeats.isEmpty()) {
            JOptionPane.showMessageDialog(this, "All fields are required!", "Error", JOptionPane.ERROR_MESSAGE);
            return;
        }

        if (!isValidDate(takeoff)) {
            JOptionPane.showMessageDialog(this, "Please enter a valid takeoff date in MM/DD/YYYY format.", "Invalid Date", JOptionPane.ERROR_MESSAGE);
            return;
        }

        try {
            Integer.parseInt(noOfSeats);
        } catch (NumberFormatException e) {
            JOptionPane.showMessageDialog(this, "Number of seats must be a valid integer.", "Invalid Number of Seats", JOptionPane.ERROR_MESSAGE);
            return;
        }

        // Database connection
        try (Connection conn = DriverManager.getConnection("jdbc:mysql://localhost:4306/airline_management_system", "root", "")) {
            String query = "{CALL AddNewFlight(?, ?, ?, ?, ?)}";
            CallableStatement stmt = conn.prepareCall(query);
            stmt.setString(1, flightCode);
            stmt.setString(2, source);
            stmt.setString(3, destination);
            stmt.setString(4, takeoff);
            stmt.setInt(5, Integer.parseInt(noOfSeats));

            ResultSet rs = stmt.executeQuery();

            if (rs.next()) {
                String message = rs.getString("message");
                JOptionPane.showMessageDialog(this, message, "Success", JOptionPane.INFORMATION_MESSAGE);
            }

            flightCodeField.setText("");
            sourceField.setText("");
            destinationField.setText("");
            takeoffField.setText("");
            noOfSeatsField.setText("");

            rs.close();
            stmt.close();

        } catch (SQLException ex) {
            JOptionPane.showMessageDialog(this, "Database error: " + ex.getMessage(), "Error", JOptionPane.ERROR_MESSAGE);
        }
    }

    // Method to validate date format MM/DD/YYYY
    private boolean isValidDate(String date) {
        String datePattern = "^(0[1-9]|1[0-2])/(0[1-9]|[12][0-9]|3[01])/\\d{4}$";
        Pattern pattern = Pattern.compile(datePattern);
        Matcher matcher = pattern.matcher(date);
        return matcher.matches();
    }

    private void jLabelBackMouseClicked(MouseEvent evt) {
        dashboard obj = new dashboard();  // Open the Dashboard form
        obj.setVisible(true);  // Show the dashboard
        dispose();  // Close the current form
    }

    public static void main(String[] args) {
        new AddFlightForm(); 
    }
}
