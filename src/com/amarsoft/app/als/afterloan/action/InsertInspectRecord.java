package com.amarsoft.app.als.afterloan.action;

/**
 * 功能：贷后检查新增和完成时对应新增记录或改变状态
 * 		张万亮
 */
import com.amarsoft.app.base.businessobject.BusinessObjectManager;
import com.amarsoft.app.base.util.DateHelper;
import com.amarsoft.are.jbo.BizObject;
import com.amarsoft.are.jbo.BizObjectManager;
import com.amarsoft.are.jbo.JBOFactory;
import com.amarsoft.are.jbo.JBOTransaction;
import com.amarsoft.are.util.StringFunction;
import com.amarsoft.are.util.json.JSONObject;

public class InsertInspectRecord {
	
	private JSONObject inputParameter;

	private BusinessObjectManager businessObjectManager;
	
	public void setInputParameter(JSONObject inputParameter){
		this.inputParameter = inputParameter;
	}
	
	private JBOTransaction tx;

	public void setTx(JBOTransaction tx){
		this.tx = tx;
	}
	
	public void setBusinessObjectManager(BusinessObjectManager businessObjectManager){
		this.businessObjectManager = businessObjectManager;
		this.tx = businessObjectManager.getTx();
	}
	
	public void insertInspectRecord(JBOTransaction tx) throws Exception{
		BizObjectManager bm = JBOFactory.getBizObjectManager("jbo.al.INSPECT_RECORD");
		tx.join(bm);
		String serialNo = (String)inputParameter.getValue("SerialNo");
		String inspectType = (String)inputParameter.getValue("InspectType");
		String operateUserID = (String)inputParameter.getValue("OperateUserID");
		String operateOrgID = (String)inputParameter.getValue("OperateOrgID");
		String objectType = (String)inputParameter.getValue("ObjectType");
		BizObject bo = bm.newObject();
		
		bo.setAttributeValue("OBJECTNO", serialNo);
		bo.setAttributeValue("OBJECTTYPE", objectType);
		bo.setAttributeValue("INSPECTTYPE", inspectType);
		bo.setAttributeValue("STATUS", "1");
		bo.setAttributeValue("CREATETYPE", "3");
		bo.setAttributeValue("OPERATEUSERID", operateUserID);
		bo.setAttributeValue("OPERATEORGID", operateOrgID);
		bo.setAttributeValue("INPUTDATE", DateHelper.getBusinessDate());
		bm.saveObject(bo);
	}
	public void finishInspectRecord(JBOTransaction tx) throws Exception{
		BizObjectManager bm = JBOFactory.getBizObjectManager("jbo.al.INSPECT_RECORD");
		tx.join(bm);
		String serialNo = (String)inputParameter.getValue("SerialNo");
		String status = (String)inputParameter.getValue("Status");
		int sStatus = Integer.parseInt(status);
		switch(sStatus){
			case 1 : 
				bm.createQuery("UPDATE O SET STATUS = '3',UPDATEDATE='"+StringFunction.getToday()+"',OPERATEDATE='"+StringFunction.getToday()+"' WHERE SERIALNO = :SERIALNO")
				.setParameter("SERIALNO", serialNo).executeUpdate();
				break;
			case 2 : 
				bm.createQuery("UPDATE O SET STATUS = '4',UPDATEDATE='"+StringFunction.getToday()+"',OPERATEDATE='"+StringFunction.getToday()+"' WHERE SERIALNO = :SERIALNO")
				.setParameter("SERIALNO", serialNo).executeUpdate();
				break;
			default :
				bm.createQuery("UPDATE O SET STATUS = '5',UPDATEDATE='"+StringFunction.getToday()+"' WHERE SERIALNO = :SERIALNO")
				.setParameter("SERIALNO", serialNo).executeUpdate();
				break;
		}
	}
}
