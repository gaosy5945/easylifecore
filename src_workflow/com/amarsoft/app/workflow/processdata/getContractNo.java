package com.amarsoft.app.workflow.processdata;

import java.util.List;

import com.amarsoft.app.base.businessobject.BusinessObject;
import com.amarsoft.app.base.businessobject.BusinessObjectManager;
import com.amarsoft.are.jbo.BizObject;

public class getContractNo implements IProcess {

	@Override
	public String process(List<BusinessObject> bos,BusinessObjectManager bomanager,
			String paraName, String dataType, BusinessObject otherPara)
			throws Exception {
		BizObject bo = bos.get(0);
		String contractNo = "";	

		contractNo = bo.getAttribute("contractartificialno").toString();
		
			return contractNo;
	}

}
