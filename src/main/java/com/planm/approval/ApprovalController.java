package com.planm.approval;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
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

import com.planm.approval.service.ApprovalService;
import com.planm.approval.vo.ApprovalVO;
import com.planm.login.vo.LoginVO;

@Controller
public class ApprovalController {

	private static final Logger logger = LoggerFactory.getLogger(ApprovalController.class);

	@Autowired
	private ApprovalService approvalService;

	@RequestMapping(value="/approval/main.do", method={ RequestMethod.GET })
	public String approvalPage(Model model) {
		return "/approval/main";
	}

	@RequestMapping(value="/approval/signDocPage.do", method={ RequestMethod.GET, RequestMethod.POST })
	public ModelAndView signDocPage(@RequestParam HashMap<String, Object> paramMap, Model model, HttpSession session) {
		ModelAndView mav = new ModelAndView();

		mav.addObject("docGubun", paramMap.get("docGubun"));
		mav.addObject("docNo" , paramMap.get("docNo"));

		mav.setViewName("/approval/signDocPage");

		return mav;
	}

	@RequestMapping(value="/approval/leavePage.do", method={ RequestMethod.GET })
	public String vacPage(Model model) {
		return "/approval/leavePage";
	}

	@RequestMapping(value="/approval/prfPage.do", method={ RequestMethod.GET })
	public String prfPage(Model model) {
		return "/approval/prfPage";
	}

	@RequestMapping(value="/approval/getDocList.ajax", method={ RequestMethod.GET, RequestMethod.POST }, produces="application/json; charset=UTF-8")
	public @ResponseBody JSONObject getDocList(HttpSession session, @RequestBody String jsonParams) {
		LoginVO loginVO = (LoginVO) session.getAttribute("loginVO");
		JSONObject result = new JSONObject();
		Map<String, Object> map = new HashMap<String, Object>();

		try {
			JSONObject json = (JSONObject) JSONValue.parse(jsonParams);

			map.put("cmpcd"    , loginVO.getCmpcd());
			map.put("usercd"   , loginVO.getUsercd());
			map.put("startDay" , json.get("startDay"));
			map.put("endDay"   , json.get("endDay"));
			map.put("docGubun" , json.get("docGubun"));
			map.put("docStatus", json.get("docStatus"));

			List<Map<String, Object>> resultList = approvalService.getDocList(map);

			result.put("resultList", resultList);
			result.put("status", "success");
		} catch (Exception e) {
			e.printStackTrace();
			result.put("status", "error");
		}

		return result;
	}

	@RequestMapping(value="/approval/getLeaveCnt.ajax", method={ RequestMethod.GET, RequestMethod.POST }, produces="application/json; charset=UTF-8")
	public @ResponseBody HashMap<String, Object> getLeaveCnt(@RequestBody String jsonParams, HttpServletRequest request, HttpServletResponse response, HttpSession session) {
		LoginVO loginVO = (LoginVO) session.getAttribute("loginVO");
		JSONObject result = new JSONObject();
		Map<String, Object> map = new HashMap<String, Object>();

		try {
			map.put("cmpcd" , loginVO.getCmpcd());
			map.put("usercd", loginVO.getUsercd());

			Map<String, Object> leaveInfo = approvalService.getLeaveCnt(map);

			result.put("result", leaveInfo);
			result.put("status", "success");
		} catch (Exception e) {
			e.printStackTrace();
			result.put("status", "error");
		}

		return result;
	}

	@RequestMapping(value="/approval/getApprovalUser.ajax", method={ RequestMethod.GET, RequestMethod.POST }, produces="application/json; charset=UTF-8")
	public @ResponseBody HashMap<String, Object> getApprovalUser(@RequestBody String jsonParams, HttpServletRequest request, HttpServletResponse response, HttpSession session) {
		LoginVO loginVO = (LoginVO) session.getAttribute("loginVO");
		JSONObject result = new JSONObject();
		Map<String, Object> map = new HashMap<String, Object>();

		try {
			map.put("cmpcd" , loginVO.getCmpcd());
			map.put("usercd", loginVO.getUsercd());

			List<Map<String, Object>> resultList = approvalService.getApprovalUser(map);

			result.put("resultList", resultList);
			result.put("status", "success");
		} catch (Exception e) {
			e.printStackTrace();
			result.put("status", "error");
		}

		return result;
	}

