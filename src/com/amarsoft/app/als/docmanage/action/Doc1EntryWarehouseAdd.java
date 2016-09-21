package com.amarsoft.app.als.docmanage.action;

import java.sql.Connection;
import java.sql.SQLException;

import com.amarsoft.app.base.businessobject.BusinessObject;
import com.amarsoft.app.base.businessobject.BusinessObjectManager;
import com.amarsoft.app.base.util.DateHelper;
import com.amarsoft.are.ARE;
import com.amarsoft.are.jbo.BizObjectManager;
import com.amarsoft.are.jbo.BizObjectQuery;
import com.amarsoft.are.jbo.JBOException;
import com.amarsoft.are.jbo.JBOFactory;
import com.amarsoft.are.jbo.JBOTransaction;
import com.amarsoft.are.lang.StringX;
import com.amarsoft.are.util.StringFunction;
import com.amarsoft.are.util.json.JSONObject;
import com.amarsoft.awe.util.DBKeyHelp;
import com.amarsoft.awe.util.Transaction;

/**
 * yil
 * @author t-shenj
 *
 */
public class Doc1EntryWarehouseAdd {
	//����
	private JSONObject inputParameter;

	private BusinessObjectManager businessObjectManager;
	
	public void setInputParameter(JSONObject inputParameter) {
		this.inputParameter = inputParameter;
	}
	
	private JBOTransaction tx;

	public void setTx(JBOTransaction tx) {
		this.tx = tx;
	}
	
	public void setBusinessObjectManager(BusinessObjectManager businessObjectManager) {
		this.businessObjectManager = businessObjectManager;
		this.tx = businessObjectManager.getTx();
	}
	
	private BusinessObjectManager getBusinessObjectManager() throws JBOException, SQLException{
		if(businessObjectManager==null)
			businessObjectManager = BusinessObjectManager.createBusinessObjectManager(tx);
		return businessObjectManager;
	}

	
	/**
	 * һ��ҵ������ ���
	 * @param sDFIInfoList��sDFISerialNo,sObjectType,sObjectNo
	 * @return
	 * @throws Exception
	 */
	public String EntryWarehouseListAdd(String sDFIInfoList) throws Exception {
		String[] sDFIInfo = sDFIInfoList.split(",");
		try {
			String [] sDFISerialNo1 = sDFIInfoList.split(",");//new String[100];
			for(int i=0;i<sDFISerialNo1.length;i++){
				
			}
			for (int i = 0; i < sDFIInfo.length; i++) {
				String [] sDFIInfo1 = sDFIInfo[i].split("*");
				String sDFISerialNo = sDFIInfo1[0];
				String sObjectType = sDFIInfo1[1];
				String sObjectNo = sDFIInfo1[2];
				
				String sDOSerialNo = insertDocOperation(sObjectType,sObjectNo);
				if (!"".equals(sDOSerialNo) || "" != sDOSerialNo
						|| sDOSerialNo.length() > 0) {
					insertDocOperationFile(sDOSerialNo,sDFISerialNo1[i]);	
				}
			}
			return "true";
		} catch (Exception e) {
			e.printStackTrace();
			return "false";
		}

	}
	 
	/**
	 * һ�����Ϲ����� ��������
	 * @param tx
	 * @return
	 * @throws Exception
	 */
	public String EntryWarehousePackage(JBOTransaction tx) throws Exception{
		this.tx=tx;
		String sObjectNoList = (String)inputParameter.getValue("ObjectNoList");  
		String sObjectType = "jbo.guaranty.GUARANTY_RELATIVE";
		//ͨ����ȡ��ˮ�ŵķ�ʽ����"������"
		String sPackageId = DBKeyHelp.getSerialNo();
		int iCount = 0;
		//��ȡҪ�����ҵ��������Ŀ
		iCount = sObjectNoList.split("@").length;
		String ObjectInfo[] = new String[iCount]; 
		ObjectInfo = sObjectNoList.split("@");
		String sReturnFlag = "false";
		for(int i=0;i<iCount;i++){
			sReturnFlag = this.EntryWarehousePackage(ObjectInfo[i],sObjectType,sPackageId);
			if("false".equals(sReturnFlag) || "false"==sReturnFlag){
				continue;
			}
		}
		return sReturnFlag;
	}
	 
