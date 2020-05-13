package com.planm.mail.service.impl;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.planm.login.vo.LoginVO;
import com.planm.mail.dao.MailDao;
import com.planm.mail.service.MailService;
import com.planm.mail.vo.MailVO;
import com.planm.util.paging.vo.PagingVO;

@Service("mail.MailService")
public class MailServiceImpl implements MailService {

	@Autowired
	private MailDao mailDao;
	
	@Override
	public String getMailNo(String cmpcd) throws Exception {
		return mailDao.getMailNo(cmpcd);
	}
	
	@Override
	public List<Map<String, Object>> getUsermail(String cmpcd) throws Exception {
		return mailDao.getUsermail(cmpcd);
	}
	
	@Override
	public void sendMail(MailVO mailVO) throws Exception {		
		String toUserCd   = mailVO.getTousercd();
		String ccUserCd   = mailVO.getCcusercd();
		String mailNo     =  mailVO.getMailno();				
		String[] toUserCdArr   = toUserCd.split(",");
		String[] ccUserCdArr   = ccUserCd.split(",");			
					
		if(mailVO.getMailstatus().equals("U")) {	// 임시저장
			mailVO.setMailno(mailDao.getMailNo(mailVO.getCmpcd()));		
			mailDao.sendMail(mailVO);
		} else {									// 메일 보내기
			/* 받는 사람에게 메일 전송 */
			if(toUserCd.length() > 0) {
				if(mailNo.equals("X")) {	// 신규 메일 작성
					for(int i = 0; i < toUserCdArr.length; i++) {									
						mailVO.setMailno(mailDao.getMailNo(mailVO.getCmpcd()));
						mailVO.setUsercd(toUserCdArr[i]);					
						mailDao.sendMail(mailVO);
					}		
				} else {					// 임시저장 후 메일 작성
					for(int i = 0; i < toUserCdArr.length; i++) {				
						mailVO.setUsercd(toUserCdArr[i]);					
						
						mailDao.sendMail(mailVO);
					}	
				}
			}			
			
			/* 참조자에게 메일 전송 */
			if(ccUserCd.length() > 0) {
				if(mailNo.equals("X")) {	// 신규 메일 작성
					for(int i = 0; i < ccUserCdArr.length; i++) {
						mailVO.setMailno(mailDao.getMailNo(mailVO.getCmpcd()));
						mailVO.setUsercd(ccUserCdArr[i]);										
						mailDao.sendMail(mailVO);
					}	
				} else {					// 임시저장 후 메일 작성
					for(int i = 0; i < ccUserCdArr.length; i++) {
						mailVO.setUsercd(ccUserCdArr[i]);					
						mailDao.sendMail(mailVO);
					}	
				}			
			}			
		}		
	}
	
	@Override
	public List<Map<String, Object>> getMailList(Map<String, Object> map) throws Exception {
		return mailDao.getMailList(map);
	}

	@Override
	public Map<String, Object> getMailContent(Map<String, Object> map) throws Exception {		
		return mailDao.getMailContent(map);
	}

	@Override
	public List<Map<String, Object>> setMailList(Map<String, Object> map) throws Exception {
		return mailDao.setMailList(map);
	}
	
	@Override
	public Map<String, Object> setMailContent(Map<String, Object> map) throws Exception {		
		return mailDao.setMailContent(map);
	}
	
	@Override
	public int readMailEdit(Map<String, Object> map) throws Exception {		
		return mailDao.readMailEdit(map);
	}
	
	@Override
	public int setMailStatus(Map<String, Object> map) throws Exception {		
		String mailStatus = (String) map.get("mailStatus");
		int result = 0;
		
		if(mailStatus.equals("D")) {			// 완전 제거
			result = mailDao.deleteMail(map);				
		} else {
			/**
			 * map - U : 임시보관, P : 휴지통, M : 내게쓴메일함
			 */
			result = mailDao.editMail(map);		
		}
		
		return result;
	}

}
