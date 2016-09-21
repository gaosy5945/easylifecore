package com.amarsoft.app.lending.bizlets;

import com.amarsoft.awe.util.ASResultSet;
import com.amarsoft.awe.util.SqlObject;
import com.amarsoft.awe.util.Transaction;
import com.amarsoft.biz.bizlet.Bizlet;

/**
 * 
 * @author t-liuzq
 * 删除诉讼前案件信息时，做相关处理
 * 输入  案件信息流水号，输出 1
 */
public class DeleteLawCaseInfo extends Bizlet 
{

 public Object  run(Transaction Sqlca) throws Exception
	 {
		//自动获得传入的参数值		
		String sObjectNo   = (String)this.getAttribute("ObjectNo");
		
		//定义变量
		ASResultSet rs = null;
		String sSql = null;
		SqlObject so ;//声明对象

		//删除诉讼案件的台账信息
		sSql = 	" delete from LAWCASE_BOOK where LAWCASESERIALNO=:SERIALNO ";
	    so = new SqlObject(sSql).setParameter("SERIALNO", sObjectNo);
        Sqlca.executeSQL(so);
		//删除诉讼案件的关联信息
		sSql = 	" delete from LAWCASE_RELATIVE where OBJECTNO=:SERIALNO ";
	    so = new SqlObject(sSql).setParameter("SERIALNO", sObjectNo);
        Sqlca.executeSQL(so);
		//删除诉讼案件的关联人员信息
		sSql = 	" delete from LAWCASE_PERSONS where LAWCASESERIALNO=:SERIALNO ";
	    so = new SqlObject(sSql).setParameter("SERIALNO", sObjectNo);
        Sqlca.executeSQL(so);
        
		//删除诉讼案件信息表信息
		sSql = 	" delete from LAWCASE_INFO where SERIALNO=:SERIALNO ";
	    so = new SqlObject(sSql).setParameter("SERIALNO", sObjectNo);
        Sqlca.executeSQL(so);
	    return "1";
	 }

}
