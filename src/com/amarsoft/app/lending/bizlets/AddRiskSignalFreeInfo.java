/*
		Author: --zywei 2005-08-13
		Tester:
		Describe: --������׼��Ԥ����Ϣ���Ƶ�Ԥ����Ϣ�����
		Input Param:
				ObjectNo: ��׼��Ԥ����Ϣ���				
		Output Param:
				SerialNo����ˮ��
		HistoryLog:
*/
package com.amarsoft.app.lending.bizlets;

import com.amarsoft.are.jbo.JBOTransaction;
import com.amarsoft.are.util.StringFunction;
import com.amarsoft.awe.util.DBKeyHelp;
import com.amarsoft.awe.util.Transaction;
import com.amarsoft.context.ASUser;


public class AddRiskSignalFreeInfo{
	String objectNo;//�������׼Ԥ����Ϣ��ˮ��
	String userID;//��ȡ��ǰ�û�
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
		//�����ˮ��
		String serialNo = DBKeyHelp.getSerialNo("RISK_SIGNAL","SerialNo","",Sqlca);
		//���������SQL���
		String sSql = "";		
						
		//ʵ�����û�����
		ASUser CurUser = ASUser.getUser(userID,Sqlca);
		
		//������׼����Ϣ���Ƶ�Ԥ����Ϣ�����
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
