package com.amarsoft.app.configurator.bizlets;

import java.sql.PreparedStatement;
import java.sql.SQLException;
import java.text.DecimalFormat;

import com.amarsoft.are.jbo.JBOTransaction;
import com.amarsoft.awe.util.SqlObject;
import com.amarsoft.awe.util.Transaction;

public class GenerateCodeCatalogSortNo{
	
	/*
	 * @modify ckxu
	 * @date 12/09/2015
	 * @description getStringMatrix方法涉及到了系统的方法
	 */
	public String generateCodeCatalogSortNo(JBOTransaction tx) throws Exception {
		Transaction Sqlca = Transaction.createTransaction(tx);
		SqlObject so = null;
		//放入2维数组
		String sSql = "select CODENO,SORTNO,CODETYPEONE,CODETYPETWO,CODENAME from CODE_CATALOG where CodeTypeTwo is not null order by CODETYPEONE,CODETYPETWO"; 
		so = new SqlObject(sSql);
		String[][] sCodeCatalog = Sqlca.getStringMatrix(so);


		sSql = "select CODETYPEONE,count(*) from CODE_CATALOG where CodeTypeTwo is not null group by CODETYPEONE order by CODETYPEONE"; 
		so = new SqlObject(sSql);
		String[][] sCodeTypeOne = Sqlca.getStringMatrix(so);
		
		for(int i=0;i<sCodeTypeOne.length;i++){
			sSql = "insert into CODE_CATALOG(CODENO,SORTNO,CODETYPEONE,CODETYPETWO,CODENAME) " +
					"values('"+new DecimalFormat("000").format(i+1)+"0"+"'," +
					"'"+new DecimalFormat("000").format(i+1)+"0"+"',:CODETYPEONE,null,:CODENAME)";
			so = new SqlObject(sSql).setParameter("CODETYPEONE", sCodeTypeOne[i][0]).setParameter("CODENAME", sCodeTypeOne[i][0]);
			try{
				Sqlca.executeSQL(so);
			}catch(Exception ex){
			}
		}
		
		for(int i=0;i<sCodeTypeOne.length;i++){
			String s1 = new DecimalFormat("000").format(i+1);
			int n = 0;
			for(int j=0;j<sCodeCatalog.length;j++){
				if(sCodeCatalog[j][2]!=null && sCodeCatalog[j][2].equals(sCodeTypeOne[i][0])){
					n++;
					String s2 = new DecimalFormat("000").format(n);
					sCodeCatalog[j][1]=s1+"0"+s2+"0";
				}
			}
		}
		
		//将2维数组更新到数据库
		sSql = "update CODE_CATALOG set SORTNO=? where CODENO=?";
		PreparedStatement pstm = Sqlca.getConnection().prepareStatement(sSql);

		for(int i=0;i<sCodeCatalog.length;i++){
			pstm.setString(1, sCodeCatalog[i][1]);
			pstm.setString(2, sCodeCatalog[i][0]);
			pstm.addBatch();
		}
		try{
			pstm.executeBatch();
		}catch(Exception ex){
			throw new Exception("更新数据库失败："+ex);
		}
		
		// 关闭数据库资源
		if (pstm != null) {
			try{
				pstm.close();
				pstm = null;
			}catch(SQLException e){}
		}
		
		return "succeeded";
	}
	
}
