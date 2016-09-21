package com.amarsoft.acct.accounting.web;

import java.util.List;

import com.amarsoft.app.base.businessobject.BusinessObject;
import com.amarsoft.app.base.businessobject.BusinessObjectManager;
import com.amarsoft.app.base.util.BUSINESSOBJECT_CONSTANTS;

public class GetRepaymentTrans {
	public String GetRepaymentTrans(String reverseSerialNo) throws Exception {
		BusinessObjectManager bom = new BusinessObjectManager();
		BusinessObject at = bom.keyLoadBusinessObject(
				BUSINESSOBJECT_CONSTANTS.transaction, reverseSerialNo);
		String relativeObjectType = at.getString("RELATIVEOBJECTTYPE");
		String relativeObjectNo = at.getString("RELATIVEOBJECTNO");
		List<BusinessObject> bos = bom
				.loadBusinessObjects(
						BUSINESSOBJECT_CONSTANTS.transaction,
						"relativeObjectType=:relativeObjectType and relativeObjectNo=:relativeObjectNo and transCode in ('2001','2002') and transStatus='1' ",
						"relativeObjectType", relativeObjectType,
						"relativeObjectNo", relativeObjectNo);
		if (bos == null || bos.size() == 0)
			return "true";
		return "false";

	}
}
