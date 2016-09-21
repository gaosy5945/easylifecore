package com.amarsoft.app.als.customer.model;

import java.util.List;

import com.amarsoft.app.als.customer.common.action.CustomerBelongChangeLog;
import com.amarsoft.app.util.ASUserObject;
import com.amarsoft.are.jbo.BizObject;
import com.amarsoft.are.jbo.BizObjectManager;
import com.amarsoft.are.jbo.JBOException;
import com.amarsoft.are.jbo.JBOFactory;
import com.amarsoft.are.jbo.JBOTransaction;
import com.amarsoft.are.lang.DataElement;
import com.amarsoft.are.lang.StringX;
import com.amarsoft.are.util.StringFunction;

/**
 * �ͻ�Ȩ�޶�����
 * @author wmZhu
 *
 */
public class CustomerBelong {
	
	private String customerID;
	private String orgID;
	private String userID;
	private String manageRight = "2";//�ܻ�Ȩ (BelongAttribute)Ĭ�϶�Ϊ��
	private String viewyRight = "2";//��Ϣ�鿴Ȩ(BelongAttribute1)
	private String modifyRight = "2";//��Ϣά��Ȩ (BelongAttribute2)
	private String applyRight = "2";//ҵ�����Ȩ (BelongAttribute3)
	private String inputUserID;
	private String inputOrgID;
	private String inputDate;
	
	private BizObjectManager bom = null;
	private BizObject bizObject;
	private List<BizObject> listBelong;
	private JBOTransaction tx = null;
	
	/**
	 * �������
	 * ���ֻ��Ҫ�鿴������Ҫ�޸�,�����txΪ�ռ���
	 * ���Ҫ�鿴�ͻ��������û�ӵ�е�Ȩ����userIDΪ��
	 * @param tx
	 * @param customerID �ͻ����
	 * @param userID �û����
	 * @throws JBOException
	 */
	public CustomerBelong(JBOTransaction tx,String customerID,String userID) throws JBOException{
		this.tx = tx;
		this.customerID = customerID;
		this.userID = userID;
		init();
	}
	
	/**
	 * ��ʼ��Ȩ�޶���
	 * @param tx
	 * @throws JBOException
	 */
	@SuppressWarnings({ "unchecked"})
	private void init() throws JBOException{
		bom = JBOFactory.getBizObjectManager(CustomerConst.CUSTOMER_BELONG);
		boolean updateFlag = false;//�Ƿ���±�ʶ
		if(tx != null){
			tx.join(bom);
			updateFlag = true;
		}
		if(StringX.isEmpty(this.userID)){//�û�Ϊ��ʱ,��ѯ�ͻ������йܻ���¼
			listBelong = bom.createQuery("CustomerID=:customerID").setParameter("customerID", this.customerID).getResultList(updateFlag);
		}else{
			bizObject = bom.createQuery("CustomerID=:customerID and UserID=:userID")
						.setParameter("customerID", this.customerID).setParameter("UserID", this.userID)
						.getSingleResult(updateFlag);
			//��ʼ����������
			if(bizObject != null){
				this.customerID = bizObject.getAttribute("CustomerID").getString();
				this.userID = bizObject.getAttribute("UserID").getString();
				this.orgID = bizObject.getAttribute("OrgID").getString();
				this.manageRight = bizObject.getAttribute("BelongAttribute").getString();
				this.viewyRight = bizObject.getAttribute("BelongAttribute1").getString();
				this.modifyRight = bizObject.getAttribute("BelongAttribute2").getString();
				this.applyRight = bizObject.getAttribute("BelongAttribute3").getString();
				this.inputUserID = bizObject.getAttribute("InputUserID").getString();
				this.inputOrgID = bizObject.getAttribute("InputOrgID").getString();
				this.inputDate = bizObject.getAttribute("InputDate").getString();
			}
		}
	}
	/**
	 * ��������¼
	 * @throws Exception 
	 */
	@SuppressWarnings("deprecation")
	public void saveBelong() throws Exception{
		//�ͻ������¼����
		CustomerBelongChangeLog cbc = new CustomerBelongChangeLog();
		ASUserObject ao = ASUserObject.getUser(this.userID);
		this.orgID = ao.getOrgID();//��ʼ���������
		
		if(bizObject == null){
			bizObject = bom.newObject();
			bizObject.setAttributeValue("InputDate", StringFunction.getToday());
			bizObject.setAttributeValue("InputUserID", this.inputUserID);
			bizObject.setAttributeValue("InputOrgID", this.inputOrgID);
			
			/*//���������¼
			cbc.createImportLog(tx, customerID, this.userID,this.orgID);*/
		}
		/*if(CustomerConst.HAVENO_1.equals(this.manageRight)){//ӵ�йܻ�Ȩʱ,�����ܻ��˱����¼
			cbc.createManageChangeLog(tx, customerID, this.userID, this.orgID);
		}*/
		bizObject.setAttributeValue("CustomerID", this.customerID);
		bizObject.setAttributeValue("UserID", this.userID);
		bizObject.setAttributeValue("OrgID",this.orgID);
		bizObject.setAttributeValue("BelongAttribute", this.manageRight);
		bizObject.setAttributeValue("BelongAttribute1", this.viewyRight);
		bizObject.setAttributeValue("BelongAttribute2", this.modifyRight);
		bizObject.setAttributeValue("BelongAttribute3", this.applyRight);
		bom.saveObject(bizObject);
	}
	/**
	 * ɾ�������¼
	 * @throws JBOException
	 */
	public void deleteBelong() throws JBOException{
		bom.deleteObject(bizObject);
	}
	
