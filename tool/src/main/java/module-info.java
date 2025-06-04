module com.example.tool {
    requires javafx.controls;
    requires javafx.fxml;


    opens com.example.tool to javafx.fxml;
    exports com.example.tool;
}