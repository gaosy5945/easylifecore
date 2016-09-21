package com.amarsoft.app.bizmethod;

import java.util.HashMap;

import com.amarsoft.are.jbo.JBOTransaction;
import com.amarsoft.awe.util.SqlObject;
import com.amarsoft.awe.util.Transaction;

/*
 * author �����Ŷ�
 * description ��Դ��Class_Method---className='CustomerManage' ;
 * ��;������һ�������࣬��������������Ƕ����˲�ͬ�ķ�����ÿһ����������������Class_Method
 * */
public class ProjectManage {
	private String paras;//������
	private String splitStr;//�ָ�������:Ĭ��ֵ@~@
	private String paraSplit;//������ֵ�ķָ���Ĭ��ֵ@@
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
	 * ����Ŀ��Ϣ���������������
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
