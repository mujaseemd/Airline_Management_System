# Airline Management System

## Project Description
The Airline Management System is a comprehensive application designed to simplify and manage airline operations efficiently. It includes features for flight management, passenger booking, ticket handling, and more. This system aims to enhance user experience and operational productivity for airlines.

## Features
- **Manage Flights**: Add, update, delete, and search flights.
- **Passenger Management**: Record and track passenger details.
- **Ticket Booking and Cancellation**: Handle ticket operations with ease.
- **Dashboard**: Separate dashboards for users and admins with role-specific functionalities.
- **Seat Availability Tracking**: Monitor and manage the availability of seats.
- **User Authentication**: Secure login system for admins and users.

## Technologies Used
- **Frontend**: Java (NetBeans GUI)
- **Backend**: PHP (via phpMyAdmin)
- **Database**: MySQL
- **Dependency**: MySQL Connector JAR (`mysql-connector-j-9.1.0.jar` or higher)

## How to Run the Project
1. **Setup Database**:
   - Import the SQL file into phpMyAdmin to set up the database tables: `manageflight`, `managepassenger`, `ticket_booking`, and `ticket_cancellation`.

2. **Install Required Dependencies**:
   - Download and include the MySQL Connector JAR file (`mysql-connector-j-9.1.0.jar` or higher) in your project's library.  
     - [Download MySQL Connector JAR](https://dev.mysql.com/downloads/connector/j/).

3. **Open the Project**:
   - Load the project in NetBeans.

4. **Run the Application**:
   - Configure the database connection settings in the backend code.
   - Execute the project from NetBeans.

## File Structure
- **/src**: Contains the source code for the project.
- **/resources**: Includes assets such as images, icons, and other resources.
- **/database**: SQL file for setting up the database.

## Login Credentials
| Role   | Username  | Password |
|--------|-----------|----------|
| Admin  | `admin`   | `admin123` |
| User   | `passengerUser`    | `passengerPass`  |


## Project Screenshots
Include screenshots of:
- The login screen.
- Admin dashboard.
- Flight management interface.
- Ticket booking screen.

