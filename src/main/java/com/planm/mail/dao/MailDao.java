package com.planm.mail.dao;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.apache.ibatis.session.SqlSession;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Repository;

import com.planm.login.vo.LoginVO;
import com.planm.mail.vo.MailVO;
import com.planm.util.paging.vo.PagingVO;

@Repository("MailDao")
public class MailDao {

	@Autowired
	private SqlSession mybatis;
	
	public String getMailNo(String cmpcd) throws Exception {			
		return mybatis.selectOne("mail.getMailNo", cmpcd);
	}
	
	/** 사용자 메일 조회 */
	public List<Map<String, Object>> getUsermail(String cmpcd) throws Exception {			
		return mybatis.selectList("mail.getUsermail", cmpcd);
	}
	
	/** 메일 전송 */
	public void sendMail(MailVO mailVO) throws Exception {
		mybatis.insert("mail.sendMail", mailVO);
	}	
	
	/** 받은 메일 리스트 */
	public List<Map<String, Object>> getMailList(Map<String, Object> map) throws Exception {			
		return mybatis.selectList("mail.getMailList", map);
	}
	
	/** 받은 메일 내용 조회 */
	public Map<String, Object> getMailContent(Map<String, Object> map) throws Exception {			
		return mybatis.selectOne("mail.getMailContent", map);
	}
	
	/** 보낸 메일 리스트 */
	public List<Map<String, Object>> setMailList(Map<String, Object> map) throws Exception {			
		return mybatis.selectList("mail.setMailList", map);
	}
	
	/** 보낸 메일 내용 조회 */
	public Map<String, Object> setMailContent(Map<String, Object> map) throws Exception {			
		return mybatis.selectOne("mail.setMailContent", map);
	}
	
	/** 메일 읽음 처리 */
	public int readMailEdit(Map<String, Object> map) {
		return mybatis.update("mail.readMailEdit", map);
	}
	
	/** 메일 휴지통 */
	public int editMail(Map<String, Object> map) {
		return mybatis.update("mail.editMail", map);
	}
	
	/** 메일 완전 제거 */
	public int deleteMail(Map<String, Object> map) {
		return mybatis.delete("mail.deleteMail", map);
	}
}
