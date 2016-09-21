package com.amarsoft.app.als.customer.transfer.action;

import com.amarsoft.app.als.customer.model.CustomerBelong;
import com.amarsoft.app.als.customer.model.CustomerConst;
import com.amarsoft.are.jbo.BizObject;
import com.amarsoft.are.jbo.BizObjectManager;
import com.amarsoft.are.jbo.JBOException;
import com.amarsoft.are.jbo.JBOFactory;
import com.amarsoft.are.jbo.JBOTransaction;
import com.amarsoft.are.util.StringFunction;
/**
 * �ͻ�ת�ƴ�����
 * @author wmZhu
 *
 */
public class TransferAction {
	
	private String customerID;//�ͻ����
	private String userID;//��ǰ�û����
	private String orgID;//��ǰ�û����
	private String receiveUserID;//��ת�Ƶ��û����
	private String receiveOrgID;//��ת�Ƶ��û�����
	private String rightType;//ת������
	private String afrightFlag;//ҵ��ܻ�Ȩת�Ʊ�ʶ
	private String serialNo;//��ˮ��
	private String transferType;//ת��״̬
	private String manaTime;//ά��ʱ��
	private String customerType;//�ͻ�����
	
	/**
	 * ����ת�������¼
	 * @throws Exception 
	 * @return2012-8-25
	 */
	public String saveTransferOut(JBOTransaction tx){
		String result = "true";
		try {
			BizObjectManager bomTransfer = JBOFactory.getBizObjectManager(CustomerConst.CUSTOMER_TRANSFER);
			tx.join(bomTransfer);
			BizObject bo;
			String sCustomers[] = customerID.split("@");
			for(int i=0;i<sCustomers.length;i++){
				checkApply(sCustomers[i],CustomerConst.tOperateType_20,userID,tx);
				//��������¼
				bo = bomTransfer.newObject();
				bo.setAttributeValue("TransferType",CustomerConst.TransferType_10);//ת��״̬ 10:δȷ��
				saveTransfer(tx,bo,bomTransfer,sCustomers[i],"out");
			}
		} catch (Exception e) {
			result = "false";
			e.printStackTrace();
		}
		return result;
	}
	
	/**
	 * ����ת�������¼
	 * @throws Exception 
	 * @return2012-8-25
	 */
	public String saveTransferIn(JBOTransaction tx){
		String result = "true";
		try {
			BizObjectManager bomTransfer = JBOFactory.getBizObjectManager(CustomerConst.CUSTOMER_TRANSFER);
			tx.join(bomTransfer);
			BizObject bo;
			String sCustomers[] = customerID.split("@");
			for(int i=0;i<sCustomers.length;i++){
				checkApply(sCustomers[i],CustomerConst.tOperateType_10,userID,tx);
				//��������¼
				bo = bomTransfer.newObject();
				bo.setAttributeValue("TransferType",CustomerConst.TransferType_10);//ת��״̬ 10:δȷ��
				saveTransfer(tx,bo,bomTransfer,sCustomers[i],"in");
			}
		} catch (Exception e) {
			result = "false";
			e.printStackTrace();
		}
		return result;
	}
	
	/**
	 * ͬ��ͻ�ת������
	 * @throws Exception 
	 * @return
	 */
	@SuppressWarnings("deprecation")
	public String consentTransfer(JBOTransaction tx){
		String result = "true";
		try {
			BizObjectManager bom = JBOFactory.getBizObjectManager(CustomerConst.CUSTOMER_TRANSFER);
			tx.join(bom);
			BizObject biz = bom.createQuery("SerialNo=:serialNo").setParameter("serialNo", serialNo).getSingleResult(true);
			if(biz != null){
				String unOperateType = biz.getAttribute("UnOperateType").getString();//ת�Ʊ�־
				String newUser = biz.getAttribute("InputUserID").getString();//������
				String newOrg = biz.getAttribute("InputOrgID").getString();//�������
				String oldUser = userID;
				String oldOrg = orgID;
				if(CustomerConst.tOperateType_10.equals(unOperateType)){//ת��
					oldUser = newUser;
					oldOrg = newOrg;
					newUser = userID;
					newOrg = orgID;
				}
				setBelong(tx,newUser,newOrg,oldUser,oldOrg,customerID);
				
				//����ת��������Ϣ
				biz.setAttributeValue("AFFIRMUSERID", userID);//ȷ����
				biz.setAttributeValue("AFFIRMORGID", orgID);//ȷ�ϻ���
				biz.setAttributeValue("AFFIRMDate", StringFunction.getToday());//ȷ������
				biz.setAttributeValue("TRANSFERTYPE", CustomerConst.TransferType_20);//��ȷ��
				biz.setAttributeValue("MainTainTime", manaTime);
				bom.saveObject(biz);
			}
		} catch (Exception e) {
			result = "false";
			e.printStackTrace();
		}
		return result;
	}
	
