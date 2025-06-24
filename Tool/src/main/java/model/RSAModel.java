package model;

import java.io.*;
import java.security.*;
import java.security.spec.*;
import java.util.Base64;

public class RSAModel {
    private PublicKey publicKey;
    private PrivateKey privateKey;

    // === 1. Tạo cặp khóa RSA ===
    public void generateKeyPair(int keySize) throws NoSuchAlgorithmException {
        KeyPairGenerator generator = KeyPairGenerator.getInstance("RSA");
        generator.initialize(keySize);
        KeyPair pair = generator.generateKeyPair();
        this.publicKey = pair.getPublic();
        this.privateKey = pair.getPrivate();
    }

    // === 2. Lấy khóa dưới dạng chuỗi Base64 ===
    public String getPublicKeyBase64() {
        return Base64.getEncoder().encodeToString(publicKey.getEncoded());
    }

    public String getPrivateKeyBase64() {
        return Base64.getEncoder().encodeToString(privateKey.getEncoded());
    }

    // === 3. Tải khóa từ chuỗi Base64 ===
    public void loadPublicKeyFromBase64(String base64Key) throws Exception {
        byte[] decoded = Base64.getDecoder().decode(base64Key);
        X509EncodedKeySpec spec = new X509EncodedKeySpec(decoded);
        KeyFactory factory = KeyFactory.getInstance("RSA");
        this.publicKey = factory.generatePublic(spec);
    }

    public void loadPrivateKeyFromBase64(String base64Key) throws Exception {
        byte[] decoded = Base64.getDecoder().decode(base64Key);
        PKCS8EncodedKeySpec spec = new PKCS8EncodedKeySpec(decoded);
        KeyFactory factory = KeyFactory.getInstance("RSA");
        this.privateKey = factory.generatePrivate(spec);
    }

    // === 4. Lưu khóa ra file theo định dạng PEM (Base64 có header/footer) ===
    public void savePublicKeyToFile(String filePath) throws IOException {
        String base64Key = getPublicKeyBase64();
        String pem = "-----BEGIN PUBLIC KEY-----\n"
                + wrapBase64Lines(base64Key)
                + "-----END PUBLIC KEY-----\n";
        try (BufferedWriter writer = new BufferedWriter(new FileWriter(filePath))) {
            writer.write(pem);
        }
    }

    public void savePrivateKeyToFile(String filePath) throws IOException {
        String base64Key = getPrivateKeyBase64();
        String pem = "-----BEGIN PRIVATE KEY-----\n"
                + wrapBase64Lines(base64Key)
                + "-----END PRIVATE KEY-----\n";
        try (BufferedWriter writer = new BufferedWriter(new FileWriter(filePath))) {
            writer.write(pem);
        }
    }

    // === Hàm phụ trợ: chia dòng mỗi 64 ký tự cho đẹp và đúng chuẩn PEM ===
    private String wrapBase64Lines(String base64) {
        StringBuilder sb = new StringBuilder();
        int index = 0;
        while (index < base64.length()) {
            int end = Math.min(index + 64, base64.length());
            sb.append(base64, index, end).append("\n");
            index = end;
        }
        return sb.toString();
    }


    // === 5. Đọc khóa từ file Base64 ===
    public void loadPublicKeyFromFile(String filePath) throws Exception {
        String base64Key = readBase64FromFile(filePath);
        loadPublicKeyFromBase64(base64Key);
    }

    public void loadPrivateKeyFromFile(String filePath) throws Exception {
        String base64Key = readBase64FromFile(filePath);
        loadPrivateKeyFromBase64(base64Key);
    }

    // === 6. Ký chuỗi văn bản ===
    public String signText(String text) throws Exception {
        Signature signature = Signature.getInstance("SHA256withRSA");
        signature.initSign(privateKey);
        signature.update(text.getBytes("UTF-8"));
        byte[] signedBytes = signature.sign();
        return Base64.getEncoder().encodeToString(signedBytes);
    }

    // === 7. Xác minh chữ ký chuỗi văn bản ===
    public boolean verifyText(String text, String base64Signature) throws Exception {
        Signature signature = Signature.getInstance("SHA256withRSA");
        signature.initVerify(publicKey);
        signature.update(text.getBytes("UTF-8"));
        byte[] signedBytes = Base64.getDecoder().decode(base64Signature);
        return signature.verify(signedBytes);
    }

