package com.example.digitalsignature.model;

import java.security.*;
import java.util.Base64;

public class SignatureModel {
    private PrivateKey privateKey;
    private PublicKey publicKey;
    private Signature signature;

    public SignatureModel() throws Exception {
        generateKeyPair();
        signature = Signature.getInstance("SHA256withRSA");
    }

    public void generateKeyPair() throws Exception {
        KeyPairGenerator keyGen = KeyPairGenerator.getInstance("RSA");
        keyGen.initialize(2048);
        KeyPair pair = keyGen.generateKeyPair();
        privateKey = pair.getPrivate();
        publicKey = pair.getPublic();
    }

    public String signData(byte[] data) throws Exception {
        signature.initSign(privateKey);
        signature.update(data);
        byte[] signBytes = signature.sign();
        return Base64.getEncoder().encodeToString(signBytes);
    }

    public boolean verifySignature(byte[] data, String signatureStr) throws Exception {
        signature.initVerify(publicKey);
        signature.update(data);
        byte[] signBytes = Base64.getDecoder().decode(signatureStr);
        return signature.verify(signBytes);
    }

    public PublicKey getPublicKey() {
        return publicKey;
    }

    public PrivateKey getPrivateKey() {
        return privateKey;
    }
}
