package com.amarsoft.app.lending.bizlets;

import com.amarsoft.are.jbo.JBOTransaction;
import com.amarsoft.awe.util.ASResultSet;
import com.amarsoft.awe.util.SqlObject;
import com.amarsoft.awe.util.Transaction;

public class CheckAccountChangeCustomer{
	private String account;
	
	public String getAccount() {
		return account;
	}

	public void setAccount(String account) {
		this.account = account;
	}

	public Object  checkAccountChangeCustomer(JBOTransaction tx) throws Exception{
		//自动获得传入的参数值
		Transaction Sqlca = Transaction.createTransaction(tx);
		ASResultSet rs = null;
		String sExistAccount = "";
		String sFlag ="";
		String sAccount = this.account;
		String sSql = "select Account from ACCOUNT_INFO where Account =:Account ";
		rs = Sqlca.getASResultSet(new SqlObject(sSql).setParameter("Account", sAccount));
		if (rs.next()) {
			sExistAccount = rs.getString("Account");
		}
		rs.getStatement().close();

		if (sExistAccount == null)
			sExistAccount = "";
		if (sExistAccount.equals("")) {
			sFlag = "true";
		} else {
			sFlag = "false";
		}
		
		return sFlag;
	}
}
