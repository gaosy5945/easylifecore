/*
		Author: --zywei 2006-08-18
		Tester:
		Describe: 更新抵质押物状态，并保存入库/出库痕迹
		Input Param:
			GuarantyID：抵质押物编号
			GuarantyStatus：抵质押物状态
			UserID：登记人编号	
		Output Param:

		HistoryLog:
*/

package com.amarsoft.app.lending.bizlets;

import com.amarsoft.are.jbo.JBOTransaction;
import com.amarsoft.are.util.StringFunction;
import com.amarsoft.awe.util.DBKeyHelp;
import com.amarsoft.awe.util.SqlObject;
import com.amarsoft.awe.util.Transaction;
import com.amarsoft.context.ASUser;


public class DistributeRiskSignal{
	private String objectNo;
	private String checkUser;
	
	public String getObjectNo() {
		return objectNo;
	}

	public void setObjectNo(String objectNo) {
		if(objectNo == null) objectNo = "";
		this.objectNo = objectNo;
	}

	public String getCheckUser() {
		return checkUser;
	}

	public void setCheckUser(String checkUser) {
		if(checkUser == null) checkUser = "";
		this.checkUser = checkUser;
	}

	public String  distributeRiskSignal(JBOTransaction tx) throws Exception
	 {
		Transaction Sqlca = Transaction.createTransaction(tx);
		SqlObject so ;//声明对象
		//定义变量
		String sCheckOrg = "",sCheckDate = "",sUpdateSql = "",sInsertSql = "";
				
		//获取系统日期
		sCheckDate = StringFunction.getToday();
		//获取用户所在机构
		ASUser CurUser = ASUser.getUser(checkUser,Sqlca);
		sCheckOrg = CurUser.getOrgID();
		//获得预警信息分发流水号
		String sROSerialNo = DBKeyHelp.getSerialNo("RISKSIGNAL_OPINION","SerialNo","",Sqlca);
		
		//更新预警信号的预警状态
		sUpdateSql = " update RISK_SIGNAL set SignalStatus = '20' "+
		 " where SerialNo =:SerialNo ";
		so = new SqlObject(sUpdateSql).setParameter("SerialNo", objectNo);
        Sqlca.executeSQL(so);
        sInsertSql = " insert into RISKSIGNAL_OPINION(ObjectNo,SerialNo,CheckUser,CheckOrg,CheckDate) "+
		 " values (:ObjectNo,:SerialNo,:CheckUser,:CheckOrg,:CheckDate) ";	
        so = new SqlObject(sInsertSql).setParameter("ObjectNo", objectNo).setParameter("SerialNo", sROSerialNo).setParameter("CheckUser", checkUser)
                .setParameter("CheckOrg", sCheckOrg).setParameter("CheckDate", sCheckDate);
        Sqlca.executeSQL(so); 
		return "1";
	 }
}
