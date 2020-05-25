package com.planm.notice.service;

import java.util.List;
import java.util.Map;

import com.planm.notice.vo.NoticeVO;

public interface NoticeService {
	
	/*
	 * 공지사항 리스트 조회
	 */
	public List<Map<String, Object>> getNoticeList(Map<String, Object> map) throws Exception;
	
	/*
	 * 공지사항 등록
	 */
	public void writeNotice(NoticeVO noticeVO) throws Exception;
	
	/*
	 * 공지사항 내용 조회
	 */
	public Map<String, Object> getNoticeContent(NoticeVO noticeVO) throws Exception;
}
