package com.amarsoft.app.workflow.processdata;

import java.util.List;

import com.amarsoft.app.base.businessobject.BusinessObject;
import com.amarsoft.app.base.businessobject.BusinessObjectManager;
import com.amarsoft.app.base.config.impl.SystemDBConfig;

public class GetOrgType implements IProcess{

	public String process(List<BusinessObject> bos, BusinessObjectManager bomanager,
			String paraName, String dataType, BusinessObject otherPara)
			throws Exception {
		String orgID = bos.get(0).getString("INPUTORGID");
		String orgType = SystemDBConfig.getOrg(orgID).getString("OrgType");
		return orgType;
	}
}
