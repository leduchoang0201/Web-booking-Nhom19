package view;

import javax.swing.*;
import java.awt.*;

public class MainView extends JFrame {
    public JComboBox<String> keySizeBox = new JComboBox<>(new String[]{"1024", "2048", "4096"});
    public JButton genKeyBtn = new JButton("Tạo cặp khóa RSA");
    public JButton loadPrivateKeyBtn = new JButton("Tải Private Key");
    public JButton encryptBtn = new JButton("Ký bằng Private Key");
    public JButton saveKeyBtn = new JButton("Lưu khóa");

    public JTextArea inputArea = new JTextArea(5, 40);
    public JTextArea outputArea = new JTextArea(5, 40);

    public JLabel privateKeyStatus = new JLabel("Chưa có Private Key");

    // Thay JLabel bằng JTextArea cho Private và Public Key
    public JTextArea privateKeyArea = new JTextArea(5, 30);
    public JTextArea publicKeyArea = new JTextArea(5, 30);

    public MainView() {
        setTitle("Tool Ký Chữ Ký Điện Tử");
        setDefaultCloseOperation(EXIT_ON_CLOSE);
        setSize(800, 550);
        setLocationRelativeTo(null);

        JPanel mainPanel = new JPanel(new BorderLayout(10, 10));
        mainPanel.setBorder(BorderFactory.createEmptyBorder(10, 10, 10, 10));

        // Top panel chứa các nút
        JPanel topPanel = new JPanel(new FlowLayout(FlowLayout.LEFT, 15, 5));
        topPanel.add(new JLabel("Chọn độ dài khóa:"));
        topPanel.add(keySizeBox);

        // Style buttons with colors
        genKeyBtn.setBackground(new Color(0, 122, 255));
        genKeyBtn.setForeground(Color.WHITE);
        genKeyBtn.setOpaque(true);
        genKeyBtn.setBorderPainted(false);
        topPanel.add(genKeyBtn);

        saveKeyBtn.setBackground(new Color(255, 149, 0));
        saveKeyBtn.setForeground(Color.WHITE);
        saveKeyBtn.setOpaque(true);
        saveKeyBtn.setBorderPainted(false);
        topPanel.add(saveKeyBtn);

        loadPrivateKeyBtn.setBackground(new Color(52, 199, 89));
        loadPrivateKeyBtn.setForeground(Color.WHITE);
        loadPrivateKeyBtn.setOpaque(true);
        loadPrivateKeyBtn.setBorderPainted(false);
        topPanel.add(loadPrivateKeyBtn);



        privateKeyStatus.setForeground(Color.RED);
        privateKeyStatus.setFont(new Font("Arial", Font.BOLD, 12));
        topPanel.add(privateKeyStatus);

        // Thiết lập JTextArea cho khóa
        privateKeyArea.setLineWrap(true);
        privateKeyArea.setWrapStyleWord(true);
        privateKeyArea.setEditable(false);
        privateKeyArea.setBorder(BorderFactory.createTitledBorder("Private Key"));
        JScrollPane privateScroll = new JScrollPane(privateKeyArea);
        privateScroll.setPreferredSize(new Dimension(350, 100));

        publicKeyArea.setLineWrap(true);
        publicKeyArea.setWrapStyleWord(true);
        publicKeyArea.setEditable(false);
        publicKeyArea.setBorder(BorderFactory.createTitledBorder("Public Key"));
        JScrollPane publicScroll = new JScrollPane(publicKeyArea);
        publicScroll.setPreferredSize(new Dimension(350, 100));

        // Panel chứa 2 vùng hiển thị khóa nằm ngang cho gọn
        JPanel keyPanel = new JPanel(new FlowLayout(FlowLayout.CENTER, 20, 5));
        keyPanel.add(privateScroll);
        keyPanel.add(publicScroll);

        // Text areas nhập/xuất chuỗi
        inputArea.setLineWrap(true);
        inputArea.setBorder(BorderFactory.createTitledBorder("🔤 Nhập chuỗi cần ký"));
        outputArea.setLineWrap(true);
        outputArea.setEditable(false);
        outputArea.setBorder(BorderFactory.createTitledBorder("📤 Chuỗi đã mã hóa (ký)"));

        JPanel textPanel = new JPanel(new GridLayout(2, 1, 10, 10));
        textPanel.add(new JScrollPane(inputArea));
        textPanel.add(new JScrollPane(outputArea));

        // Nút ký ở dưới cùng
        JPanel bottomPanel = new JPanel();
        encryptBtn.setBackground(new Color(88, 86, 214));
        encryptBtn.setForeground(Color.WHITE);
        encryptBtn.setOpaque(true);
        encryptBtn.setBorderPainted(false);
        bottomPanel.add(encryptBtn);

        // Panel chính giữa: 2 vùng khóa trên, text nhập/xuất dưới
        JPanel centerPanel = new JPanel(new BorderLayout(5, 5));
        centerPanel.add(keyPanel, BorderLayout.NORTH);
        centerPanel.add(textPanel, BorderLayout.CENTER);

        mainPanel.add(topPanel, BorderLayout.NORTH);
        mainPanel.add(centerPanel, BorderLayout.CENTER);
        mainPanel.add(bottomPanel, BorderLayout.SOUTH);

        add(mainPanel);

        saveKeyBtn.setEnabled(false);
    }
}