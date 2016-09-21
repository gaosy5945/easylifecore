package com.amarsoft.app.urge;
import com.amarsoft.are.jbo.BizObject;
import com.amarsoft.are.jbo.BizObjectManager;
import com.amarsoft.are.jbo.BizObjectQuery;
import com.amarsoft.are.jbo.JBOException;
import com.amarsoft.are.jbo.JBOFactory;
import com.amarsoft.are.jbo.JBOTransaction;
import com.amarsoft.are.util.json.JSONObject;


public class CollSelectTel {
	//参数
	private JSONObject inputParameter;
	
	public void setInputParameter(JSONObject inputParameter) {
		this.inputParameter = inputParameter;
	}
	public String CheckTelphone(JBOTransaction tx){
		String sCustomerID = (String)inputParameter.getValue("CustomerID");
		String sContactorType = (String)inputParameter.getValue("ContactorType");
		//查询是否存在当前任务批次号
		String IsHaveFlag="no";
		BizObjectManager bmcl;
		try {
			bmcl = JBOFactory.getBizObjectManager("jbo.customer.COLL_CUSTOMER_TEL");
			BizObjectQuery boqcl = bmcl.createQuery("O.CUSTOMERID=:CUSTOMERID AND O.RELATIONSHIP=:RELATIONSHIP AND O.ISNEW='1' ");
			boqcl.setParameter("CUSTOMERID", sCustomerID);
			boqcl.setParameter("RELATIONSHIP", sContactorType);
			BizObject bocl = boqcl.getSingleResult(false);
			if(bocl!=null)
			{
				IsHaveFlag="yes";
			}else{
				IsHaveFlag="no";
			}
		} catch (JBOException e) {
			e.printStackTrace();
		}
		return IsHaveFlag;
	}
	
		
}	




