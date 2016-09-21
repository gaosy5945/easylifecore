package com.amarsoft.app.als.database;

import com.amarsoft.are.jbo.BizObjectManager;
import com.amarsoft.are.jbo.JBOException;
import com.amarsoft.are.jbo.JBOFactory;
import com.amarsoft.are.jbo.JBOTransaction;
import com.amarsoft.awe.util.SqlObject;
import com.amarsoft.awe.util.Transaction;

public class MetaDataHandler {
	
	/**
	 * @hzcheng
	 * 根据对数据表结构进行的删除和更新操作，
	 * 对于关联关系表进行对应的操作。
	 */
	
	private String TableName;
	private String ColName;
	private String ColName1;
	private String CodeNo;

	public String getCodeNo() {
		return CodeNo;
	}
	public void setCodeNo(String codeNo) {
		CodeNo = codeNo;
	}
	public String getColName1() {
		return ColName1;
	}
	public void setColName1(String colName1) {
		ColName1 = colName1;
	}
	
	public String getTableNameo() {
		return TableName;
	}
	public String getColName() {
		return ColName;
	}
	public void setTableName(String TableName) {
		this.TableName = TableName;
	}
	
	public void setColName(String ColName) {
		this.ColName = ColName;
	}
	//删除后操作
	public String getTableName(Transaction Sqlca) throws Exception{
		String rs1;
		rs1 = Sqlca.getString(new SqlObject("SELECT ITEMNAME FROM code_library where codeno = 'TableName' and itemno = :CodeNo").setParameter("CodeNo",CodeNo));
		return rs1;
	}
	public String AfterDelete(JBOTransaction tx) throws JBOException {
		String s1 = ColName+'%' ;
		BizObjectManager m = JBOFactory.getFactory().getManager("jbo.app.ALS_TABLE_RELATIVE");
		tx.join(m);
		m.createQuery("delete from O where RELATBNAME =:TableName AND (SOURCE4RELACOL like '"+s1+"' OR DEST4RELACOL like '"+s1+"')").setParameter("TableName", TableName).executeUpdate();
		m.createQuery("delete from O where SOURCETBNAME =:TableName AND SOURCECOL like '"+s1+"'").setParameter("TableName", TableName).executeUpdate();
		m.createQuery("delete from O where DESTTBNAME =:TableName AND DESTCOL like '"+s1+"' ").setParameter("TableName", TableName).executeUpdate();
		
		return "SUCCESS";
	}
	//更新后操作
	public String AfterUpdate(JBOTransaction tx) throws JBOException {
		BizObjectManager m = JBOFactory.getFactory().getManager("jbo.app.ALS_TABLE_RELATIVE");
		tx.join(m);
		m.createQuery("update O set SOURCE4RELACOL =:ColName1 where RELATBNAME =:TableName AND SOURCE4RELACOL = :ColName").setParameter("TableName", TableName).setParameter("ColName", ColName).setParameter("ColName1", ColName1).executeUpdate();
		m.createQuery("update O set DEST4RELACOL =:ColName1 where RELATBNAME =:TableName AND DEST4RELACOL = :ColName").setParameter("TableName", TableName).setParameter("ColName", ColName).setParameter("ColName1", ColName1).executeUpdate();
		m.createQuery("update O set SOURCECOL =:ColName1 where SOURCETBNAME =:TableName AND SOURCECOL = :ColName").setParameter("TableName", TableName).setParameter("ColName", ColName).setParameter("ColName1", ColName1).executeUpdate();
		m.createQuery("update O set DESTCOL =:ColName1 where DESTTBNAME =:TableName AND DESTCOL = :ColName").setParameter("TableName", TableName).setParameter("ColName", ColName).setParameter("ColName1", ColName1).executeUpdate();
		
		return "SUCCESS";
	}
	
}
