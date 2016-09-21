package com.amarsoft.app.workflow.filter;

import java.util.List;

import com.amarsoft.app.base.businessobject.BusinessObject;
import com.amarsoft.app.base.businessobject.BusinessObjectManager;

public class NNEQUserFilter implements IFlowFilter {

	public boolean run(List<BusinessObject> boList, BusinessObject ft,
			String objectID,BusinessObjectManager bomanager) throws Exception{
		
		if(ft.getString("CurUserID").equals(objectID)) //��ǰ�û�ֱ�Ӳ���ʾ
		{
			return false;
		}
		
		return true;
	}

}
