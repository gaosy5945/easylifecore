package com.amarsoft.app.als.afterloan.action;

/**
 * 功能：分类调整申请新增和完成时对应新增记录或改变状态
 * 		吴睿
 */
import com.amarsoft.app.base.businessobject.BusinessObjectManager;
import com.amarsoft.app.base.util.DateHelper;
import com.amarsoft.are.jbo.BizObject;
import com.amarsoft.are.jbo.BizObjectManager;
import com.amarsoft.are.jbo.JBOFactory;
import com.amarsoft.are.jbo.JBOTransaction;
import com.amarsoft.are.util.json.JSONObject;

public class InsertClassifyRecord {
	
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
	
	public void insertClassifyRecord(JBOTransaction tx) throws Exception{
		BizObjectManager bm = JBOFactory.getBizObjectManager("jbo.al.CLASSIFY_RECORD");
		tx.join(bm);
		String serialNo = (String)inputParameter.getValue("SerialNo");
		String operateUserID = (String)inputParameter.getValue("OperateUserID");
		String operateOrgID = (String)inputParameter.getValue("OperateOrgID");
		String objectType = (String)inputParameter.getValue("ObjectType");
		BizObject bo = bm.newObject();
		
		bo.setAttributeValue("OBJECTNO", serialNo);
		bo.setAttributeValue("OBJECTTYPE", objectType);
		bo.setAttributeValue("CLASSIFYSTATUS", "0010");
		bo.setAttributeValue("CLASSIFYMETHOD", "01");
		bo.setAttributeValue("CLASSIFYUSERID", operateUserID);
		bo.setAttributeValue("CLASSIFYORGID", operateOrgID);
		bo.setAttributeValue("INPUTDATE", DateHelper.getBusinessDate());
		bm.saveObject(bo);
	}
	public void finishInspectRecord(JBOTransaction tx) throws Exception{
		BizObjectManager bm = JBOFactory.getBizObjectManager("jbo.al.CLASSIFY_RECORD");
		tx.join(bm);
		String serialNo = (String)inputParameter.getValue("SerialNo");
		String classifyStatus = (String)inputParameter.getValue("ClassifyStatus");
		int sStatus = Integer.parseInt(classifyStatus);
		switch(sStatus){
			case 10 : 
				bm.createQuery("UPDATE O SET CLASSIFYSTATUS = '0020' WHERE SERIALNO = :SERIALNO")
				.setParameter("SERIALNO", serialNo).executeUpdate();
				break;
			case 20 : 
				bm.createQuery("UPDATE O SET CLASSIFYSTATUS = '4' WHERE SERIALNO = :SERIALNO")
				.setParameter("SERIALNO", serialNo).executeUpdate();
				break;
			default :
				bm.createQuery("UPDATE O SET CLASSIFYSTATUS = '5' WHERE SERIALNO = :SERIALNO")
				.setParameter("SERIALNO", serialNo).executeUpdate();
				break;
		}
	}
}