	/**
	 * �ڽ��з������ʱ���������ϰ���š�ҵ������״̬
	 * @param sObjectNo
	 * @param sObjectType
	 * @param sPackageId
	 * @return
	 */
	private String EntryWarehousePackage(String sObjectNo,String sObjectType,String sPackageId) {
		String sReturnFlag = "false";//�Ƿ�����ɹ��ı�ʶ
		try {
  			//1����ȡ�������ʵ��
  			BizObjectManager m = JBOFactory.getFactory().getManager("jbo.doc.DOC_FILE_PACKAGE");
  			//2������������SQL���
			BizObjectQuery bq = m.createQuery("update O set PACKAGEID =:PACKAGEID,STATUS=:STATUS where OBJECTNO=:OBJECTNO "
					                         + "AND OBJECTTYPE=:OBJECTTYPE AND STATUS='01'");
			//3��ΪSQL����ռλ����ֵ��ִ�и��²���
			int i = bq.setParameter("PACKAGEID", sPackageId)
			  .setParameter("STATUS","02")
			  .setParameter("OBJECTNO", sObjectNo)
			  .setParameter("OBJECTTYPE", sObjectType).executeUpdate();	 
			if(i>0){
				sReturnFlag = "true";
			}
		} catch (Exception e) {
			e.printStackTrace();
			return sReturnFlag;
		}
		return sReturnFlag;
	}

	/**
	 * �����ѵ�Ѻ��Ч��ѺƷʱ����ҵ�����ϰ���Ϣ(doc_file_package)���в�������  yjhou 2015.02.27
	 *    ����ҵ������ ״̬����Ϊ "�����"
	 * @param sObjectNo  ������-->������ͬ������ˮ��
	 * @param sObjectType  �������� --> ������ͬ
	 * @throws SQLException 
	 * @throws JBOException 
	 */
	public String insertDocFilePackage(JBOTransaction tx){
		this.tx=tx;
		//1����ȡ��ز���:ҵ���������͡�ѺƷ��š���ǰ�û���š���ǰ���������������ȡ�Ĳ���ֵΪnull��������Ϊ���ַ���
		String sObjectType = (String)inputParameter.getValue("ObjectType"); 
		String sObjectNo = (String)inputParameter.getValue("ObjectNo");
		
		String sUserId =  (String)inputParameter.getValue("UserId");
		if(StringX.isEmpty(sUserId) || "null".equals(sUserId) || null == sUserId){
			sUserId=""; 
		}
		String sOrgId =  (String)inputParameter.getValue("OrgId");
		if(StringX.isEmpty(sOrgId) || "null".equals(sOrgId) || null == sOrgId){
			sOrgId="";
		}
		try {
			//2����ȡҵ�������� businessObjectManager
			businessObjectManager =  this.getBusinessObjectManager();
			//3����ȡҪ�����ı����:ҵ�����ϰ���Ӧ�ı����
			BusinessObject bo = BusinessObject.createBusinessObject("jbo.doc.DOC_FILE_PACKAGE");
			//4����ȡ���µ���ˮ��
			bo.generateKey();
			//5.Ϊ��Ӧ�ı��ֶθ�ֵ
			bo.setAttributeValue("OBJECTTYPE", sObjectType);
			bo.setAttributeValue("OBJECTNO", sObjectNo);
			bo.setAttributeValue("PACKAGETYPE", "01");
			bo.setAttributeValue("STATUS", "02");
			bo.setAttributeValue("MANAGEORGID", sOrgId);
			bo.setAttributeValue("MANAGEUSERID", sUserId);
			bo.setAttributeValue("INPUTUSERID", sUserId);
			bo.setAttributeValue("INPUTORGID", sOrgId);
			bo.setAttributeValue("INPUTDATE", DateHelper.getBusinessDate());
			bo.setAttributeValue("UPDATEDATE", DateHelper.getBusinessDate());  
			//6��ִ�в������
			businessObjectManager.updateBusinessObject(bo); 
			businessObjectManager.updateDB();
			
			return "true";
		} catch (Exception e) {
			e.printStackTrace();
			return "false";
		}
	}
	
	
	/**
	 * �Դ�������Ϣ����������ʱ����������ݲ��뵽��Ӧ�����ݱ�   yjhou 2015-02-27
	 * @param tx  �������
	 * @return
	 * @throws Exception
	 */
	public String EntryWarehouseAdd(JBOTransaction tx) throws Exception{
		this.tx=tx;
		//��ȡ����������������͡�������(ҵ�����ϱ��)
		String sObjectType = (String)inputParameter.getValue("ObjectType");
		String sObjectNo = (String)inputParameter.getValue("ObjectNo");
		String SrcStmBsnSerialNo = insertDocOperation(sObjectType,sObjectNo);

		//����ʵ�ʲ����ķ��� 
		String sReturn = "";
		String sPackageId="";
		
		sPackageId = SrcStmBsnSerialNo;
		//insertDocOperationFile(SrcStmBsnSerialNo,sObjectNo);
		
		try{
			  	/**
			 * ����������ʱ��
			 *   ��doc_file_package���е�status��ֵ����Ϊ"03"(�����)
			 */
			 if(this.updateDocFilePackage(sObjectNo,sObjectType,sPackageId)){
					sReturn="true";
			 } 
		}catch(Exception ex)
		{
			ex.printStackTrace();
			//throw ex;
			sReturn= "false";//
		}
	  
		return sReturn;
	}
	 
