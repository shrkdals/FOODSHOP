package com.ensys.sample.security;

import java.nio.charset.StandardCharsets;
import java.security.MessageDigest;
import java.security.NoSuchAlgorithmException;
import java.security.Security;
import javax.crypto.Cipher;
import javax.crypto.SecretKey;
import javax.crypto.spec.IvParameterSpec;
import javax.crypto.spec.SecretKeySpec;

import org.bouncycastle.jce.provider.BouncyCastleProvider;

public class SymmetricCryptoProvider {
    static {
        Security.insertProviderAt(new BouncyCastleProvider(), 1);
    }

    public SymmetricCryptoProvider() {
    }

    static String Encrypt(String plainText) throws Exception {
        String cipherText = null;

        try {
            IvParameterSpec ivParamSpec = new IvParameterSpec(CryptoConstant.IV);
            byte[] bytes = plainText.getBytes(StandardCharsets.UTF_16LE);
            SecretKey secret = new SecretKeySpec(CryptoConstant.KEY, "AES");
            Cipher cipher = Cipher.getInstance("AES/CBC/PKCS7Padding");
            cipher.init(1, secret, ivParamSpec);
            byte[] encryptData = cipher.doFinal(bytes);
            cipherText = Base64Coder.encodeLines(encryptData);
            return cipherText;
        } catch (Exception var7) {
            var7.printStackTrace();
            throw var7;
        }
    }

    static String Decrypt(String cipherText) throws Exception {
        String plainText = null;

        try {
            byte[] bytes = Base64Coder.decodeLines(cipherText);
            SecretKey secret = new SecretKeySpec(CryptoConstant.KEY, "AES");
            IvParameterSpec ivParamSpec = new IvParameterSpec(CryptoConstant.IV);
            Cipher cipher = Cipher.getInstance("AES/CBC/PKCS7Padding");
            cipher.init(2, secret, ivParamSpec);
            plainText = new String(cipher.doFinal(bytes), StandardCharsets.UTF_16LE);
            return plainText;
        } catch (Exception var6) {
            var6.printStackTrace();
            throw var6;
        }
    }

    static byte[] getHash(byte[] plainTextBytes, byte[] saltBytes) throws NoSuchAlgorithmException {
        byte[] hashBytes = null;
        MessageDigest digest = MessageDigest.getInstance("SHA-256");
        digest.reset();
        digest.update(saltBytes);
        digest.reset();
        hashBytes = digest.digest(plainTextBytes);
        return hashBytes;
    }
}
