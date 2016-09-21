package com.amarsoft.app.als.customer.action;

import java.util.List;

import com.amarsoft.app.base.businessobject.BusinessObjectManager;
import com.amarsoft.are.jbo.BizObject;
import com.amarsoft.are.jbo.BizObjectManager;
import com.amarsoft.are.jbo.BizObjectQuery;
import com.amarsoft.are.jbo.JBOFactory;
import com.amarsoft.are.jbo.JBOTransaction;
import com.amarsoft.are.util.json.JSONObject;

public class JudgeIncomeType {
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
	public String judgeIncomeType(JBOTransaction tx) throws Exception{
		String CustomerID = (String)inputParameter.getValue("CustomerID");
		String financialItem = (String)inputParameter.getValue("FinancialItem");
		BizObjectManager table = JBOFactory.getBizObjectManager("jbo.customer.CUSTOMER_FINANCE");
		tx.join(table);
		
		BizObjectQuery q = table.createQuery("CustomerID=:CustomerID and FinancialItem=:FinancialItem")
				.setParameter("CustomerID", CustomerID).setParameter("FinancialItem", financialItem);
		BizObject pr = q.getSingleResult(false);
		
		String financialItemName = codeToCHNName(financialItem,"FinancialItem",tx);
		
		if(pr!=null){
			return "Full@"+financialItemName;
		}else{
			return "Empty@";
		}
		
	}
	
	//根据代码值转换为相应的中文
	public static String codeToCHNName(String itemNo, String codeNo, JBOTransaction tx) throws Exception{
		
		BizObjectManager bm = JBOFactory.getBizObjectManager("jbo.sys.CODE_LIBRARY");
		tx.join(bm);
		BizObject bo = bm.createQuery("ItemNo=:ItemNo and CodeNo=:CodeNo").setParameter("ItemNo", itemNo).setParameter("CodeNo", codeNo).getSingleResult(true);
		String CHNName = "";
		
		try{
			CHNName = bo.getAttribute("ITEMNAME").getString();
		}catch(IndexOutOfBoundsException e){
			e.printStackTrace();
		}
		
		return CHNName;
	}
	
	public String judgeIncomeExists(String customerID,JBOTransaction tx) throws Exception{
		BizObjectManager table = JBOFactory.getBizObjectManager("jbo.customer.CUSTOMER_FINANCE");
		tx.join(table);
		
		BizObjectQuery q = table.createQuery("CustomerID=:CustomerID and FinancialItem like '30%' and FinancialItem <> '30'")
				.setParameter("CustomerID", customerID);
		List<BizObject> DataLast = q.getResultList(false);
		
		if(DataLast!=null && !DataLast.isEmpty()){
			int i = 0;
			for(BizObject bo:DataLast){
				i=i+1;
			}
			if(i < 5){
				return "notFull";
			}else{
				return "Full";
			}
		}else{
			return "Empty";
		}
		
	}
	
	
}
