package com.planm.util;

import java.net.InetAddress;
import java.net.UnknownHostException;
import java.text.SimpleDateFormat;
import java.util.Date;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.scheduling.annotation.Scheduled;
import org.springframework.stereotype.Service;

@Service
public class Scheduler {
		
	private static final Logger logger = LoggerFactory.getLogger(Scheduler.class);

	//@Scheduled(fixedDelay = 1000*60)
	public void TestScheduler() throws Exception {
		InetAddress local;
		Date date = new Date();
		
		try {
			local = InetAddress.getLocalHost();
			String ip = local.getHostAddress();
			String today = (new SimpleDateFormat("yyyy-MM-dd HH:mm:ss").format(date));

			System.out.println("----------------------------------");
			System.out.println("TestSchedule START : " + ip);
			System.out.println("Day : " + today);
			System.out.println("----------------------------------");

			
		} catch (UnknownHostException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		} 
		
	}

}
