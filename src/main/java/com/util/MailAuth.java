package com.planm.util;

import javax.mail.Authenticator;
import javax.mail.PasswordAuthentication;

public class MailAuth extends Authenticator{
    
    PasswordAuthentication pa;
    
    public MailAuth() {    	
        String mailId = "shxorld";
        String mailPw = "pln20200303";
        
        pa = new PasswordAuthentication(mailId, mailPw);
    }
    
    public PasswordAuthentication getPasswordAuthentication() {
        return pa;
    }
}