	/**
	 * �Դ�����ѺƷ����������ʱ����ҵ�����Ϲ��������¼(doc_operation)���в����������  yjhou 2015.02.27
	 * @param sObjectNo  ������-->ѺƷ���
	 * @param sObjectType  �������� --> ������ͬ
	 * @throws SQLException 
	 * @throws JBOException 
	 */
  	private String insertDocOperation(String sObjectType,String sObjectNo) throws Exception{
  		//1����ȡ��ز���:��ǰ�û���š���ǰ���������������ȡ�Ĳ���ֵΪnull��������Ϊ���ַ���
  		String sUserId =  (String)inputParameter.getValue("UserId");
  		if(StringX.isEmpty(sUserId) || "null".equals(sUserId) || null == sUserId){
  			sUserId=""; 
  		}
  		String sOrgId =  (String)inputParameter.getValue("OrgId");
  		if(StringX.isEmpty(sOrgId) || "null".equals(sOrgId) || null == sOrgId){
  			sOrgId="";
  		}
		//2����ȡҵ�������� businessObjectManager
  		businessObjectManager =  this.getBusinessObjectManager();
  		//3����ȡҪ�����ı����:ҵ�����Ϲ��������¼��Ӧ�ı����
  		BusinessObject bo = BusinessObject.createBusinessObject("jbo.doc.DOC_OPERATION");
		//4����ȡ���µ���ˮ��
  		bo.generateKey();
  		//5��Ϊ���ֶθ�ֵ
  		bo.setAttributeValue("OBJECTTYPE", sObjectType);//��������
  		bo.setAttributeValue("OBJECTNO", sObjectNo);//������
  		bo.setAttributeValue("TRANSACTIONCODE", "0020");//�������ͣ�Ĭ��Ϊ"���"
  		bo.setAttributeValue("OPERATEDATE", DateHelper.getBusinessDate());//��������
  		bo.setAttributeValue("OPERATEUSERID", sUserId);//������
  		bo.setAttributeValue("STATUS", "01");//״̬��Ĭ��Ϊ"������"
  		bo.setAttributeValue("INPUTUSERID", sUserId);//�Ǽ���
  		bo.setAttributeValue("INPUTORGID",sOrgId);//�Ǽǻ���
  		bo.setAttributeValue("UPDATEDATE",DateHelper.getBusinessDate());//�Ǽ�����
  		//6��ִ�в������
		businessObjectManager.updateBusinessObject(bo);
		businessObjectManager.updateDB();//����DOC_OPERATION��Ϣ
		//7���������ɵĲ�����ˮ��
		return bo.getString("SERIALNO");
  	}	
  	
