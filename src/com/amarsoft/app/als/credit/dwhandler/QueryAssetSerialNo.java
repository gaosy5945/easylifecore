package com.amarsoft.app.als.credit.dwhandler;

import com.amarsoft.app.base.businessobject.BusinessObjectManager;
import com.amarsoft.are.jbo.BizObject;
import com.amarsoft.are.jbo.BizObjectManager;
import com.amarsoft.are.jbo.BizObjectQuery;
import com.amarsoft.are.jbo.JBOFactory;
import com.amarsoft.are.jbo.JBOTransaction;
import com.amarsoft.are.lang.StringX;
import com.amarsoft.are.util.json.JSONObject;

public class QueryAssetSerialNo {
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
	public String queryAssetSerialNo(JBOTransaction tx) throws Exception{
		String AssetSerialNo = (String)inputParameter.getValue("AssetSerialNo");
		BizObjectManager table = JBOFactory.getBizObjectManager("jbo.app.ASSET_INFO");
		tx.join(table);

		BizObjectQuery q = table.createQuery("SerialNo=:SerialNo").setParameter("SerialNo", AssetSerialNo);
		BizObject pr = q.getSingleResult(false);
		String flag = "No";
		if(pr!=null)
		{
			String clrSerialNo = pr.getAttribute("clrSerialNo").getString();
			if(!StringX.isEmpty(clrSerialNo)){
				flag = "Yes";
			}
		}

		return flag;
	}
}
