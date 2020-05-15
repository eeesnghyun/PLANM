package com.planm.mail;

import java.io.File;
import java.io.UnsupportedEncodingException;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Date;
import java.util.HashMap;
import java.util.Iterator;
import java.util.List;
import java.util.Locale;
import java.util.Map;
import java.util.Properties;

import javax.mail.Authenticator;
import javax.mail.Message;
import javax.mail.MessagingException;
import javax.mail.Session;
import javax.mail.Transport;
import javax.mail.internet.AddressException;
import javax.mail.internet.InternetAddress;
import javax.mail.internet.MimeMessage;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import org.apache.commons.io.FilenameUtils;
import org.json.simple.JSONArray;
import org.json.simple.JSONObject;
import org.json.simple.JSONValue;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.multipart.MultipartFile;
import org.springframework.web.multipart.MultipartHttpServletRequest;
import org.springframework.web.servlet.ModelAndView;

import com.mysql.jdbc.jdbc2.optional.SuspendableXAConnection;
import com.planm.login.LoginController;
import com.planm.login.vo.LoginVO;
import com.planm.mail.service.MailService;
import com.planm.mail.vo.MailVO;
import com.planm.schedule.vo.ScheduleVO;
import com.planm.util.CommonUtil;
import com.planm.util.FileUtil;
import com.planm.util.MailAuth;
import com.planm.util.paging.PagingController;
import com.planm.util.paging.service.PagingService;
import com.planm.util.paging.vo.PagingVO;

@Controller
public class MailController {
	
	private static final Logger logger = LoggerFactory.getLogger(MailController.class);
	
	@Autowired
	private MailService mailService;
	
	@Autowired
	private PagingService pagingService;
	
	@RequestMapping(value="/mail/main.do", method={ RequestMethod.GET })
	public String mailPage(Model model) {								
		return "/mail/main";
	}
	
	@RequestMapping(value="/mail/writeMail.do", method={ RequestMethod.GET, RequestMethod.POST })
	public ModelAndView writeMail(@RequestParam HashMap<String, Object> paramMap, Model model, HttpSession session) {
		ModelAndView mav = new ModelAndView();
		
		mav.addObject("mailStatus", paramMap.get("mailStatus")); 		
		mav.addObject("mailNo" , paramMap.get("mailNo"));
		
		mav.setViewName("/mail/writeMail");
		
		return mav;
	}
	
	@RequestMapping(value="/mail/replyMail.do", method={ RequestMethod.GET, RequestMethod.POST })
	public ModelAndView replyMail(@RequestParam HashMap<String, Object> paramMap, Model model) {	
		ModelAndView mav = new ModelAndView();
		
		mav.addObject("mailVO", paramMap);
		
		mav.setViewName("/mail/replyMail");
		
		return mav;
	}
	
	@RequestMapping(value="/mail/getMailList.do", method={ RequestMethod.GET })
	public String getMailList(Locale locale, Model model) {								
		return "/mail/getMailList";
	}
	
	@RequestMapping(value="/mail/myList.do", method={ RequestMethod.GET })
	public String myList(Locale locale, Model model) {								
		return "/mail/myList";
	}
	
	@RequestMapping(value="/mail/setMailList.do", method={ RequestMethod.GET })
	public String setMailList(Locale locale, Model model) {								
		return "/mail/setMailList";
	}
	
	@RequestMapping(value="/mail/saveList.do", method={ RequestMethod.GET })
	public String saveList(Locale locale, Model model) {								
		return "/mail/saveList";
	}	
	
