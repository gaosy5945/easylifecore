package com.amarsoft.app.workflow.filter;

import java.util.List;

import com.amarsoft.app.base.businessobject.BusinessObject;
import com.amarsoft.app.base.businessobject.BusinessObjectManager;

public interface IFlowFilter {
	/**
	 * 计算流程对象与用户匹配关系
	 * @param boList
	 * @param para
	 * @param objectID
	 * @return
	 */
	public abstract boolean run(List<BusinessObject> boList,BusinessObject ft,String objectID,BusinessObjectManager bomanager) throws Exception;
}
