package com.amarsoft.acct.accounting.web;
/**
 * 2015-11-23
 * ckxu 
 * ���ݽ�����ˮ�ŵ��ý���
 */

import com.amarsoft.app.base.businessobject.BusinessObject;
import com.amarsoft.app.base.businessobject.BusinessObjectManager;
import com.amarsoft.app.base.trans.TransactionHelper;
import com.amarsoft.app.base.util.DateHelper;
import com.amarsoft.are.ARE;
import com.amarsoft.are.jbo.JBOFactory;
import com.amarsoft.are.jbo.JBOTransaction;

public class RunTransaction {
	private String transactionSerialNo;
	private String userID;
	private String orgID;
	private String flag;
	public String run(JBOTransaction tx) throws Exception{
		String messageError = "";
		BusinessObjectManager bom =BusinessObjectManager.createBusinessObjectManager(tx);//�������������
		try{
			 
			if(transactionSerialNo == null) transactionSerialNo = "";
			if(userID == null) userID = "";
			if(orgID == null) orgID = "";
			//�����ñʽ��ף���ֹ�ظ����//����״̬���ý��׵�״̬ת���Ϊ��ִ��
			int i=JBOFactory.getBizObjectManager("jbo.acct.ACCT_TRANSACTION",tx)
			.createQuery("update O set TransStatus=TransStatus where TransStatus = '0' and SerialNo = :SerialNo")
			.setParameter("SerialNo",transactionSerialNo)
			.executeUpdate();
			
			if(i == 0) messageError = "false@ϵͳ���ڴ��������ظ������";
			
			BusinessObject transaction = TransactionHelper.loadTransaction(transactionSerialNo, bom);//���ؽ���
			if(!"0".equals(transaction.getString("TransStatus"))){
				messageError = "false@����ԭ�򣺽���״̬��������ȷ���Ƿ��Ѽ��ˣ�";
				return messageError;
			}
			if(!"".equals(transaction.getString("TransDate")) && transaction.getString("TransDate").compareTo(DateHelper.getBusinessDate())>0 && "N".equals(flag))
			{
				ARE.getLog().info("���ס�"+transaction.getKeyString()+"���Ѿ�ԤԼ����"+transaction.getString("TransDate")+"��");
				transaction.setAttributeValue("TransStatus", "3");
				bom.updateBusinessObject(transaction);
			}else{
				transaction.setAttributeValue("TransDate",DateHelper.getBusinessDate());//���ý���ʵ��ִ������
				TransactionHelper.executeTransaction(transaction, bom);//ִ�н���
			}
			bom.updateDB();
			bom.commit();
			messageError = "true@���׳ɹ�";
			return messageError;
		}
		catch(Exception e){
			bom.rollback();
			ARE.getLog().debug("ϵͳ����", e);
			e.printStackTrace();
			messageError =  "false@����ԭ��"+e.getMessage();
			throw e;
		}
	}
	
	public String cancel(JBOTransaction tx) throws Exception{
		JBOFactory.getBizObjectManager("jbo.acct.ACCT_TRANSACTION",tx)
			.createQuery("update O set TransStatus = '2' where SerialNo = :SerialNo")
			.setParameter("SerialNo",transactionSerialNo)
			.executeUpdate();
		
		return "true@������ȡ����";
	}
	public String getTransactionSerialNo() {
		return transactionSerialNo;
	}
	public void setTransactionSerialNo(String transactionSerialNo) {
		this.transactionSerialNo = transactionSerialNo;
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
	public String getFlag() {
		return flag;
	}
	public void setFlag(String flag) {
		this.flag = flag;
	}
}
