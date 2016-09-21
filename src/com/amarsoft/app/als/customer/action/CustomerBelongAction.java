package com.amarsoft.app.als.customer.action;

import com.amarsoft.app.als.customer.model.CustomerBelong;
import com.amarsoft.app.als.customer.model.CustomerConst;
import com.amarsoft.app.als.sys.tools.SystemConst;
import com.amarsoft.are.ARE;
import com.amarsoft.are.jbo.BizObject;
import com.amarsoft.are.jbo.BizObjectManager;
import com.amarsoft.are.jbo.JBOException;
import com.amarsoft.are.jbo.JBOFactory;
import com.amarsoft.are.jbo.JBOTransaction;
import com.amarsoft.are.lang.StringX;
import com.amarsoft.dict.als.manage.NameManager;

/**
 * �ͻ�Ȩ��������������
 * @author lyin
 *
 */
public class CustomerBelongAction{
	private String customerID = "";//�ͻ����
	private String userID = "";//�û����
	private String orgID = "";//�û�����������
	private String applyAttribute = "";//�Ƿ�����ͻ�����Ȩ
	private String applyAttribute1 = "";//�Ƿ�������Ϣ�鿴Ȩ
	private String applyAttribute2 = "";//�Ƿ�������Ϣά��Ȩ
	private String applyAttribute3 = "";//�Ƿ�����ҵ�����Ȩ
	private String applyAttribute4 = "";//����Ȩ��
	private String belongUserID = "";//�ܻ����û����
	
	/**
	 * �жϷ���ͻ�Ȩ������Ŀͻ�������ԭ�ܻ��ͻ�����Ĺ�ϵ�Լ������־λ
	 * @return
	 * @throws Exception 
	 */
	public String checkRoleApply(JBOTransaction tx) throws Exception{
		String sReturn = "";
		String sApplyType = "";
		String sOldOrgID  = "";
		String sOldRelativeOrgID = "";
		BizObjectManager bm = null;
		BizObject bizObject = null;
		//��ȡ�ͻ�ԭ�ܻ��ͻ�������������
		CustomerBelong cb = new CustomerBelong(null,customerID,null);
		String [] manage= cb.getManageUser();
		if(manage!=null){
			sOldOrgID = manage[1];//�ͻ�ԭ�ܻ��ͻ�������������
			ARE.getLog().debug("�ͻ�ԭ�ܻ��ͻ�������������:"+sOldOrgID);
			if(StringX.isEmpty(sOldOrgID)) sOldOrgID = "";
			
			//��ȡ���û�ԭ�����ͻ������ϼ�����
			bm=JBOFactory.getBizObjectManager(SystemConst.ORG_INFO);
			bizObject=bm.createQuery("OrgID=:OrgID").setParameter("OrgID", sOldOrgID).getSingleResult(false);
			sOldRelativeOrgID = bizObject.getAttribute("RelativeOrgID").toString();
			ARE.getLog().debug("ԭ�����ͻ������ϼ�����:"+sOldRelativeOrgID);
			if(StringX.isEmpty(sOldRelativeOrgID)) sOldRelativeOrgID = "";
		}else{
			sOldOrgID = "";
			sOldRelativeOrgID = "";
			ARE.getLog().debug("�ÿͻ�Ŀǰ�޹ܻ��ͻ�����");
		}

		//��ȡ��ǰ�������ϼ�����
		bm=JBOFactory.getBizObjectManager(SystemConst.ORG_INFO);
		BizObject bo=bm.createQuery("OrgID=:OrgID").setParameter("OrgID",orgID).getSingleResult(false);
		String sRelativeOrgID = bo.getAttribute("RelativeOrgID").getString();
		String sRelativeOrgName = NameManager.getOrgName(sRelativeOrgID).toString();
		ARE.getLog().debug("��ǰ�������ϼ�����:"+sRelativeOrgID+","+sRelativeOrgName);
		if(StringX.isEmpty(sRelativeOrgID)) sRelativeOrgID = "";
		
		//�ж��Ƿ�����ͬһ����
		if(sOldOrgID.equals(orgID)){
			sApplyType = "1" ;
		//�ж��Ƿ�����ͬһ�ϼ�����
		}else if(sOldRelativeOrgID.equals(sRelativeOrgID)){
			sApplyType = "2" ;
		//�ж��Ƿ����ڲ�ͬ�ϼ�����
		}else {
			sApplyType = "3" ;
		}
		
		CustomerBelong customerBelong = new CustomerBelong(tx,customerID,userID);
		updateApplyType(customerBelong,sApplyType);//����һ����־λ��CUSTOMER_BELONG
		sReturn = updateApplyRight(customerBelong,sRelativeOrgID,sApplyType);//����CUSTOMER_BELONG��RightType		
		return sReturn;	
	}
	
