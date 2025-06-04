package main;

import controller.MainController;
import model.RSAModel;
import view.MainView;

public class Main {
    public static void main(String[] args) {
        javax.swing.SwingUtilities.invokeLater(() -> {
            RSAModel model = new RSAModel();
            MainView view = new MainView();
            new MainController(model, view);
            view.setVisible(true);
        });
    }
}
