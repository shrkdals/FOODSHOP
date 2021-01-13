package com.ensys.sample.utils;

import java.io.File;
import java.io.FileInputStream;
import java.io.IOException;
import java.io.InputStream;
import java.io.PrintWriter;

import org.apache.commons.net.PrintCommandListener;
import org.apache.commons.net.ftp.FTP;
import org.apache.commons.net.ftp.FTPClient;
import org.apache.commons.net.ftp.FTPReply;

public class FTPUploader {

    FTPClient ftp = null;

    //param( host server ip, username, password )
    public FTPUploader(String host, String user, String pwd) throws Exception {
        ftp = new FTPClient();
        ftp.addProtocolCommandListener(new PrintCommandListener(new PrintWriter(System.out)));
        int reply;
        ftp.connect(host);//호스트 연결
        reply = ftp.getReplyCode();
        if (!FTPReply.isPositiveCompletion(reply)) {
            ftp.disconnect();
            throw new Exception("Exception in connecting to FTP Server");
        }
        ftp.login(user, pwd);//로그인
        ftp.setFileType(FTP.BINARY_FILE_TYPE);
        ftp.enterLocalPassiveMode();
        System.out.println("FTP 로그인완료");
    }

    //param( 보낼파일경로+파일명, 호스트에서 받을 파일 이름, 호스트 디렉토리 )
    public void uploadFile(String localFileFullName, String fileName, String hostDir)
            throws Exception {

        String path = "";
        for (int i = 0 ; i < hostDir.split("/").length; i++){
            if (i != 0){
                path += "/";
            }
            path += hostDir.split("/")[i];

            if (ftp.changeWorkingDirectory(path)){
                ftp.changeWorkingDirectory("/");
            }else{
                ftp.makeDirectory(path);
            }
        }
        System.out.println("파일 전송하는 경로 : " + localFileFullName);
        System.out.println("파일 전송되는 경로 : " + hostDir + "/" + fileName);

        try (InputStream input = new FileInputStream(new File(localFileFullName))) {
            this.ftp.storeFile(hostDir + "/" + fileName, input);
        }
        System.out.println("FTP 파일전송완료!!");
    }

    public void disconnect() {
        System.out.println("FTP 접속종료시작!!");
        if (this.ftp.isConnected()) {
            try {
                this.ftp.logout();
                this.ftp.disconnect();
            } catch (IOException f) {
                f.printStackTrace();
            }
        }
        System.out.println("FTP 접속종료끝!!");
    }

    public static void main(String[] args) throws Exception {
        FTPUploader ftpUploader = new FTPUploader("rahan2002.cafe24.com", "rahan2002", "rahan123!@");
        ftpUploader.uploadFile("/rahan2002/", "hello.txt", "/home/jdk/");
        ftpUploader.disconnect();
        System.out.println("Done");
    }

}