	/**
	 * �ܾ��ͻ�ת������
	 * @throws Exception 
	 * @return
	 */
	@SuppressWarnings("deprecation")
	public String rejectTransfer(JBOTransaction tx){
		String result = "true";
		try {
			BizObjectManager bom = JBOFactory.getBizObjectManager(CustomerConst.CUSTOMER_TRANSFER);
			tx.join(bom);
			BizObject biz = bom.createQuery("SerialNo=:serialNo").setParameter("serialNo", serialNo).getSingleResult(true);
			if(biz != null){
				biz.setAttributeValue("REFUSEDATE", StringFunction.getToday());//�ܾ�����
				biz.setAttributeValue("TRANSFERTYPE", CustomerConst.TransferType_30);//�Ѿܾ�
				bom.saveObject(biz);
			}
		} catch (Exception e) {
			result = "false";
			e.printStackTrace();
		}
		return result;
	}
	
	/**
	 * ά��Ȩ����
	 * @throws JBOException 
	 * @return2012-8-28
	 */
	public String recover(JBOTransaction tx){
		String result = "true";
		try {
			BizObjectManager bomTransfer = JBOFactory.getBizObjectManager(CustomerConst.CUSTOMER_TRANSFER);
			tx.join(bomTransfer);
			
			BizObject bo = null;
			if( CustomerConst.TransferType_20.equals(this.transferType)){//���״̬Ϊ��ȷ��,�����޸Ķ�Ӧ�û���Ȩ��
				CustomerBelong cb = new CustomerBelong(tx, this.customerID, this.userID);
				cb.setManageRight("2");
				cb.saveBelong();
			}
			//ɾ����Ӧ�������¼
			bo = bomTransfer.createQuery("serialNo = :serialNo").setParameter("serialNo",this.serialNo).getSingleResult(true);
			bomTransfer.deleteObject(bo);
		} catch (Exception e) {
			result = "false";
			e.printStackTrace();
		}
		return result;
	}
	
	/**
	 * ���ùܻ���¼
	 * @param tx
	 * @param newUser ���û�
	 * @param newOrg �»���
	 * @param oldUser ���û�
	 * @param oldOrg �ɻ���
	 * @param customerID �ͻ����
	 * @throws Exception
	 */
	private void setBelong(JBOTransaction tx,String newUser,String newOrg,String oldUser,String oldOrg,String customerID) throws Exception{
		CustomerBelong cb = new CustomerBelong(tx, customerID, newUser);
		cb.setInputUserID(userID);
		cb.setInputOrgID(orgID);
		if(CustomerConst.RightType_10.equals(rightType)){//�ܻ�Ȩ
				//�ܻ�Ȩʱ,�轫�ɹܻ��˵Ĺܻ�Ȩ��ȡ��
				CustomerBelong cb2 = new CustomerBelong(tx, customerID, oldUser);
				cb2.setApplyRight("2");
				cb2.setManageRight("2");
				cb2.setModifyRight("2");
				cb2.saveBelong();
				
				cb.setManageRight("1");
				cb.setApplyRight("1");
		}
		cb.setViewyRight("1");
		cb.setModifyRight("1");
		cb.saveBelong();
	}
	
