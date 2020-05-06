package com.planm.schedule.service.impl;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.planm.schedule.dao.ScheduleDao;
import com.planm.schedule.service.ScheduleService;
import com.planm.schedule.vo.ScheduleVO;

@Service("schedule.ScheduleService")
public class ScheduleServiceImpl implements ScheduleService {
	
	@Autowired
	private ScheduleDao scheduleDao;	
	
	@Override
	public void addSchedule(ScheduleVO scheduleVO) throws Exception {
		scheduleDao.addSchedule(scheduleVO);
	}
	
	@Override
	public List<ScheduleVO> getSchedule(String userid) throws Exception {
		return scheduleDao.getSchedule(userid);		
	}

	@Override
	public void editSchedule(ScheduleVO scheduleVO) throws Exception {
		scheduleDao.editSchedule(scheduleVO);		
	}

	@Override
	public void deleteSchedule(ScheduleVO scheduleVO) throws Exception {
		scheduleDao.deleteSchedule(scheduleVO);		
	}

}