	/**
	 * ����һ����־λ��CUSTOMER_BELONG���������ֿͻ�Ȩ������������������ͻ��ܻ������������Ƿ�Ϊͬһ������ͬһ�ϼ�����
	 * @return
	 * @throws Exception 
	 */
	public void updateApplyType(CustomerBelong customerBelong,String sApplyType) throws JBOException{
		customerBelong.getBizObject().setAttributeValue("ApplyType", sApplyType);
		customerBelong.saveObject();
	} 
	
	/**
	 * ����CUSTOMER_BELONG��RightType�����ڼ�¼�ͻ�Ȩ�����뷢�͵��ĸ�������������
	 * @return
	 * @throws Exception 
	 */
	public String updateApplyRight(CustomerBelong customerBelong,String sRelativeOrgID,String sApplyType) throws Exception{
		String sReturn = "";
		if("1".equals(sApplyType)){
			customerBelong.getBizObject().setAttributeValue("ApplyRight", orgID);
			sReturn = "�ÿͻ�Ȩ��������Ϣ�Ѿ����͵���"+NameManager.getOrgName(orgID)+"�����������ϻ����Ŀͻ�Ȩ�޹�����Ա�������硣 ";//��ǰ����
		}else if("2".equals(sApplyType)){
			customerBelong.getBizObject().setAttributeValue("ApplyRight", sRelativeOrgID);
			sReturn = "�ÿͻ�Ȩ��������Ϣ�Ѿ����͵���"+NameManager.getOrgName(sRelativeOrgID)+"�����������ϻ����Ŀͻ�Ȩ�޹�����Ա�������硣 ";//��ǰ�������ϼ�����
		}else if("3".equals(sApplyType)){
			customerBelong.getBizObject().setAttributeValue("ApplyRight", sRelativeOrgID);
			sReturn = "�ÿͻ�Ȩ��������Ϣ�Ѿ����͵���"+NameManager.getOrgName(sRelativeOrgID)+"�����������ϻ����Ŀͻ�Ȩ�޹�����Ա�������硣 ";//��ǰ�������ϼ�����
		}
		customerBelong.saveObject();
		return sReturn;
		
	}
	
	/**
	 * �ͻ�Ȩ������ͨ�������Customer_Belong���滻ԭ��AuthorizeRoleActionAjax.jsp���ܣ�
	 * @return
	 * @throws Exception 
	 */
	public String updateBelongAttributes(JBOTransaction tx) throws Exception{
	    String sHave = "_FALSE_";      //�ÿͻ��Ƿ�������Ȩ
	    String sBelongUserID = "";
	    String sBelongUserName = "";
	    String sOrgID = "";
	    String sOrgName = "";
	    if("1".equals(applyAttribute)){
	    	//�ж��Ƿ��������ͻ������Ѿ��иÿͻ�������Ȩ
	    	CustomerBelong cb = new CustomerBelong(null,customerID,userID);
	    	BizObject bo = cb.getBelongAttribute(tx, customerID, userID);
	    	if(cb.getBelongAttribute(tx, customerID, userID)!=null){
	    		sHave = "_TRUE_";  //��������Ȩ
	    		sBelongUserID = bo.getAttribute("UserID").toString();//��������Ȩ�Ŀͻ�����ID
	    		sBelongUserName = NameManager.getUserName(sBelongUserID);
	    		sOrgID = bo.getAttribute("OrgID").toString();//�ͻ�����Ȩ�Ŀͻ�������������
	    		sOrgName = NameManager.getOrgName(sOrgID);
	    	}
	    }
        
	    //����ÿͻ�������Ȩ��û���û�ӵ�У���ֱ�Ӹ�������������пͻ�Ȩ�޵ĸ���
		if(sHave.equals("_FALSE_")){
			CustomerBelong customerBelong = new CustomerBelong(tx,customerID,userID);
			customerBelong.setAttribute("BelongAttribute", applyAttribute);
			customerBelong.setAttribute("BelongAttribute1", applyAttribute1);
			customerBelong.setAttribute("BelongAttribute2", applyAttribute2);
			customerBelong.setAttribute("BelongAttribute3", applyAttribute3);
			customerBelong.setAttribute("BelongAttribute4", applyAttribute4);

			customerBelong.saveObject();
		}
		return sHave+"@"+sOrgName+"@"+sBelongUserName+"@"+sBelongUserID;
	} 
	
