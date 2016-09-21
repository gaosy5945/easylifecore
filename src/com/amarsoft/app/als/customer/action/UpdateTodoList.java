package com.amarsoft.app.als.customer.action;

/**
 * @柳显涛
 * 客户名单复核提交逻辑类
 */

import java.sql.SQLException;
import java.util.List;

import com.amarsoft.app.base.businessobject.BusinessObject;
import com.amarsoft.app.base.businessobject.BusinessObjectManager;
import com.amarsoft.app.base.util.DateHelper;
import com.amarsoft.are.jbo.BizObjectManager;
import com.amarsoft.are.jbo.JBOException;
import com.amarsoft.are.jbo.JBOFactory;
import com.amarsoft.are.jbo.JBOTransaction;
import com.amarsoft.are.util.json.JSONObject;

public class UpdateTodoList {
	private JSONObject inputParameter;
	private String statusFlag="";
	private String traceObjectNo="";
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
	
	private BusinessObjectManager getBusinessObjectManager() throws JBOException, SQLException{
		if(businessObjectManager==null)
			businessObjectManager = BusinessObjectManager.createBusinessObjectManager(tx);
		return businessObjectManager;
	}
	
	public String updatePhaseAction(JBOTransaction tx) throws Exception{
		BizObjectManager bm = JBOFactory.getBizObjectManager("jbo.app.PUB_TODO_LIST");
		tx.join(bm);
		String todoType = (String)inputParameter.getValue("TodoType");
		String status = (String)inputParameter.getValue("Status");
		String serialNo = (String)inputParameter.getValue("SerialNo");
		BusinessObjectManager bomanager = this.getBusinessObjectManager();
		List<BusinessObject> list = bomanager.loadBusinessObjects("jbo.app.PUB_TODO_LIST", "TraceObjectNo=:traceObjectNo", "traceObjectNo",serialNo);
		statusFlag = list.get(0).getString("STATUS");
		if("01".equals(statusFlag)){
			return "FAILED";
		}else{
			bm.createQuery("update O set TODOTYPE=:TodoType, STATUS=:Status Where TRACEOBJECTNO=:serialNo")
			  .setParameter("TodoType",todoType).setParameter("Status", status).setParameter("serialNo", serialNo)
			  .executeUpdate();
			return "SUCCEED";
		}
	}
	
	public String updateTodoList(JBOTransaction tx) throws Exception{
		BizObjectManager bm = JBOFactory.getBizObjectManager("jbo.app.PUB_TODO_LIST");
		tx.join(bm);
		String Status = "02";
		String serialNos = (String)inputParameter.getValue("serialNos");
		String phaseActionType = (String)inputParameter.getValue("phaseActionType");
		String TodoTypes = (String)inputParameter.getValue("relaTodoTypes");
		String[] serialNosArray = serialNos.split("@");
		String[] TodoTypesArray = TodoTypes.split("@");
		if("01".equals(phaseActionType)){//如果审核意见为同意，当任务类型为特殊客户新增时，则更新使用状态为“正常”，当任务类型为特殊客户取消时，则更新使用状态为“停用”，失效时间为获取时间
			for(int i = 0; i < serialNosArray.length; i++){
				bm.createQuery("update O set STATUS=:Status, PHASEACTIONTYPE=:phaseActionType Where serialNo=:serialNo")
					.setParameter("Status",Status).setParameter("phaseActionType", phaseActionType).setParameter("serialNo", serialNosArray[i])
					.executeUpdate();
					String serialNo = selectCustomerListSerialNo(serialNosArray[i]);
					updateUseFlag(tx, serialNo, TodoTypesArray[i]);
			}
				return "SUCCEED";
		}else{//否则，不更新使用状态
			for(int i = 0; i < serialNosArray.length; i++){
					bm.createQuery("update O set STATUS=:Status, PHASEACTIONTYPE=:phaseActionType Where serialNo=:serialNo")
					  .setParameter("Status",Status).setParameter("phaseActionType", phaseActionType).setParameter("serialNo", serialNosArray[i])
					  .executeUpdate();
				}
				return "SUCCEED";
		}
	}
	//通过pub_todo_list的serialNo查询来traceObjectNo
	public String selectCustomerListSerialNo(String serialNosArray) throws Exception{
		BusinessObjectManager bomanager = this.getBusinessObjectManager();
		List<BusinessObject> list = bomanager.loadBusinessObjects("jbo.app.PUB_TODO_LIST", "SerialNo=:serialNo", "serialNo",serialNosArray);
		traceObjectNo = list.get(0).getString("TRACEOBJECTNO");
		return traceObjectNo;
	}
	//根据任务类型不同，更新customer_list的使用状态和失效时间
	public void updateUseFlag(JBOTransaction tx,String serialNo,String TodoTypesArray) throws Exception{
		BizObjectManager bm = JBOFactory.getBizObjectManager("jbo.customer.CUSTOMER_LIST");
		tx.join(bm);
		String statusNormal = "1";
		String statusUnUse = "2";
		if("03".equals(TodoTypesArray)){
			bm.createQuery("update O set STATUS=:Status Where serialNo=:serialNo")
				.setParameter("Status", statusNormal).setParameter("serialNo", serialNo).executeUpdate();
		}else{
			bm.createQuery("update O set STATUS=:Status,ENDDATE=:EndDate Where serialNo=:serialNo")
				.setParameter("Status", statusUnUse).setParameter("EndDate", DateHelper.getBusinessDate()).setParameter("serialNo", serialNo).executeUpdate();
		}
	}
}
