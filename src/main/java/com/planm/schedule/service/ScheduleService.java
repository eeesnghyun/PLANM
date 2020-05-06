package com.planm.schedule.service;

import java.util.List;

import com.planm.schedule.vo.ScheduleVO;

public interface ScheduleService {

	/** 스케줄 조회 */
	public List<ScheduleVO> getSchedule(String userid) throws Exception;
	
	/** 스케줄 입력 */
	public void addSchedule(ScheduleVO scheduleVO) throws Exception;
	
	/** 스케줄 수정 */
	public void editSchedule(ScheduleVO scheduleVO) throws Exception;
	
	/** 스케줄 삭제 */
	public void deleteSchedule(ScheduleVO scheduleVO) throws Exception;
}
