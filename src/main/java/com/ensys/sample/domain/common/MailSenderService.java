package com.ensys.sample.domain.common;

import javax.activation.DataHandler;
import javax.activation.FileDataSource;
import javax.mail.*;
import javax.mail.internet.InternetAddress;
import javax.mail.internet.MimeBodyPart;
import javax.mail.internet.MimeMessage;
import javax.mail.internet.MimeMultipart;
import java.io.File;
import java.util.Date;
import java.util.HashMap;
import java.util.List;
import java.util.Properties;

public class MailSenderService {
    public static void sendMail(String email,String title, String content, List<HashMap<String, Object>> re_file) {

        try{
            //set up the default parameters.
            String host = "smtp.naver.com";
            final String username = "osj7606";
            final String password = "visualsj";
            int port=465;
            String recipient = email;

            String subject = "메일테스트";
            String body = username+"님으로 부터 메일을 받았습니다.";
            Properties props = System.getProperties();
            props.put("mail.smtp.host", host);
            props.put("mail.smtp.port", port);
            props.put("mail.smtp.auth", "true");
            props.put("mail.smtp.ssl.enable", "true");
            props.put("mail.smtp.ssl.trust", host);

            Session mailSession = Session.getDefaultInstance(props, new Authenticator() {
                String un=username;
                String pw=password;
                protected PasswordAuthentication getPasswordAuthentication() {
                    return new PasswordAuthentication(un, pw);
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
            String fileNm = null;
            String fileExt = null;
            String fullPath = "";

            messageBodyPart.setText(content);
            Multipart multipart = new MimeMultipart();
            multipart.addBodyPart(messageBodyPart);

            if (re_file != null && re_file.size() > 0) {
                for (HashMap<String, Object> item : re_file) {
                    fileExt =  item.get("FILE_EXT").toString();
                    fileNm =  item.get("FILE_NAME").toString();
//                    fullPath = filePath + "/"+ fileNm+"."+ fileExt ;
                    fullPath = item.get("FILE_PATH").toString() + "/" + fileNm+"."+ fileExt ;
                    System.out.println("fullPath ==>"+fullPath);
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
        }catch(Exception e){
            e.printStackTrace();
        }
    }
}
