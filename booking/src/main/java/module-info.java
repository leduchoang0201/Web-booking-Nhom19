module com.example.booking {
    requires javafx.controls;
    requires javafx.fxml;


    opens com.example.booking to javafx.fxml;
    exports com.example.booking;
}