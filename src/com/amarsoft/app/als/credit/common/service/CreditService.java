package com.amarsoft.app.als.credit.common.service;

import com.amarsoft.app.als.apply.model.BusinessApprove;
import com.amarsoft.app.als.apply.model.BusinessContract;
import com.amarsoft.are.jbo.JBOTransaction;

/**
 * 其他模块调用授信方案模块入口
 * @author lyin
 *
 */
public class CreditService {
	
	
	/**
	 * 检查客户是否存在未终结的终审批复
	 * @return 
	 * @throws Exception 
	 */
	public String checkBusinessApprove(JBOTransaction tx,String customerID,String userID) throws Exception{
		BusinessApprove ba = new BusinessApprove(tx,null);
		String result = ba.checkBusinessApprove(customerID,userID);
		return result;
	}
	
	/**
	 * 检查客户是否存在未终结的业务合同
	 * @return 
	 * @throws Exception 
	 */
	public String checkBusinessContract(JBOTransaction tx,String customerID,String userID) throws Exception{
		BusinessContract ba = new BusinessContract(tx,null);
		String result = ba.checkBusinessContract(customerID,userID);
		return result;
	}
}