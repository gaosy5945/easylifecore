/**
 * 		Author: --jqliang 2015-03-21
 * 		Tester:
 * 		Describe: --�½�������Ʒ�޶����
 * 		
*/

package com.amarsoft.app.lending.bizlets;

import com.amarsoft.awe.util.ASResultSet;
import com.amarsoft.awe.util.SqlObject;
import com.amarsoft.awe.util.Transaction;
import com.amarsoft.biz.bizlet.Bizlet;


public class CLGroupLimitCheck extends Bizlet 
{
	public Object  run(Transaction Sqlca) throws Exception
	{		
		//��ȡ�������������ͺͶ�����
		String sSerialNo = (String)this.getAttribute("SerialNo");
		String sOrgID = (String)this.getAttribute("OrgID");
		String sLIMITAMOUNT = (String)this.getAttribute("LIMITAMOUNT");//���峨��
		String sParameterID1 = (String)this.getAttribute("ParameterID1");
		if(sSerialNo == null) sSerialNo = "";
		if(sOrgID == null) sOrgID = "";
		if(sLIMITAMOUNT == null) sLIMITAMOUNT = "";
		if(sParameterID1==null) sParameterID1 = "";
		
		String sReturn = "true";
		ASResultSet rs = null;
		String sSql = "";
		int iNum = 0;
		double dUpOneLIMITAMOUNT = 0.00;//�ϼ����������峨��
		double dDownAllLIMITAMOUNT = 0.00;//�ϼ������������¼����������޶�(�ų�����)
		
		//���в�������
		if(!"9900".equals(sOrgID)){
			//һ���ϼ���������
			String sUpOneOrgName = Sqlca.getString("select OrgName from Org_Info where OrgID=(select RelativeOrgID from Org_Info where OrgID='"+sOrgID+"')");
			//1.�û������ϼ������Ƿ��Ƿ��Ѿ�ά��������Ʒ�޶�
			sSql = "select count(SerialNo) from CL_GROUP_LIMIT where OrgID=(select RelativeOrgID from Org_Info where OrgID=:OrgID) and ','||ParameterID1||',' like :ParameterID1 and Status='1'";
			rs = Sqlca.getASResultSet(new SqlObject(sSql).setParameter("OrgID", sOrgID).setParameter("ParameterID1", "%,"+sParameterID1+",%"));
			if(rs.next()){
				iNum = rs.getInt(1);
			}
			rs.getStatement().close();
			if(iNum>0){
				sSql = "select sum(LIMITAMOUNT) from CL_GROUP_LIMIT where OrgID=(select RelativeOrgID from Org_Info where OrgID=:OrgID) and ','||ParameterID1||',' like :ParameterID1 and Status='1'";
			    rs = Sqlca.getASResultSet(new SqlObject(sSql).setParameter("OrgID", sOrgID).setParameter("ParameterID1", "%,"+sParameterID1+",%"));
			    if(rs.next()){
			    	dUpOneLIMITAMOUNT = rs.getDouble(1);
			    }
			    rs.getStatement().close();
			    
			    //ȡ�ϼ��������е��¼������Ļ����޶�
			    sSql = "select sum(LIMITAMOUNT) from CL_GROUP_LIMIT cgl where cgl.Status='1' and ','||cgl.ParameterID1||',' like :ParameterID1 and "+
			           "exists(select 'x' from Org_Belong where cgl.OrgID=BelongOrgID and OrgID<>BelongOrgID  "+
			    		       "and OrgID = (select RelativeOrgID from Org_Info where OrgID=:OrgID))";
			    rs = Sqlca.getASResultSet(new SqlObject(sSql).setParameter("OrgID", sOrgID).setParameter("ParameterID1", "%,"+sParameterID1+",%"));
			    if(rs.next()){
			    	dDownAllLIMITAMOUNT = rs.getDouble(1);
			    }
			    rs.getStatement().close();
			    if(dDownAllLIMITAMOUNT+Double.valueOf(sLIMITAMOUNT)>dUpOneLIMITAMOUNT){
			    	
			    	sReturn = "�ϼ�����["+sUpOneOrgName+"]�Ļ�����Ʒ�޶��";
			    }
			}
		}
		
	    return sReturn;
	 }
	 

}
