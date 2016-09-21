package com.amarsoft.app.workflow.exterdata;


import java.util.Map;

import com.amarsoft.app.base.businessobject.BusinessObjectManager;



/**
 * 定义获取流程任务接口
 * @author 赵晓建
 */
public interface IFlowData{
	/**
	 * 通过联机接口获取流程管理系统提供的任务数据
	 * @param para 输入接口参数，该参数通过流程配置加工得到
	 * @return 接口数据标准对象
	 */
	public abstract Map<String,Object> getData(Map<String,String> para,BusinessObjectManager bomanager) throws Exception;

}
