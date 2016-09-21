package com.amarsoft.app.workflow.pcp;

import java.util.List;

import com.amarsoft.app.base.businessobject.BusinessObject;
import com.amarsoft.app.base.businessobject.BusinessObjectManager;

public interface IFlowPcp {
	
	/**
	 * 获取流程任务池定义
	 * @param fi 流程实例对象
	 * @param fp 流程阶段定义对象
	 * @return
	 * @throws Exception
	 */
	public String getFlowPool(BusinessObject fi, BusinessObject fp, BusinessObjectManager bomanager) throws Exception;
	
	/**
	 * 获取流程用户列表
	 * @param fi 流程实例对象
	 * @param fp 流程阶段定义对象
	 * @return
	 * @throws Exception
	 */
	public List<BusinessObject> getFlowUsers(BusinessObject fi, BusinessObject fp, BusinessObjectManager bomanager) throws Exception;
	
}
