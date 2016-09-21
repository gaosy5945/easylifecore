package com.amarsoft.app.als.project;

import java.sql.SQLException;
import java.util.List;

import com.amarsoft.app.base.businessobject.BusinessObject;
import com.amarsoft.app.base.businessobject.BusinessObjectManager;
import com.amarsoft.are.jbo.BizObject;
import com.amarsoft.are.jbo.BizObjectManager;
import com.amarsoft.are.jbo.BizObjectQuery;
import com.amarsoft.are.jbo.JBOException;
import com.amarsoft.are.jbo.JBOFactory;
import com.amarsoft.are.jbo.JBOTransaction;
import com.amarsoft.are.lang.StringX;
import com.amarsoft.are.util.json.JSONObject;

public class SelectMarginInfo {
	private JSONObject inputParameter;
	private BusinessObjectManager businessObjectManager;
	private String AccountNo;
	private String MarginSerialNo;
	
	
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
	
	private BusinessObjectManager getBusinessObjectManager() throws JBOException, SQLException{
		if(businessObjectManager==null)
			businessObjectManager = BusinessObjectManager.createBusinessObjectManager(tx);
		return businessObjectManager;
	}
	public String selectMarginInfo(JBOTransaction tx) throws Exception{
		this.tx=tx;
		String ProjectSerialNo = (String)inputParameter.getValue("ProjectSerialNo");
		BizObjectManager table = JBOFactory.getBizObjectManager("jbo.guaranty.CLR_MARGIN_INFO");
		tx.join(table);

		BizObjectQuery q = table.createQuery("ObjectNo=:ObjectNo and ObjectType=:ObjectType")
				.setParameter("ObjectNo", ProjectSerialNo).setParameter("ObjectType", "jbo.prj.PRJ_BASIC_INFO");
		BizObject pr = q.getSingleResult(false);
		if(pr!=null)
		{
			MarginSerialNo = pr.getAttribute("SerialNo").getString();
			
			BizObjectManager table1 = JBOFactory.getBizObjectManager("jbo.acct.ACCT_BUSINESS_ACCOUNT");
			tx.join(table1);

			BizObjectQuery q1 = table1.createQuery("ObjectNo=:ObjectNo and ObjectType=:ObjectType")
					.setParameter("ObjectNo", MarginSerialNo).setParameter("ObjectType", "jbo.guaranty.CLR_MARGIN_INFO");
			BizObject pr1 = q1.getSingleResult(false);
			if(pr1!=null)
			{
				AccountNo = pr1.getAttribute("AccountNo").getString();
			}
			return MarginSerialNo+"@"+AccountNo;
		}else{
			return "MarginEmpty@";
		}

	}
	public String selectMarginSerialNo(JBOTransaction tx) throws Exception{
		this.tx=tx;
		String SerialNo = (String)inputParameter.getValue("MarginSerialNo");
		BizObjectManager table = JBOFactory.getBizObjectManager("jbo.guaranty.CLR_MARGIN_INFO");
		tx.join(table);

		BizObjectQuery q = table.createQuery("SerialNo=:SerialNo").setParameter("SerialNo", SerialNo);
		BizObject pr = q.getSingleResult(false);
		String flag = "1";
		if(pr!=null){
			flag = "2";
		}
		return flag;
	}
}
