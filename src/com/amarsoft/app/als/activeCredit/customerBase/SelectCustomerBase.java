package com.amarsoft.app.als.activeCredit.customerBase;

import java.util.List;

import com.amarsoft.app.base.businessobject.BusinessObjectManager;
import com.amarsoft.are.jbo.BizObject;
import com.amarsoft.are.jbo.BizObjectManager;
import com.amarsoft.are.jbo.BizObjectQuery;
import com.amarsoft.are.jbo.JBOFactory;
import com.amarsoft.are.jbo.JBOTransaction;
import com.amarsoft.are.util.json.JSONObject;

public class SelectCustomerBase {
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
	public String selectCustomerBaseDocNo(JBOTransaction tx) throws Exception{
		String CustomerBaseID = (String)inputParameter.getValue("CustomerBaseID");
		BizObjectManager table = JBOFactory.getBizObjectManager("jbo.doc.DOC_RELATIVE");
		tx.join(table);

		BizObjectQuery q = table.createQuery("ObjectNo=:CustomerBaseID and ObjectType=:ObjectType")
				.setParameter("CustomerBaseID", CustomerBaseID).setParameter("ObjectType", "jbo.customer.CUSTOMER_BASE");
		BizObject pr = q.getSingleResult(false);
		String  DocNo = "";
		if(pr!=null)
		{
			DocNo = pr.getAttribute("DocNo").getString();
		}

		return DocNo;
	}
	public String selectDocs(JBOTransaction tx) throws Exception{
		String DocNo = (String)inputParameter.getValue("DocNo");
		BizObjectManager table = JBOFactory.getBizObjectManager("jbo.doc.DOC_ATTACHMENT");
		tx.join(table);

		BizObjectQuery q = table.createQuery("DocNo=:DocNo").setParameter("DocNo", DocNo);
		List<BizObject> DataLast = q.getResultList(false);
		int i = 0;
		String flag = "One";
		if(DataLast!=null){
			for(BizObject bo:DataLast){
				i = i + 1;
			}
		}
		if(i>0){
			flag = "More";
		}
		
		return flag;
	}
	public String selectCustomerBaseName(JBOTransaction tx) throws Exception{
		String CustomerBaseName = (String)inputParameter.getValue("CustomerBaseName");
		BizObjectManager table = JBOFactory.getBizObjectManager("jbo.customer.CUSTOMER_BASE");
		tx.join(table);
		
		BizObjectQuery q = table.createQuery("CustomerBaseName=:CustomerBaseName").setParameter("CustomerBaseName", CustomerBaseName);
		BizObject pr = q.getSingleResult(false);
		String  flag = "";
		if(pr!=null)
		{
			flag = "Exists";
		}
		return flag;
	}
	public String selectCustomerBaseType(JBOTransaction tx) throws Exception{
		String CustomerBaseID = (String)inputParameter.getValue("CustomerBaseID");
		BizObjectManager table = JBOFactory.getBizObjectManager("jbo.customer.CUSTOMER_BASE");
		tx.join(table);
		
		BizObjectQuery q = table.createQuery("CustomerBaseID=:CustomerBaseID").setParameter("CustomerBaseID", CustomerBaseID);
		BizObject pr = q.getSingleResult(false);
		String  CustomerBaseType = "";
		if(pr!=null)
		{
			CustomerBaseType = pr.getAttribute("CustomerBaseType").getString();
		}
		return CustomerBaseType;
	}
	public String selectCustomerApproval(JBOTransaction tx) throws Exception{
		
		String CustomerBaseID = (String)inputParameter.getValue("CustomerBaseID");
		BizObjectManager table = JBOFactory.getBizObjectManager("jbo.customer.CUSTOMER_APPROVAL");
		tx.join(table);
		
		BizObjectQuery q = table.createQuery("CustomerBaseID=:CustomerBaseID").setParameter("CustomerBaseID", CustomerBaseID);
		List<BizObject> DataLast = q.getResultList(false);
		String flag = "";
		if(DataLast!=null){
			for(BizObject bo:DataLast){
				flag = "1";
			}
		}
		
		return flag;
	}
}
