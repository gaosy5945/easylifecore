package com.amarsoft.app.workflow.processdata;

import java.util.List;

import com.amarsoft.app.base.businessobject.BusinessObject;
import com.amarsoft.app.base.businessobject.BusinessObjectManager;

public class Avg implements IProcess {

	@Override
	public String process(List<BusinessObject> bos,BusinessObjectManager bomanager,String paraName,String dataType,BusinessObject otherPara)
			throws Exception {
		if(bos == null || bos.isEmpty() || !"2".equals(dataType)) return "0";
		
		double d = 0.0;
		for(BusinessObject bo:bos)
		{
			double dd = bo.getDouble(paraName);
			d += dd;
		}
		
		return String.valueOf(d/bos.size());
	}

}
