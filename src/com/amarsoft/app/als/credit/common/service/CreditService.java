package com.amarsoft.app.als.credit.common.service;

import com.amarsoft.app.als.apply.model.BusinessApprove;
import com.amarsoft.app.als.apply.model.BusinessContract;
import com.amarsoft.are.jbo.JBOTransaction;

/**
 * ����ģ��������ŷ���ģ�����
 * @author lyin
 *
 */
public class CreditService {
	
	
	/**
	 * ���ͻ��Ƿ����δ�ս����������
	 * @return 
	 * @throws Exception 
	 */
	public String checkBusinessApprove(JBOTransaction tx,String customerID,String userID) throws Exception{
		BusinessApprove ba = new BusinessApprove(tx,null);
		String result = ba.checkBusinessApprove(customerID,userID);
		return result;
	}
	
	/**
	 * ���ͻ��Ƿ����δ�ս��ҵ���ͬ
	 * @return 
	 * @throws Exception 
	 */
	public String checkBusinessContract(JBOTransaction tx,String customerID,String userID) throws Exception{
		BusinessContract ba = new BusinessContract(tx,null);
		String result = ba.checkBusinessContract(customerID,userID);
		return result;
	}
}