	/**
	 * ת�ƿͻ�����Ȩ(�滻ԭChangeRoleActionAjax.jsp����)
	 * @return
	 * @throws JBOException 
	 */
	public String changeBelongAttribute(JBOTransaction tx) throws JBOException{
		//��ԭ���û��Ե�ǰ�ͻ�������Ȩ����Ϣ�鿴Ȩ����Ϣά��Ȩ��ҵ�����Ȩȫ����Ϊ���ޡ�
		CustomerBelong customerBelong = new CustomerBelong(tx,customerID,belongUserID);
		customerBelong.setAttribute("BelongAttribute", CustomerConst.CUSTOMER_BELONG_BELONGATTRIBUTE_2);
		customerBelong.setAttribute("BelongAttribute1", CustomerConst.CUSTOMER_BELONG_BELONGATTRIBUTE_2);
		customerBelong.setAttribute("BelongAttribute2", CustomerConst.CUSTOMER_BELONG_BELONGATTRIBUTE_2);
		customerBelong.setAttribute("BelongAttribute3", CustomerConst.CUSTOMER_BELONG_BELONGATTRIBUTE_2);
		customerBelong.setAttribute("BelongAttribute4", CustomerConst.CUSTOMER_BELONG_BELONGATTRIBUTE_2);
		customerBelong.saveObject();
		
		//����ǰ�û��Ե�ǰ�ͻ�������Ȩ����Ϣ�鿴Ȩ����Ϣά��Ȩ��ҵ�����Ȩȫ����Ϊ���С�
		CustomerBelong cb = new CustomerBelong(tx,customerID,userID);
		cb.setAttribute("BelongAttribute", CustomerConst.CUSTOMER_BELONG_BELONGATTRIBUTE_1);
		cb.setAttribute("BelongAttribute1", CustomerConst.CUSTOMER_BELONG_BELONGATTRIBUTE_1);
		cb.setAttribute("BelongAttribute2", CustomerConst.CUSTOMER_BELONG_BELONGATTRIBUTE_1);
		cb.setAttribute("BelongAttribute3", CustomerConst.CUSTOMER_BELONG_BELONGATTRIBUTE_1);
		cb.setAttribute("BelongAttribute4", CustomerConst.CUSTOMER_BELONG_BELONGATTRIBUTE_1);
		cb.saveObject();
		
		return "true";
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

	public String getApplyAttribute() {
		return applyAttribute;
	}

	public void setApplyAttribute(String applyAttribute) {
		this.applyAttribute = applyAttribute;
	}

	public String getApplyAttribute1() {
		return applyAttribute1;
	}

	public void setApplyAttribute1(String applyAttribute1) {
		this.applyAttribute1 = applyAttribute1;
	}

	public String getApplyAttribute2() {
		return applyAttribute2;
	}

	public void setApplyAttribute2(String applyAttribute2) {
		this.applyAttribute2 = applyAttribute2;
	}

	public String getApplyAttribute3() {
		return applyAttribute3;
	}

	public void setApplyAttribute3(String applyAttribute3) {
		this.applyAttribute3 = applyAttribute3;
	}

	public String getApplyAttribute4() {
		return applyAttribute4;
	}

	public void setApplyAttribute4(String applyAttribute4) {
		this.applyAttribute4 = applyAttribute4;
	}

	public String getBelongUserID() {
		return belongUserID;
	}

	public void setBelongUserID(String belongUserID) {
		this.belongUserID = belongUserID;
	}
	
	
}