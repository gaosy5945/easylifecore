package com.amarsoft.app.als.customer.action;

/**
 * @柳显涛
 * 客户名单提交逻辑类
 */
import java.sql.SQLException;
import java.util.HashMap;
import java.util.List;

import com.amarsoft.app.base.businessobject.BusinessObject;
import com.amarsoft.app.base.businessobject.BusinessObjectManager;
import com.amarsoft.are.jbo.BizObject;
import com.amarsoft.are.jbo.BizObjectManager;
import com.amarsoft.are.jbo.JBOException;
import com.amarsoft.are.jbo.JBOFactory;
import com.amarsoft.are.jbo.JBOTransaction;
import com.amarsoft.are.util.json.JSONObject;

public class ImportTodoList {
	private JSONObject inputParameter;
	private HashMap<String , Object> data;

	private BusinessObjectManager businessObjectManager;
	
	public void setInputParameter(JSONObject inputParameter) {
		this.inputParameter = inputParameter;
	}
	
	public void setData(HashMap<String , Object> map){
		this.data = map;
	}
	
	private JBOTransaction tx;

	public void setTx(JBOTransaction tx) {
		this.tx = tx;
	}
	
	private BusinessObjectManager getBusinessObjectManager() throws JBOException, SQLException{
		if(businessObjectManager==null)
			businessObjectManager = BusinessObjectManager.createBusinessObjectManager(tx);
		return businessObjectManager;
	}
	
	public void setBusinessObjectManager(BusinessObjectManager businessObjectManager) {
		this.businessObjectManager = businessObjectManager;
		this.tx = businessObjectManager.getTx();
	}
	

	public String importCancelTodoList(JBOTransaction tx) throws Exception{
		
		String objectType = (String)inputParameter.getValue("ObjectType");
		String serialNos = (String)inputParameter.getValue("ObjectNo");
		String todoType = (String)inputParameter.getValue("TodoType");
		String status = (String)inputParameter.getValue("Status");
		String phaseOpinion = (String)inputParameter.getValue("PhaseOpinion");
		String memo = (String)inputParameter.getValue("Memo");
		String operateOrgID = (String)inputParameter.getValue("OperateOrgID");
		String operateUserID = (String)inputParameter.getValue("OperateUserID");
		String inputDate = (String)inputParameter.getValue("InputDate");
		String inputOrgID = (String)inputParameter.getValue("InputOrgID");
		String inputUserID = (String)inputParameter.getValue("InputUserID");
		String[] serialNosArray = serialNos.split("@");
		for(int i = 0; i < serialNosArray.length; i++){
			this.businessObjectManager=this.getBusinessObjectManager();
			List<BusinessObject> checkList = this.businessObjectManager.loadBusinessObjects("jbo.app.PUB_TODO_LIST", "traceObjectType = :traceObjectType and traceObjectNo = :traceObjectNo and status = :status", "traceObjectType",objectType,"traceObjectNo",serialNosArray[i],"status",status);
			if(checkList == null || checkList.isEmpty()){
				BizObjectManager bm = JBOFactory.getBizObjectManager("jbo.app.PUB_TODO_LIST");
				tx.join(bm);
	
				BizObject bo = bm.newObject();
		
				bo.setAttributeValue("TRACEOBJECTTYPE", objectType);
				bo.setAttributeValue("TRACEOBJECTNO", serialNosArray[i]);
				bo.setAttributeValue("TODOTYPE", todoType);
				bo.setAttributeValue("STATUS", status);
				bo.setAttributeValue("PHASEOPINION", phaseOpinion);
				bo.setAttributeValue("MEMO", memo);
				bo.setAttributeValue("OPERATEORGID", operateOrgID);
				bo.setAttributeValue("OPERATEUSERID", operateUserID);
				bo.setAttributeValue("INPUTDATE", inputDate);
				bo.setAttributeValue("INPUTORGID", inputOrgID);
				bo.setAttributeValue("INPUTUSERID", inputUserID);
				
				bm.saveObject(bo);
			}
		}
		return "SUCCEED";
	}
	
}
