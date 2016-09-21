package com.amarsoft.app.als.customer.dwhandler;

import com.amarsoft.app.als.customer.model.CustomerBelong;
import com.amarsoft.are.jbo.BizObject;
import com.amarsoft.awe.dw.handler.impl.CommonHandler;
import com.amarsoft.dict.als.manage.NameManager;

/**
 * 
 * @author Administrator
 *
 */

public class FinceQueryHandler extends CommonHandler {

	protected void initDisplayForEdit(BizObject bo) throws Exception {
		super.initDisplayForEdit(bo);
		String customerID = bo.getAttribute("CustomerID").getString();
		//获取管户机构管户人
		String [] str =new CustomerBelong(null, customerID, null).getManageUser();
		String userName ="",orgName ="";
		if(str !=null){
			userName=NameManager.getUserName(str[0]);
			orgName=NameManager.getOrgName(str[1]);
		}
		bo.setAttributeValue("ManagerUser", userName);
		bo.setAttributeValue("ManagerOrg", orgName);
	}
}
