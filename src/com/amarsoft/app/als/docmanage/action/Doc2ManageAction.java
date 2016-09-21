package com.amarsoft.app.als.docmanage.action;


import com.amarsoft.app.base.businessobject.BusinessObject;
import com.amarsoft.app.base.businessobject.BusinessObjectManager;
import com.amarsoft.app.base.util.DateHelper;
import com.amarsoft.are.jbo.BizObject;
import com.amarsoft.are.jbo.BizObjectManager;
import com.amarsoft.are.jbo.BizObjectQuery;
import com.amarsoft.are.jbo.JBOException;
import com.amarsoft.are.jbo.JBOFactory;
import com.amarsoft.are.jbo.JBOTransaction;
import com.amarsoft.awe.audit.DBHandler;
import com.amarsoft.awe.util.DBKeyHelp;

/**
 * ������������
 * @author t-zhaoxj
 *
 */
public class Doc2ManageAction {
	
	private String serialNo; 
	private String status;
	private String transactionCode;
	private String userID;
	private String orgID;
	
	
	
	public String getSerialNo() {
		return serialNo;
	}


	public void setSerialNo(String serialNo) {
		this.serialNo = serialNo;
	}


	public String getStatus() {
		return status;
	}


	public void setStatus(String status) {
		this.status = status;
	}


	public String getTransactionCode() {
		return transactionCode;
	}


	public void setTransactionCode(String transactionCode) {
		this.transactionCode = transactionCode;
	}


	public String getUserID() {
		return userID;
	}


	public void setUserID(String userID) {
		this.userID = userID;
	}


	public String getOrgID() {
		return orgID;
	}


	public void setOrgID(String orgID) {
		this.orgID = orgID;
	}


	/**
	 * ���������ύ
	 * @param tx
	 * @return
	 * @throws Exception
	 */
	public String commit(JBOTransaction tx) throws Exception{
		BusinessObjectManager bom = BusinessObjectManager.createBusinessObjectManager(tx);
		BusinessObject dobo = bom.keyLoadBusinessObject("jbo.doc.DOC_OPERATION", this.serialNo);
		BusinessObject dfpbo = bom.keyLoadBusinessObject("jbo.doc.DOC_FILE_PACKAGE", dobo.getString("ObjectNo"));
		//Ԥ�鵵�ύ
		if("0000".equals(transactionCode) && "01".equals(status))
		{
			dobo.setAttributeValue("Status", "03");
			dfpbo.setAttributeValue("Status", "02");
		}//��������ύ �� �����½���⡢������⡢�黹���
		else if("0010".equals(transactionCode) 
				|| "0015".equals(transactionCode)
				|| "0040".equals(transactionCode))
		{
			dobo.setAttributeValue("Status", "03");
			dfpbo.setAttributeValue("Status", "03");
		}//���������ύ �� ���ⷽʽΪ��������ʱ
		else if("0020".equals(transactionCode)||"0030".equals(transactionCode))
		{
			//��ȡtaskSerialno
			String sTaskSerialNO = DBKeyHelp.getSerialNo("PUB_TASK_INFO","SerialNo");
			if("".equals(dobo.getString("TASKSERIALNO"))){
				dobo.setAttributeValue("TASKSERIALNO", sTaskSerialNO);
			} 
			dobo.setAttributeValue("Status", "02");
		}
		
		bom.updateBusinessObject(dobo);
		bom.updateBusinessObject(dfpbo);
		bom.updateDB();	 
		
		if("0015".equals(transactionCode) || "0015"==transactionCode){
			//��֮ǰ��DO��Ϣ���ó�1000״̬���������б���ʾ����
			BizObjectManager bomdo = JBOFactory.getBizObjectManager("jbo.doc.DOC_OPERATION");
			tx.join(bomdo);
			BizObjectQuery bqdo = bomdo.createQuery("update O set STATUS=:STATUS  where ObjectNo=:ObjectNo and ObjectType=:ObjectType and serialno <> :SerialNo ");
			bqdo.setParameter("STATUS","1000").setParameter("ObjectNo" , dfpbo.getAttribute("SerialNo").getString())
				.setParameter("ObjectType", "jbo.doc.DOC_FILE_PACKAGE").setParameter("SerialNo", dobo.getAttribute("SerialNo").getString()).executeUpdate();
		}
		
		return "�ύ�ɹ���";  
		
	}
	
	/**
	 * ��������Ǽ�δ�ύʱ��do_operation����һ���µ�����
	 * @param tx
	 * @return
	 * @throws Exception
	 */
	public String createDo(JBOTransaction tx) throws Exception{
		BizObjectManager bomdo = JBOFactory.getBizObjectManager("jbo.doc.DOC_OPERATION");
		tx.join(bomdo);
		BizObject bo = bomdo.newObject();
		
		bo.setAttributeValue("InputUserID",userID);
		bo.setAttributeValue("InputOrgID", orgID);
		bo.setAttributeValue("InputDate",DateHelper.getBusinessDate());
		bo.setAttributeValue("UpdateUserID",userID);
		bo.setAttributeValue("UpdateOrgID", orgID);
		bo.setAttributeValue("UpdateDate",DateHelper.getBusinessDate());
		bo.setAttributeValue("OperateDate",DateHelper.getBusinessDate());
		bo.setAttributeValue("OperateUserID",userID);
		bo.setAttributeValue("ObjectType", "jbo.doc.DOC_FILE_PACKAGE");
		bo.setAttributeValue("ObjectNo", serialNo);
		bo.setAttributeValue("TransactionCode", transactionCode);
		bo.setAttributeValue("STATUS", "01");
		bomdo.saveObject(bo);
		return bo.getAttribute("SerialNo").getString();
	}
	
	/**
	 * �ڶ������ϳ������롢����ʱ�����ݶ������͵Ĳ�ͬ��ȡ��Ӧ���ı���ͬ��źͺ�����ĿЭ���
	 * @param tx
	 * @return
	 */
	public String selectDocFileObjectNo(JBOTransaction tx){
		String fileDocObjectNo = "";
		try{
			BusinessObjectManager bom = BusinessObjectManager.createBusinessObjectManager(tx);
			BusinessObject dobo = bom.keyLoadBusinessObject("jbo.doc.DOC_OPERATION", this.serialNo);
			BusinessObject dfpbo = bom.keyLoadBusinessObject("jbo.doc.DOC_FILE_PACKAGE", dobo.getString("ObjectNo"));
		
			String sObjectType = dfpbo.getString("OBJECTTYPE");
			BizObjectManager m = null;
			if("jbo.app.BUSINESS_CONTRACT".equals(sObjectType)){
				BusinessObject bc = bom.keyLoadBusinessObject("jbo.app.BUSINESS_CONTRACT", dfpbo.getString("OBJECTNO"));
				fileDocObjectNo = bc.getString("CONTRACTARTIFICIALNO");
			}else if("jbo.prj.PRJ_BASIC_INFO".equals(sObjectType)){
				BusinessObject prj = bom.keyLoadBusinessObject("jbo.prj.PRJ_BASIC_INFO", dfpbo.getString("OBJECTNO"));
				fileDocObjectNo = prj.getString("AGREEMENTNO");
			} 
		}catch(Exception e){
			fileDocObjectNo = "";
		}
		return fileDocObjectNo; 
	}
	
	
	
	
}
