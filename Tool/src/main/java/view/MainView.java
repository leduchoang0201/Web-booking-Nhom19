package view;

import javax.swing.*;
import java.awt.*;

public class MainView extends JFrame {
    public JComboBox<String> keySizeBox = new JComboBox<>(new String[]{"1024", "2048", "4096"});
    public JButton genKeyBtn = new JButton("Tạo cặp khóa RSA");
    public JButton loadPrivateKeyBtn = new JButton("Tải Private Key");
    public JButton loadFileBtn = new JButton("Tải file cần ký");
    public JButton encryptBtn = new JButton("Ký bằng Private Key");
    public JButton copyBtn = new JButton("Copy");
    public JButton saveKeyBtn = new JButton("Lưu khóa");

    public JTextArea outputArea = new JTextArea(5, 40);
    public JLabel privateKeyStatus = new JLabel("Chưa có Private Key");
    public JLabel privateKeyLoadStatus = new JLabel("Chưa tải Private Key");

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

        privateKeyLoadStatus.setForeground(Color.BLUE);
        privateKeyLoadStatus.setFont(new Font("Arial", Font.BOLD, 12));
        topPanel.add(privateKeyLoadStatus);

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

        // Panel chứa 2 vùng hiển thị khóa nằm ngang
        JPanel keyPanel = new JPanel(new FlowLayout(FlowLayout.CENTER, 20, 5));
        keyPanel.add(privateScroll);
        keyPanel.add(publicScroll);

        // Text area xuất chữ ký
        outputArea.setLineWrap(true);
        outputArea.setEditable(false);
        outputArea.setBorder(BorderFactory.createTitledBorder("📤 Chữ ký của file"));

        JPanel textPanel = new JPanel(new BorderLayout(10, 10));
        textPanel.add(new JScrollPane(outputArea), BorderLayout.CENTER);

        // Bottom panel chứa nút tải file, ký và copy
        JPanel bottomPanel = new JPanel(new FlowLayout(FlowLayout.CENTER, 10, 5));
        loadFileBtn.setBackground(new Color(255, 87, 51));
        loadFileBtn.setForeground(Color.WHITE);
        loadFileBtn.setOpaque(true);
        loadFileBtn.setBorderPainted(false);
        bottomPanel.add(loadFileBtn);

        encryptBtn.setBackground(new Color(88, 86, 214));
        encryptBtn.setForeground(Color.WHITE);
        encryptBtn.setOpaque(true);
        encryptBtn.setBorderPainted(false);
        bottomPanel.add(encryptBtn);

        copyBtn.setBackground(new Color(108, 117, 125));
        copyBtn.setForeground(Color.WHITE);
        copyBtn.setOpaque(true);
        copyBtn.setBorderPainted(false);
        copyBtn.setEnabled(false);
        bottomPanel.add(copyBtn);

        // Panel chính giữa
        JPanel centerPanel = new JPanel(new BorderLayout(5, 5));
        centerPanel.add(keyPanel, BorderLayout.NORTH);
        centerPanel.add(textPanel, BorderLayout.CENTER);

        mainPanel.add(topPanel, BorderLayout.NORTH);
        mainPanel.add(centerPanel, BorderLayout.CENTER);
        mainPanel.add(bottomPanel, BorderLayout.SOUTH);

        add(mainPanel);

        saveKeyBtn.setEnabled(false);
        encryptBtn.setEnabled(false); // Vô hiệu hóa nút ký mặc định
    }
}