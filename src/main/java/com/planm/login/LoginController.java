package com.planm.login;

import java.io.File;
import java.util.HashMap;
import java.util.Locale;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;

import org.json.simple.JSONObject;
import org.json.simple.JSONValue;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.core.Authentication;
import org.springframework.security.core.userdetails.UserDetails;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.multipart.MultipartFile;
import org.springframework.web.servlet.ModelAndView;

import com.planm.login.service.LoginService;
import com.planm.login.vo.LoginVO;

@Controller
public class LoginController {
	
	private static final Logger logger = LoggerFactory.getLogger(LoginController.class);
	
	@Autowired
	LoginService loginService;
	
	@RequestMapping(value = "/login/test.do", method = RequestMethod.GET)
	public String test(HttpServletRequest request, Locale locale, Model model) {
		String browser 	 = "";
		String userAgent = request.getHeader("User-Agent");		
		
		if(userAgent.indexOf("Trident") > -1) {												// IE
			browser = "ie";
		} else if(userAgent.indexOf("Edge") > -1) {											// Edge
			browser = "edge";
		} else if(userAgent.indexOf("Whale") > -1) { 										// Naver Whale
			browser = "whale";
		} else if(userAgent.indexOf("Opera") > -1 || userAgent.indexOf("OPR") > -1) { 		// Opera
			browser = "opera";
		} else if(userAgent.indexOf("Firefox") > -1) { 										 // Firefox
			browser = "firefox";
		} else if(userAgent.indexOf("Safari") > -1 && userAgent.indexOf("Chrome") == -1 ) {	 // Safari
			browser = "safari";		
		} else if(userAgent.indexOf("Chrome") > -1) {										 // Chrome	
			browser = "chrome";
		}
		
		logger.info("---------------------------------------------");
		logger.info("User-Agent : " + userAgent);
		logger.info("Browser : " + browser);
		logger.info("---------------------------------------------");
		
		return "/login/test";
	}
	
	@RequestMapping(value = "/login/testEnter.ajax", method = {RequestMethod.POST})
	public ModelAndView testEnter(@RequestParam(value = "ipt-id") String id
								, @RequestParam(value = "ipt-pass") String password
								, HttpSession session) throws Exception {
		ModelAndView mav = new ModelAndView();
							
		try {
			System.out.println("id : " + id + "  / pass : " + password);
				
			if(id.equals("admin") && password.equals("1234")) {
				mav.addObject("msg", "접속 성공");
				mav.addObject("url", "/login/test.do");			
				
				String filePath = "P:\\upload\\NC\\5133202003231358370.png";
				File file = new File(filePath);

				return new ModelAndView("download", "downloadFile", file);
			} else {
				mav.addObject("msg", "계정 정보가 틀렸습니다.");
				mav.addObject("url", "/login/test.do");
				mav.setViewName("login/enter");	
			}
			 	
		} catch (Exception e) {
			e.printStackTrace();
			mav.addObject("msg", "계정 정보가 틀렸습니다.");
			mav.addObject("url", "/login/test.do");				
		}
		
		return mav;
	}
	
	
	@RequestMapping(value = "/login/pmLogin.do", method = RequestMethod.GET)
	public String loginPage(Locale locale, Model model) {								 
		return "/login/login";
	}
	
	@RequestMapping(value = "/login/accessDenied.do", method = RequestMethod.GET)
	public String accessDenied(Locale locale, Model model) {

		return "/login/accessDenied";
	}	
	
	@RequestMapping(value = "/login/userInfo.do", method = {RequestMethod.GET, RequestMethod.POST})
	public String userInfo(Model model, HttpSession session) {
		return "/login/userInfo";
	}	
	
	@RequestMapping(value = "/main.do", method = {RequestMethod.GET, RequestMethod.POST})
	public String main(Locale locale, Model model, Authentication authentication, HttpServletRequest request, HttpSession session) {
		logger.info("==========================================================");
		logger.info("==================== Welcome PLANM =======================");
		logger.info("==========================================================");
		
		try {
			UserDetails userDetails = (UserDetails) authentication.getPrincipal();
			
			String userIp = request.getRemoteAddr();		 		
			String userId = userDetails.getUsername();
			
			LoginVO loginVO = loginService.getUserInfo(userId);
			
			session.setAttribute("userIp", userIp);
			session.setAttribute("loginVO", loginVO);		
		} catch (Exception e) {
			// TODO: handle exception
			e.printStackTrace();
		}
		
		return "index.body";
	}		
	
	@RequestMapping(value = "/login/saveUserImg.ajax", method = {RequestMethod.POST})
	public ModelAndView saveUserImg(@RequestParam("userImgfile") MultipartFile multipartFile, HttpSession session) throws Exception {
		LoginVO loginVO = new LoginVO();
		ModelAndView mav = new ModelAndView();
							
		try {
			loginVO = (LoginVO) session.getAttribute("loginVO");
			
			String PATH = "D:\\PLANM\\file\\user\\";		
			String orgFileName = multipartFile.getOriginalFilename();
			String fileType = orgFileName.substring(orgFileName.lastIndexOf(".")+1, orgFileName.length());
			String fileName = loginVO.getUsercd() + "." + fileType;  
			
			loginVO.setUserimg(fileName);						

			if(loginService.saveUserImg(loginVO) != 0) {
				File file = new File(PATH + fileName);
				
				multipartFile.transferTo(file);			// 이미지 업로드
				
				mav.addObject("msg", "저장되었습니다.");
				mav.addObject("url", "/main.do");
			}	
			
			mav.setViewName("common/msg"); 	
		} catch (Exception e) {
			e.printStackTrace();
			mav.addObject("msg", "저장에 실패하였습니다.");
			mav.addObject("url", "/main.do");
		}
		
		return mav;
	}
	
	@RequestMapping(value = "/login/deleteUserImg.ajax", method = {RequestMethod.POST})
	public @ResponseBody HashMap<String, Object> deleteUserImg(HttpSession session) throws Exception {
		LoginVO loginVO = new LoginVO();
		JSONObject result = new JSONObject(); 
							
		try {
			loginVO = (LoginVO) session.getAttribute("loginVO");
			loginVO.setUserimg("userimg.png");
			if(loginService.saveUserImg(loginVO) != 0) {
				result.put("status", "success");
			}	
		} catch (Exception e) {
			e.printStackTrace();
			result.put("status", "error");
		}
		
		return result;
	}
	
	@RequestMapping(value = "/login/checkPass.ajax", method = {RequestMethod.POST})
	public @ResponseBody HashMap<String, Object> checkPass(@RequestBody String jsonParams, HttpSession session) throws Exception {
		LoginVO loginVO = new LoginVO();
		JSONObject result = new JSONObject(); 
		Map<String, Object> map = new HashMap<String, Object>();
							
		try {
			loginVO = (LoginVO) session.getAttribute("loginVO");
			JSONObject json = (JSONObject) JSONValue.parse(jsonParams);
			
			map.put("cmpcd"     , loginVO.getCmpcd());
			map.put("usercd"    , loginVO.getUsercd());
			map.put("beforePass", json.get("beforePass"));	
			map.put("newPass"   , json.get("newPass"));	
			
			if(loginService.checkPass(map) != 0) {
				
				loginService.editPass(map);
				result.put("status", "success");	
			}										
		} catch (Exception e) {
			e.printStackTrace();
			result.put("status", "error");
		}
		
		return result;
	}
}
