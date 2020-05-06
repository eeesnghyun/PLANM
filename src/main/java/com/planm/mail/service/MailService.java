package com.planm.mail.service;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import com.planm.login.vo.LoginVO;
import com.planm.mail.vo.MailVO;
import com.planm.util.paging.vo.PagingVO;

public interface MailService {
	
	/** 메일 PK 설정 */
	public String getMailNo(String cmpcd) throws Exception;
	
	/** 사용자 메일 조회 */
	public List<Map<String, Object>> getUsermail(String cmpcd) throws Exception;
	
	/** 메일 전송 */
	public void sendMail(MailVO mailVO) throws Exception;
	
	/** 받은 메일 리스트 */
	public List<Map<String, Object>> getMailList(Map<String, Object> map) throws Exception;
		
	/** 받은 메일 내용 */
	public Map<String, Object> getMailContent(Map<String, Object> map) throws Exception;

	/** 보낸 메일 리스트 */
	public List<Map<String, Object>> setMailList(Map<String, Object> map) throws Exception;	
	
	/** 보낸 메일 내용 */
	public Map<String, Object> setMailContent(Map<String, Object> map) throws Exception;
	
	/** 메일 읽음 처리 */
	public int readMailEdit(Map<String, Object> map) throws Exception;
	
	/** 메일 삭제 */
	public int setMailStatus(Map<String, Object> map) throws Exception;
}
