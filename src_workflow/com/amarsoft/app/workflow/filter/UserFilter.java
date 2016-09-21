package com.amarsoft.app.workflow.filter;

import java.sql.PreparedStatement;
import java.util.List;

import com.amarsoft.app.base.businessobject.BusinessObject;
import com.amarsoft.app.base.businessobject.BusinessObjectManager;
import com.amarsoft.app.workflow.util.FlowHelper;

public class UserFilter implements IFlowFilter {

	public boolean run(List<BusinessObject> boList, BusinessObject ft,
			String objectID,BusinessObjectManager bomanager) throws Exception{
		
		String flowSerialNo = ft.getString("FlowSerialNo");
		String flowNo = ft.getString("FlowNo");
		String flowVersion = ft.getString("FlowVersion");
		PreparedStatement ps = null;
		String approveModel="01";
		
		
		if(ft.getString("CurUserID").equals(objectID)) //当前用户直接不显示
		{
			return false;
		}
		
		boolean curAuthorize = FlowHelper.ApproveAuth("0",objectID, boList,approveModel, bomanager);
		return curAuthorize;
	}

}
