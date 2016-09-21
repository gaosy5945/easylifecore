package com.amarsoft.app.lending.bizlets;

import com.amarsoft.awe.util.ASResultSet;
import com.amarsoft.awe.util.SqlObject;
import com.amarsoft.awe.util.Transaction;
import com.amarsoft.biz.bizlet.Bizlet;

/**
 * 
 * @author t-liuzq
 * ɾ������ǰ������Ϣʱ������ش���
 * ����  ������Ϣ��ˮ�ţ���� 1
 */
public class DeleteLawCaseInfo extends Bizlet 
{

 public Object  run(Transaction Sqlca) throws Exception
	 {
		//�Զ���ô���Ĳ���ֵ		
		String sObjectNo   = (String)this.getAttribute("ObjectNo");
		
		//�������
		ASResultSet rs = null;
		String sSql = null;
		SqlObject so ;//��������

		//ɾ�����ϰ�����̨����Ϣ
		sSql = 	" delete from LAWCASE_BOOK where LAWCASESERIALNO=:SERIALNO ";
	    so = new SqlObject(sSql).setParameter("SERIALNO", sObjectNo);
        Sqlca.executeSQL(so);
		//ɾ�����ϰ����Ĺ�����Ϣ
		sSql = 	" delete from LAWCASE_RELATIVE where OBJECTNO=:SERIALNO ";
	    so = new SqlObject(sSql).setParameter("SERIALNO", sObjectNo);
        Sqlca.executeSQL(so);
		//ɾ�����ϰ����Ĺ�����Ա��Ϣ
		sSql = 	" delete from LAWCASE_PERSONS where LAWCASESERIALNO=:SERIALNO ";
	    so = new SqlObject(sSql).setParameter("SERIALNO", sObjectNo);
        Sqlca.executeSQL(so);
        
		//ɾ�����ϰ�����Ϣ����Ϣ
		sSql = 	" delete from LAWCASE_INFO where SERIALNO=:SERIALNO ";
	    so = new SqlObject(sSql).setParameter("SERIALNO", sObjectNo);
        Sqlca.executeSQL(so);
	    return "1";
	 }

}
