package com.amarsoft.app.bizmethod;

import java.util.HashMap;

import com.amarsoft.are.jbo.JBOTransaction;
import com.amarsoft.awe.util.SqlObject;
import com.amarsoft.awe.util.Transaction;

/*
 * author 核算团队
 * description 来源于Class_Method---className='CustomerManage' ;
 * 用途：这是一个公用类，在这个类里面我们定义了不同的方法，每一个方法都是来自于Class_Method
 * */
public class ProjectManage {
	private String paras;//参数串
	private String splitStr;//分隔符参数:默认值@~@
	private String paraSplit;//参数与值的分隔：默认值@@
	public String getParas() {
		return paras;
	}
	public void setParas(String paras) {
		this.paras = paras;
	}
	public String getSplitStr() {
		return splitStr;
	}
	public void setSplitStr(String splitStr) {
		this.splitStr = splitStr;
	}
	public String getParaSplit() {
		return paraSplit;
	}
	public void setParaSplit(String paraSplit) {
		this.paraSplit = paraSplit;
	}
	
	/*
	 * 将项目信息与主体对象建立关联
	 * String ObjectNo,String ObjectType,String ProjectNo,String TableName
	 * insert into #TableName(ProjectNo,ObjectType,ObjectNo) values('#ProjectNo','#ObjectType','#ObjectNo')  
	 * */
	public String insertProjectRelative(JBOTransaction tx) throws Exception {
		Transaction Sqlca = Transaction.createTransaction(tx);
		String sqlStr = "insert into :TableName(ProjectNo,ObjectType,ObjectNo) values(:ProjectNo,:ObjectType,:ObjectNo)";
		HashMap<String, String> map = ParseAttirbutesTool.parseParas(sqlStr, sqlStr, sqlStr);
		SqlObject so = new SqlObject(sqlStr)
					.setParameter("ProjectNo", map.get("projectNo"))
					.setParameter("ObjectType", map.get("objectType"))
					.setParameter("ObjectNo", map.get("objectNo"))
					.setParameter("TableName", map.get("tableName"));
		int i = Sqlca.executeSQL(so);
		return i>0?"SUCCESS":"FALSE";
	}
}
