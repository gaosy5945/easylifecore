package com.amarsoft.app.als.detaildesign;

import java.sql.SQLException;

import com.amarsoft.awe.util.ASResultSet;
import com.amarsoft.awe.util.SqlObject;
import com.amarsoft.awe.util.Transaction;

public class detaildesignHandler {

	/**
	 * @param args
	 * @throws Exception 
	 */
	public String getModulecount(Transaction Sqlca) throws Exception {
		String result="";
		String sSql="Select unique(Module) as Module From ALS_Design";
		ASResultSet rs=Sqlca.getASResultSet(new SqlObject(sSql));
		while(rs.next()){
			result+="@"+rs.getString("Module");
		}
		return result.substring(1);
	}
	
	public String getFunccount(Transaction Sqlca, String Module) throws Exception {
		String result="";
		String sSql="Select unique(FuncName) as FuncName From ALS_Design Where Module=:Module";
		ASResultSet rs=Sqlca.getASResultSet(new SqlObject(sSql).setParameter("Module", Module));
		while(rs.next()){
			result+="@"+rs.getString("FuncName");
		}
		return result.substring(1);
	}

	public String getDono(Transaction  Sqlca, String Module,String FuncName) throws Exception {
		String result="";
		String sSql="select dono from ALS_DESIGN where Module=:Module and FuncName=:FuncName order by donoserial";
		ASResultSet rs=Sqlca.getASResultSet(new SqlObject(sSql).setParameter("Module", Module).setParameter("FuncName", FuncName));
		while(rs.next()){
			result+="@"+rs.getString("dono");
		}
		return result.substring(1);
	}
}
