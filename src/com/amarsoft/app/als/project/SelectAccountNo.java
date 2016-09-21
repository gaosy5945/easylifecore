package com.amarsoft.app.als.project;

import com.amarsoft.app.base.businessobject.BusinessObjectManager;
import com.amarsoft.are.jbo.BizObject;
import com.amarsoft.are.jbo.BizObjectManager;
import com.amarsoft.are.jbo.BizObjectQuery;
import com.amarsoft.are.jbo.JBOFactory;
import com.amarsoft.are.jbo.JBOTransaction;
import com.amarsoft.are.util.json.JSONObject;

public class SelectAccountNo {
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
	public String selectAccountNo(JBOTransaction tx) throws Exception{
		String ProjectSerialNo = (String)inputParameter.getValue("ProjectSerialNo");
		BizObjectManager table = JBOFactory.getBizObjectManager("jbo.guaranty.CLR_MARGIN_INFO");
		tx.join(table);

		BizObjectQuery q = table.createQuery("ObjectNo=:ObjectNo and ObjectType='jbo.prj.PRJ_BASIC_INFO'")
				.setParameter("ObjectNo", ProjectSerialNo);
		BizObject pr = q.getSingleResult(false);
		String  MrgSerialNo = "";
		String  AccountNo = "";
		String flag = "0";
		if(pr!=null)
		{
			MrgSerialNo = pr.getAttribute("SerialNo").getString();
			flag = "1";
			BizObjectManager tableACI = JBOFactory.getBizObjectManager("jbo.acct.ACCT_BUSINESS_ACCOUNT");
			tx.join(tableACI);
			BizObjectQuery qACI = tableACI.createQuery("ObjectNo=:ObjectNo and ObjectType='jbo.guaranty.CLR_MARGIN_INFO' and AccountIndicator='06'")
					.setParameter("ObjectNo", MrgSerialNo);
			BizObject prACI = qACI.getSingleResult(false);
			if(prACI != null){
				AccountNo = pr.getAttribute("SerialNo").getString();
				flag = "2";
			}
		}

		return flag+"@"+AccountNo;
	}
}
