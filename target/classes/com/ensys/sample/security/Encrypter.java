package com.ensys.sample.security;

import java.io.BufferedReader;
import java.io.InputStreamReader;

public class Encrypter {

    private static final String PREFIX_STRING = "!@1@!";
    private static final String POSTFIX_STRING = "+ty+tz+";
    private static final int JUMIN_START_INDEX = 7;
    private static final int FOREIGN_START_INDEX = 7;
    private static final int PASSPORT_START_INDEX = -1;
    private static final int DRIVE_START_INDEX = -1;
    private static final int CREDIT_START_INDEX = 6;
    private static final int ACCOUNT_START_INDEX = 6;
    private static final int MAIL_START_INDEX = 3;
    private static final int OFFSET = 0;

    public static void main(String[] args) {
        try {
            InputStreamReader sr = new InputStreamReader(System.in);
            BufferedReader br = new BufferedReader(sr);
            System.out.print("1:주민번호, 2:외국인번호, 3:여권번호, 4:운전번호 번호     : ");
            String style = br.readLine();
            String msg = "";
            int nStyle = 10;
            if (style == "1") {
                nStyle = 10;
                msg = "주민번호";
            } else if (style == "2") {
                nStyle = 13;
                msg = "외국인번호";
            } else if (style == "3") {
                nStyle = 11;
                msg = "여권번호";
            } else if (style == "4") {
                nStyle = 12;
                msg = "운전면허번호";
            }

            System.out.print(msg + " 입력하세요 : ");
            String originText = br.readLine();
            System.out.println("Original String : " + originText);
            String cipherText = Encrypt(originText, nStyle);
            System.out.println("Encrypt String : " + cipherText);
            String plainText = Decrypt(cipherText, nStyle);
            System.out.println("Decrypt String : " + plainText);
        } catch (Exception var9) {
            System.out.println(var9.toString());
        }

    }

    private Encrypter() {
    }

    public static String Encrypt(String plainText, int encStyle) throws Exception {
        String cipherText = null;
        String encString = null;
        String unEncString = null;

        try {
            if (!plainText.startsWith("!@1@!") && !plainText.endsWith("+ty+tz+")) {
                int beginIndex = getBeginIndexOfSpecialStyle(encStyle);
                if (beginIndex == -1) {
                    unEncString = "";
                    encString = plainText;
                } else {
                    unEncString = plainText.substring(0, beginIndex - 0);
                    encString = plainText.substring(beginIndex - 0);
                }

                cipherText = unEncString + "!@1@!" + Internal_Encrypt(encString) + "+ty+tz+";
                return cipherText;
            } else {
                return plainText;
            }
        } catch (Exception var6) {
            var6.printStackTrace();
            throw var6;
        }
    }

    private static String Internal_Encrypt(String plainText) throws Exception {
        return SymmetricCryptoProvider.Encrypt(plainText);
    }

    public static String Decrypt(String cipherText, int encStyle) throws Exception {
        String plainText = null;
        String encString = null;
        String unEncString = null;

        try {
            int beginIndex = getBeginIndexOfSpecialStyle(encStyle);
            if (beginIndex == -1) {
                unEncString = "";
                encString = cipherText;
            } else {
                unEncString = cipherText.substring(0, beginIndex - 0);
                encString = cipherText.substring(beginIndex - 0);
            }

            if (encString.startsWith("!@1@!") && encString.endsWith("+ty+tz+")) {
                String text = encString.substring("!@1@!".length(), encString.length() - "+ty+tz+".length());
                String decString = Internal_Decrypt(text);
                plainText = unEncString + decString;
                return plainText;
            } else {
                return cipherText;
            }
        } catch (Exception var8) {
            var8.printStackTrace();
            throw var8;
        }
    }

    private static String Internal_Decrypt(String cipherText) throws Exception {
        return SymmetricCryptoProvider.Decrypt(cipherText);
    }

    private static int getBeginIndexOfSpecialStyle(int style) {
        int nIndex = -1;
        switch (style) {
            case 10:
                nIndex = 7;
                break;
            case 11:
                nIndex = -1;
                break;
            case 12:
                nIndex = -1;
                break;
            case 13:
                nIndex = 7;
        }

        return nIndex;
    }
}

