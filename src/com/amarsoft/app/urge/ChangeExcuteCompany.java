package com.amarsoft.app.urge;

import com.amarsoft.awe.util.SqlObject;
import com.amarsoft.awe.util.Transaction;

public class ChangeExcuteCompany {
private String serialNo;
private String operateuserid;
private String taskbatchno;

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

public String getTaskbatchno() {
	return taskbatchno;
}

public void setTaskbatchno(String taskbatchno) {
	this.taskbatchno = taskbatchno;
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
            String sql = "update COLL_TASK set operateuserid=:operateuserid, TASKBATCHNO=:TASKBATCHNO where SERIALNO=:serialNo";
            SqlObject  so = new SqlObject(sql);
            so.setParameter("operateuserid", operateuserid);
            so.setParameter("serialNo", serialNo);
            so.setParameter("TASKBATCHNO", taskbatchno);
            Sqlca.executeSQL(so);
            returnValue="ok";         
    }
	return returnValue;
}

}