  	/**
  	 * �Դ�����ѺƷ����������ʱ����ҵ�����Ϲ������������¼(Doc_Operation_File)���в����������  yjhou 2015.02.27
  	 * @param sDOSerialNo  ҵ�����Ϲ������
  	 * @param ObjectNo  ҵ�����ϱ��<������ͬ������ˮ��>
  	 * @return
  	 * @throws Exception
  	 */
  	private boolean insertDocOperationFile(String sDOSerialNo,String ObjectNo){
  		String sDOFSerialNo = "";
		try{
			//1����ȡҵ�������� businessObjectManager
	  		businessObjectManager =  this.getBusinessObjectManager();
			//2����ȡҪ�����ı����:ҵ�����Ϲ������������¼��Ӧ�ı����
			BusinessObject bo = BusinessObject.createBusinessObject("jbo.doc.DOC_OPERATION_FILE");
			//3����ȡ���µ���ˮ��
			bo.generateKey();
			//4��Ϊ�������ݱ��ֶ�����ֵ
			bo.setAttributeValue("OPERATIONSERIALNO", sDOSerialNo);//����������<ҵ�����Ϲ��������¼��ˮ��>
			bo.setAttributeValue("FILESERIALNO", ObjectNo);//ҵ�����ϱ��
			bo.setAttributeValue("OPERATEMEMO", "");//����
			//5��ִ�в������
			businessObjectManager.updateBusinessObject(bo);
			businessObjectManager.updateDB();//����DOC_OPERATION��Ϣ
			sDOFSerialNo = bo.getString("SERIALNO");
			return true;
		} catch(Exception e){
			e.printStackTrace();
			return false;
		}
  	}	
  	
  	/**
  	 * ���������ɹ��󣬽�doc_file_package����е�"һ��ҵ������״̬"��ֵ���Ϊ"03"(�����)
  	 * @param sObjectNo
  	 * @param sObjectType
  	 * @return
  	 */
  	private boolean updateDocFilePackage(String sObjectNo, String sObjectType,String sPackageId) {
  		try{
  			//1����ȡ�������ʵ��
  			BizObjectManager m = JBOFactory.getFactory().getManager("jbo.doc.DOC_FILE_PACKAGE");
  			//2������������SQL���
			BizObjectQuery bq = m.createQuery("update O set STATUS=:STATUS,PACKAGEID=:PACKAGEID,UPDATEDATE=:UPDATEDATE where OBJECTNO=:OBJECTNO AND OBJECTTYPE=:OBJECTTYPE AND STATUS='02'");
			//3��ΪSQL����ռλ����ֵ
			bq.setParameter("STATUS","03")
			  .setParameter("PACKAGEID",sPackageId)
			  .setParameter("UPDATEDATE",DateHelper.getBusinessDate())
			  .setParameter("OBJECTNO", sObjectNo)
			  .setParameter("OBJECTTYPE", sObjectType).executeUpdate();	
			return true;
		} catch(Exception e){
			e.printStackTrace(); 
			return false;
		}
	}
  	
  	
  	
	/**
	 * ���� ����������Doc_Operation_File
	 * @param 
	 * @throws Exception 
	 */
  	private void insertDocOperationFileList(String sDOSerialNo,String sDFISerialNo) throws Exception{
		String [] sDFISerialNo1 = sDFISerialNo.split(",");//new String[100];
		for(int i=0;i<sDFISerialNo.length();i++){
			insertDocOperationFile(sDOSerialNo,sDFISerialNo1[i]);	
		}
  	}	
	
  
  	/**
  	 * һ�����ϳ��������ύ
  	 * @return
  	 */
  	public String commit(JBOTransaction tx) throws Exception{
  		this.tx=tx;
  		//1����ȡҵ���������
		String sDOSerialNo = (String)inputParameter.getValue("DOSerialNo");//������ˮ��
		String sApplyType = (String)inputParameter.getValue("ApplyType"); //�׶����ͣ�01 ����  02 ����ͨ�� 03�˻�
		String sUserId = (String)inputParameter.getValue("UserID");//��ǰ�û����
		String sTransactionCode = (String)inputParameter.getValue("TransactionCode");//���ⷽʽ
		
		//�������������״̬��ҵ������״̬������ֵ���������
		String sDOStatus = "",sDFPStatus = "",  sReturnValue="false";
		boolean flag = false ;
		try{
			String  sDate= DateHelper.getBusinessDate();
			//����׶��ύ����ʱ
			if("01" == sApplyType || "01".equals(sApplyType)){
				sDOStatus = "02";
				flag = updateDO(sDOStatus,sDOSerialNo,sUserId,sDate,sApplyType);
			}//�����׶�
			 else  if("02" == sApplyType || "02".equals(sApplyType)){
				sDOStatus = "03";
				flag = updateDO(sDOStatus,sDOSerialNo,sUserId,sDate,sApplyType);
			}//���������˻�
			else if("03" == sApplyType || "03".equals(sApplyType)){
				sDOStatus = "04";
				flag = updateDO(sDOStatus,sDOSerialNo,sUserId,sDate,sApplyType);
			}
			//��Doc_operation���³ɹ��󣬸���ҵ������״̬
			if(flag==true){
				/*businessObjectManager =  this.getBusinessObjectManager();
				BusinessObject bo1 = BusinessObject.createBusinessObject("jbo.doc.DOC_OPERATION");
				bo1.generateKey();
				bo1.setAttributeValue("OBJECTTYPE", "jbo.doc.DOC_FILE_PACKAGE");
				bo1.setAttributeValue("OBJECTNO", sDOSerialNo);
				bo1.setAttributeValue("TRANSACTIONCODE", "0010");
				bo1.setAttributeValue("OPERATEDATE", DateHelper.getToday());
				bo1.setAttributeValue("OPERATEUSERID", sUserId);
				bo1.setAttributeValue("STATUS", "01");
				bo1.setAttributeValue("INPUTUSERID", sUserId);
				
				//6��ִ�в������ 
				businessObjectManager.updateBusinessObject(bo1);
				businessObjectManager.updateDB();*/
				sReturnValue="true";
			} 
		}catch(Exception e){
			tx.rollback();
		}
  		return sReturnValue;
  	}
  	
