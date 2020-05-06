package com.planm.manage.dao;

import java.util.List;
import java.util.Map;

import org.apache.ibatis.session.SqlSession;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Repository;

import com.planm.manage.vo.ManageVO;

@Repository("ManageDao")
public class ManageDao {
	
	@Autowired
	private SqlSession mybatis;
	
	/* 
	 * 출근 기록
	 */
	public void recordCommuteT(Map<String, Object> map) throws Exception {
		mybatis.insert("manage.recordCommuteT", map);
	}	
	
	/*
	 * 퇴근 기록
	 */
	public void recordCommuteF(Map<String, Object> map) throws Exception {
		mybatis.update("manage.recordCommuteF", map);
	}	
	
	/*
	 * 
	 */
	public int getMaxWorkday(ManageVO manageVO) throws Exception {
		return mybatis.selectOne("manage.getMaxWorkday", manageVO);
	}
	
	/*
	 * 근태 기록 조회 
	 */
	public List<Map<String, Object>> getCommuteList(Map<String, Object> map) throws Exception {
		return mybatis.selectList("manage.getCommuteList", map);
	}
}
