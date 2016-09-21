package com.amarsoft.app.workflow.processdata;

import java.util.List;

import com.amarsoft.app.base.businessobject.BusinessObject;
import com.amarsoft.app.base.businessobject.BusinessObjectManager;

public class Min implements IProcess {

	public String process(List<BusinessObject> bos, BusinessObjectManager bomanager,String paraName,String dataType,BusinessObject otherPara)
			throws Exception {
		if(bos == null) return null;
		
		String s = "";
		double d = 0.0;
		for(BusinessObject bo:bos)
		{
			if("1".equals(dataType)) //×Ö·û
			{
				String ss = bo.getString(paraName);
				if(ss == null) continue;
				else if(s.compareTo(ss) > 0)
					s = ss;
			}else if("2".equals(dataType))//Êý×Ö
			{
				double dd = bo.getDouble(paraName);
				if(d > dd) d = dd;
				s = String.valueOf(d);
			}
		}
		return s;
	}

}
