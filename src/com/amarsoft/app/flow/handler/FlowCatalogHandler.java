package com.amarsoft.app.flow.handler;

import com.amarsoft.are.jbo.BizObject;
import com.amarsoft.are.jbo.JBOFactory;
import com.amarsoft.are.jbo.JBOTransaction;
import com.amarsoft.awe.dw.handler.impl.CommonHandler;

public class FlowCatalogHandler extends CommonHandler{
	
	protected void beforeDelete(JBOTransaction tx, BizObject bo) throws Exception{
		String FlowNo = bo.getAttribute("FlowNo").toString();
		String FlowVersion = bo.getAttribute("FlowVersion").toString();
		int i= JBOFactory.getBizObjectManager("jbo.flow.FLOW_MODEL", tx)
				.createQuery("delete from O where FlowNo=:FlowNo and FlowVersion=:FlowVersion")
				.setParameter("FlowNo", FlowNo)
				.setParameter("FlowVersion", FlowVersion)
				.executeUpdate();
	}


}
