package com.planm.notice.service.impl;

import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.planm.notice.dao.NoticeDao;
import com.planm.notice.service.NoticeService;
import com.planm.notice.vo.NoticeVO;

@Service("notice.NoviceService")
public class NoticeServiceImpl implements NoticeService {
	
	@Autowired
	private NoticeDao noticeDao;

	@Override
	public List<Map<String, Object>> getNoticeList(Map<String, Object> map) throws Exception {		
		return noticeDao.getNoticeList(map);
	} 
	
	@Override
	public void writeNotice(NoticeVO noticeVO) throws Exception {
		noticeDao.writeNotice(noticeVO);
	}

	@Override
	public Map<String, Object> getNoticeContent(NoticeVO noticeVO) throws Exception { 
		return noticeDao.getNoticeContent(noticeVO);
	}	
}
