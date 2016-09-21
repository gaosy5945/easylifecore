package com.amarsoft.app.als.customer.common.action;

import com.amarsoft.app.als.customer.model.CustomerConst;
import com.amarsoft.are.jbo.BizObject;
import com.amarsoft.are.jbo.BizObjectManager;
import com.amarsoft.are.jbo.JBOException;
import com.amarsoft.are.jbo.JBOFactory;
import com.amarsoft.are.jbo.JBOTransaction;
import com.amarsoft.are.util.StringFunction;

/**
 * �ͻ������¼ά��
 * @author wmZhu
 *
 */
public class CustomerBelongChangeLog {
	
	private String logType = "1";//Ĭ��Ϊ�ܻ��˱����¼
	
	/**
	 * �����ܻ��˱����¼
	 * @param tx
	 * @param customerID �ͻ����
	 * @param userID �¹ܻ���
	 * @param orgID �¹ܻ�����
	 * @param oldUser �ɹܻ���
	 * @param oldOrg �ɹܻ�����
	 * @throws JBOException
	 */
	/*@SuppressWarnings("deprecation")
	public void createManageChangeLog(JBOTransaction tx,String customerID,String userID,String orgID) throws JBOException{
		BizObjectManager bom = JBOFactory.getBizObjectManager(CustomerConst.CUSTOMER_IMPORT_LOG);
		if(tx != null) tx.join(bom);
		BizObject biz = bom.newObject();
		biz.setAttributeValue("CustomerID", customerID);
		biz.setAttributeValue("UserID", userID);
		biz.setAttributeValue("OrgID", orgID);
		if("1".equals(logType)){
			String[] oldManage = getHistManage(tx,customerID);
			biz.setAttributeValue("OldUserID", oldManage[0]);
			biz.setAttributeValue("OldOrgID", oldManage[1]);
		}
		biz.setAttributeValue("LogType", logType);
		biz.setAttributeValue("InputDate", StringFunction.getToday());
		bom.saveObject(biz);
		this.logType = "1";//��ԭĬ��ֵ
	}*/
	
	/**
	 * ���ݿͻ��ܻ��˱����¼��ȡ���µ�һ���ܻ�����Ϣ
	 * @param customerID
	 * @return
	 * @throws JBOException 
	 */
	private String[] getHistManage(JBOTransaction tx,String customerID) throws JBOException{
		String[] manage = new String[2];
		BizObjectManager bom = JBOFactory.getBizObjectManager(CustomerConst.CUSTOMER_IMPORT_LOG);
		if(tx != null) tx.join(bom);
		BizObject biz = bom.createQuery("CustomerID=:customerID and LogType='1' order by serialNo desc")
								.setParameter("customerID", customerID).getSingleResult(false);
		if(biz != null){
			manage[0] = biz.getAttribute("UserID").getString();
			manage[1] = biz.getAttribute("OrgID").getString();
		}
		return manage;
	}
	
	/**
	 * �����ͻ������¼
	 * @param tx
	 * @param customerID �ͻ����
	 * @param userID �û����
	 * @param orgID �������
	 * @throws JBOException
	 */
/*	public void createImportLog(JBOTransaction tx,String customerID,String userID,String orgID) throws JBOException{
		this.logType = "2";
		createManageChangeLog(tx,customerID,userID,orgID);
	}
*/
}
