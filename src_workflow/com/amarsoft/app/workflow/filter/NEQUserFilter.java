package com.amarsoft.app.workflow.filter;

import java.util.List;

import com.amarsoft.app.base.businessobject.BusinessObject;
import com.amarsoft.app.base.businessobject.BusinessObjectManager;

public class NEQUserFilter implements IFlowFilter {

	public boolean run(List<BusinessObject> boList, BusinessObject ft,
			String objectID,BusinessObjectManager bomanager) throws Exception{
		
		String phaseNo = ft.getString("PhaseNo");
		if(phaseNo == null) phaseNo = "";
		String nextPhaseNo = ft.getString("NextPhaseNo");
		if(nextPhaseNo == null) nextPhaseNo="";
		
		if(ft.getString("CurUserID").equals(objectID) && phaseNo.equals(nextPhaseNo)) //当前用户直接不显示
		{
			return false;
		}
		
		return true;
	}

}
