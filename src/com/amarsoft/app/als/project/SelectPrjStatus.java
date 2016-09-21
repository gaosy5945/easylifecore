package com.amarsoft.app.als.project;

import com.amarsoft.app.base.businessobject.BusinessObjectManager;
import com.amarsoft.are.jbo.BizObject;
import com.amarsoft.are.jbo.BizObjectManager;
import com.amarsoft.are.jbo.BizObjectQuery;
import com.amarsoft.are.jbo.JBOFactory;
import com.amarsoft.are.jbo.JBOTransaction;
import com.amarsoft.are.lang.StringX;
import com.amarsoft.are.util.json.JSONObject;
import com.amarsoft.dict.als.manage.NameManager;

public class SelectPrjStatus {
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
	public String selectPrjStatus(JBOTransaction tx) throws Exception{
		String ProjectSerialNo = (String)inputParameter.getValue("ProjectSerialNo");
		BizObjectManager table = JBOFactory.getBizObjectManager("jbo.prj.PRJ_BASIC_INFO");
		tx.join(table);

		BizObjectQuery q = table.createQuery("SerialNo=:SerialNo").setParameter("SerialNo", ProjectSerialNo);
		BizObject pr = q.getSingleResult(false);
		String  PrjStatus = "";
		if(pr!=null)
		{
			PrjStatus = pr.getAttribute("Status").getString();
		}

		return PrjStatus;
	}
	
	/*检查项目信息的状态*/
	public String selectIsSaveProjectInfo(JBOTransaction tx) throws Exception{
		String ProjectSerialNo = (String)inputParameter.getValue("ProjectSerialNo");
		BizObjectManager table = JBOFactory.getBizObjectManager("jbo.prj.PRJ_BASIC_INFO");
		tx.join(table);

		BizObjectQuery q = table.createQuery("SerialNo=:SerialNo").setParameter("SerialNo", ProjectSerialNo);
		BizObject pr = q.getSingleResult(false);
//		String  ProductList = "";
//		if(pr!=null)
//		{
//			ProductList = pr.getAttribute("ProductList").getString();
//		}
//		if(StringX.isEmpty(ProductList)){
//			ProductList = "SUCCEED";
//		}
		
//		return ProductList;
		
		String tempSaveFlag = "";
		if(pr!=null){
			tempSaveFlag = pr.getAttribute("tempSaveFlag").getString();
		}
		
		tempSaveFlag = tempSaveFlag.equals("0")? "SUCCEED":tempSaveFlag;
		
		return tempSaveFlag;
	}
	
}
