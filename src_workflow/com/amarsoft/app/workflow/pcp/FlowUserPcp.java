package com.amarsoft.app.workflow.pcp;

import java.io.ByteArrayInputStream;
import java.io.InputStream;
import java.util.List;

import com.amarsoft.app.base.businessobject.BusinessObject;
import com.amarsoft.app.base.businessobject.BusinessObjectManager;
import com.amarsoft.app.base.config.impl.SystemDBConfig;
import com.amarsoft.are.lang.StringX;
import com.amarsoft.are.util.xml.Document;

public class FlowUserPcp implements IFlowPcp {

	@Override
	public String getFlowPool(BusinessObject fi, BusinessObject fp, BusinessObjectManager bomanager) throws Exception {
		String roleID = fp.getString("RoleID");
		String orgLevel = fp.getString("OrgLevel");
		
		if(StringX.isEmpty(roleID) || StringX.isEmpty(orgLevel)) return " $ ";
		
		BusinessObject taskContext = BusinessObject.createBusinessObject();
		InputStream in = new ByteArrayInputStream(fi.getString("Parameter").getBytes());
		Document document = new Document(in);
		in.close();
		
		taskContext = BusinessObject.createBusinessObject(document.getRootElement());
		
		String orgID = taskContext.getString("OrgID");
		while(true){
			BusinessObject org = SystemDBConfig.getOrg(orgID);
			if(orgLevel.equalsIgnoreCase(org.getString("OrgLevel")))
			{
				break;
			}
			
			if(org.getString("RelativeOrgID").equals(orgID)) break;
			else orgID = org.getString("RelativeOrgID");
		}
		return roleID+"$"+orgID; 
	}

	@Override
	public List<BusinessObject> getFlowUsers(BusinessObject fi, BusinessObject fp, BusinessObjectManager bomanager) throws Exception {
		String[] pool = getFlowPool(fi,fp,bomanager).split("\\$");
		List<BusinessObject> users = bomanager.loadBusinessObjects("jbo.sys.USER_INFO","UserID in(select UR.UserID from jbo.sys.USER_ROLE UR where UR.RoleID=:RoleID and UR.Status=:Status) and Status=:Status and BelongOrg=:OrgID",
										"RoleID",pool[0],"OrgID",pool[1],"Status","1");
		
		List<BusinessObject> fts = bomanager.loadBusinessObjects("jbo.flow.FLOW_TASK", "FlowSerialNo=:FlowSerialNo and PhaseNo=:PhaseNo", "FlowSerialNo",fi.getString("SerialNo"),"PhaseNo",fp.getString("PhaseNo"));
		for(BusinessObject ft:fts)
		{
			users = bomanager.loadBusinessObjects("jbo.sys.USER_INFO","UserID=:UserID","UserID",ft.getString("UserID"));
		}
		
		return users; 
	}

}
