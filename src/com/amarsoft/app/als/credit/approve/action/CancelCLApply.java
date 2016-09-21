package com.amarsoft.app.als.credit.approve.action;

import java.sql.SQLException;
import java.util.List;

import com.amarsoft.app.base.businessobject.BusinessObject;
import com.amarsoft.app.base.businessobject.BusinessObjectManager;
import com.amarsoft.app.als.customer.model.CustomerConst;
import com.amarsoft.are.jbo.JBOException;
import com.amarsoft.are.jbo.JBOTransaction;
import com.amarsoft.are.util.json.JSONObject;

public class CancelCLApply {
	private JSONObject inputParameter;

	private BusinessObjectManager businessObjectManager;
	
	public void setInputParameter(JSONObject inputParameter) {
		this.inputParameter = inputParameter;
	}
	
	public void setInputParameter(String key,Object value) {
		if(this.inputParameter == null)
			inputParameter = JSONObject.createObject();
		com.amarsoft.are.lang.Element a = new com.amarsoft.are.util.json.JSONElement(key);
		a.setValue(value);
		inputParameter.add(a);
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
	
	public String cancelCLApply(JBOTransaction tx) throws Exception{
		this.tx = tx;
		String CLSerialNo = (String)inputParameter.getValue("CLSerialNo");
		
		String result = selectTodoSerialNo(CLSerialNo);
		String COSerialNo = result.split("@")[0]; 
		String TodoSerialNo = result.split("@")[1];
		deleteCO(COSerialNo);
		deleteTodo(TodoSerialNo);
		return "SUCCEED";
	}
	
	public String selectTodoSerialNo(String CLSerialNo) throws Exception{
		BusinessObjectManager bomanager = this.getBusinessObjectManager();
		List<BusinessObject> listCO = bomanager.loadBusinessObjects("jbo.cl.CL_OPERATE", "OperationStatus is null and CLSerialNo=:CLSerialNo", "CLSerialNo",CLSerialNo);
		String COSerialNo = listCO.get(0).getString("SERIALNO");
		
		List<BusinessObject> listTodo = bomanager.loadBusinessObjects("jbo.app.PUB_TODO_LIST", "TraceObjectNo=:TraceObjectNo and TraceObjectType='jbo.cl.CL_OPERATE'", "TraceObjectNo",COSerialNo);
		String TodoSerialNo = listTodo.get(0).getString("SERIALNO");
		
		return COSerialNo+"@"+TodoSerialNo;
		
	}
	
	public void deleteCO(String COSerialNo) throws Exception{
		BusinessObjectManager bomanager = this.getBusinessObjectManager();
		List<BusinessObject> bo = bomanager.loadBusinessObjects("jbo.cl.CL_OPERATE", "SerialNo = :SerialNo", "SerialNo",COSerialNo);
		bomanager.deleteBusinessObjects(bo);

		bomanager.updateDB();
		
	}
	
	public void deleteTodo(String TodoSerialNo) throws Exception{
		BusinessObjectManager bomanager = this.getBusinessObjectManager();
		List<BusinessObject> bo = bomanager.loadBusinessObjects("jbo.app.PUB_TODO_LIST", "SerialNo = :SerialNo", "SerialNo",TodoSerialNo);
		bomanager.deleteBusinessObjects(bo);

		bomanager.updateDB();
	}
}
