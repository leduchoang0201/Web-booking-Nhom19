package main;

import controller.MainController;
import view.MainView;

import javax.swing.*;

public class Main {
    public static void main(String[] args) {
        SwingUtilities.invokeLater(() -> {
            MainView view = new MainView();
            new MainController(view);
            view.setVisible(true);
        });
    }
}
