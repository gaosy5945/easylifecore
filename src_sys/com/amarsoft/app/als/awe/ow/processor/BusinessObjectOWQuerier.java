package com.amarsoft.app.als.awe.ow.processor;

import com.amarsoft.app.als.awe.ow.ALSBusinessProcess;
import com.amarsoft.app.base.businessobject.BusinessObject;

public interface BusinessObjectOWQuerier {
	public BusinessObject[] getBusinessObjectList(int fromIndex,int toIndex) throws Exception;
	public int query(BusinessObject inputParameters,ALSBusinessProcess businessProcess) throws Exception;
	public int getTotalCount() throws Exception;
}