  	/**
  	 * ��ҵ�����ϲ���(����ͨ��ʱ)״̬��������ɹ����ڱ��ҵ������״̬
  	 * 		������ʽΪ�� ����  ���Ϊ �ѳ���
  	 *              ����   ���Ϊ �������ϳ���
  	 * @param sDOSerialNo   ҵ�����ϲ�����ˮ��
  	 * @param sDFPStatus    ҵ������״̬ (04�ѳ��� ��05 �������ϳ���)
  	 */
  	private int updateDocPackageStatus(String sDOSerialNo, String sDFPStatus) {
  		 int i = 0;
		try {
			//1����ȡ�������ʵ��
			BizObjectManager m = JBOFactory.getFactory().getManager("jbo.doc.DOC_FILE_PACKAGE");
			//2������������SQL���
			BizObjectQuery bq = m.createQuery("update O set STATUS=:STATUS "+ 
				     						  " where O.SERIALNO = (select DO.objectNo from jbo.doc.DOC_OPERATION DO WHERE DO.SerialNo=:SerialNo)"); 
			i = bq.setParameter("STATUS",sDFPStatus)   
			   .setParameter("SerialNo", sDOSerialNo).executeUpdate();
		} catch (Exception e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
		return i;
	}

	/**
  	 * ����������׶ε�״̬���
  	 * @param sDOStatus   ҵ�����ϲ���״̬ (01 �����ύ 02 ����ͨ�� 03 �����˻�)
  	 * @param sDOSerialNo  ҵ�����ϲ�����ˮ��
   	 * @param sUserId      ��ǰ�û�ID
  	 * @param sDate		         ��������
  	 * @param sApplyType   �����׶�  (01  �ύ 02 ����  03  �˻�)
  	 * @return
  	 */
	private boolean updateDO(String sDOStatus, String sDOSerialNo,
			String sUserId, String sDate, String sApplyType) {
		boolean flag = false;
		try{
  			//1����ȡ�������ʵ��
  			BizObjectManager m = JBOFactory.getFactory().getManager("jbo.doc.DOC_OPERATION");
  			//2������������SQL���
			BizObjectQuery bq = m.createQuery("update O set STATUS=:STATUS,O.OPERATEUSERID=:OperateUserId"+ 
				     						  " where O.SERIALNO =:SerialNo");  
			//3��ΪSQL����ռλ����ֵ
			int i = bq.setParameter("STATUS",sDOStatus)
			  .setParameter("OperateUserId", sUserId) 
			  .setParameter("SerialNo", sDOSerialNo)
			  .executeUpdate();	
			if(i>0){
				flag = true;
			} 
		} catch(Exception e){
			e.printStackTrace(); 
			flag = false;
		} 
		return flag;
	}
	
}
