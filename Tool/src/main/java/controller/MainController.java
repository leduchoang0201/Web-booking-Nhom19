package controller;

import model.RSAModel;
import view.MainView;

import javax.swing.*;
import java.awt.*;
import java.awt.event.ActionEvent;
import java.security.PrivateKey;
import java.security.PublicKey;

public class MainController {
    private final RSAModel model;
    private final MainView view;
    private PrivateKey loadedPrivateKey = null;

    public MainController(RSAModel model, MainView view) {
        this.model = model;
        this.view = view;

        view.genKeyBtn.addActionListener(this::onGenerateKey);
        view.saveKeyBtn.addActionListener(this::onSaveKey);
        view.loadPrivateKeyBtn.addActionListener(this::onLoadPrivateKey);
        view.encryptBtn.addActionListener(this::onEncrypt);

        // Khởi đầu ẩn vùng hiển thị khóa
        view.privateKeyArea.setVisible(false);
        view.publicKeyArea.setVisible(false);
    }

    private void onGenerateKey(ActionEvent e) {
        try {
            int keySize = Integer.parseInt((String) view.keySizeBox.getSelectedItem());
            model.generateKeyPair(keySize);

            PrivateKey privateKey = model.getPrivateKey();
            PublicKey publicKey = model.getPublicKey();

            // Hiển thị khóa dưới dạng base64 text
            view.privateKeyArea.setText(model.encodeKey(privateKey));
            view.publicKeyArea.setText(model.encodeKey(publicKey));

            // Hiển thị 2 vùng khóa và bật nút lưu
            view.privateKeyArea.setVisible(true);
            view.publicKeyArea.setVisible(true);
            view.saveKeyBtn.setEnabled(true);

        } catch (Exception ex) {
            JOptionPane.showMessageDialog(view, "❌ Lỗi tạo khóa: " + ex.getMessage());
        }
    }

    private void onSaveKey(ActionEvent e) {
        JFileChooser fc = new JFileChooser();
        fc.setFileSelectionMode(JFileChooser.DIRECTORIES_ONLY);
        if (fc.showSaveDialog(view) == JFileChooser.APPROVE_OPTION) {
            try {
                model.saveKeys(fc.getSelectedFile().getAbsolutePath());
                JOptionPane.showMessageDialog(view, "Đã lưu khóa thành công!");

                // Ẩn 2 vùng khóa và tắt nút lưu sau khi lưu
                view.privateKeyArea.setVisible(false);
                view.publicKeyArea.setVisible(false);
                view.saveKeyBtn.setEnabled(false);

                view.privateKeyStatus.setText("🔒 Chưa có Private Key");
                view.privateKeyStatus.setForeground(Color.RED);

            } catch (Exception ex) {
                JOptionPane.showMessageDialog(view, "❌ Lỗi lưu khóa: " + ex.getMessage());
            }
        }
    }

    private void onLoadPrivateKey(ActionEvent e) {
        JFileChooser fc = new JFileChooser();
        if (fc.showOpenDialog(view) == JFileChooser.APPROVE_OPTION) {
            try {
                loadedPrivateKey = model.loadPrivateKey(fc.getSelectedFile().getAbsolutePath());
                view.privateKeyStatus.setText("✅ Đã nhận Private Key");
                view.privateKeyStatus.setForeground(new Color(0, 128, 0));
            } catch (Exception ex) {
                view.privateKeyStatus.setText("❌ Lỗi tải Private Key");
                view.privateKeyStatus.setForeground(Color.RED);
                JOptionPane.showMessageDialog(view, "Lỗi: " + ex.getMessage());
            }
        }
    }

    private void onEncrypt(ActionEvent e) {
        try {
            if (loadedPrivateKey == null) {
                JOptionPane.showMessageDialog(view, "Vui lòng tải Private Key trước khi mã hóa.");
                return;
            }

            String input = view.inputArea.getText();
            if (input.isEmpty()) {
                JOptionPane.showMessageDialog(view, "Vui lòng nhập chuỗi cần mã hóa.");
                return;
            }

            String encrypted = model.encryptWithPrivateKey(input, loadedPrivateKey);
            view.outputArea.setText(encrypted);
        } catch (Exception ex) {
            JOptionPane.showMessageDialog(view, "❌ Lỗi mã hóa: " + ex.getMessage());
        }
    }
}
