package com.amarsoft.app.urge;

import com.amarsoft.awe.util.DBKeyHelp;
import com.amarsoft.awe.util.SqlObject;
import com.amarsoft.awe.util.Transaction;

public class AddtoCollTask {
	private String objectno;

	public String getObjectno() {
		return objectno;
	}

	public void setObjectno(String objectno) {
		this.objectno = objectno;
	}

	public Object execute(Transaction Sqlca) throws Exception {

		String[] you = objectno.split("@");
		String returnValue = "";
		// 多比记录循环插入
		for (String element : you) {
			String sql = "insert into COLL_TASK (SERIALNO,OBJECTTYPE,OBJECTNO) values(:serialNo,'jbo.acct.ACCT_LOAN',:objectno)";
			SqlObject so = new SqlObject(sql);
			so.setParameter("serialNo",
					DBKeyHelp.getSerialNo("COLL_TASK", "SERIALNO"));
			so.setParameter("objectno", element);
			Sqlca.executeSQL(so);
		}

		returnValue = "ok";

		return returnValue;
	}

}
