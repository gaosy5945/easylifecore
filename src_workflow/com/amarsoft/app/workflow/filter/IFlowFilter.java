package com.amarsoft.app.workflow.filter;

import java.util.List;

import com.amarsoft.app.base.businessobject.BusinessObject;
import com.amarsoft.app.base.businessobject.BusinessObjectManager;

public interface IFlowFilter {
	/**
	 * �������̶������û�ƥ���ϵ
	 * @param boList
	 * @param para
	 * @param objectID
	 * @return
	 */
	public abstract boolean run(List<BusinessObject> boList,BusinessObject ft,String objectID,BusinessObjectManager bomanager) throws Exception;
}
