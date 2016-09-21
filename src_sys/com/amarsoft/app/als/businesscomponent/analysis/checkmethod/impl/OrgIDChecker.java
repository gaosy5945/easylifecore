package com.amarsoft.app.als.businesscomponent.analysis.checkmethod.impl;

import com.amarsoft.app.base.businessobject.BusinessObject;
import com.amarsoft.app.base.config.impl.SystemDBConfig;

public class OrgIDChecker extends StepParamterChecker {

	@Override
	public Object getUpLevelValue(Object value, BusinessObject parameter)
			throws Exception {
		String orgID = (String)value;
		return SystemDBConfig.getOrg(orgID).getString("RelativeOrgID");
	}
	
	
}
