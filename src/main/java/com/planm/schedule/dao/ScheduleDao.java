package com.planm.schedule.dao;

import java.util.List;

import org.apache.ibatis.session.SqlSession;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Repository;

import com.planm.schedule.vo.ScheduleVO;

@Repository("ScheduleDao")
public class ScheduleDao {
	
	@Autowired
	private SqlSession mybatis;
	
	/** 스케줄 조회 */
	public List<ScheduleVO> getSchedule(String userid) throws Exception {			
		return mybatis.selectList("schedule.getSchedule", userid);
	}
	
	/** 스케줄 입력 */
	public void addSchedule(ScheduleVO scheduleVO) throws Exception {
		mybatis.insert("schedule.addSchedule", scheduleVO);
	}	
	
	/** 스케줄 수정 */
	public void editSchedule(ScheduleVO scheduleVO) throws Exception {
		mybatis.update("schedule.editSchedule", scheduleVO);
	}
	
	/** 스케줄 삭제 */
	public void deleteSchedule(ScheduleVO scheduleVO) throws Exception {
		mybatis.delete("schedule.deleteSchedule", scheduleVO);
	}
}
