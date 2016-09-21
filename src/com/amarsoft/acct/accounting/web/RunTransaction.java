package com.amarsoft.acct.accounting.web;
/**
 * 2015-11-23
 * ckxu 
 * 根据交易流水号调用交易
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
		BusinessObjectManager bom =BusinessObjectManager.createBusinessObjectManager(tx);//创建对象管理器
		try{
			 
			if(transactionSerialNo == null) transactionSerialNo = "";
			if(userID == null) userID = "";
			if(orgID == null) orgID = "";
			//锁定该笔交易，防止重复点击//锁定状态将该交易的状态转变成为已执行
			int i=JBOFactory.getBizObjectManager("jbo.acct.ACCT_TRANSACTION",tx)
			.createQuery("update O set TransStatus=TransStatus where TransStatus = '0' and SerialNo = :SerialNo")
			.setParameter("SerialNo",transactionSerialNo)
			.executeUpdate();
			
			if(i == 0) messageError = "false@系统正在处理，请勿重复点击！";
			
			BusinessObject transaction = TransactionHelper.loadTransaction(transactionSerialNo, bom);//加载交易
			if(!"0".equals(transaction.getString("TransStatus"))){
				messageError = "false@错误原因：交易状态不正常，确认是否已记账！";
				return messageError;
			}
			if(!"".equals(transaction.getString("TransDate")) && transaction.getString("TransDate").compareTo(DateHelper.getBusinessDate())>0 && "N".equals(flag))
			{
				ARE.getLog().info("交易【"+transaction.getKeyString()+"】已经预约到【"+transaction.getString("TransDate")+"】");
				transaction.setAttributeValue("TransStatus", "3");
				bom.updateBusinessObject(transaction);
			}else{
				transaction.setAttributeValue("TransDate",DateHelper.getBusinessDate());//设置交易实际执行日期
				TransactionHelper.executeTransaction(transaction, bom);//执行交易
			}
			bom.updateDB();
			bom.commit();
			messageError = "true@交易成功";
			return messageError;
		}
		catch(Exception e){
			bom.rollback();
			ARE.getLog().debug("系统出错", e);
			e.printStackTrace();
			messageError =  "false@错误原因："+e.getMessage();
			throw e;
		}
	}
	
	public String cancel(JBOTransaction tx) throws Exception{
		JBOFactory.getBizObjectManager("jbo.acct.ACCT_TRANSACTION",tx)
			.createQuery("update O set TransStatus = '2' where SerialNo = :SerialNo")
			.setParameter("SerialNo",transactionSerialNo)
			.executeUpdate();
		
		return "true@交易已取消。";
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
