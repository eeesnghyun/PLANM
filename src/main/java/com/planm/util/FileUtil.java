package com.planm.util;

import java.io.File;
import java.io.FileInputStream;
import java.io.OutputStream;
import java.net.URLEncoder;
import java.text.SimpleDateFormat;
import java.util.Date;
import java.util.Iterator;
import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.apache.commons.io.FilenameUtils;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.stereotype.Controller;
import org.springframework.util.FileCopyUtils;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.multipart.MultipartFile;
import org.springframework.web.multipart.MultipartHttpServletRequest;
import org.springframework.web.servlet.ModelAndView;
import org.springframework.web.servlet.view.AbstractView;

import com.planm.mail.MailController;

@Controller
public class FileUtil {
  
	private static final Logger logger = LoggerFactory.getLogger(FileUtil.class);
	
    public String fileUpload(MultipartHttpServletRequest mtfRequest) {
    	CommonUtil commonUtil = new CommonUtil();
    	
    	SimpleDateFormat sdf = new SimpleDateFormat ( "yyyyMMddHHmmss");		
		Date date = new Date();
    	
    	String PATH = "D:\\PLANM\\file\\mail\\";	// 파일 저장 경로
		String fileName = "";						// 파일 이름(확장자 제외)
		String fileFullName = "";					// 파일 이름(확장자 포함)
		String fileType = "";						// 파일 확장자				
		String fileUploadTime = sdf.format(date);	// 파일 업로드 시간(yyyymmddhhmmss)			
		String uploadFileName = "";				// 최종 업로드 파일명
		
		try {
			Iterator<String> itr =  mtfRequest.getFileNames();
			
			if(itr.hasNext()) {				
        		List<MultipartFile> mpf = mtfRequest.getFiles((String) itr.next());
        		
        		if(!mpf.get(0).getOriginalFilename().equals("")) {
        			
        			for(int i = 0; i < mpf.size(); i++) {
              			File file = new File(PATH + mpf.get(i).getOriginalFilename());
              		
              			fileName = FilenameUtils.getBaseName(mpf.get(i).getOriginalFilename());
              			fileFullName = mpf.get(i).getOriginalFilename();            			
            			fileType = fileFullName.substring(fileFullName.lastIndexOf(".")+1, fileFullName.length());
            			uploadFileName = uploadFileName + fileName + "_" + fileUploadTime + "." + fileType + ",";   // DB에 저장될 파일명      		
            			
              			file = new File(PATH + fileName + "_" + fileUploadTime + "." + fileType);          				
              				
               		 	logger.info("----------------------- FILE UPLOAD START ---------------------------");
               		 	logger.info("FILE : " + file.getAbsolutePath());
               		 	logger.info("SIZE : " + mpf.get(i).getSize() + "bytes");
               		 	logger.info("----------------------- FILE UPLOAD END -----------------------------");
               		            		 	
               		 	mpf.get(i).transferTo(file);	// 파일 전송
               	 	}    
        			
        			uploadFileName = commonUtil.returnRmvStr(uploadFileName);
        		}        		        		           	         	
        	}        	  
			
		} catch (Exception e) {
			e.printStackTrace();
		}
		
    	return uploadFileName; 
    }
        
    @RequestMapping(value="/file/download.do", method={ RequestMethod.GET })
    public ModelAndView download(@RequestParam("fileName")String fileName){
    	
    	String PATH = "D:\\PLANM\\file\\mail\\";	// 파일 저장 경로
        String fullPath = PATH + "\\" + fileName;
         
        File file = new File(fullPath);
         
        return new ModelAndView("download", "downloadFile", file);
    }
    
}
