package com.amarsoft.app.als.database;


import com.amarsoft.awe.util.ASResultSet;
import com.amarsoft.awe.util.SqlObject;
import com.amarsoft.awe.util.Transaction;



public class DoNoRelacol {

	/**
	 * @hzcheng
	 * 根据数据表字段名找出其对应的显示模板名称
	 */
	public String tbNo;
	public String colName;
	
	public String getColName() {
		return colName;
	}

	public void setColName(String colName) {
		this.colName = colName;
	}

	public String getTbNo() {
		return tbNo;
	}

	public void setTbNo(String tbNo) {
		this.tbNo = tbNo;
	}
	public String getdono(Transaction Sqlca) throws Exception{
		String sResult="";
		ASResultSet rs=null;
		String 	sSql="SELECT dc.dono FROM dataobject_catalog dc, dataobject_library dl where dc.doupdatetable=:table and dc.dono=dl.dono and upper(dl.colname)=:colname";
		SqlObject so=new SqlObject(sSql);
		so.setParameter("table", tbNo).setParameter("colname", colName);
		rs=Sqlca.getASResultSet(so);
		while(rs.next())
		{
			sResult+="@"+rs.getString(1);
		}
		if(sResult ==""||sResult ==null)
			return "";
		else
			return sResult.substring(1);	
	}
}
