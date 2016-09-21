/**
 * 		Author: --jqliang 2015-03-21
 * 		Tester:
 * 		Describe: --新建机构产品限额检验
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
		//获取参数：对象类型和对象编号
		String sSerialNo = (String)this.getAttribute("SerialNo");
		String sOrgID = (String)this.getAttribute("OrgID");
		String sLIMITAMOUNT = (String)this.getAttribute("LIMITAMOUNT");//名义敞口
		String sParameterID1 = (String)this.getAttribute("ParameterID1");
		if(sSerialNo == null) sSerialNo = "";
		if(sOrgID == null) sOrgID = "";
		if(sLIMITAMOUNT == null) sLIMITAMOUNT = "";
		if(sParameterID1==null) sParameterID1 = "";
		
		String sReturn = "true";
		ASResultSet rs = null;
		String sSql = "";
		int iNum = 0;
		double dUpOneLIMITAMOUNT = 0.00;//上级机构的名义敞口
		double dDownAllLIMITAMOUNT = 0.00;//上级机构的所有下级机构名义限额(排除本笔)
		
		//总行不做限制
		if(!"9900".equals(sOrgID)){
			//一级上级机构名称
			String sUpOneOrgName = Sqlca.getString("select OrgName from Org_Info where OrgID=(select RelativeOrgID from Org_Info where OrgID='"+sOrgID+"')");
			//1.该机构的上级机构是否是否已经维护机构产品限额
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
			    
			    //取上级机构所有的下级机构的机构限额
			    sSql = "select sum(LIMITAMOUNT) from CL_GROUP_LIMIT cgl where cgl.Status='1' and ','||cgl.ParameterID1||',' like :ParameterID1 and "+
			           "exists(select 'x' from Org_Belong where cgl.OrgID=BelongOrgID and OrgID<>BelongOrgID  "+
			    		       "and OrgID = (select RelativeOrgID from Org_Info where OrgID=:OrgID))";
			    rs = Sqlca.getASResultSet(new SqlObject(sSql).setParameter("OrgID", sOrgID).setParameter("ParameterID1", "%,"+sParameterID1+",%"));
			    if(rs.next()){
			    	dDownAllLIMITAMOUNT = rs.getDouble(1);
			    }
			    rs.getStatement().close();
			    if(dDownAllLIMITAMOUNT+Double.valueOf(sLIMITAMOUNT)>dUpOneLIMITAMOUNT){
			    	
			    	sReturn = "上级机构["+sUpOneOrgName+"]的机构产品限额不足";
			    }
			}
		}
		
	    return sReturn;
	 }
	 

}
