/*
		Author: --zywei 2006-08-18
		Tester:
		Describe: ���µ���Ѻ��״̬�����������/����ۼ�
		Input Param:
			GuarantyID������Ѻ����
			GuarantyStatus������Ѻ��״̬
			UserID���Ǽ��˱��	
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
		SqlObject so ;//��������
		//�������
		String sCheckOrg = "",sCheckDate = "",sUpdateSql = "",sInsertSql = "";
				
		//��ȡϵͳ����
		sCheckDate = StringFunction.getToday();
		//��ȡ�û����ڻ���
		ASUser CurUser = ASUser.getUser(checkUser,Sqlca);
		sCheckOrg = CurUser.getOrgID();
		//���Ԥ����Ϣ�ַ���ˮ��
		String sROSerialNo = DBKeyHelp.getSerialNo("RISKSIGNAL_OPINION","SerialNo","",Sqlca);
		
		//����Ԥ���źŵ�Ԥ��״̬
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
