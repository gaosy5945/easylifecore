package com.amarsoft.app.als.database;

import java.util.ArrayList;
import java.util.List;

import com.amarsoft.are.jbo.BizObject;
import com.amarsoft.are.jbo.BizObjectManager;
import com.amarsoft.are.jbo.JBOException;
import com.amarsoft.are.jbo.JBOFactory;
import com.amarsoft.are.jbo.JBOTransaction;
import com.amarsoft.awe.util.ASResultSet;
import com.amarsoft.awe.util.SqlObject;
import com.amarsoft.awe.util.Transaction;

public class PerformanceHandler {
	
	/**
	 * @hzcheng
	 * 根据给定的数据库表条目数和增长幅度
	 * 计算与其关联的表的条目数和增长率
	 */

	private String RECORD;
	private String UPDAILY;
	private String NUM;
	private String REMARK;
	private ArrayList<String> tbno;


	public ArrayList<String> getTbno() {
		return tbno;
	}
	public void setTbno(ArrayList<String> tbno) {
		this.tbno = tbno;
	}
	public String getREMARK() {
		return REMARK;
	}
	public void setREMARK(String rEMARK) {
		REMARK = rEMARK;
	}
	public String getNUM() {
		return NUM;
	}
	public void setNUM(String nUM) {
		NUM = nUM;
	}
	public String getUPDAILY() {
		return UPDAILY;
	}
	public void setUPDAILY(String uPDAILY) {
		UPDAILY = uPDAILY;
	}
	public String getRECORD() {
		return RECORD;
	}
	public void setRECORD(String rECORD) {
		RECORD = rECORD;
	}
	//取数据库中BD表的记录数。
	public String calRownum(Transaction Sqlca) throws Exception{
		String rs1;
		rs1 = Sqlca.getString(new SqlObject("select count(*) from Business_duebill"));
		return rs1;
	}
	//取数据库中ATP表的记录数，确定是对其进行新增还是更新。
	public String calATPnum(Transaction Sqlca) throws Exception{
		String rs1;
		rs1 = Sqlca.getString(new SqlObject("select count(*) from ALS_TABLE_PERFORMANCE"));
		return rs1;
	}
	public String calculateRecord(JBOTransaction tx) throws JBOException {
		int temp = Integer.parseInt(this.RECORD);
		double temp1 = Integer.parseInt(this.UPDAILY);
		int temp2 = Integer.parseInt(this.NUM);
		BizObjectManager bm = JBOFactory.getFactory().getManager("jbo.app.ALS_TABLE");
		List<BizObject> al = bm.createQuery( "SELECT TBNO,RATE FROM O where tbno in (select distinct R.desttbname from jbo.app.ALS_TABLE_RELATIVE R where R.sourcetbname = 'BUSINESS_DUEBILL')" ).getResultList();
		BizObjectManager m = JBOFactory.getFactory().getManager("jbo.app.ALS_TABLE_PERFORMANCE");
		for( int i = 0; i < al.size(); i++ ){
			String tbname = al.get( i ).getAttribute( "TBNO" ).getString();
			double Temp = al.get( i ).getAttribute( "RATE" ).getDouble();
			if(temp2 == 0){
				BizObject bo = m.newObject();
				bo.setAttributeValue("TBNAME",tbname);
				bo.setAttributeValue("RECORD",temp*Temp);
				bo.setAttributeValue("RECORDRATE",temp1*Temp);
				bo.setAttributeValue("REMARK",REMARK);
				m.saveObject(bo);
			}
			else{
				m.createQuery("update O set RECORD =:record , RECORDRATE = :recordRATE ,REMARK = :REMARK where TBNAME =:tbname").setParameter("record", temp*Temp).setParameter("recordRATE", temp1*Temp).setParameter("REMARK",REMARK).setParameter("tbname",tbname).executeUpdate();
		
			}
		}
		
		return "SUCCESS";
	}
}
