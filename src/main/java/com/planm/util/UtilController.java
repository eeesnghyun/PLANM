package com.planm.util;

import java.io.File;
import java.text.SimpleDateFormat;
import java.util.Date;
import java.util.HashMap;
import java.util.Iterator;
import java.util.List;

import javax.servlet.http.HttpSession;

import org.apache.commons.io.FilenameUtils;

import org.json.simple.JSONObject;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.multipart.MultipartFile;
import org.springframework.web.multipart.MultipartHttpServletRequest;

import com.planm.login.vo.LoginVO;
import com.planm.mail.service.MailService;
import com.planm.mail.vo.MailVO;

@Controller
public class UtilController {
	
	private static final Logger logger = LoggerFactory.getLogger(UtilController.class);
	
	@Autowired
	private MailService mailService;		
	
	@RequestMapping(value = "/util/fileUpload.ajax", method = { RequestMethod.POST })
	public @ResponseBody HashMap<String, Object> fileUpload(HttpSession session, MultipartHttpServletRequest mtfRequest) throws Exception {
		SimpleDateFormat sdf = new SimpleDateFormat ( "yyyyMMddHHmmss");		
		Date date = new Date();
		
		CommonUtil commonUtil = new CommonUtil();
		JSONObject result = new JSONObject(); 			
		LoginVO loginVO = (LoginVO) session.getAttribute("loginVO");
		MailVO mailVO = new MailVO();

		String PATH = "D:\\PLANM\\file\\";		
		String fileName = "";		// 파일 이름(확장자 제외)
		String fileFullName = "";	// 파일 이름(확장자 포함)
		String fileType = "";		// 파일 확장자				
		String fileUploadTime = sdf.format(date);	// 파일 업로드 시간(yyyymmddhhmmss)
		
		String fromuser    = loginVO.getUserid() + "@planm.com";
		String toUser      = mtfRequest.getParameter("toUser");
		String ccUser      = mtfRequest.getParameter("ccUser");
		
		String[] mailTitle   = mtfRequest.getParameterValues("mailTitle");		
		String[] mailContent = mtfRequest.getParameterValues("CkmailContent");
		// FormData 사용시 한글이 깨지는 것을 방지
		String convertTomailTitle   = new String(mailTitle[0].getBytes("8859_1"),"utf-8");  		
		String convertToContent = new String(mailContent[0].getBytes("8859_1"),"utf-8");
		String sendFileName = "";
		
		try {
			
			Iterator<String> itr =  mtfRequest.getFileNames();
        	
        	if(itr.hasNext()) {        		        		
        		List<MultipartFile> mpf = mtfRequest.getFiles((String) itr.next());
        		
        		for(int i = 0; i < mpf.size(); i++) {
          			File file = new File(PATH + mpf.get(i).getOriginalFilename());
          		
          			fileFullName = mpf.get(i).getOriginalFilename();
        			fileName = FilenameUtils.getBaseName(mpf.get(i).getOriginalFilename());
        			fileType = fileFullName.substring(fileFullName.lastIndexOf(".")+1, fileFullName.length());
            			
          			file = new File(PATH + fileName + "_" + fileUploadTime + "." + fileType);          				
          			sendFileName = sendFileName + fileName + "_" + fileUploadTime + "." + fileType + ",";         			
          			
           		 	logger.info("----------------------- FILE UPLOAD START ---------------------------");
           		 	logger.info("FILE : " + file.getAbsolutePath());
           		 	logger.info("SIZE : " + mpf.get(i).getSize() + "bytes");
           		 	logger.info("----------------------- FILE UPLOAD END -----------------------------");
           		            		 	
           		 	mpf.get(i).transferTo(file);	// 파일 전송
           	 	}           	         		
        	}        	        	
			
        	mailVO.setMailtitle(convertTomailTitle);
			mailVO.setMailcontent(convertToContent);
			mailVO.setMailfile(commonUtil.returnRmvStr(sendFileName));
			mailVO.setFromuser(fromuser);			
        	mailVO.setTouser(toUser);
			mailVO.setCcuser(ccUser); 
        							
			mailService.sendMail(mailVO);
			
          	result.put("result", "OK"); 
        	
		} catch (Exception e) {
			e.printStackTrace();
			result.put("result", "N");
			
		}
        	
        return result;
	}
	
}
