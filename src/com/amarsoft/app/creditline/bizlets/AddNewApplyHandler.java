package com.amarsoft.app.creditline.bizlets;

import com.amarsoft.app.bizobject.BusinessApply;
import com.amarsoft.are.jbo.BizObject;
import com.amarsoft.awe.dw.handler.impl.CommonHandler;

public class AddNewApplyHandler extends CommonHandler {

	@Override
	protected void initDisplayForAdd(BizObject bo) throws Exception {
		// TODO Auto-generated method stub
		String[][] defaultFields = { { "CycleFlag", BusinessApply.CYCLEFLAG_NO },{"CreditCycle",BusinessApply.CREDITCYCLE_NO}
		                                                 ,{"OtherAreaLoan",BusinessApply.OTHERAREALOAN_NO},{"RateFloatType",BusinessApply.RATEFLOATTYPE_YES}
		                                                 ,{"FRCode",BusinessApply.FRCODE_NO},{"IPCode",BusinessApply.IPCODE_NO}};

	    for (int i = 0; i < defaultFields.length; i++)
	      try
	      {
	        bo.setAttributeValue(defaultFields[i][0], defaultFields[i][1]);
	      }
	      catch (Exception e)
	      {
	      }
		super.initDisplayForAdd(bo);
	}

}
