/*
		Author: --zywei 2005-08-13
		Tester:
		Describe: --将已批准的预警信息复制到预警信息解除中
		Input Param:
				ObjectNo: 批准的预警信息编号				
		Output Param:
				SerialNo：流水号
		HistoryLog:
*/
package com.amarsoft.app.lending.bizlets;

import com.amarsoft.are.jbo.JBOTransaction;
import com.amarsoft.are.util.StringFunction;
import com.amarsoft.awe.util.DBKeyHelp;
import com.amarsoft.awe.util.Transaction;
import com.amarsoft.context.ASUser;


public class AddRiskSignalFreeInfo{
	String objectNo;//获得已批准预警信息流水号
	String userID;//获取当前用户
	public String getObjectNo() {
		return objectNo;
	}

	public void setObjectNo(String objectNo) {
		if(objectNo == null) objectNo = "";		
		this.objectNo = objectNo;
	}

	public String getUserID() {
		
		return userID;
	}

	public void setUserID(String userID) {
		if(userID == null) userID = "";
		this.userID = userID;
	}

	public String addRiskSignalFreeInfo(JBOTransaction tx) throws Exception{		
		Transaction Sqlca = Transaction.createTransaction(tx);
		//获得流水号
		String serialNo = DBKeyHelp.getSerialNo("RISK_SIGNAL","SerialNo","",Sqlca);
		//定义变量：SQL语句
		String sSql = "";		
						
		//实例化用户对象
		ASUser CurUser = ASUser.getUser(userID,Sqlca);
		
		//将已批准的信息复制到预警信息解除中
		sSql =  "insert into RISK_SIGNAL ( "+
					"ObjectType, "+          
					"ObjectNo, "+
					"SerialNo, "+
					"RelativeSerialNo, "+ 
					"SignalType, "+
					"SignalStatus, "+
					"InputOrgID, "+
					"InputUserID, "+
					"InputDate, "+
					"UpdateDate, "+
					"Remark, "+
					"SignalNo, "+
					"SignalName, "+
					"MessageOrigin, "+ 
					"MessageContent, "+
					"ActionFlag, "+
					"ActionType, "+											
					"FreeReason, "+
					"SignalChannel) "+					
					"select "+ 
					"ObjectType, "+          
					"ObjectNo, "+
					"'"+serialNo+"', "+
					"'"+objectNo+"', "+ 
					"'02', "+
					"'10', "+
					"'"+CurUser.getOrgID()+"', " + 
					"'"+CurUser.getUserID()+"', " +
					"'"+StringFunction.getToday()+"', " + 
					"'"+StringFunction.getToday()+"', " + 
					"'', "+
					"SignalNo, "+
					"SignalName, "+
					"MessageOrigin, "+ 
					"MessageContent, "+
					"ActionFlag, "+
					"ActionType, "+		
					"FreeReason, "+
					"SignalChannel "+					
					"from RISK_SIGNAL " +
					"where SerialNo='"+objectNo+"'";
		Sqlca.executeSQL(sSql);		
				
		return serialNo;
	}	
}