	@RequestMapping(value="/mail/garbageList.do", method={ RequestMethod.GET })
	public String garbageList(Locale locale, Model model) {								
		return "/mail/garbageList";
	}

//	@RequestMapping(value = "/mail/sendMail.ajax", method = { RequestMethod.POST })
//    public @ResponseBody String sendMail(@RequestBody String jsonParams, HttpServletRequest request, HttpServletResponse response) {
//		JSONObject result = new JSONObject(); 				
//		
//		Properties prop = System.getProperties();
//        prop.put("mail.smtp.starttls.enable", "true");
//        prop.put("mail.smtp.host", "smtp.gmail.com");
//        prop.put("mail.smtp.auth", "true");
//        prop.put("mail.smtp.port", "587");
//	        
//        Authenticator auth = new MailAuth();
//	        
//        Session session = Session.getDefaultInstance(prop, auth);
//	        
//        MimeMessage msg = new MimeMessage(session);
//	    
//        try {
//        	msg.setSentDate(new Date());
//	                
//          	msg.setFrom(new InternetAddress("shxorld@gmail.com", "VISITOR"));	// 보내는 사람
//                    
//          	InternetAddress to = new InternetAddress("szhyun2002@gmail.com"); // 받는 사람
//          
//          	msg.setRecipient(Message.RecipientType.TO, to);            
//          	msg.setSubject("제목", "UTF-8");            
//          	msg.setText("안녕하세요 테스트 메일입니다.", "UTF-8");            
//            
//          	Transport.send(msg);
//          	result.put("result", "OK"); 
//        } catch (Exception e) {
//			// TODO: handle exception
//        	/**
//        	 * 만약 javax.mail.AuthenticationFailedException 에러가 난다면 99% 확률로 Gmail의 보안 수준 설정 때문일 것이다.
//        	 * myaccount.google.com/security 에서 보안 수준이 낮은 앱의 액세스를 허용하여 해결가능하다. 
//        	 */
//			e.printStackTrace();
//			result.put("result", "ERROR");		
//		}
//        
//        return result.toJSONString();
//    }
	
	@RequestMapping(value="/mail/getUsermail.ajax", method={ RequestMethod.GET, RequestMethod.POST }, produces="application/json; charset=UTF-8")
	public @ResponseBody HashMap<String, Object> getUsermail(@RequestBody String jsonParams, HttpServletRequest request, HttpServletResponse response, HttpSession session) {			
		LoginVO loginVO = (LoginVO) session.getAttribute("loginVO");		
		JSONObject result = new JSONObject(); 					
					
		try {
			String cmpcd = loginVO.getCmpcd();
			
			List<Map<String, Object>> resultList = mailService.getUsermail(cmpcd);		
						
			result.put("resultList", resultList);
			result.put("status", "success");
		} catch (Exception e) {			
			e.printStackTrace();
			result.put("status", "error");		
		}
		
		return result;
	}
	
	@RequestMapping(value="/mail/sendMail.ajax", method={ RequestMethod.POST })
	public @ResponseBody HashMap<String, Object> fileUpload(HttpSession session, MultipartHttpServletRequest mtfRequest) throws Exception {
		FileUtil fileUtil = new FileUtil();					
		
		JSONObject result = new JSONObject(); 			
		LoginVO loginVO = (LoginVO) session.getAttribute("loginVO");
		MailVO mailVO = new MailVO();

		try {
			String toUserCd    = mtfRequest.getParameter("toUserCd");
			String ccUserCd    = mtfRequest.getParameter("ccUserCd");
			String mailNo	   = mtfRequest.getParameter("mailNo");	
			String fromUser    = loginVO.getUsermail();					// 보낸 사람
			String toUser      = mtfRequest.getParameter("toUser");	 	// 받는 사람
			String ccUser      = mtfRequest.getParameter("ccUser"); 	// 참조
			String mailStatus  = mtfRequest.getParameter("mailStatus"); // 메일 상태
			
			String[] mailTitle   = mtfRequest.getParameterValues("mailTitle");		
			String[] mailContent = mtfRequest.getParameterValues("CkmailContent");
			// FormData 사용시 한글이 깨지는 것을 방지
			String convertTomailTitle   = new String(mailTitle[0].getBytes("8859_1"),"utf-8");  		
			String convertToContent = new String(mailContent[0].getBytes("8859_1"),"utf-8");
			
			String sendFileName = fileUtil.fileUpload(mtfRequest);

			mailVO.setCmpcd(loginVO.getCmpcd());
			mailVO.setUsercd(loginVO.getUsercd());
			mailVO.setMailno(mailNo);
        	mailVO.setMailtitle(convertTomailTitle);				// 메일 제목
			mailVO.setMailcontent(convertToContent);				// 메일 내용
			mailVO.setMailfile(sendFileName);						// 첨부 파일
			mailVO.setUserid(loginVO.getUserid());					// 보낸 사람 ID
			mailVO.setFromuser(fromUser);							// 보낸 사람 메일
			mailVO.setFromusercd(loginVO.getUsercd());     			// 보낸 사람 사번
        	mailVO.setTouser(toUser);								// 받는 사람 메일(전체)
        	mailVO.setTousercd(toUserCd);							// 받는 사람 사번(전체) 
			mailVO.setCcuser(ccUser); 								// 참조 메일(전체)
			mailVO.setCcusercd(ccUserCd);							// 참조 사번(전체)
        	mailVO.setMailstatus(mailStatus);						// 메일 상태
			
			mailService.sendMail(mailVO);
          	result.put("status", "success");        				
		} catch (Exception e) {
			e.printStackTrace();
			result.put("status", "error");		
		}
        	
        return result;
	}
	
