package com.planm.menu;

import java.util.HashMap;
import java.util.List;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

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
import org.springframework.web.bind.annotation.ResponseBody;

import com.planm.login.service.LoginService;
import com.planm.login.vo.LoginVO;
import com.planm.menu.service.MenuService;
import com.planm.menu.vo.MenuVO;
import com.planm.schedule.vo.ScheduleVO;

@Controller
public class MenuController {
	
	private static final Logger logger = LoggerFactory.getLogger(MenuController.class);
	
	@Autowired
	private MenuService menService;
	
	@RequestMapping(value = "/menu/getMenuList.ajax", method = { RequestMethod.GET, RequestMethod.POST }, produces = "application/json; charset=UTF-8")
	public @ResponseBody HashMap<String, Object> getMenuList(@RequestBody String jsonParams, HttpServletRequest request, HttpServletResponse response, HttpSession session) {
		LoginVO loginVO = (LoginVO) session.getAttribute("loginVO");		
		JSONObject result = new JSONObject(); 						

		try {
			String userid = loginVO.getUserid();
			
			List<MenuVO> resultList = menService.getMenuList(userid); 
			
			result.put("result", resultList);	
			result.put("status", "success");												
		} catch (Exception e) {		
			e.printStackTrace();
			result.put("status", "error");
		}
		
		return result;
	}

}
