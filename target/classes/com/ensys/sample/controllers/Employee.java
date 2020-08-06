package com.ensys.sample.controllers;

public class Employee {
    // Generate Getters and Setters...


    private String  NO_SENARIO;
    private String  SEND_NMEMP;
    private String NOTIFY_NMEMP;
    private String TITLE;
    private String CONTENT;

    public Employee(String NO_SENARIO, String SEND_NMEMP, String NOTIFY_NMEMP, String TITLE, String CONTENT) {
        super();
        this.NO_SENARIO = NO_SENARIO;
        this.SEND_NMEMP = SEND_NMEMP;
        this.NOTIFY_NMEMP = NOTIFY_NMEMP;
        this.TITLE = TITLE;
        this.CONTENT = CONTENT;
    }

    public String getNO_SENARIO() {
        return NO_SENARIO;
    }

    public void setNO_SENARIO(String NO_SENARIO) {
        this.NO_SENARIO = NO_SENARIO;
    }

    public String getSEND_NMEMP() {
        return SEND_NMEMP;
    }

    public void setSEND_NMEMP(String SEND_NMEMP) {
        this.SEND_NMEMP = SEND_NMEMP;
    }

    public String getNOTIFY_NMEMP() {
        return NOTIFY_NMEMP;
    }

    public void setNOTIFY_NMEMP(String NOTIFY_NMEMP) {
        this.NOTIFY_NMEMP = NOTIFY_NMEMP;
    }

    public String getTITLE() {
        return TITLE;
    }

    public void setTITLE(String TITLE) {
        this.TITLE = TITLE;
    }

    public String getCONTENT() {
        return CONTENT;
    }

    public void setCONTENT(String CONTENT) {
        this.CONTENT = CONTENT;
    }
}
