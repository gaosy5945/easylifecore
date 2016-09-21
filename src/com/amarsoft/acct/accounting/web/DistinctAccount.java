package com.amarsoft.acct.accounting.web;

import java.sql.SQLException;
import java.util.List;

import com.amarsoft.are.jbo.BizObject;
import com.amarsoft.are.jbo.BizObjectQuery;
import com.amarsoft.are.jbo.JBOException;
import com.amarsoft.are.jbo.JBOFactory;
import com.amarsoft.are.jbo.JBOTransaction;

public class DistinctAccount {
	private String objectNo;
	private String objectType;
	private String accountIndicator;
	private String serialNo;
	
	public String getObjectNo() {
		return objectNo;
	}

	public void setObjectNo(String objectNo) {
		this.objectNo = objectNo;
	}

	public String getObjectType() {
		return objectType;
	}

	public void setObjectType(String objectType) {
		this.objectType = objectType;
	}

	public String getAccountIndicator() {
		return accountIndicator;
	}

	public void setAccountIndicator(String accountIndicator) {
		this.accountIndicator = accountIndicator;
	}

	public String getSerialNo() {
		return serialNo;
	}


	public void setSerialNo(String serialNo) {
		this.serialNo = serialNo;
	}

	//获取数据库中的存款账户的个数,防止重复添加重复提交
	public String getAccountNumber(JBOTransaction tx) throws SQLException, JBOException{
		BizObjectQuery query = JBOFactory.getBizObjectManager("jbo.acct.ACCT_BUSINESS_ACCOUNT",tx)
		.createQuery(" ObjectNo=:ObjectNo and ObjectType=:ObjectType and AccountIndicator =:AccountIndicator" +
				" and SerialNo <> :SerialNo and status='0'");   //edit by ckxu 2015/12/30  @账号jywen 增加 and status='0'
		query.setParameter("ObjectNo", objectNo)
		.setParameter("ObjectType", objectType)
		.setParameter("AccountIndicator", accountIndicator)
		.setParameter("SerialNo", serialNo);
		 
		@SuppressWarnings("unchecked")
		List<BizObject> bos = query.getResultList(false);
		if(bos==null || bos.size()<=0){
			return "false";
		}
 		
		return Integer.toString(bos.size());
	}
}
