package com.ensys.sample.controllers;

import org.springframework.web.multipart.MultipartFile;

import java.util.Properties;

import javax.mail.*;
import javax.mail.internet.*;
import javax.activation.*;
import java.io.*;
import java.util.*;

public class MailSenderService {
    public static void sendMail(String title, String content, String recipient, String filePath, List<MultipartFile> mf) {

        try {
            //set up the default parameters.
            String host = "smtp.naver.com";
            final String username = "osj7606";
            final String password = "visualsj";
            int port = 465;

            String subject = "메일테스트";
            String body = username + "님으로 부터 메일을 받았습니다.";
            Properties props = System.getProperties();
            props.put("mail.smtp.host", host);
            props.put("mail.smtp.port", port);
            props.put("mail.smtp.auth", "true");
            props.put("mail.smtp.ssl.enable", "true");
            props.put("mail.smtp.ssl.trust", host);


            Session mailSession = Session.getDefaultInstance(props, new javax.mail.Authenticator() {
                String un = username;
                String pw = password;

                protected javax.mail.PasswordAuthentication getPasswordAuthentication() {
                    return new javax.mail.PasswordAuthentication(un, pw);
                }
            });
            mailSession.setDebug(true); //for debug

            Message msg = new MimeMessage(mailSession);

            //송신자 메일주소
            msg.setFrom(new InternetAddress("osj7606@naver.com"));

            //수신자 메일주소
            msg.setRecipients(Message.RecipientType.TO, InternetAddress.parse(recipient));
            msg.setSentDate(new Date());
            msg.setSubject(title);

            /*첨부파일 없이 메시지만 전송할 경우 다음 라인처럼 텍스트를 설정하고 전송하면 된다.
             * msg.setText("Hello! from my first java e-mail...Testing!!/n");
             * Transport.send(msg);
             */

            // Create the message part
            BodyPart messageBodyPart = new MimeBodyPart();


            // Fill the message
            String originFileNm = null;
            String fullPath = "";

            messageBodyPart.setContent(content, "text/html; charset=utf-8");

            Multipart multipart = new MimeMultipart();
            multipart.addBodyPart(messageBodyPart);

            // 첫번째 파일을 바디파트에 설정한다.
            if (mf != null && mf.size() > 0) {
                for (int i = 0; i < mf.size(); i++) {
                    originFileNm = mf.get(i).getOriginalFilename();
                    fullPath = filePath + "/" + originFileNm;
                    System.out.println("fullPath ==>" + fullPath);
                    messageBodyPart = new MimeBodyPart();

                    File file = new File(fullPath);
                    FileDataSource fds = new FileDataSource(file);
                    messageBodyPart.setDataHandler(new DataHandler(fds));
                    messageBodyPart.setFileName(fds.getName());
                    multipart.addBodyPart(messageBodyPart);
                }
            }


            // Put parts in message
            msg.setContent(multipart);

            // Send the message
            Transport.send(msg);

            System.out.println("E-mail successfully sent!!");
        } catch (Exception e) {
            e.printStackTrace();
        }
    }
}