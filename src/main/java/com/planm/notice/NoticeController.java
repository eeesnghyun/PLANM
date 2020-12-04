package com.planm.notice;

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
import org.springframework.web.multipart.MultipartHttpServletRequest;
import org.springframework.web.servlet.ModelAndView;

import com.planm.login.vo.LoginVO;
import com.planm.notice.service.NoticeService;
import com.planm.notice.vo.NoticeVO;
import com.planm.util.FileUtil;
import com.planm.util.paging.PagingController;
import com.planm.util.paging.service.PagingService;
import com.planm.util.paging.vo.PagingVO;

@Controller
public class NoticeController {

	private static final Logger logger = LoggerFactory.getLogger(NoticeController.class);
	
	@Autowired
	private NoticeService noticeService;
	
	@Autowired
	private PagingService pagingService;
	
	@RequestMapping(value="/notice/main.do", method={ RequestMethod.GET })
	public String noticePage(Model model) {								
		return "/notice/main";
	}
	
	@RequestMapping(value="/notice/getNoticeList.do", method={ RequestMethod.GET })
	public String getNoticeList(Model model) {								
		return "/notice/getNoticeList";
	}
	
	@RequestMapping(value="/notice/writeNotice.do", method={ RequestMethod.GET })
	public String writeNotice(Model model) {								
		return "/notice/writeNotice";
	}
	
	@RequestMapping(value="/notice/getNoticeList.ajax", method={ RequestMethod.GET, RequestMethod.POST }, produces="application/json; charset=UTF-8")
	public @ResponseBody HashMap<String, Object> getMailList(@RequestBody String jsonParams, HttpSession session) {			
		LoginVO loginVO = (LoginVO) session.getAttribute("loginVO");
		PagingVO pagingVO = new PagingVO();	
		
		JSONObject result = new JSONObject(); 											
		JSONObject json = (JSONObject) JSONValue.parse(jsonParams);
		Map<String, Object> map = new HashMap<String, Object>();
		
		PagingController paging = new PagingController();
		
		try {			
			String cmpcd = loginVO.getCmpcd();
			int totalPage = pagingService.getNoticeListTotalCount(cmpcd);
			int nowPage = Integer.parseInt(json.get("nowPage").toString());
			
			pagingVO.setNowPage(nowPage);	
			
			map.put("cmpcd"		 , cmpcd);			
			map.put("startNum"   , pagingVO.getStartNum());
			map.put("nowPageCnt" , pagingVO.getNowPageCnt());			
			
			List<Map<String, Object>> resultList = noticeService.getNoticeList(map);
	
			paging.setPagingVO(pagingVO);
			paging.setTotalPageCnt(totalPage);			
					
			result.put("paging"    , paging);
			result.put("resultList", resultList);	
			result.put("status"    , "success");
		} catch (Exception e) {
			e.printStackTrace();
			result.put("result", "ERROR");			
		}
		
		return result;
	}
	
	@RequestMapping(value = "/notice/writeNotice.ajax", method = {RequestMethod.POST})
	public ModelAndView writeNotice(MultipartHttpServletRequest mtfRequest, HttpSession session) throws Exception {
		FileUtil fileUtil = new FileUtil();	
		
		NoticeVO noticeVO = new NoticeVO();
		LoginVO loginVO = new LoginVO();
		ModelAndView mav = new ModelAndView();
							
		try {
			loginVO = (LoginVO) session.getAttribute("loginVO");
							
			String noticetitle = new String(mtfRequest.getParameter("noticeTitle").getBytes("8859_1"), "UTF-8");
			String noticecontent = new String(mtfRequest.getParameter("noticeContent").getBytes("8859_1"), "UTF-8");
			String noticefile = fileUtil.fileUpload(mtfRequest, "notice");
			
			noticeVO.setCmpcd(loginVO.getCmpcd());
			noticeVO.setUsercd(loginVO.getUsercd());
			noticeVO.setNoticetitle(noticetitle);
			noticeVO.setNoticecontent(noticecontent);
			noticeVO.setNoticefile(noticefile);
						
			noticeService.writeNotice(noticeVO);			
			
			mav.addObject("msg", "저장되었습니다.");
			mav.addObject("url", "/notice/main.do");						
			mav.setViewName("common/msg"); 	
		} catch (Exception e) {
			e.printStackTrace();
			mav.addObject("msg", "저장에 실패하였습니다.");
			mav.addObject("url", "/main.do");
		}

		return mav;
	}
	
	@RequestMapping(value="/notice/getNoticeContent.ajax", method={ RequestMethod.GET, RequestMethod.POST }, produces="application/json; charset=UTF-8")
	public ModelAndView getNoticeContent(@RequestParam HashMap<String, Object> paramMap, HttpSession session) {			
		LoginVO loginVO = (LoginVO) session.getAttribute("loginVO");
		NoticeVO noticeVO = new NoticeVO();
											
		ModelAndView mav = new ModelAndView();
		
		try {			
			String noticeNo =  (String) paramMap.get("noticeNo");
			noticeVO.setNoticeno(noticeNo);
			noticeVO.setCmpcd(loginVO.getCmpcd());
			
			Map<String, Object> noticeContent = noticeService.getNoticeContent(noticeVO);
			
			mav.addObject("noticeVO" , noticeContent);
			
			mav.setViewName("/notice/noticeContent");
			
		} catch (Exception e) {			
			e.printStackTrace();			
		}
		
		return mav;
	}
}
