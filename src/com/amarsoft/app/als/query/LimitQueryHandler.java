package com.amarsoft.app.als.query;

import com.amarsoft.are.jbo.BizObject;
import com.amarsoft.are.jbo.BizObjectManager;
import com.amarsoft.are.jbo.BizObjectQuery;
import com.amarsoft.are.jbo.JBOFactory;
import com.amarsoft.awe.dw.handler.impl.CommonHandler;

public class LimitQueryHandler extends CommonHandler{

	@Override
	protected void initDisplayForEdit(BizObject bo) throws Exception {
		BizObjectManager cim = JBOFactory.getBizObjectManager("jbo.cl.CL_INFO");		
		String serialNo = bo.getAttribute("serialNo").toString();
		
		BizObjectQuery ciq = cim.createQuery("ObjectType='jbo.app.BUSINESS_CONTRACT' and ObjectNo=:ObjectNo and "
				+ "CLType in ('0101','0102','0103','0104','0107','0108')");
		ciq.setParameter("ObjectNo", serialNo);
		BizObject cibo = ciq.getSingleResult(false);
		
		double appAmt = cibo.getAttribute("BusinessAppAmt").getDouble();
		double avaBalance = cibo.getAttribute("BusinessAvaBalance").getDouble();
		
		bo.setAttributeValue("BUSINESSAPPAMT",appAmt);
		bo.setAttributeValue("BUSINESSAVABALANCE",avaBalance);
		bo.setAttributeValue("ALREADY",appAmt-avaBalance);
	}
}
