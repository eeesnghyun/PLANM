package com.planm.approval.service.impl;

import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.planm.approval.dao.ApprovalDao;
import com.planm.approval.service.ApprovalService;
import com.planm.approval.vo.ApprovalVO;

@Service("approval.ApprovalService")
public class ApprovalServiceImpl implements ApprovalService {
	
	@Autowired
	private ApprovalDao approvalDao;
	
	@Override
	public List<Map<String, Object>> getDocList(Map<String, Object> map) throws Exception {		
		List<Map<String, Object>> resultList = approvalDao.getDocList(map);

		return resultList;
	}

	@Override
	public Map<String, Object> getLeaveCnt(Map<String, Object> map) throws Exception {
		return approvalDao.getLeaveCnt(map);		
	}

	@Override
	public List<Map<String, Object>> getApprovalUser(Map<String, Object> map) throws Exception {		
		return approvalDao.getApprovalUser(map);
	}

	@Override
	public String getDocno(String cmpcd) throws Exception {
		return approvalDao.getDocno(cmpcd);
	}
	
	@Override
	public int addDoc(ApprovalVO approvalVO) throws Exception {		
		String signUser = approvalVO.getSignuser();		
		String[] signUserArr = signUser.split(",");		
			
		/* 결재자 신청서 저장 */
		if(signUser.length() > 0) {			
			for(int i = 0; i < signUserArr.length; i++) {		
				int seq = i + 1;
				approvalVO.setSeq(seq);
				approvalVO.setSignuser(signUserArr[i]);
				approvalDao.addDocSign(approvalVO);
			}
		}	
		
		return approvalDao.addDoc(approvalVO);
	}

	@Override
	public int addDocLeave(Map<String, Object> map) throws Exception { 
		return approvalDao.addDocLeave(map);
	}

	@Override
	public int editUserLeave(Map<String, Object> map) throws Exception {
		return approvalDao.editUserLeave(map);
	}
	
	@Override
	public Map<String, Object> getDocLeave(ApprovalVO approvalVO) throws Exception {		
		return approvalDao.getDocLeave(approvalVO);
	}

	@Override
	public List<Map<String, Object>> getSignLine(ApprovalVO approvalVO) throws Exception {		
		return approvalDao.getSignLine(approvalVO);
	}

	@Override
	public int editDocSign(ApprovalVO approvalVO) throws Exception {		
		return approvalDao.editDocSign(approvalVO);
	}

	@Override
	public String getDocSignYmd(ApprovalVO approvalVO) throws Exception { 
		return approvalDao.getDocSignYmd(approvalVO);
	}

	@Override
	public int editDocRequest(ApprovalVO approvalVO) throws Exception {		
		return approvalDao.editDocRequest(approvalVO);
	}

	@Override
	public String getLeaveVacday(ApprovalVO approvalVO) throws Exception {		
		return approvalDao.getLeaveVacday(approvalVO);
	}

	@Override
	public int returnUserLeave(Map<String, Object> map) throws Exception {		
		return approvalDao.returnUserLeave(map);
	}
	
}