	/**
	 * ��ȡ�ܻ�����ܻ�����
	 * @return ����һ������,����ܻ��˲������������Ϊ��
	 * @throws JBOException 
	 */
	@SuppressWarnings("unchecked")
	public String[] getManageUser() throws JBOException{
		String[] manage = null;
		if(listBelong == null){
			listBelong = bom.createQuery("CustomerID=:customerID").setParameter("customerID", this.customerID).getResultList(false);
		}
		BizObject biz = null;
		for(int i=0;i<listBelong.size();i++){
			biz = listBelong.get(i);
			if("1".equals(biz.getAttribute("BelongAttribute").getString())){
				manage = new String[2];
				manage[0] = biz.getAttribute("UserID").getString();
				manage[1] = biz.getAttribute("OrgID").getString();
				break;
			}
		}
		return manage;
	}
	
	/**
	 * ��ÿͻ�����������
	 * @param attributeIndex
	 * @return
	 * @throws JBOException
	 */
	public DataElement getAttribute(String attributeIndex) throws JBOException{
		return bizObject.getAttribute(attributeIndex);
	}
	
	/**
	 * ��������
	 * @param attributeName
	 * @param value
	 * @throws JBOException
	 */
	public void setAttribute(String attributeName,Object value) throws JBOException{
		bizObject.setAttributeValue(attributeName, value);
		
	}

	/**
	 * ����ͻ�Ȩ����Ϣ
	 * @throws JBOException 
	 */
	public void saveObject() throws JBOException{
		this.bom.saveObject(this.bizObject);
	}
	
	/**
	 * �ж��Ƿ��������ͻ������Ѿ��иÿͻ�������Ȩ
	 * @throws JBOException 
	 */
	public BizObject getBelongAttribute(JBOTransaction tx,String customerID,String userID) throws JBOException{
		this.customerID = customerID;
		this.userID= userID;
		this.bizObject = bom.createQuery("CustomerID=:customerID and UserID<>:userID and BelongAttribute=:belongAttribute").
				setParameter("customerID", customerID).setParameter("userID", userID).
				setParameter("belongAttribute", CustomerConst.CUSTOMER_BELONG_BELONGATTRIBUTE_1).getSingleResult(tx!=null);
		return bizObject;
	}

	
	public String getCustomerID() {
		return customerID;
	}
	public String getOrgID() {
		return orgID;
	}
	public String getUserID() {
		return userID;
	}
	public String getManageRight() {
		return manageRight;
	}
	public void setManageRight(String manageRight) {
		this.manageRight = manageRight;
	}
	public String getViewyRight() {
		return viewyRight;
	}
	public void setViewyRight(String viewyRight) {
		this.viewyRight = viewyRight;
	}
	public String getModifyRight() {
		return modifyRight;
	}
	public void setModifyRight(String modifyRight) {
		this.modifyRight = modifyRight;
	}
	public String getApplyRight() {
		return applyRight;
	}
	public void setApplyRight(String applyRight) {
		this.applyRight = applyRight;
	}
	public String getInputUserID() {
		return inputUserID;
	}
	public void setInputUserID(String inputUserID) {
		this.inputUserID = inputUserID;
	}
	public void setInputOrgID(String inputOrgID) {
		this.inputOrgID = inputOrgID;
	}
	public String getInputOrgID() {
		return inputOrgID;
	}
	public String getInputDate() {
		return inputDate;
	}
	public BizObject getBizObject(){
		return bizObject;
	}
	public List<BizObject> getListBelong() {
		return listBelong;
	}
}
