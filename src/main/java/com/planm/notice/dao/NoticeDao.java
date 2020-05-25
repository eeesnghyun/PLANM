package com.planm.notice.dao;

import java.util.List;
import java.util.Map;

import org.apache.ibatis.session.SqlSession;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Repository;

import com.planm.notice.vo.NoticeVO;

@Repository("NoticeDao")
public class NoticeDao {
	
	@Autowired
	private SqlSession mybatis;
	
	/* 
	 * 공지사항 리스트 조회 
	 */
	public List<Map<String, Object>> getNoticeList(Map<String, Object> map) throws Exception {			
		return mybatis.selectList("notice.getNoticeList", map);
	}
	
	/*
	 * 공지사항 등록
	 */
	public void writeNotice(NoticeVO noticeVO) throws Exception {
		mybatis.insert("notice.writeNotice", noticeVO);
	}


	/*
	 * 공지사항 내용 조회
	 */
	public Map<String, Object> getNoticeContent(NoticeVO noticeVO) throws Exception {			
		return mybatis.selectOne("notice.getNoticeContent", noticeVO);
	}
	
}
