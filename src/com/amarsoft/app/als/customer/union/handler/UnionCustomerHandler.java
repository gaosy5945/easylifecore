package com.amarsoft.app.als.customer.union.handler;

import com.amarsoft.app.als.customer.union.model.UnionInfo;
import com.amarsoft.are.jbo.BizObject;
import com.amarsoft.awe.dw.handler.impl.CommonHandler;
import com.amarsoft.dict.als.manage.NameManager;

/**
 * 客户群详情模板Handler
 * @author wmZhu
 *
 */
public class UnionCustomerHandler extends CommonHandler{

	@Override
	protected void initDisplayForEdit(BizObject bo) throws Exception {
		String unionID = bo.getAttribute("GroupID").getString();
		UnionInfo ui = new UnionInfo(unionID);
		String userID = ui.getManageUserID();
		String orgID = ui.getManageOrgID();
		bo.setAttributeValue("ManagerUser", NameManager.getUserName(userID));
		bo.setAttributeValue("ManagerOrg", NameManager.getOrgName(orgID));
	}

}
