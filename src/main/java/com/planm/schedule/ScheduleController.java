package com.planm.schedule;

import java.util.List;
import java.util.Locale;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import org.json.simple.JSONArray;
import org.json.simple.JSONObject;
import org.json.simple.JSONValue;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.ResponseBody;

import com.planm.login.vo.LoginVO;
import com.planm.schedule.service.ScheduleService;
import com.planm.schedule.vo.ScheduleVO;

@Controller
public class ScheduleController {
	
	@Autowired
	private ScheduleService scheduleService;
	
	@RequestMapping(value = "/schedule/main.do", method = {RequestMethod.GET, RequestMethod.POST})
	public String schedulePage(Locale locale, Model model) {								
		return "/schedule/main";
	}
	
	/** 스케줄 입력 */
	@RequestMapping(value= "/schedule/addSchedule.ajax", method = RequestMethod.POST)
	public @ResponseBody String addSchedule(HttpSession session, @RequestBody String jsonParams, HttpServletRequest request) {	
		ScheduleVO scheduleVO = new ScheduleVO();
		LoginVO loginVO = (LoginVO) session.getAttribute("loginVO");
		
		JSONObject result = new JSONObject(); 				
		JSONObject json = (JSONObject) JSONValue.parse(jsonParams);		
		
		try {
			String schno = String.valueOf(json.get("schno"));
			String userid = loginVO.getUserid();
			String title = String.valueOf(json.get("title"));
			String schContent = String.valueOf(json.get("content"));
			String schType = String.valueOf(json.get("schType"));
			String startdt = String.valueOf(json.get("startdt"));
			String enddt = String.valueOf(json.get("enddt"));
			String bgColor = String.valueOf(json.get("bgColor"));
			String txtColor = String.valueOf(json.get("txtColor"));
			String allDay = String.valueOf(json.get("allDay"));			
			
			scheduleVO.setSchno(schno);
			scheduleVO.setUserid(userid);
			scheduleVO.setTitle(title);
			scheduleVO.setSchContent(schContent);
			scheduleVO.setSchType(schType);
			scheduleVO.setStartdt(startdt);
			scheduleVO.setEnddt(enddt);
			scheduleVO.setBgColor(bgColor);
			scheduleVO.setTxtColor(txtColor);
			scheduleVO.setAllDay(allDay);							
			scheduleService.addSchedule(scheduleVO);
			
			result.put("result", "OK");
		} catch (Exception e) {
			// TODO: handle exception
			e.printStackTrace();
			result.put("result", "ERROR");			
		}		
		return result.toJSONString();		
	}
	
	@RequestMapping(value= "/schedule/getSchedule.ajax",method = {RequestMethod.GET, RequestMethod.POST}, produces = "application/text; charset=UTF-8")
	public @ResponseBody String getSchedule(@RequestBody String jsonParams, HttpServletRequest request, HttpServletResponse response, HttpSession session) {			
		LoginVO loginVO = (LoginVO) session.getAttribute("loginVO");		
		JSONObject result = new JSONObject(); 					
		JSONArray jsonArray = new JSONArray();					
					
		try {
			String userid = loginVO.getUserid();
			
			List<ScheduleVO> resultList = scheduleService.getSchedule(userid);				
			
			for(int i = 0; i < resultList.size(); i++) {
				ScheduleVO scheduleVO = resultList.get(i);
				result = new JSONObject(); 		
				
				result.put("schno", scheduleVO.getSchno());
				result.put("title", scheduleVO.getTitle());
				result.put("schContent", scheduleVO.getSchContent());				
				result.put("schType", scheduleVO.getSchType());
				result.put("userid", scheduleVO.getUserid());		
				
				// 시작일, 종료일, 배경색, 글자색, 종일 여부는 Fullcalendar.js 내부에 키값이 정의되어 있어 고정되어야 함
				result.put("start"      , scheduleVO.getStartdt());
				result.put("end"        , scheduleVO.getEnddt());
				result.put("backgroundColor", scheduleVO.getBgColor());
				result.put("textColor"  , scheduleVO.getTxtColor());					
				result.put("allDay"     , scheduleVO.getAllDay());
				
				jsonArray.add(result);
			}									
		} catch (Exception e) {
			// TODO: handle exception
			e.printStackTrace();
			result.put("result", "ERROR");
			jsonArray.add(result);
		}
		
		return jsonArray.toJSONString();
	}
	
	@RequestMapping(value= "/schedule/editSchedule.ajax", method = RequestMethod.POST)
	public @ResponseBody String setU_schedule(@RequestBody String jsonParams, HttpServletRequest request) {	
		ScheduleVO scheduleVO = new ScheduleVO();
		
		JSONObject result = new JSONObject(); 				
		JSONObject json = (JSONObject) JSONValue.parse(jsonParams);		
		
		try {
			String schno = String.valueOf(json.get("schno"));
			String userid = String.valueOf(json.get("userid"));
			String title = String.valueOf(json.get("title"));
			String schContent = String.valueOf(json.get("schContent"));
			String schType = String.valueOf(json.get("schType"));
			String startdt = String.valueOf(json.get("startdt"));
			String enddt = String.valueOf(json.get("enddt"));
			String bgColor = String.valueOf(json.get("bgColor"));
			String txtColor = String.valueOf(json.get("txtColor"));
			String allDay = String.valueOf(json.get("allDay"));		
			
			scheduleVO.setSchno(schno);
			scheduleVO.setUserid(userid);
			scheduleVO.setTitle(title);
			scheduleVO.setSchContent(schContent);
			scheduleVO.setSchType(schType);
			scheduleVO.setStartdt(startdt);
			scheduleVO.setEnddt(enddt);
			scheduleVO.setBgColor(bgColor);
			scheduleVO.setTxtColor(txtColor);
			scheduleVO.setAllDay(allDay);						
			
			scheduleService.editSchedule(scheduleVO);
			result.put("result", "OK");
		} catch (Exception e) {
			// TODO: handle exception
			e.printStackTrace();
			result.put("result", "ERROR");			
		}	
		
		return result.toJSONString();
	}
	
	@RequestMapping(value= "/schedule/deleteSchedule.ajax", method = RequestMethod.POST)
	public @ResponseBody String deleteSchedule(@RequestBody String jsonParams, HttpServletRequest request) {	
		ScheduleVO scheduleVO = new ScheduleVO();
		
		JSONObject result = new JSONObject(); 				
		JSONObject json = (JSONObject) JSONValue.parse(jsonParams);
		
		try {
			String schno = String.valueOf(json.get("schno"));
			String userid = String.valueOf(json.get("userid"));	
			
			scheduleVO.setSchno(schno);
			scheduleVO.setUserid(userid);
			
			scheduleService.deleteSchedule(scheduleVO);
			result.put("result", "OK");
		} catch (Exception e) {
			// TODO: handle exception
			e.printStackTrace();
			result.put("result", "ERROR");		
		}
		
		return result.toJSONString();
	}
	
}
