package com.planm.approval.service;

import java.util.List;
import java.util.Map;

import com.planm.approval.vo.ApprovalVO;

public interface ApprovalService {
	
	/** 문서 조회 */
	public List<Map<String, Object>> getDocList(Map<String, Object> map) throws Exception;
	
	/** 휴가일수 조회 */
	public Map<String, Object> getLeaveCnt(Map<String, Object> map) throws Exception;
	
	/** 결재자 조회 */
	public List<Map<String, Object>> getApprovalUser(Map<String, Object> map) throws Exception;

	/** 신청서 번호 */
	public String getDocno(String cmpcd) throws Exception;
	
	/** 신청서 저장 */
	public int addDoc(ApprovalVO approvalVO) throws Exception;
	
	/** 휴가 신청서 저장 */
	public int addDocLeave(Map<String, Object> map) throws Exception;
	
	/** 유저 휴가일수 수정 */
	public int editUserLeave(Map<String, Object> map) throws Exception;
	
	/** 신청서 조회(휴가) */
	public Map<String, Object> getDocLeave(ApprovalVO approvalVO) throws Exception;
	
	/** 결재선 조회 */
	public List<Map<String, Object>> getSignLine(ApprovalVO approvalVO) throws Exception;

	/** 신청서 결재/반려 */
	public int editDocSign(ApprovalVO approvalVO) throws Exception;
	
	/** 신청서 최종 결재 여부 */
	public String getDocSignYmd(ApprovalVO approvalVO) throws Exception;
	
	/** 신청서 최종 결재 */
	public int editDocRequest(ApprovalVO approvalVO) throws Exception;
	
	/** 휴가신청 사용일수 조회 */ 
	public String getLeaveVacday(ApprovalVO approvalVO) throws Exception;
	
	/** 반려에 의한 휴가 사용일수 원복 */
	public int returnUserLeave(Map<String, Object> map) throws Exception;
}
