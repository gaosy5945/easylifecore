package com.amarsoft.app.urge;

import com.amarsoft.awe.util.SqlObject;
import com.amarsoft.awe.util.Transaction;

public class ChangeExcutePerson {
private String serialNo;
private String operateuserid;

public String getSerialNo() {
	return serialNo;
}

public void setSerialNo(String serialNo) {
	this.serialNo = serialNo;
}
public String getOperateuserid() {
	return operateuserid;
}

public void setOperateuserid(String operateuserid) {
	this.operateuserid = operateuserid;
}

public Object execute(Transaction Sqlca) throws Exception{
    String returnValue="";
    String returnsql="";
    String sSql = "";  

    sSql = " select operateuserid from COLL_TASK where SERIALNO=:serialNo";

    returnsql= Sqlca.getString(sSql);
    if(returnsql!=null){
    	returnValue="existed";   
    }else{	
            String sql = "update COLL_TASK set operateuserid=:operateuserid where SERIALNO=:serialNo";
            SqlObject  so = new SqlObject(sql);
            so.setParameter("operateuserid", operateuserid);
            so.setParameter("serialNo", serialNo);
            Sqlca.executeSQL(so);
            returnValue="ok";         
    }
	return returnValue;
}

}