	@RequestMapping(value="/mail/getMailList.ajax", method={ RequestMethod.GET, RequestMethod.POST }, produces="application/json; charset=UTF-8")
	public @ResponseBody HashMap<String, Object> getMailList(@RequestBody String jsonParams, HttpSession session) {			
		LoginVO loginVO = (LoginVO) session.getAttribute("loginVO");
		PagingVO pagingVO = new PagingVO();	
		
		JSONObject result = new JSONObject(); 											
		JSONObject json = (JSONObject) JSONValue.parse(jsonParams);
		Map<String, Object> map = new HashMap<String, Object>();
		
		try {							
			int nowPage = Integer.parseInt(json.get("nowPage").toString());
			pagingVO.setNowPage(nowPage);	
			
			map.put("cmpcd"		 , loginVO.getCmpcd());
			map.put("usercd"     , loginVO.getUsercd());
			map.put("startNum"   , pagingVO.getStartNum());
			map.put("nowPageCnt" , pagingVO.getNowPageCnt());			
			map.put("mailStatus" , json.get("mailStatus"));
			
			int totalPage = pagingService.getMailListTotalCount(map);			

			PagingController paging = new PagingController();
			paging.setPagingVO(pagingVO);
			paging.setTotalPageCnt(totalPage);			
			
			List<Map<String, Object>> resultList = mailService.getMailList(map);
					
			result.put("paging", paging);
			result.put("resultList", resultList);	
			result.put("status", "success");
		} catch (Exception e) {
			e.printStackTrace();
			result.put("result", "ERROR");			
		}
		
		return result;
	}

	@RequestMapping(value="/mail/getMailContent.ajax", method={ RequestMethod.GET, RequestMethod.POST }, produces="application/json; charset=UTF-8")
	public @ResponseBody HashMap<String, Object> getMailContent(@RequestBody String jsonParams, HttpSession session) {			
		LoginVO loginVO = (LoginVO) session.getAttribute("loginVO");		
		JSONObject result = new JSONObject(); 											
		JSONObject json = (JSONObject) JSONValue.parse(jsonParams);
		Map<String, Object> map = new HashMap<String, Object>();					
					
		try {
			String mailNo = json.get("mailNo").toString(); 
			
			map.put("cmpcd"	  , loginVO.getCmpcd());
			map.put("usercd"  , loginVO.getUsercd());
			map.put("mailno"  , mailNo);
			
			Map<String, Object> mailContent = mailService.getMailContent(map);
			
			int cnt = mailService.readMailEdit(map);		
			if(cnt > 0) {
				result.put("result", mailContent);	
				result.put("status", "success");
			}			
		} catch (Exception e) {			
			e.printStackTrace();
			result.put("status", "error");
		}
		
		return result;
	}
	