    // === 8. Ký file và trả về chữ ký Base64 ===
    public String signFile(String filePath) throws Exception {
        Signature signature = Signature.getInstance("SHA256withRSA");
        signature.initSign(privateKey);

        try (InputStream fis = new FileInputStream(filePath)) {
            byte[] buffer = new byte[4096];
            int len;
            while ((len = fis.read(buffer)) != -1) {
                signature.update(buffer, 0, len);
            }
        }

        byte[] signedBytes = signature.sign();
        return Base64.getEncoder().encodeToString(signedBytes);
    }

    // === 9. Xác minh chữ ký file ===
    public boolean verifyFile(String filePath, String base64Signature) throws Exception {
        Signature signature = Signature.getInstance("SHA256withRSA");
        signature.initVerify(publicKey);

        try (InputStream fis = new FileInputStream(filePath)) {
            byte[] buffer = new byte[4096];
            int len;
            while ((len = fis.read(buffer)) != -1) {
                signature.update(buffer, 0, len);
            }
        }

        byte[] signedBytes = Base64.getDecoder().decode(base64Signature);
        return signature.verify(signedBytes);
    }

    // === 10. Đọc nội dung file PEM và bỏ header/footer ===
    private String readBase64FromFile(String filePath) throws IOException {
        StringBuilder builder = new StringBuilder();
        try (BufferedReader reader = new BufferedReader(new FileReader(filePath))) {
            String line;
            while ((line = reader.readLine()) != null) {
                line = line.trim();
                // Bỏ qua các dòng header/footer
                if (line.startsWith("-----BEGIN") || line.startsWith("-----END") || line.isEmpty()) {
                    continue;
                }
                builder.append(line);
            }
        }
        return builder.toString();
    }

    // === GETTERS ===
    public PublicKey getPublicKey() {
        return publicKey;
    }

    public PrivateKey getPrivateKey() {
        return privateKey;
    }
    public static void main(String[] args) {
        try {
//            RSAModel rsa = new RSAModel();
//
//            // === 1. Tạo cặp khóa RSA ===
//            rsa.generateKeyPair(2048);
//            System.out.println("Đã tạo cặp khóa RSA.");
//
//            // === 2. In ra khóa ở dạng Base64 ===
//            System.out.println("\nPublic Key (Base64):\n" + rsa.getPublicKeyBase64());
//            System.out.println("\nPrivate Key (Base64):\n" + rsa.getPrivateKeyBase64());
//
//            // === 3. Lưu khóa ra file PEM ===
//            rsa.savePublicKeyToFile("C:\\Users\\Hao\\Desktop\\Sign\\public.pem");
//            rsa.savePrivateKeyToFile("C:\\Users\\Hao\\Desktop\\Sign\\private.pem");
//            System.out.println("\nĐã lưu khóa vào file public.pem và private.pem.");

            // === 4. Tải khóa lại từ file ===
            RSAModel rsaLoaded = new RSAModel();
            rsaLoaded.loadPublicKeyFromFile("C:\\Users\\Hao\\Desktop\\Sign\\public_key.txt");
            //rsaLoaded.loadPrivateKeyFromFile("C:\\Users\\Hao\\Desktop\\Sign\\private.pem");
            System.out.println("\nĐã nạp lại khóa từ file.");

//            // === 5. Ký văn bản và xác minh ===
//            String message = "Đây là chuỗi cần ký.";
//            String signature = rsaLoaded.signText(message);
//            boolean verified = rsaLoaded.verifyText(message, signature);
//
//            System.out.println("\nChữ ký:\n" + signature);
//            System.out.println("Xác minh chữ ký văn bản: " + (verified ? "HỢP LỆ" : "KHÔNG HỢP LỆ"));

            // === 6. Ký và xác minh file ===
            String filePath = "C:\\Users\\Hao\\Desktop\\Sign\\tdbb.txt";
            // java.nio.file.Files.write(java.nio.file.Paths.get(filePath), message.getBytes());

            //String fileSignature = rsaLoaded.signFile(filePath);
            String fileSignature = "Is/XokcxRARcD0iuUeMa5W0gkevhimE9Q0qhnmT5chvwB95qER71xBqVmSZ8rxa7wXL7o50yL0MscflI8SODAY223EMsff9IrqZ7LloTbjHkW0VVfY6TvCWmWbgeTzrXj//ldWJNhxCCiPjLAKjeI44NWEF7aLBxgv+YSbYCVf0=";
            boolean fileVerified = rsaLoaded.verifyFile(filePath, fileSignature);

            System.out.println("\nChữ ký file:\n" + fileSignature);
            System.out.println("Xác minh chữ ký file: " + (fileVerified ? "HỢP LỆ" : "KHÔNG HỢP LỆ"));

        } catch (Exception e) {
            e.printStackTrace();
        }
    }
}
