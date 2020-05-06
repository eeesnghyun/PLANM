package com.planm.approval.dao;

import java.util.List;
import java.util.Map;

import org.apache.ibatis.session.SqlSession;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Repository;

import com.planm.approval.vo.ApprovalVO;

@Repository("ApprovalDao")
public class ApprovalDao {
	
	@Autowired
	private SqlSession mybatis;
	
	/** 문서 조회 */
	public List<Map<String, Object>> getDocList(Map<String, Object> map) throws Exception {
		return mybatis.selectList("approval.getDocList", map);
	}
	
	/** 휴가일수 조회 */
	public Map<String, Object> getLeaveCnt(Map<String, Object> map) throws Exception {			
		return mybatis.selectOne("approval.getLeaveCnt", map);
	}
	
	/** 결재자 조회 */
	public List<Map<String, Object>> getApprovalUser(Map<String, Object> map) throws Exception {			
		return mybatis.selectList("approval.getApprovalUser", map);
	}
	
	/** 신청서 번호 */
	public String getDocno(String cmpcd) throws Exception {
		return mybatis.selectOne("approval.getDocno", cmpcd);
	}
	
	/** 신청서 저장 */
	public int addDoc(ApprovalVO approvalVO) throws Exception {
		return mybatis.insert("approval.addDoc", approvalVO);
	}
	
	/** 휴가 신청서 저장 */
	public int addDocLeave(Map<String, Object> map) throws Exception {
		return mybatis.insert("approval.addDocLeave", map);
	}
	
	/** 유저 휴가일수 수정 */
	public int editUserLeave(Map<String, Object> map) throws Exception {
		return mybatis.update("approval.editUserLeave", map);
	}
	
	/** 결재자 신청서 저장 */
	public int addDocSign(ApprovalVO approvalVO) throws Exception {
		return mybatis.insert("approval.addDocSign", approvalVO);
	}
	
	/** 신청서 조회(휴가) */
	public Map<String, Object> getDocLeave(ApprovalVO approvalVO) throws Exception {
		return mybatis.selectOne("approval.getDocLeave", approvalVO);
	}
	
	/** 결재선 조회 */
	public List<Map<String, Object>> getSignLine(ApprovalVO approvalVO) throws Exception {			
		return mybatis.selectList("approval.getSignLine", approvalVO);
	}
	
	/** 신청서 결재/반려 */
	public int editDocSign(ApprovalVO approvalVO) throws Exception {
		return mybatis.update("approval.editDocSign", approvalVO);
	}
	
	/** 신청서 최종 결재 여부 */
	public String getDocSignYmd(ApprovalVO approvalVO) throws Exception {
		return mybatis.selectOne("approval.getDocSignYmd", approvalVO);
	}
	
	/** 신청서 최종 결재 */
	public int editDocRequest(ApprovalVO approvalVO) throws Exception {
		return mybatis.update("approval.editDocRequest", approvalVO);
	}
	
	/** 휴가신청 사용일수 조회 */
	public String getLeaveVacday(ApprovalVO approvalVO) throws Exception {
		return mybatis.selectOne("approval.getLeaveVacday", approvalVO);
	}
	
	/** 반려에 의한 휴가 사용일수 원복 */
	public int returnUserLeave(Map<String, Object> map) throws Exception {
		return mybatis.update("approval.returnUserLeave", map);
	}
}


