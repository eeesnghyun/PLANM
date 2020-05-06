package com.planm.util.paging.dao;

import java.util.Map;

import org.apache.ibatis.session.SqlSession;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Repository;

import com.planm.mail.vo.MailVO;

@Repository("PagingDao")
public class PagingDao {
	
	@Autowired
	private SqlSession mybatis;
	
	/* 페이징을 위한 받은 메일 갯수 */
	public int getMailListTotalCount(Map<String, Object> map) throws Exception {
		return mybatis.selectOne("paging.getMailListTotalCount", map);
	}
	
	/* 페이징을 위한 보낸 메일 갯수 */
	public int setMailListTotalCount(Map<String, Object> map) throws Exception {
		return mybatis.selectOne("paging.setMailListTotalCount", map);
	}
}
