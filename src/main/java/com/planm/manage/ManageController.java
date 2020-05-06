package com.planm.manage;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpSession;

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
import org.springframework.web.servlet.ModelAndView;

import com.planm.login.vo.LoginVO;
import com.planm.manage.service.ManageService;
import com.planm.manage.vo.ManageVO;

@Controller
public class ManageController {
	
	private static final Logger logger = LoggerFactory.getLogger(ManageController.class);
	
	@Autowired
	private ManageService manageService;
	
	@RequestMapping(value="/manage/main.do", method={ RequestMethod.GET })
	public String managePage(Model model) {								
		return "/manage/main";
	}
	
	@RequestMapping(value="/manage/recordCommute.ajax", method={ RequestMethod.POST })
	public @ResponseBody HashMap<String, Object> recordCommute(@RequestBody String jsonParams, HttpSession session) {		
		LoginVO loginVO = (LoginVO) session.getAttribute("loginVO");

		JSONObject result = new JSONObject(); 											
		JSONObject json = (JSONObject) JSONValue.parse(jsonParams);
		Map<String, Object> map = new HashMap<String, Object>();
				
		try {				
			map.put("flag"   , json.get("flag"));
			map.put("cmpcd"  , loginVO.getCmpcd());
			map.put("usercd" , loginVO.getUsercd());
			map.put("workday", json.get("todate"));			
			map.put("todate" , json.get("todate"));
			map.put("fromdate",  json.get("fromdate"));
			map.put("fixyn"  , "N");
			
			manageService.recordCommute(map);
			
			result.put("status", "success");
		} catch (Exception e) {
			e.printStackTrace();
			result.put("result", "ERROR");			
		}
		
		return result;
	}
	
	@RequestMapping(value="/manage/getMaxWorkday.ajax", method={ RequestMethod.POST })
	public @ResponseBody HashMap<String, Object> getMaxWorkday(@RequestBody String jsonParams, HttpSession session) {
		LoginVO loginVO = (LoginVO) session.getAttribute("loginVO");
		ManageVO manageVO = new ManageVO();
		
		JSONObject result = new JSONObject(); 	
		
		try {	
			manageVO.setCmpcd(loginVO.getCmpcd());
			manageVO.setUsercd(loginVO.getUsercd());
			int cnt = manageService.getMaxWorkday(manageVO);
			
			result.put("cnt", cnt);
			result.put("status", "success");
		} catch (Exception e) {
			e.printStackTrace();
			result.put("result", "ERROR");			
		}
		
		return result;
	}
	
	@RequestMapping(value="/manage/getCommuteList.do", method={ RequestMethod.GET, RequestMethod.POST })
	public ModelAndView getUserCommute(@RequestParam HashMap<String, Object> paramMap, Model model, HttpSession session) {	
		ModelAndView mav = new ModelAndView();		
		LoginVO loginVO = (LoginVO) session.getAttribute("loginVO");
		
		Map<String, Object> map = new HashMap<String, Object>();
		
		try {
			map.put("cmpcd" , loginVO.getCmpcd());
			map.put("usercd", loginVO.getUsercd());
			map.put("userauth", loginVO.getUserauth());
			map.put("datechar", paramMap.get("dateChar"));
			
			List<Map<String, Object>> resultList = manageService.getCommuteList(map);
			
			mav.addObject("resultList", resultList);		
			mav.setViewName("/manage/commuteList");
		} catch (Exception e) {
			e.printStackTrace();
		}		
		
		return mav;
	}
}