	@RequestMapping(value="/mail/setMailList.ajax", method={ RequestMethod.GET, RequestMethod.POST }, produces="application/json; charset=UTF-8")
	public @ResponseBody HashMap<String, Object> setMailList(@RequestBody String jsonParams, HttpSession session) {			
		LoginVO loginVO = (LoginVO) session.getAttribute("loginVO");
		PagingVO pagingVO = new PagingVO();	
		
		JSONObject result = new JSONObject(); 											
		JSONObject json = (JSONObject) JSONValue.parse(jsonParams);
		Map<String, Object> map = new HashMap<String, Object>();
		
		try {							
			int nowPage = Integer.parseInt(json.get("nowPage").toString());
			pagingVO.setNowPage(nowPage);	
				
			map.put("cmpcd"		 , loginVO.getCmpcd());
			map.put("startNum"   , pagingVO.getStartNum());
			map.put("nowPageCnt" , pagingVO.getNowPageCnt());
			map.put("fromusercd" , loginVO.getUsercd());
			
			int totalPage = pagingService.setMailListTotalCount(map);			

			PagingController paging = new PagingController();
			paging.setPagingVO(pagingVO);
			paging.setTotalPageCnt(totalPage);			
			
			List<Map<String, Object>> resultList = mailService.setMailList(map);
					
			result.put("paging", paging);
			result.put("resultList", resultList);	
			result.put("status", "success");
		} catch (Exception e) {
			e.printStackTrace();
			result.put("result", "ERROR");			
		}
		
		return result;
	}
	
	@RequestMapping(value="/mail/setMailContent.ajax", method={ RequestMethod.GET, RequestMethod.POST }, produces="application/json; charset=UTF-8")
	public @ResponseBody HashMap<String, Object> setMailContent(@RequestBody String jsonParams, HttpSession session) {			
		LoginVO loginVO = (LoginVO) session.getAttribute("loginVO");		
		JSONObject result = new JSONObject(); 											
		JSONObject json = (JSONObject) JSONValue.parse(jsonParams);
		Map<String, Object> map = new HashMap<String, Object>();					
					
		try {			
			String mailNo = json.get("mailNo").toString(); 
			
			map.put("cmpcd"	     , loginVO.getCmpcd());
			map.put("fromusercd" , loginVO.getUsercd());
			map.put("mailno" 	 , mailNo);
			
			Map<String, Object> mailContent = mailService.setMailContent(map);
	
			result.put("result", mailContent);	
			result.put("status", "success");		
		} catch (Exception e) {			
			e.printStackTrace();
			result.put("status", "error");
		}
		
		return result;
	}
	
	@RequestMapping(value="/mail/setMailStatus.ajax", method={ RequestMethod.GET, RequestMethod.POST })
	public @ResponseBody HashMap<String, Object> setMailStatus(@RequestBody String jsonParams, HttpSession session) {					
		LoginVO loginVO = (LoginVO) session.getAttribute("loginVO");	
		JSONObject result = new JSONObject(); 											
		JSONObject json = (JSONObject) JSONValue.parse(jsonParams);
		Map<String, Object> map = new HashMap<String, Object>();	
		
		try {
			List<String> mailList = new ArrayList<String>();
			
			String mailNo = json.get("mailNo").toString();
			String[] mailNoList = mailNo.split(",");			
			
			if(mailNoList.length > 1) {
				for(int i = 0; i < mailNoList.length; i++) {
					mailList.add(mailNoList[i]);	
				}				
			} else {			
				map.put("mailno"  , mailNo);
			}	
			map.put("cmpcd"	    , loginVO.getCmpcd());
			map.put("usercd"    , loginVO.getUsercd());
			map.put("mailList"  , mailList);
			map.put("mailStatus", json.get("mailStatus"));
		
			int cnt = mailService.setMailStatus(map);			
			if(cnt > 0) {
				result.put("status", "success");	
			}
		} catch (Exception e) {			
			e.printStackTrace();
			result.put("status", "error");
		}
		
		return result;
	}
}
