package com.amarsoft.app.als.project;

import com.amarsoft.app.base.businessobject.BusinessObjectManager;
import com.amarsoft.are.jbo.BizObject;
import com.amarsoft.are.jbo.BizObjectManager;
import com.amarsoft.are.jbo.BizObjectQuery;
import com.amarsoft.are.jbo.JBOFactory;
import com.amarsoft.are.jbo.JBOTransaction;
import com.amarsoft.are.util.json.JSONObject;

public class SelectFlowSerialNo {
	private JSONObject inputParameter;
	private BusinessObjectManager businessObjectManager;
	
	public void setInputParameter(JSONObject inputParameter) {
		this.inputParameter = inputParameter;
	}
	
	private JBOTransaction tx;

	public void setTx(JBOTransaction tx) {
		this.tx = tx;
	}
	
	public void setBusinessObjectManager(BusinessObjectManager businessObjectManager) {
		this.businessObjectManager = businessObjectManager;
		this.tx = businessObjectManager.getTx();
	}
	public String selectFlowSerialNo(JBOTransaction tx) throws Exception{
		String ObjectNo = (String)inputParameter.getValue("ObjectNo");
		BizObjectManager table = JBOFactory.getBizObjectManager("jbo.flow.FLOW_OBJECT");
		tx.join(table);

		BizObjectQuery q = table.createQuery("ObjectNo=:ObjectNo and ObjectType='jbo.prj.PRJ_BASIC_INFO'").setParameter("ObjectNo", ObjectNo);
		BizObject pr = q.getSingleResult(false);
		String  flowSerialNo = "";
		if(pr!=null)
		{
			flowSerialNo = pr.getAttribute("FLOWSERIALNO").getString();
		}

		return flowSerialNo;
	}
}