	@RequestMapping(value="/approval/addDoc.ajax", method={ RequestMethod.GET, RequestMethod.POST }, produces="application/json; charset=UTF-8")
	public @ResponseBody HashMap<String, Object> addDoc(@RequestBody String jsonParams, HttpServletRequest request, HttpServletResponse response, HttpSession session) {
		ApprovalVO approvalVO = new ApprovalVO();
		LoginVO loginVO = (LoginVO) session.getAttribute("loginVO");
		JSONObject result = new JSONObject();
		Map<String, Object> map = new HashMap<String, Object>();

		try {
			JSONObject json = (JSONObject) JSONValue.parse(jsonParams);
			String docno = approvalService.getDocno(loginVO.getCmpcd());
			String docType = (String) json.get("docType");
			String signUser = (String) json.get("signUser");
			String signLine = (String) json.get("signLine");

			approvalVO.setDocno(docno);
			approvalVO.setDoctype(docType);
			approvalVO.setCmpcd(loginVO.getCmpcd());
			approvalVO.setUsercd(loginVO.getUsercd());
			approvalVO.setSignline(signLine);
			approvalVO.setSignuser(signUser);
			approvalVO.setRequestymd((String) json.get("requestYmd"));
			/* 신청서/결재신청서 생성*/
			approvalService.addDoc(approvalVO);

			if(docType.equals("L")) {
				map.put("cmpcd"     , loginVO.getCmpcd());
				map.put("usercd"    , loginVO.getUsercd());
				map.put("docno"		, docno);
				map.put("requestYmd", json.get("requestYmd"));
				map.put("leaveType" , json.get("leaveType"));
				map.put("dayType"	, json.get("dayType"));
				map.put("startDay"	, json.get("startDay"));
				map.put("endDay"	, json.get("endDay"));
				map.put("vacDay"	, json.get("vacDay"));
				map.put("remark"	, json.get("remark"));

				if(approvalService.addDocLeave(map) != 0) {  // 휴가 신청서 생성
					approvalService.editUserLeave(map);		 // 유저 휴가일수 수정
				}
			} else if(docType.equals("P")) {

			}

			result.put("status", "success");
		} catch (Exception e) {
			e.printStackTrace();
			result.put("status", "error");
		}

		return result;
	}

	@RequestMapping(value="/approval/getDocLeave.ajax", method={ RequestMethod.GET, RequestMethod.POST }, produces="application/json; charset=UTF-8")
	public @ResponseBody HashMap<String, Object> getDocLeave(@RequestBody String jsonParams, HttpServletRequest request, HttpServletResponse response, HttpSession session) {
		ApprovalVO approvalVO = new ApprovalVO();
		LoginVO loginVO = (LoginVO) session.getAttribute("loginVO");
		JSONObject result = new JSONObject();
		Map<String, Object> map = new HashMap<String, Object>();

		try {
			JSONObject json = (JSONObject) JSONValue.parse(jsonParams);

			approvalVO.setDocno((String) json.get("docNo"));
			approvalVO.setCmpcd(loginVO.getCmpcd());

			Map<String, Object> docLeave = approvalService.getDocLeave(approvalVO);
			List<Map<String, Object>> signLine = approvalService.getSignLine(approvalVO);

			result.put("result"    , docLeave);
			result.put("resultList", signLine);
			result.put("status"    , "success");
		} catch (Exception e) {
			e.printStackTrace();
			result.put("status", "error");
		}

		return result;
	}

	@RequestMapping(value="/approval/editDocSign.ajax", method={ RequestMethod.GET, RequestMethod.POST })
	public @ResponseBody HashMap<String, Object> editDocSign(@RequestBody String jsonParams, HttpServletRequest request, HttpServletResponse response, HttpSession session) {
		ApprovalVO approvalVO = new ApprovalVO();
		LoginVO loginVO = (LoginVO) session.getAttribute("loginVO");
		JSONObject result = new JSONObject();
		Map<String, Object> map = new HashMap<String, Object>();

		try {
			JSONObject json  = (JSONObject) JSONValue.parse(jsonParams);
			String usercd	 = (String) json.get("usercd");		// 신청자 사번
			String docType   = (String) json.get("docType");
			String docStatus = (String) json.get("docStatus");
			String returnCause = (String) json.get("returnCause");

			approvalVO.setDocno((String) json.get("docNo"));
			approvalVO.setCmpcd(loginVO.getCmpcd());
			approvalVO.setUsercd(loginVO.getUsercd());
			approvalVO.setDocstatus(docStatus);
			approvalVO.setReturncause(returnCause);

			if(approvalService.editDocSign(approvalVO) != 0) {
				String docYmd = approvalService.getDocSignYmd(approvalVO);

				/* 최종 결재 여부 */
				if(!docYmd.equals("N")) {
					approvalService.editDocRequest(approvalVO);
				}

				/* 반려 처리 */
				if(docStatus.equals("R")) {
					approvalService.editDocRequest(approvalVO);

					/* 휴가 신청서일 경우 사용일수 원복 */
					if(docType.equals("L")) {
						String vacDay = approvalService.getLeaveVacday(approvalVO);	// 휴가 사용일수 조회

						map.put("cmpcd" , loginVO.getCmpcd());
						map.put("usercd", usercd);
						map.put("vacday", vacDay);
						approvalService.returnUserLeave(map);
					}
				}

				result.put("status", "success");
			}
		} catch (Exception e) {
			e.printStackTrace();
			result.put("status", "error");
		}

		return result;
	}
}
