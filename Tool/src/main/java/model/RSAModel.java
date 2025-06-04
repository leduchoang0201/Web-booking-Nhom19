package model;

import javax.crypto.Cipher;
import java.io.FileInputStream;
import java.io.FileOutputStream;
import java.io.IOException;
import java.security.*;
import java.security.spec.PKCS8EncodedKeySpec;
import java.util.Base64;

public class RSAModel {
    private PrivateKey privateKey;
    private PublicKey publicKey;

    // 1. Tạo cặp khóa
    public void generateKeyPair(int keySize) throws NoSuchAlgorithmException {
        KeyPairGenerator generator = KeyPairGenerator.getInstance("RSA");
        generator.initialize(keySize);
        KeyPair pair = generator.generateKeyPair();
        privateKey = pair.getPrivate();
        publicKey = pair.getPublic();
    }

    // 2. Lấy private/public key (dùng để hiển thị)
    public PrivateKey getPrivateKey() {
        return privateKey;
    }

    public PublicKey getPublicKey() {
        return publicKey;
    }

    // 3. Lưu cả hai khóa ra file
    public void saveKeys(String folderPath) throws IOException {
        // Lưu public key
        try (FileOutputStream out = new FileOutputStream(folderPath + "/public.key")) {
            out.write(publicKey.getEncoded());
        }
        // Lưu private key
        try (FileOutputStream out = new FileOutputStream(folderPath + "/private.key")) {
            out.write(privateKey.getEncoded());
        }
    }

    // 4. Load private key từ file
    public PrivateKey loadPrivateKey(String filePath) throws Exception {
        byte[] keyBytes = readAllBytes(filePath);
        PKCS8EncodedKeySpec spec = new PKCS8EncodedKeySpec(keyBytes);
        KeyFactory factory = KeyFactory.getInstance("RSA");
        return factory.generatePrivate(spec);
    }

    // 5. Mã hóa bằng private key (dùng để ký)
    public String encryptWithPrivateKey(String data, PrivateKey privateKey) throws Exception {
        Cipher cipher = Cipher.getInstance("RSA");
        cipher.init(Cipher.ENCRYPT_MODE, privateKey);
        byte[] encrypted = cipher.doFinal(data.getBytes("UTF-8"));
        return Base64.getEncoder().encodeToString(encrypted);
    }

    // 6. Helper: đọc file thành mảng byte
    private byte[] readAllBytes(String filePath) throws IOException {
        try (FileInputStream in = new FileInputStream(filePath)) {
            return in.readAllBytes();
        }
    }

    // 7. Helper: chuyển key thành chuỗi base64 để hiển thị
    public String encodeKey(Key key) {
        return Base64.getEncoder().encodeToString(key.getEncoded());
    }
}
