package com.ensys.sample.controllers;


import org.yaml.snakeyaml.external.biz.base64Coder.Base64Coder;

import java.io.PrintStream;
import java.nio.charset.StandardCharsets;
import java.security.SecureRandom;
import java.util.Random;

public class EncrypterPassword {
    private static final String POST_FIX = "+ty+tz+";

    /*public static void main(String[] args) throws Exception {
        String hashValue = null;

        String plainText = "1!2#asd";
        System.out.println("plainText : " + plainText);
        hashValue = ComputeHash(plainText);

        System.out.println("hashValue : " + hashValue);

        boolean b = VerifyHash(plainText, hashValue);

        if (b) {
            System.out.println("같음");
        } else
            System.out.println("다름");
    }*/

    public static String ComputeHash(String password) throws Exception {
        return ComputeHash(password, null);
    }

    public static String ComputeHash(String password, byte[] salts)
            throws Exception {
        String cipherText = null;

        if (salts == null) {
            salts = getSaltBytes();
        }

        byte[] plainTextBytes = password.getBytes(StandardCharsets.UTF_16LE);

        byte[] plainTextWithSaltBytes = new byte[plainTextBytes.length
                + salts.length];
        System.arraycopy(plainTextBytes, 0, plainTextWithSaltBytes, 0,
                plainTextBytes.length);
        System.arraycopy(salts, 0, plainTextWithSaltBytes,
                plainTextBytes.length, salts.length);

        byte[] hashBytes = SymmetricCryptoProvider.getHash(
                plainTextWithSaltBytes, salts);

        byte[] hashWithSaltBytes = new byte[hashBytes.length + salts.length];
        System.arraycopy(hashBytes, 0, hashWithSaltBytes, 0, hashBytes.length);
        System.arraycopy(salts, 0, hashWithSaltBytes, hashBytes.length,
                salts.length);

        cipherText = String.valueOf(Base64Coder.encode(hashWithSaltBytes));
        cipherText = cipherText.trim() + "+ty+tz+";
        return cipherText;
    }

    public static boolean VerifyHash(String plainText, String hashValue)
            throws Exception {
        boolean bResult = false;

        String orginHashValue = hashValue.trim();

        hashValue = hashValue.substring(0,
                hashValue.length() - "+ty+tz+".length()).trim();

        byte[] hashWithSaltBytes = Base64Coder.decodeLines(hashValue.trim());

        int hashSizeInBits = 256;
        int hashSizeInBytes = hashSizeInBits / 8;

        if (hashWithSaltBytes.length < hashSizeInBytes)
            return false;

        byte[] saltBytes = new byte[hashWithSaltBytes.length - hashSizeInBytes];

        System.arraycopy(hashWithSaltBytes, hashSizeInBytes, saltBytes, 0,
                saltBytes.length);

        String expectHashString = ComputeHash(plainText, saltBytes);

        if (orginHashValue.equals(expectHashString.trim())) {
            bResult = true;
        }
        return bResult;
    }

    private static byte[] getSaltBytes() throws Exception {
        byte[] salts = null;

        int randomNumber = getRandomNumber();

        System.out.println("random Number : " + randomNumber);

        SecureRandom random = new SecureRandom();
        salts = new byte[randomNumber];
        random.nextBytes(salts);

        return salts;
    }

    private static int getRandomNumber() throws Exception {
        Random rd = new Random();
        int minSaltSize = 4;
        int maxSaltSize = 8;

        int n = maxSaltSize - minSaltSize + 1;
        int k = rd.nextInt(8) % n;

        return (minSaltSize + k);
    }

    private static void WriteHexString(String name, byte[] bytes) {
        if (bytes == null)
            return;

        StringBuffer sb = new StringBuffer();

        for (int i = 0; i < bytes.length; ++i) {
            sb.append(Integer.toHexString(0xFF & bytes[i]));
        }
        System.out.println(name + sb.toString());
    }
}
