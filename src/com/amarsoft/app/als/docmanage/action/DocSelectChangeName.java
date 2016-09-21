package com.amarsoft.app.als.docmanage.action;

import com.amarsoft.app.base.util.DateHelper;
import com.amarsoft.are.jbo.BizObject;
import com.amarsoft.are.jbo.BizObjectManager;
import com.amarsoft.are.jbo.BizObjectQuery;
import com.amarsoft.are.jbo.JBOFactory;
import com.amarsoft.awe.util.DBKeyHelp;
import com.amarsoft.dict.als.cache.NameCache;

/**
 * �������Ϲ���ģ�飺
 *     
 * @author t-shenj
 *
 */
public class DocSelectChangeName {
	
	public static String getBusinessName(String sTypeNo) throws Exception{
		return NameCache.getName("BUSINESS_TYPE", "TypeName", "TypeNo", sTypeNo);
	}
	
	
	/**
	 * ��ͬ�ſ�ɹ��������Ŀ��Ч���Զ����ɴ�����Ķ���ҵ�������������
	 * @param sObjectNo  ����Ϊҵ���ͬʱ���ı���ͬ��� ��Ϊ������Ŀʱ����ĿЭ����
	 * @param sObjectType �������ͣ���ͬ��������Ŀ����
	 * @param sExecutiveUserID  �ܻ���
	 * @param sExecutiveOrgID   �ܻ�����
	 */
	public static void insertDocPackageAndOperation(String sObjectNo,String sObjectType,String sExecutiveUserID,String sExecutiveOrgID,String sCustomerName,String sContractArtificialNo){
		try {
			//��ȡҵ�����ϰ��������
			BizObjectManager bmDfp = JBOFactory.getBizObjectManager("jbo.doc.DOC_FILE_PACKAGE");
			BizObjectManager bmDo = JBOFactory.getBizObjectManager("jbo.doc.DOC_OPERATION");
			//��ȡҵ�����ϰ���ˮ��
			String sPackageSerialNo = DBKeyHelp.getSerialNo("DOC_FILE_PACKAGE","SERIALNO");
			//��ȡҵ�����ϰ�������¼��ˮ��
			String sOperationSerialNo = DBKeyHelp.getSerialNo("DOC_OPERATION","SERIALNO");  
			
			BizObject bo = bmDfp.newObject();
			bo.setAttributeValue("SERIALNO", sPackageSerialNo); //�������
  		  	bo.setAttributeValue("OBJECTTYPE", sObjectType); //�������ͣ��������ϡ�������Ŀ����
  		  	bo.setAttributeValue("OBJECTNO", sObjectNo);//�����ţ���ͬ��ˮ�š�������Ŀ��ˮ��
	  		bo.setAttributeValue("PACKAGETYPE", "02");//ҵ���������Ĭ��Ϊ"����ҵ������"
	  		bo.setAttributeValue("STATUS", "01");//״̬ Ĭ��Ϊ "������"
	  	    bo.setAttributeValue("MANAGEUSERID", sExecutiveUserID);//������
	  		bo.setAttributeValue("MANAGEORGID", sExecutiveOrgID);//�������
	  		bo.setAttributeValue("INPUTUSERID", sExecutiveUserID); 
	  		bo.setAttributeValue("INPUTORGID", sExecutiveOrgID);
	  		bo.setAttributeValue("INPUTDATE", DateHelper.getBusinessDate());
	  		bo.setAttributeValue("PACKAGENAME", sCustomerName);
	  		bo.setAttributeValue("CONTRACTARTIFICIALNO", sContractArtificialNo);
	  		bmDfp.saveObject(bo);
			/*String sSQLDFP="insert into DOC_FILE_PACKAGE(SERIALNO,OBJECTTYPE,OBJECTNO,PACKAGETYPE,STATUS,INPUTUSERID,INPUTORGID,INPUTDATE)"+
				    " VALUES(:SERIALNO,:OBJECTTYPE,:OBJECTNO,:PACKAGETYPE,:STATUS,:INPUTUSERID,:INPUTORGID,:INPUTDATE)";
		    BizObjectQuery bq = bmDfp.createQuery(sSQLDFP);
		    int i = bq.setParameter("SERIALNO", sPackageSerialNo) //�������
		    		  .setParameter("OBJECTTYPE", sObjectType) //�������ͣ��������ϡ�������Ŀ����
		    		  .setParameter("OBJECTNO", sObjectNo)//�����ţ���ͬ��ˮ�š�������Ŀ��ˮ��
		    		  .setParameter("PACKAGETYPE", "02")//ҵ���������Ĭ��Ϊ"����ҵ������"
		    		  .setParameter("STATUS", "01")//״̬ Ĭ��Ϊ "������"
		    		  .setParameter("MANAGEUSERID", sExecutiveUserID)//������
		    		  .setParameter("MANAGEORGID", sExecutiveOrgID)//�������
		    		  .setParameter("INPUTUSERID", sExecutiveUserID) 
		    		  .setParameter("INPUTORGID", sExecutiveOrgID)
		    		  .setParameter("INPUTDATE", DateHelper.getToday())
		    		  .setParameter("PACKAGENAME", sCustomerName)
		    		  .executeUpdate();*/
			BizObject bo1 = bmDo.newObject();
			bo1.setAttributeValue("SERIALNO", sOperationSerialNo);
    		bo1.setAttributeValue("OBJECTTYPE", "jbo.doc.DOC_FILE_PACKAGE");
    		bo1.setAttributeValue("OBJECTNO", sPackageSerialNo);
    		bo1.setAttributeValue("TRANSACTIONCODE", "0010");
    		bo1.setAttributeValue("OPERATEDATE",  DateHelper.getBusinessDate());
    		bo1.setAttributeValue("OPERATEUSERID", sExecutiveUserID);
    		bo1.setAttributeValue("INPUTUSERID", sExecutiveUserID);
    		bo1.setAttributeValue("STATUS", "01");
    		bo1.setAttributeValue("INPUTDATE", DateHelper.getBusinessDate());
    		bo1.setAttributeValue("INPUTORGID", sExecutiveOrgID);
	  		bmDo.saveObject(bo1);
/*		    String sSQLDO = "INSERT INTO DOC_OPERATION(SERIALNO,OBJECTTYPE,OBJECTNO,TRANSACTIONCODE,OPERATEDATE,OPERATEUSERID,INPUTUSERID,STATUS,INPUTDATE,INPUTORGID)"+
		    				" VALUES(:SERIALNO,:OBJECTTYE,:OBJECTNO,:TRANSACTIONCODE,:OPERATEDATE,:OPERATEUSERID,:INPUTUSERID,:STATUS,:INPUTDATE,:INPUTORGID)";
		    bq = bmDo.createQuery(sSQLDO);
		    
		    int j = bq.setParameter("SERIALNO", sOperationSerialNo)
		    		.setParameter("OBJECTTYPE", "jbo.doc.DOC_FILE_PACKAGE")
		    		  .setParameter("OBJECTNO", sPackageSerialNo)
		    		  .setParameter("TRANSACTIONCODE", "0010")
		    		  .setParameter("OPERATEDATE",  DateHelper.getToday())
		    		  .setParameter("OPERATEUSERID", sExecutiveUserID)
		    		  .setParameter("INPUTUSERID", sExecutiveUserID)
		    		  .setParameter("STATUS", "01") 
		    		  .setParameter("INPUTDATE", DateHelper.getToday())
		    		  .setParameter("INPUTORGID", sExecutiveOrgID)
		    		  .executeUpdate(); */
		} catch (Exception e) { 
			e.printStackTrace();
		} 
	}
	
	
	/**
	 * ������Ѻ����Ч���Զ�����һ��ҵ�����ϴ��������
	 * @param sObjectNo  ��ǰѺƷ��Ӧ�� GUARANTY_RELATIVE����ˮ��
	 * @param sInputUserID ��ǰ�û�ID
	 * @param sInputOrgID  ��ǰ�û���������
	 */
	public static void insertDoc1PackageAndOperation(String sObjectNo,String sInputUserID,String sInputOrgID){
		try {
			//��ȡҵ�����ϰ��������
			BizObjectManager bmDfp = JBOFactory.getBizObjectManager("jbo.doc.DOC_FILE_PACKAGE");
			BizObjectManager bmDo = JBOFactory.getBizObjectManager("jbo.doc.DOC_OPERATION");
			//��ȡҵ�����ϰ���ˮ��
			String sPackageSerialNo = DBKeyHelp.getSerialNo("DOC_FILE_PACKAGE","SERIALNO");
			//��ȡҵ�����ϰ�������¼��ˮ��
			String sOperationSerialNo = DBKeyHelp.getSerialNo("DOC_OPERATION","SERIALNO");  
			String sSQLDFP="insert into DOC_FILE_PACKAGE(SERIALNO,OBJECTTYPE,OBJECTNO,PACKAGETYPE,STATUS,INPUTUSERID,INPUTORGID,INPUTDATE)"+
				    " VALUES(:SERIALNO,:OBJECTTYPE,:OBJECTNO,:PACKAGETYPE,:STATUS,:INPUTUSERID,:INPUTORGID,:INPUTDATE)";
		    BizObjectQuery bq = bmDfp.createQuery(sSQLDFP);
		    int i = bq.setParameter("SERIALNO", sPackageSerialNo) //�������
		    		  .setParameter("OBJECTTYPE", "jbo.guaranty.GUARANTY_RELATIVE") //�������ͣ�������ͬ
		    		  .setParameter("OBJECTNO", sObjectNo)//�����ţ�GUARANTY_RELATIVE�����ˮ��
		    		  .setParameter("PACKAGETYPE", "01")//ҵ���������Ĭ��Ϊ"һ��ҵ������"
		    		  .setParameter("STATUS", "01")//״̬ Ĭ��Ϊ "������" 
		    		  .setParameter("INPUTUSERID", sInputUserID) //��ǰ�û�ID
		    		  .setParameter("INPUTORGID", sInputOrgID)//��ǰ�û�����������ID
		    		  .setParameter("INPUTDATE", DateHelper.getBusinessDate()) 
		    		  .executeUpdate();
		    String sSQLDO = "INSERT INTO DOC_OPERATION(SERIALNO,OBJECTTYPE,OBJECTNO,TRANSACTIONCODE,OPERATEDATE,OPERATEUSERID,INPUTUSERID,STATUS,INPUTDATE,INPUTORGID)"+
		    				" VALUES(:SERIALNO,:OBJECTTYE,:OBJECTNO,:TRANSACTIONCODE,:OPERATEDATE,:OPERATEUSERID,:INPUTUSERID,:STATUS,:INPUTDATE,:INPUTORGID)";
		    bq = bmDo.createQuery(sSQLDO);
		    
		    int j = bq.setParameter("SERIALNO", sOperationSerialNo)
		    		.setParameter("OBJECTTYPE", "jbo.doc.DOC_FILE_PACKAGE")
		    		  .setParameter("OBJECTNO", sPackageSerialNo)
		    		  .setParameter("TRANSACTIONCODE", "0010")
		    		  .setParameter("OPERATEDATE",  DateHelper.getBusinessDate())
		    		  .setParameter("OPERATEUSERID", sInputUserID)
		    		  .setParameter("INPUTUSERID", sInputUserID)
		    		  .setParameter("STATUS", "01") 
		    		  .setParameter("INPUTDATE", DateHelper.getBusinessDate())
		    		  .setParameter("INPUTORGID", sInputOrgID)
		    		  .executeUpdate(); 
		} catch (Exception e) { 
			e.printStackTrace();
		}
	}
}
