package com.planm.manage.service;

import java.util.List;
import java.util.Map;

import com.planm.manage.vo.ManageVO;

public interface ManageService {
	
	/*
	 * 출,퇴근 기록
	 */
	public void recordCommute(Map<String, Object> map) throws Exception;
	
	/*
	 * 
	 */
	public int getMaxWorkday(ManageVO manageVO) throws Exception;
	
	/*
	 * 근태 기록 조회
	 */
	public List<Map<String, Object>> getCommuteList(Map<String, Object> map) throws Exception;
}
