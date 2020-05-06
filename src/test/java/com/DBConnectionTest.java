package com;

import java.sql.Connection;
import java.sql.DriverManager;
import org.junit.Test;

public class DBConnectionTest {
    
    private static final String DRIVER ="org.mariadb.jdbc.Driver";
    private static final String URL ="jdbc:mariadb://127.0.0.1:3306/shxdb"; 
    private static final String USER ="root";
    private static final String PW ="0591";
	
    @Test
    public void testConnect() throws Exception{
        
        Class.forName(DRIVER);
        
        try(Connection con = DriverManager.getConnection(URL, USER, PW)){
            
            System.out.println(con);
        }catch(Exception e) {
            e.printStackTrace();
        }
    }
                    

}