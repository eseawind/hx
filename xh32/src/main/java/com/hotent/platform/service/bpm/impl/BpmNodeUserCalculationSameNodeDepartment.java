package com.hotent.platform.service.bpm.impl;

import java.util.ArrayList;
import java.util.LinkedHashSet;
import java.util.List;
import java.util.Set;

import javax.annotation.Resource;

import com.hotent.core.model.TaskExecutor;
import com.hotent.core.util.BeanUtils;
import com.hotent.platform.model.bpm.BpmNodeUser;
import com.hotent.platform.model.bpm.TaskOpinion;
import com.hotent.platform.model.system.SysOrg;
import com.hotent.platform.model.system.SysUser;
import com.hotent.platform.service.bpm.CalcVars;
import com.hotent.platform.service.bpm.IBpmNodeUserCalculation;
import com.hotent.platform.service.bpm.TaskOpinionService;
import com.hotent.platform.service.system.SysOrgService;
import com.hotent.platform.service.system.SysUserService;

/**
 * 根据节点用户设置为“与其他节点相同执行人”，计算执行人员部门。
 * 
 * @author Raise
 */
public class BpmNodeUserCalculationSameNodeDepartment implements IBpmNodeUserCalculation {
	@Resource
	private SysUserService sysUserService;
	@Resource
	private SysOrgService sysOrgService;
	@Resource
	private TaskOpinionService taskOpinionService;

	@Override
	public List<SysUser> getExecutor(BpmNodeUser bpmNodeUser, CalcVars vars) {
		String actInstId = vars.getActInstId();
		List<SysUser> users = new ArrayList<SysUser>();
		String nodeId = bpmNodeUser.getCmpIds();
		TaskOpinion taskOpinion = taskOpinionService.getLatestTaskOpinion(new Long( actInstId), nodeId);
		if (taskOpinion != null) {
			if(taskOpinion.getExeUserId()!=null){
				SysUser user = sysUserService.getById(taskOpinion.getExeUserId());
				users.add(user);
			}
		}
		return users;
	}

	@Override
	public String getTitle() {
		return "与已执行节点执行人相同部门";
	}

	@Override
	public Set<TaskExecutor> getTaskExecutor(BpmNodeUser bpmNodeUser, CalcVars vars) {
		Set<TaskExecutor> uIdSet = new LinkedHashSet<TaskExecutor>();
		List<SysUser> sysUsers = this.getExecutor(bpmNodeUser, vars);
		if(BeanUtils.isNotEmpty(sysUsers)){
			for (SysUser sysUser : sysUsers) {
				if(BeanUtils.isEmpty(sysUser)) continue ;
				SysOrg sysOrg = sysOrgService.getDefaultOrgByUserId(sysUser.getUserId());
				if(BeanUtils.isEmpty(sysOrg)) continue ;
				uIdSet.add(TaskExecutor.getTaskOrg(sysOrg.getOrgId().toString(),sysOrg.getOrgName()));
			}
		}
		
		return uIdSet;
	}

	@Override
	public boolean supportMockModel() {
		
		return false;
	}

	@Override
	public List< PreViewModel> getMockModel(BpmNodeUser bpmNodeUser) {
		
		return null;
	}
	
	@Override
	public boolean supportPreView() {
		return false;
	}

}