	/**
	 * ���������¼
	 * @param bo
	 * @param bom
	 * @param sCustomerID �ͻ����
	 * @param typeFlag  ת��ת����ʶ
	 * @throws Exception 
	 */
	@SuppressWarnings("deprecation")
	private void saveTransfer(JBOTransaction tx,BizObject bo,BizObjectManager bom,String customerID,String typeFlag) throws Exception{
		if("in".equals(typeFlag)){//ת��
			//��ȡ�ͻ��ܻ�����Ϣ
			CustomerBelong cb = new CustomerBelong(null, customerID, null);
			String[] users = cb.getManageUser();
			if(users == null || checkAbandon(customerID)){//���û�йܻ��˻���Ϊ��������ֱ��ת��
				users = new String[2];
				bo.setAttributeValue("TransferType",CustomerConst.TransferType_20);//ת��״̬ 20:��ȷ��
				bo.setAttributeValue("AFFIRMUSERID",userID);//ȷ����
				bo.setAttributeValue("AFFIRMORGID",orgID);//ȷ�ϻ���
				bo.setAttributeValue("AFFIRMDATE",StringFunction.getToday());//ȷ������
				
				//���Ĺܻ���¼
				setBelong(tx,userID,orgID,null,null,customerID);
			}
			bo.setAttributeValue("OperateType",CustomerConst.tOperateType_10);//��������  10:�ͻ�ת��
			bo.setAttributeValue("UnOperateType", CustomerConst.tOperateType_20);//����������  20:�ͻ�ת��
			bo.setAttributeValue("receiveUserID",users[0]);//�����û���
			bo.setAttributeValue("receiveOrgID",users[1]);
		}else{//ת��
			bo.setAttributeValue("OperateType",CustomerConst.tOperateType_20);//�������� 20:�ͻ�ת��
			bo.setAttributeValue("UnOperateType", CustomerConst.tOperateType_10);//����������  10:�ͻ�ת��
			bo.setAttributeValue("receiveUserID",receiveUserID);//�����û���
			bo.setAttributeValue("receiveOrgID",receiveOrgID);
		}
		bo.setAttributeValue("rightType",rightType);//ת������
		bo.setAttributeValue("afrightFlag",afrightFlag);//ҵ��ת�Ʊ�ʶ
		bo.setAttributeValue("InputUserID", userID);
		bo.setAttributeValue("InputOrgID", orgID);
		bo.setAttributeValue("InputDate", StringFunction.getToday());
		bo.setAttributeValue("CustomerID",customerID);//�ͻ����
		if(this.manaTime != null && !"".equals(this.manaTime)){
			bo.setAttributeValue("MaintainTime",this.manaTime);//ά��Ȩ����			
		}
		bom.saveObject(bo);
	}
	
	/**
	 * ���ͻ��Ƿ��Ѿ�����ת�����룬���������ɾ����¼(�����븲�Ǿ�����)
	 * @param sCustomerID �ͻ����
	 * @param sOperateType ��������
	 * @param sUserID ������
	 * @param tx
	 * @throws Exception
	 */
	private void checkApply(String sCustomerID,String sOperateType,String sUserID,JBOTransaction tx) throws Exception{
		BizObjectManager bom = JBOFactory.getFactory().getManager(CustomerConst.CUSTOMER_TRANSFER);
		tx.join(bom);
		BizObject bo = bom.createQuery("CustomerID=:customerID and OperateType=:operateType and InputUserID=:userID and AFFIRMDATE is null and REFUSEDATE is null")
				.setParameter("customerID", sCustomerID).setParameter("operateType", sOperateType)
				.setParameter("userID", sUserID).getSingleResult(true);
		if(bo != null){
			bom.deleteObject(bo);
		}
	}
	
	/**
	 * ���ͻ��Ƿ�Ϊ������
	 * @param customerID
	 * @return
	 */
	private boolean checkAbandon(String customerID){
		boolean result = false;
		//TODO ���ͻ��Ƿ�Ϊ������
		return result;
	}

	public String getCustomerID() {
		return customerID;
	}

	public void setCustomerID(String customerID) {
		this.customerID = customerID;
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

	public String getReceiveUserID() {
		return receiveUserID;
	}

	public void setReceiveUserID(String receiveUserID) {
		this.receiveUserID = receiveUserID;
	}

	public String getReceiveOrgID() {
		return receiveOrgID;
	}

	public void setReceiveOrgID(String receiveOrgID) {
		this.receiveOrgID = receiveOrgID;
	}

	public String getRightType() {
		return rightType;
	}

	public void setRightType(String rightType) {
		this.rightType = rightType;
	}

	public String getAfrightFlag() {
		return afrightFlag;
	}

	public void setAfrightFlag(String afrightFlag) {
		this.afrightFlag = afrightFlag;
	}

	public String getSerialNo() {
		return serialNo;
	}

	public void setSerialNo(String serialNo) {
		this.serialNo = serialNo;
	}

	public String getTransferType() {
		return transferType;
	}

	public void setTransferType(String transferType) {
		this.transferType = transferType;
	}

	public String getManaTime() {
		return manaTime;
	}

	public void setManaTime(String manaTime) {
		this.manaTime = manaTime;
	}

	public String getCustomerType() {
		return customerType;
	}

	public void setCustomerType(String customerType) {
		this.customerType = customerType;
	}

}
