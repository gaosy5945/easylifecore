package com.amarsoft.app.als.customer.common.action;

import com.amarsoft.app.als.customer.model.CustomerConst;
import com.amarsoft.are.jbo.BizObject;
import com.amarsoft.are.jbo.BizObjectManager;
import com.amarsoft.are.jbo.JBOException;
import com.amarsoft.are.jbo.JBOFactory;
import com.amarsoft.are.jbo.JBOTransaction;
import com.amarsoft.are.util.StringFunction;

/**
 * 客户管理记录维护
 * @author wmZhu
 *
 */
public class CustomerBelongChangeLog {
	
	private String logType = "1";//默认为管户人变更记录
	
	/**
	 * 创建管护人变更记录
	 * @param tx
	 * @param customerID 客户编号
	 * @param userID 新管护人
	 * @param orgID 新管护机构
	 * @param oldUser 旧管护人
	 * @param oldOrg 旧管护机构
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
		this.logType = "1";//复原默认值
	}*/
	
	/**
	 * 根据客户管护人变更记录获取最新的一个管护人信息
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
	 * 创建客户引入记录
	 * @param tx
	 * @param customerID 客户编号
	 * @param userID 用户编号
	 * @param orgID 机构编号
	 * @throws JBOException
	 */
/*	public void createImportLog(JBOTransaction tx,String customerID,String userID,String orgID) throws JBOException{
		this.logType = "2";
		createManageChangeLog(tx,customerID,userID,orgID);
	}
*/
}
