package com.amarsoft.app.awe.config.document;

import com.amarsoft.are.ARE;
import com.amarsoft.awe.util.ASResultSet;
import com.amarsoft.awe.util.SqlObject;
import com.amarsoft.awe.util.Transaction;

public class DocumentManage {

	/**
	 * ͨ���ļ��洢·����ɾ�������ĵ�
	 * @param sTableName �ĵ���¼�� 
	 * @param sWhereClause ��ѯ����
	 * @param Sqlca
	 * @throws Exception
	 */
	public static void delDocFile(String sTableName, String sWhereClause, Transaction Sqlca) throws Exception{
		if(sTableName == null) sTableName = "";
		if(sWhereClause == null) sWhereClause = "1=2";
		//�������
		String sFullPath = "";
		//����ļ��洢·��
		String sSql = " select fullpath from " + sTableName + " where "+ sWhereClause ; 	
		ASResultSet rs = Sqlca.getASResultSet(sSql);
		//��ɾ����ѡ
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
	 * ɾ���ĵ�������Ϣ
	 * @param sDocNo �ĵ����
	 * @param Sqlca
	 * @throws Exception
	 */
	public static void delDocRelative(String sDocNo, Transaction Sqlca) throws Exception{
		if(sDocNo == null) sDocNo = "";
		
		Sqlca.executeSQL(new SqlObject(" delete from DOC_RELATIVE where DocNo = :DocNo").setParameter("DocNo", sDocNo));
	    Sqlca.executeSQL(new SqlObject(" delete from DOC_ATTACHMENT where DocNo = :DocNo").setParameter("DocNo", sDocNo));
	}
	
	/**
	 * �����ĵ���������Ϣ
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
