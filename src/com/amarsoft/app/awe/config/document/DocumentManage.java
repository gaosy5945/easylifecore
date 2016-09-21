package com.amarsoft.app.awe.config.document;

import com.amarsoft.are.ARE;
import com.amarsoft.awe.util.ASResultSet;
import com.amarsoft.awe.util.SqlObject;
import com.amarsoft.awe.util.Transaction;

public class DocumentManage {

	/**
	 * 通过文件存储路径，删除物理文档
	 * @param sTableName 文档记录表 
	 * @param sWhereClause 查询条件
	 * @param Sqlca
	 * @throws Exception
	 */
	public static void delDocFile(String sTableName, String sWhereClause, Transaction Sqlca) throws Exception{
		if(sTableName == null) sTableName = "";
		if(sWhereClause == null) sWhereClause = "1=2";
		//定义变量
		String sFullPath = "";
		//获得文件存储路径
		String sSql = " select fullpath from " + sTableName + " where "+ sWhereClause ; 	
		ASResultSet rs = Sqlca.getASResultSet(sSql);
		//可删除多选
		while(rs.next()){
			sFullPath = rs.getStringValue(1);				
			if(sFullPath==null) sFullPath="";		
			java.io.File file = new java.io.File(sFullPath);
			try{
				file.delete();
			}catch(Exception e){
				ARE.getLog().error(e.getMessage(),e);
			}
		}
		rs.close();
	}
	
	/**
	 * 删除文档关联信息
	 * @param sDocNo 文档编号
	 * @param Sqlca
	 * @throws Exception
	 */
	public static void delDocRelative(String sDocNo, Transaction Sqlca) throws Exception{
		if(sDocNo == null) sDocNo = "";
		
		Sqlca.executeSQL(new SqlObject(" delete from DOC_RELATIVE where DocNo = :DocNo").setParameter("DocNo", sDocNo));
	    Sqlca.executeSQL(new SqlObject(" delete from DOC_ATTACHMENT where DocNo = :DocNo").setParameter("DocNo", sDocNo));
	}
	
	/**
	 * 插入文档关联表信息
	 * @param sDocNo
	 * @param sObjectType
	 * @param sObjectNo
	 * @param Sqlca
	 * @throws Exception
	 */
	public static void insertDocRelative(String sDocNo, String sObjectType, String sObjectNo, Transaction Sqlca) throws Exception{
		SqlObject so = new SqlObject("insert into DOC_RELATIVE(DocNo,ObjectType,ObjectNo) values(:DocNo,:ObjectType,:ObjectNo)");
		so.setParameter("DocNo", sDocNo).setParameter("ObjectType", sObjectType).setParameter("ObjectNo", sObjectNo);
		Sqlca.executeSQL(so);
	}
}
