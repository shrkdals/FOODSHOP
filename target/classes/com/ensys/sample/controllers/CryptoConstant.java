package com.ensys.sample.controllers;

public class CryptoConstant  {
    static final String ENCODING_NAME = "UTF-16LE";
    static final String CIPHER_ALGORITHM_NAME = "AES/CBC/PKCS7Padding";
    static final String ALGORITHM_NAME = "AES";
    static final String HASH_ALGORITHM = "SHA-256";
    static byte[] IV = { -15, 45, 7, 22, 80, 44, -75, 91, -35, 86, 83, -91,
            -114, 36, 2, 71 };

    static byte[] KEY = { 22, -103, 31, -29, -107, -119, 107, -70, -15, 45, 7,
            22, 80, 44, -75, 91, -117, -74, -121, -50, -80, 100, -16, -20, 47,
            -94, -10, 30, 82, 118, 103, 115 };
}
