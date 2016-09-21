package com.amarsoft.app.als.credit.approve.action;

import com.amarsoft.app.base.businessobject.BusinessObjectManager;
import com.amarsoft.are.jbo.BizObject;
import com.amarsoft.are.jbo.BizObjectManager;
import com.amarsoft.are.jbo.JBOFactory;
import com.amarsoft.are.jbo.JBOTransaction;
import com.amarsoft.are.util.json.JSONObject;

/**
 * author��������
 * ˵������������ύ��
 */


public class UpdateCLAndTodoStatus {
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
	public String updateCLAndTodoStatus(JBOTransaction tx) throws Exception{
		this.tx = tx;
		String serialNo = (String)inputParameter.getValue("SerialNo");
		String TodoStatus = (String)inputParameter.getValue("TodoStatus");
		String CLStatus = (String)inputParameter.getValue("CLStatus");
		String CLSerialNo = (String)inputParameter.getValue("CLSerialNo");
		String COSerialNo = (String)inputParameter.getValue("COSerialNo");
		String sReturnTodo = updateTodoStatus(serialNo);
		if("SUCCEED".equals(sReturnTodo)){
			String sReturnCL = updateCLStatus(serialNo,TodoStatus,CLStatus,CLSerialNo);
			String[] CLStatusNew = sReturnCL.split("@");
			updateCOStatus(COSerialNo,CLStatusNew[1]);
			return CLStatusNew[0];
		}else{
			return "FALSE";
		}
	}
	//��ͣ���롢�ָ����롢��ֹ���봥���¼�ִ�з���������pub_todo_list��TodoStatus
	public String updateTodoStatus(String serialNo) throws Exception{
		BizObjectManager bm = JBOFactory.getBizObjectManager("jbo.app.PUB_TODO_LIST");
		tx.join(bm);
		
		bm.createQuery("update O set Status=:Status Where SerialNo=:SerialNo")
		  .setParameter("Status","02").setParameter("SerialNo", serialNo).executeUpdate();
		return "SUCCEED";
		
	}
	//�ڸ�����pub_todo_list֮�󣬸��������������CL_INFO���еĶ��״̬�����̽���
	public String updateCLStatus(String serialNo,String TodoStatus,String CLStatus,String CLSerialNo) throws Exception{
		BizObjectManager bm = JBOFactory.getBizObjectManager("jbo.cl.CL_INFO");
		tx.join(bm);
		if("01".equals(TodoStatus)){//����ͬ��
			if("1".equals(CLStatus)){
				CLStatus = "30";
			}else if("2".equals(CLStatus)){
				CLStatus = "20";
			}else{
				CLStatus = "50";
			}
			bm.createQuery("update O set Status=:Status Where SerialNo=:SerialNo")
			 .setParameter("Status",CLStatus).setParameter("SerialNo", CLSerialNo).executeUpdate();
			return "SUCCEED@"+CLStatus;
		}else{
			if("1".equals(CLStatus)){
				CLStatus = "30";
			}else if("2".equals(CLStatus)){
				CLStatus = "20";
			}else{
				CLStatus = "50";
			}
			return "REFUSED@"+CLStatus;
		}
	}
	//������CL_OPERATE���еı����״̬
	public String updateCOStatus(String COSerialNo,String CLStatusNew) throws Exception{
		BizObjectManager bm = JBOFactory.getBizObjectManager("jbo.cl.CL_OPERATE");
		tx.join(bm);
		
		bm.createQuery("update O set OperationStatus=:OperationStatus Where SerialNo=:SerialNo")
		 .setParameter("OperationStatus",CLStatusNew).setParameter("SerialNo", COSerialNo).executeUpdate();
		
		return "SUCCEED";
	}
}
