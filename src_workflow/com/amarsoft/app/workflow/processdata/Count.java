package com.amarsoft.app.workflow.processdata;

import java.util.List;

import com.amarsoft.app.base.businessobject.BusinessObject;
import com.amarsoft.app.base.businessobject.BusinessObjectManager;

public class Count implements IProcess {

	@Override
	public String process(List<BusinessObject> bos,BusinessObjectManager bomanager,String paraName,String dataType,BusinessObject otherPara)
			throws Exception {
		if(bos == null) return "0";
		
		return String.valueOf(bos.size());
	}

}
