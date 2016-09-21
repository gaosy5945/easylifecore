package com.amarsoft.app.lending.bizlets;

import com.amarsoft.are.ARE;
import com.amarsoft.are.jbo.JBOTransaction;
import com.amarsoft.awe.util.SqlObject;
import com.amarsoft.awe.util.Transaction;

/**
 *  Description:   ��Bizlet���ڼ��������϶������ҳ��ѡ��øü��ŵĸ����ų�Ա������ĸ��˾���ӹ�˾���������ĸ����ֶδ���
 *                 �����ڼ��Ź�������ҳ��RelationList.jsp�б����߼���GROUP_RESULT���������ļ�¼�����ڸü�¼�����뱾�ι�
 *                 ����������д�ļ���ĸ��˾ID�����ֻ��һ��ĸ��˾��Ҳ����û��ĸ��˾�����ӹ�˾ID����<p>
 *         Time:   2015/12/10    
 *       @author   ���� 
 *             
 */
public class SaveGroupRela{
	private	String sSerialNo;
	private	String sRelaMaStr;
	private	String sRelaChildStr;	
	
	/*
	 *  @param   SerialNo,RelaMaStr,RelaChildStr 
	 *  @return 1 �ɹ�
	 *          2 û��ѡ���ӹ�˾,�ӹ�˾�Ǳ�����
	 */
	public String  saveGroupRela(JBOTransaction tx) throws Exception{
		Transaction Sqlca = Transaction.createTransaction(tx);
		//���崫���������������������¼��ˮ�ţ���GROUP_RESULT��¼����ˮ�ţ���ĸ��˾ID���ӹ�˾ID����
		if(sSerialNo == null) sSerialNo = "";
		if(sRelaMaStr == null) sRelaMaStr = "";
		if(sRelaChildStr == null || sRelaChildStr.equals("")) return "2";	
						
		//�������		
		String sSql ="";	

		try{
			//���еļ�¼�����¡�
			sSql ="update GROUP_RESULT set RelaMacustid =:RelaMacustid ,RelaChildcustid =:RelaChildcustid where SerialNo =:SerialNo ";
			SqlObject so = new SqlObject(sSql).setParameter("RelaMacustid", sRelaMaStr).setParameter("RelaChildcustid", sRelaChildStr).setParameter("SerialNo", sSerialNo);
			Sqlca.executeSQL(so);
		}
		catch(Exception e){
			ARE.getLog().error(e.getMessage());
			throw new Exception(e);
		}	
		return "1";
		
	}

}
