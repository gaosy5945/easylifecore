package com.amarsoft.app.als.project;

import java.util.List;

import com.amarsoft.app.base.businessobject.BusinessObjectManager;
import com.amarsoft.are.jbo.BizObject;
import com.amarsoft.are.jbo.BizObjectManager;
import com.amarsoft.are.jbo.BizObjectQuery;
import com.amarsoft.are.jbo.JBOFactory;
import com.amarsoft.are.jbo.JBOTransaction;
import com.amarsoft.are.util.json.JSONObject;

public class SelectBuildingData {

	private JSONObject inputParameter;
	private BusinessObjectManager businessObjectManager;
	private Double Temp = 0.00;
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
	public String selectBusinessSum(JBOTransaction tx) throws Exception{
		String ProjectSerialNo = (String)inputParameter.getValue("ProjectSerialNo");
		BizObjectManager table = JBOFactory.getBizObjectManager("jbo.prj.PRJ_RELATIVE");
		tx.join(table);
		
		BizObjectQuery q = table.createQuery("ProjectSerialNo=:ProjectSerialNo and RelativeType=:RelativeType and ObjectType=:ObjectType")
				.setParameter("ProjectSerialNo", ProjectSerialNo).setParameter("RelativeType", "02").setParameter("ObjectType", "jbo.app.BUSINESS_CONTRACT");
		List<BizObject> DataLast = q.getResultList(false);

		if(DataLast!=null){
		for(BizObject bo:DataLast){
			String ObjectNo = bo.getAttribute("ObjectNo").getString();
			BizObjectManager table2 = JBOFactory.getBizObjectManager("jbo.app.BUSINESS_DUEBILL");
			tx.join(table2);
			
				BizObjectQuery q2 = table2.createQuery("ContractSerialNo=:ContractSerialNo").setParameter("ContractSerialNo", ObjectNo);
				BizObject pr2 = q2.getSingleResult(false);
				if(pr2!=null)
				{
					Double BusinessSum = pr2.getAttribute("BusinessSum").getDouble();
					Temp += BusinessSum;
				}
			}
		}
		String BS = String.valueOf(Temp);
		return BS;
	}
}
