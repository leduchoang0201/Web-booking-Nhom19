package controller;

import model.RSAModel;
import view.MainView;

import javax.swing.*;
import java.awt.*;
import java.awt.datatransfer.Clipboard;
import java.awt.datatransfer.StringSelection;
import java.awt.event.ActionEvent;
import java.awt.event.ActionListener;
import java.io.File;

public class MainController {
    private final MainView view;
    private final RSAModel model;
    private File selectedFile;

    public MainController(MainView view) {
        this.view = view;
        this.model = new RSAModel();

        addEventListeners();
    }

    private void addEventListeners() {
        view.genKeyBtn.addActionListener(new ActionListener() {
            @Override
            public void actionPerformed(ActionEvent e) {
                try {
                    int keySize = Integer.parseInt((String) view.keySizeBox.getSelectedItem());
                    model.generateKeyPair(keySize);
                    view.privateKeyArea.setText(model.getPrivateKeyBase64());
                    view.publicKeyArea.setText(model.getPublicKeyBase64());
                    view.privateKeyStatus.setText("✅ Đã tạo khóa");
                    view.privateKeyLoadStatus.setText("✅ Private Key đã tạo");
                    view.saveKeyBtn.setEnabled(true);
                    view.encryptBtn.setEnabled(true); // Bật nút ký khi tạo khóa thành công
                } catch (Exception ex) {
                    showError("Lỗi khi tạo khóa: " + ex.getMessage());
                }
            }
        });

        view.saveKeyBtn.addActionListener(new ActionListener() {
            @Override
            public void actionPerformed(ActionEvent e) {
                try {
                    UIManager.setLookAndFeel(UIManager.getSystemLookAndFeelClassName());
                    JFileChooser chooser = new JFileChooser();
                    chooser.setDialogTitle("Chọn thư mục để lưu khóa");
                    chooser.setFileSelectionMode(JFileChooser.DIRECTORIES_ONLY);
                    chooser.setAcceptAllFileFilterUsed(false);
                    chooser.setBackground(new Color(240, 240, 240));
                    chooser.setApproveButtonText("Lưu tại đây");

                    if (chooser.showSaveDialog(view) == JFileChooser.APPROVE_OPTION) {
                        File selectedDir = chooser.getSelectedFile();
                        String privateKeyPath = new File(selectedDir, "private_key.txt").getAbsolutePath();
                        String publicKeyPath = new File(selectedDir, "public_key.txt").getAbsolutePath();

                        model.savePrivateKeyToFile(privateKeyPath);
                        model.savePublicKeyToFile(publicKeyPath);

                        view.privateKeyArea.setText("");
                        view.publicKeyArea.setText("");
                        view.privateKeyStatus.setText("Chưa có Private Key");
                        view.privateKeyLoadStatus.setText("Chưa tải Private Key");
                        view.saveKeyBtn.setEnabled(false);
                        view.encryptBtn.setEnabled(false); // Vô hiệu hóa nút ký sau khi lưu
                        JOptionPane.showMessageDialog(view, "Đã lưu khóa thành công");
                    }
                    UIManager.setLookAndFeel(UIManager.getCrossPlatformLookAndFeelClassName());
                } catch (Exception ex) {
                    showError("Lỗi khi lưu khóa: " + ex.getMessage());
                }
            }
        });

        view.loadPrivateKeyBtn.addActionListener(new ActionListener() {
            @Override
            public void actionPerformed(ActionEvent e) {
                try {
                    UIManager.setLookAndFeel(UIManager.getSystemLookAndFeelClassName());
                    JFileChooser chooser = new JFileChooser();
                    chooser.setDialogTitle("Chọn file Private Key");
                    chooser.setApproveButtonText("Tải khóa");
                    chooser.setBackground(new Color(240, 240, 240));

                    if (chooser.showOpenDialog(view) == JFileChooser.APPROVE_OPTION) {
                        model.loadPrivateKeyFromFile(chooser.getSelectedFile().getAbsolutePath());
                        view.privateKeyArea.setText(model.getPrivateKeyBase64());
                        view.privateKeyStatus.setText("✅ Đã tải Private Key");
                        view.privateKeyLoadStatus.setText("✅ Private Key đã tải");
                        view.encryptBtn.setEnabled(true); // Bật nút ký khi tải private key thành công
                    }
                    UIManager.setLookAndFeel(UIManager.getCrossPlatformLookAndFeelClassName());
                } catch (Exception ex) {
                    showError("Lỗi khi tải Private Key: " + ex.getMessage());
                }
            }
        });

        view.loadFileBtn.addActionListener(new ActionListener() {
            @Override
            public void actionPerformed(ActionEvent e) {
                try {
                    UIManager.setLookAndFeel(UIManager.getSystemLookAndFeelClassName());
                    JFileChooser chooser = new JFileChooser();
                    chooser.setDialogTitle("Chọn file cần ký");
                    chooser.setApproveButtonText("Tải file");
                    chooser.setBackground(new Color(240, 240, 240));

                    if (chooser.showOpenDialog(view) == JFileChooser.APPROVE_OPTION) {
                        selectedFile = chooser.getSelectedFile();
                        view.outputArea.setText("Đã chọn file: " + selectedFile.getName());
                    }
                    UIManager.setLookAndFeel(UIManager.getCrossPlatformLookAndFeelClassName());
                } catch (Exception ex) {
                    showError("Lỗi khi tải file: " + ex.getMessage());
                }
            }
        });

        view.encryptBtn.addActionListener(new ActionListener() {
            @Override
            public void actionPerformed(ActionEvent e) {
                if (selectedFile == null) {
                    showError("Vui lòng chọn file cần ký.");
                    return;
                }
                try {
                    String signature = model.signFile(selectedFile.getAbsolutePath());
                    view.outputArea.setText(signature);
                    view.copyBtn.setEnabled(true);
                } catch (Exception ex) {
                    showError("Lỗi khi ký file: " + ex.getMessage());
                    view.copyBtn.setEnabled(false);
                }
            }
        });

        view.copyBtn.addActionListener(new ActionListener() {
            @Override
            public void actionPerformed(ActionEvent e) {
                String signature = view.outputArea.getText();
                if (!signature.isEmpty()) {
                    StringSelection selection = new StringSelection(signature);
                    Clipboard clipboard = Toolkit.getDefaultToolkit().getSystemClipboard();
                    clipboard.setContents(selection, null);
                    JOptionPane.showMessageDialog(view, "Đã sao chép chữ ký vào clipboard!");
                } else {
                    showError("Không có chữ ký để sao chép.");
                }
            }
        });
    }

    private void showError(String message) {
        JOptionPane.showMessageDialog(view, message, "Lỗi", JOptionPane.ERROR_MESSAGE);
    }
}