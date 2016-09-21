package com.amarsoft.app.als.project;

import java.util.List;

import com.amarsoft.app.base.businessobject.BusinessObjectManager;
import com.amarsoft.are.jbo.BizObject;
import com.amarsoft.are.jbo.BizObjectManager;
import com.amarsoft.are.jbo.BizObjectQuery;
import com.amarsoft.are.jbo.JBOFactory;
import com.amarsoft.are.jbo.JBOTransaction;
import com.amarsoft.are.util.json.JSONObject;

public class ProjectMerge {
	private JSONObject inputParameter;
	String flag = "";
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
	public String projectMerge(JBOTransaction tx) throws Exception{
		this.tx = tx;
		String projectSerialNo = (String)inputParameter.getValue("ProjectSerialNo"); 
		/*String projectSerialNoOld = (String)inputParameter.getValue("ProjectSerialNoOld"); 
		String relaBCSerialNos = (String)inputParameter.getValue("relaBCSerialNos");
		String[] BCSerialNosArray = relaBCSerialNos.split("@");*/
		String relaPRSerialNos = (String)inputParameter.getValue("relaPRSerialNos");
		String[] PRSerialNosArray = relaPRSerialNos.split("@");
		
/*		BizObjectManager selectTable = JBOFactory.getBizObjectManager("jbo.prj.PRJ_RELATIVE");
		tx.join(selectTable);
		BizObjectQuery q1 = selectTable.createQuery("ProjectSerialNo=:ProjectSerialNo and ObjectType = 'jbo.app.BUSINESS_CONTRACT'").setParameter("ProjectSerialNo", projectSerialNo);
		BizObject DataLast1 = q1.getSingleResult(false);
		
		BizObjectManager selectTable2 = JBOFactory.getBizObjectManager("jbo.prj.PRJ_RELATIVE");
		tx.join(selectTable2);
		BizObjectQuery q2 = selectTable2.createQuery("ProjectSerialNo=:ProjectSerialNo and ObjectType = 'jbo.app.BUSINESS_CONTRACT'").setParameter("ProjectSerialNo", projectSerialNoOld);
		BizObject DataLast2 = q2.getSingleResult(false);
		
		if(DataLast1 == null && DataLast2 == null){
			for(int i = 0; i < BCSerialNosArray.length; i++){
				BizObjectManager table = JBOFactory.getBizObjectManager("jbo.prj.PRJ_RELATIVE");
				tx.join(table);
				BizObjectQuery q = table.createQuery("ObjectNo=:ObjectNo and ObjectType = 'jbo.app.BUSINESS_CONTRACT'").setParameter("ObjectNo", BCSerialNosArray[i]);
				BizObject DataLast = q.getSingleResult(false);

				BizObject newData = table.newObject();
				newData.setAttributesValue(DataLast);
				newData.setAttributeValue("SerialNo", null);
				newData.setAttributeValue("ProjectSerialNo", projectSerialNo);
				table.saveObject(newData);
			}
			return "SUCCEED";*/
		for(int i = 0; i < PRSerialNosArray.length; i++){
			BizObjectManager bm = JBOFactory.getBizObjectManager("jbo.prj.PRJ_RELATIVE");
			tx.join(bm);
			
			bm.createQuery("update O set ProjectSerialNo=:ProjectSerialNo Where SerialNo=:SerialNo and ObjectType='jbo.app.BUSINESS_CONTRACT' and RelativeType='02'")
			  .setParameter("ProjectSerialNo", projectSerialNo).setParameter("SerialNo", PRSerialNosArray[i]).executeUpdate();
		}
		return "SUCCEED";

	}
}
