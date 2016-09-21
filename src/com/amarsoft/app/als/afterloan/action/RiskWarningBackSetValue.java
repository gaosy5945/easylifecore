package com.amarsoft.app.als.afterloan.action;

import com.amarsoft.are.jbo.BizObject;
import com.amarsoft.are.jbo.BizObjectManager;
import com.amarsoft.are.jbo.JBOException;
import com.amarsoft.are.jbo.JBOFactory;

public class RiskWarningBackSetValue {
	
	public static int getIsOrNotGiveOut(String serialNo) throws JBOException{
		
		int flag = 0;
		BizObjectManager bm = JBOFactory.getFactory().getManager("jbo.flow.FLOW_OBJECT");
		BizObject bo = bm.createQuery(" OBJECTNO=:OBJECTNO and OBJECTTYPE = 'jbo.al.RISK_WARNING_SIGNAL01' and FLOWNO='S0215.plbs_afterloan04.Flow_019' ")
						 .setParameter("OBJECTNO", serialNo).getSingleResult(false);
		if(bo == null){
			flag = 0;
		}else{
			flag = 1;
		}
		return flag;
	}
}
