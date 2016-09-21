package com.amarsoft.app.als.docmanage.action;

import java.util.List;

import com.amarsoft.app.base.businessobject.BusinessObject;
import com.amarsoft.app.base.businessobject.BusinessObjectManager;
import com.amarsoft.app.als.sys.tools.SystemConst;
import com.amarsoft.are.jbo.BizObject;
import com.amarsoft.are.jbo.BizObjectManager;
import com.amarsoft.are.jbo.BizObjectQuery;
import com.amarsoft.are.jbo.JBOException;
import com.amarsoft.are.jbo.JBOFactory;
import com.amarsoft.are.lang.StringX;
import com.amarsoft.are.util.ASValuePool;
import com.amarsoft.are.util.StringFunction;
import com.amarsoft.awe.util.ASResultSet;
import com.amarsoft.awe.util.SqlObject;
import com.amarsoft.awe.util.Transaction;
import com.amarsoft.dict.als.cache.NameCache;
import com.amarsoft.dict.als.manage.NameManager;

/**
 * �������������������ˮ�Ż�ȡ���Ӧ���������
 * @author zqliu
 *
 */
public class DOCNameManager{
	private String  AssetSerialNo;
	 

	public String getAssetSerialNo() {
		return AssetSerialNo;
	}

	public void setAssetSerialNo(String assetSerialNo) {
		AssetSerialNo = assetSerialNo;
	}

	//����ѺƷ��Ż�ȡѺƷ����Ȩ����  
	public static String getAssetOwnerNames(String sAISerialNo){
		if( null == sAISerialNo || "".equals(sAISerialNo)) return "";
		StringBuffer AssetOwnerName = new StringBuffer();
		String AssetOwnerNames = "";
		try{
			BizObjectManager bm=JBOFactory.getBizObjectManager("jbo.app.ASSET_OWNER");
			List<BizObject> lst=bm.createQuery("ASSETSERIALNO='"+sAISerialNo+"'").getResultList(false); 
			for(BizObject bo:lst){
					AssetOwnerName.append(bo.getAttribute("CUSTOMERNAME").getString()).append(",");	
			}
			
			if(StringX.isEmpty(AssetOwnerName.toString())||"null".equals(AssetOwnerName.toString())||"null"==AssetOwnerName.toString()){
			}else{
				AssetOwnerNames = AssetOwnerName.toString().substring(0,AssetOwnerName.toString().length()-1);
				if(StringX.isEmpty(AssetOwnerNames) || AssetOwnerNames=="null") AssetOwnerNames = "";
			}
		}catch(Exception e){
			e.printStackTrace();
		}
			
		return AssetOwnerNames;
	}
 
	/**
	 * ����ѺƷ��Ż�ȡҵ���ͬ��Ӧ�Ŀͻ�����                                                                                                                                                                                                                                                     
	 * @param sAISerialNo  ѺƷ���
	 * @return   �ͻ�����
	 */
	public static String getBCCustomer(String sAISerialNo){  
		//�����������ͻ�����
		String sCustomerName = "";                                                                                                                                                                                                                                                       
		if( null == sAISerialNo || "".equals(sAISerialNo)) return "";                                                                                                                                                                                                                    
		try{
			//����ѺƷ��ˮ�Ż�ȡҵ���ͬ��ˮ��
			String sBCSerialNo = getBCSerialNo(sAISerialNo);
			//����ҵ���ͬ��ˮ�Ż�ȡ��Ӧ�Ŀͻ�����
			sCustomerName = getBCCustomerName(sBCSerialNo);
		}catch(Exception e){                                                                                                                                                                                                                                                             
			e.printStackTrace();                                                                                                                                                                                                                                                           
		}                                                                                                                                                                                                                                                                                
		return sCustomerName ;                                                                                                                                                                                                                                                           
	}
	 
	public String getBCCustomer(){  
		return  DOCNameManager.getBCCustomer(this.AssetSerialNo); 
	}
	 
	/**
	 * ����ѺƷ��Ż�ȡѺƷ��Ӧ�� ����Ȩ֤�����Ϣ
	 * @param sAISerialNo ѺƷ���
	 * @return Ȩ֤��Ϣ�б�
	 */
	public static String getARCertNo(String sAISerialNo){
		if( null == sAISerialNo || "".equals(sAISerialNo)) return "";
		StringBuffer ARCertNo = new StringBuffer();
		String ARCertNos = "";
		try{
			BizObjectManager bm=JBOFactory.getBizObjectManager("jbo.app.ASSET_RIGHT_CERTIFICATE");
			List<BizObject> lst=bm.createQuery("ASSETSERIALNO=:AISerialNo").setParameter("AISerialNo",sAISerialNo).getResultList(false); 
			for(BizObject bo:lst){
				if(lst.size() == 1){
					ARCertNo.append(bo.getAttribute("CERTNO").getString());
				} else {
					ARCertNo.append(bo.getAttribute("CERTNO").getString()).append(",");	
				}
			}
			
			if(StringX.isEmpty(ARCertNo.toString())||"null".equals(ARCertNo.toString())){
			}else{
				ARCertNos = ARCertNo.toString().substring(0,ARCertNo.toString().length()-1);
				if(StringX.isEmpty(ARCertNos) || ARCertNos=="null") ARCertNos = "";
			}
		}catch(Exception e){
			e.printStackTrace();
		}
		return ARCertNos;
	}

	/**
	 * ����ѺƷ��Ż�ȡҵ���ͬ��ˮ��
	 * @param sAISerialNo ѺƷ���
	 * @return
	 */
	public static String getBCSerialNo(String sAISerialNo){                                                                                                                                                                                                                            
		if( null == sAISerialNo || "".equals(sAISerialNo)) return "";                                                                                                                                                                                                                    
		String sBCSerialNo = "";    //ҵ���ͬ��ˮ��
		try{  
			//��ȡ��ǰѺƷ�����ĵ�����ͬ���
			BizObjectManager bm=JBOFactory.getBizObjectManager("jbo.guaranty.GUARANTY_RELATIVE");
			BizObject bo = bm.createQuery(" O.ASSETSERIALNO=:AISerialNo ").setParameter("AISerialNo", sAISerialNo).getSingleResult(false); 
			String sGCSerialNo = "";
			if(bo==null){
				sGCSerialNo = "";
			} else {
				sGCSerialNo = bo.getAttribute("gcserialno").getString();
			}  
			//��������ȡ�ĵ�����ͬ��Ż�ȡ��Ӧ��ҵ���ͬ��ˮ��
			sBCSerialNo = getBCSerialNoFromGC(sGCSerialNo);
		}catch(Exception e){                                                                                                                                                                                                                                                             
			e.printStackTrace();                                                                                                                                                                                                                                                           
		}                                                                                                                                                                                                                                                                                
		return sBCSerialNo;                                                                                                                                                                                                                                                              
	}   
	/**
	 * ���ݵ�����ͬ��Ż�ȡҵ���ͬ��ˮ��                                                                                                                                                                                                                                               
	 * @param sGCSerialNo    ������ͬ���
	 * @return   ҵ���ͬ��ˮ��
	 */
	public static String getBCSerialNoFromGC(String sGCSerialNo){                                                                                                                                                                                                                            
		if( null == sGCSerialNo || "".equals(sGCSerialNo)) return "";                                                                                                                                                                                                                    
		String sBCSerialNo = "";    
		try{
			//���ݵ�����ͬ�ŴӺ�ͬ������Ϣ���л�ȡ��Ӧ��ҵ���ͬ��ˮ��
			BizObjectManager bm=JBOFactory.getBizObjectManager("jbo.app.CONTRACT_RELATIVE");
			BizObject bo = bm.createQuery("  O.objecttype='jbo.guaranty.GUARANTY_CONTRACT' and O.objectno=:GCSerialNo ").setParameter("GCSerialNo", sGCSerialNo).getSingleResult(false); 
			if(bo==null){
				sBCSerialNo = "";
			} else {
				sBCSerialNo = bo.getAttribute("contractserialno").getString();
			}              
		}catch(Exception e){                                                                                                                                                                                                                                                             
			e.printStackTrace();                                                                                                                                                                                                                                                           
		}                                                                                                                                                                                                                                                                                
		return sBCSerialNo;                                                                                                                                                                                                                                                              
	} 
	//����GC �õ� ҵ���ͬ�ͻ���                                                                                                                                                                                                                                                     
	public static String getBCCustomerFromGC(String sGCSerialNo){                                                                                                                                                                                                                            
		String sCustomerName = "";                                                                                                                                                                                                                                                       
		if( null == sGCSerialNo || "".equals(sGCSerialNo)) return "";                                                                                                                                                                                                                    
		try{    
			String sBCSerialNo = getBCSerialNoFromGC(sGCSerialNo);
			sCustomerName = getBCCustomerName(sBCSerialNo);
		}catch(Exception e){                                                                                                                                                                                                                                                             
			e.printStackTrace();                                                                                                                                                                                                                                                           
		}                                                                                                                                                                                                                                                                                
		return sCustomerName ;                                                                                                                                                                                                                                                           
	}
	
	//���ݺ�ͬ�� �õ� ��ͬ�ͻ���                                                                                                                                                                                                                                                     
	public static String getBCCustomerName(String sBCSerialNo){                                                                                                                                                                                                                            
		String sCustomerName = "";                                                                                                                                                                                                                                                       
		if( null == sBCSerialNo || "".equals(sBCSerialNo)) return "";                                                                                                                                                                                                                    
		try{       
			BizObjectManager bm=JBOFactory.getBizObjectManager("jbo.app.BUSINESS_CONTRACT");
			BizObject bo = bm.createQuery("  O.SERIALNO=:SERIALNO ").setParameter("SERIALNO", sBCSerialNo).getSingleResult(false); 
			if(bo==null){
				sCustomerName = "";
			} else {
				sCustomerName = bo.getAttribute("customerName").getString();
			}
		}catch(Exception e){                                                                                                                                                                                                                                                             
			e.printStackTrace();                                                                                                                                                                                                                                                           
		}                                                                                                                                                                                                                                                                                
		return sCustomerName ;                                                                                                                                                                                                                                                           
	}
	//����ҵ���ͬ��� �õ� ҵ��Ʒ��                                                                                                                                                                                                                                                     
	public static String getBCBusinessTypeName(String sBCSerialNo){                                                                                                                                                                                                                            
		String sBusinessTypeNo = "";
		String sBusinessTypeName = "";                                                                                                                                                                                                                                                       
		if( null == sBCSerialNo || "".equals(sBCSerialNo)) return "";                                                                                                                                                                                                                    
		try{         
			BizObjectManager bm=JBOFactory.getBizObjectManager("jbo.app.BUSINESS_CONTRACT");
			BizObject bo = bm.createQuery("  O.SERIALNO=:SERIALNO ").setParameter("SERIALNO", sBCSerialNo).getSingleResult(false); 
			if(bo==null){
				sBusinessTypeNo = "";
			} else {
				sBusinessTypeNo = bo.getAttribute("businesstype").getString();
			}
			sBusinessTypeName = NameManager.getBusinessName(sBusinessTypeNo);                                                                                                                                                                                                            
		}catch(Exception e){                                                                                                                                                                                                                                                             
			e.printStackTrace();                                                                                                                                                                                                                                                           
		}                                                                                                                                                                                                                                                                                
		return sBusinessTypeName ;                                                                                                                                                                                                                                                           
	}
	//���ݱ���� �õ� �� �ڼ����                                                                                                                                                                                                        
	public static String getIsPosition(String sDFPSerialNo){                                                                                                                                                                                                                            
		String sIsPosition = "";                                                                                                                                                                                                                                                       
		if( null == sDFPSerialNo || "".equals(sDFPSerialNo)){
			return "";                                                                                                                                                                                                                         
		}else {
			try{                                                                                                                                                                                                                                                                             
				BizObjectManager bm=JBOFactory.getBizObjectManager("jbo.doc.DOC_FILE_PACKAGE");
				BizObject bo = bm.createQuery("  O.SERIALNO=:SERIALNO ").setParameter("SERIALNO", sDFPSerialNo).getSingleResult(false); 
				if(bo==null){
					sIsPosition = "";
				} else {
					sIsPosition = bo.getAttribute("POSITION").getString();
					if(StringX.isEmpty(sIsPosition) || "null".equals(sIsPosition)){
						sIsPosition = "��";
					}else{
						sIsPosition = "��";
					}
				}                                                                                                                                                                                                        
			}catch(Exception e){                                                                                                                                                                                                                                                             
				e.printStackTrace();                                                                                                                                                                                                                                                           
			}      
		}
		return sIsPosition ;                                                                                                                                                                                                                                                           
	}
	//���ݲ����� �õ� �ڼ�״̬
	public static String getPackagePosition(String sDOSerialNo) throws Exception{
		if(StringX.isEmpty(sDOSerialNo)) return "";

		String isPosition = "";
		String sObjectNo = "";
		String sObjectType = "";
		try{
			BizObjectManager bm=JBOFactory.getBizObjectManager("jbo.doc.DOC_OPERATION");
			BizObject bo = bm.createQuery(" O.SERIALNO=:SERIALNO ").setParameter("SERIALNO", sDOSerialNo).getSingleResult(false); 
			if(bo==null){
				sObjectNo="";
				sObjectType = "";
			} else {
				sObjectNo = bo.getAttribute("OBJECTNO").getString(); 
				sObjectType = bo.getAttribute("OBJECTTYPE").getString();
			}
			bm=JBOFactory.getBizObjectManager("jbo.doc.DOC_FILE_PACKAGE");
			bo = bm.createQuery(" O.PACKAGETYPE='02' AND (O.ObjectType = 'jbo.app.BUSINESS_CONTRACT' or O.OBJECTTYPE=:OBJECTTYPE) AND O.OBJECTNO=:OBJECTNO ").setParameter("OBJECTTYPE", sObjectType).setParameter("OBJECTNO", sObjectNo).getSingleResult(false); 
			if(bo==null){
				isPosition = "";
			} else {
				isPosition = bo.getAttribute("POSITION").getString();
				if(StringX.isEmpty(isPosition) || "null".equals(isPosition)){
					isPosition = "��";
				}else{
					isPosition = "��";
				}
			}
		}catch(Exception e){
			e.printStackTrace();
		}
		return isPosition;
	}
	
	/**
	 * �õ�ҵ�����ϵ�  ҵ�����Ϲ���
	 * @param sFileId
	 * @return
	 * @throws Exception
	 */
	public String getDFCObjectType(String sFileId) throws Exception{
		String sDFCObjectType = "";        
		if(StringX.isEmpty(sFileId)) return "";
		try{                                                                                                                                                                                                                                                                             
			BizObjectManager bm=JBOFactory.getBizObjectManager("jbo.doc.DOC_FILE_CONFIG");
			BizObject bo = bm.createQuery("  O.FILEID=:FILEID ").setParameter("FILEID", sFileId).getSingleResult(false); 
			if(bo==null){
				sDFCObjectType = "";
			} else {
				sDFCObjectType = bo.getAttribute("OBJECTTYPE").getString();
				if(StringX.isEmpty(sDFCObjectType) || "null".equals(sDFCObjectType)){
					sDFCObjectType = "";
				}
			}                                                                                                                                                                                                        
		}catch(Exception e){                                                                                                                                                                                                                                                             
			e.printStackTrace();                                                                                                                                                                                                                                                           
		}      
		return sDFCObjectType ;   
	}
	/**
	 * �õ�ҵ�����ϵ� ҵ����������
	 * @param sFileId
	 * @return
	 * @throws Exception
	 */
	public String getDFCFileName(String sFileId) throws Exception{
		String sDFCFileName = "";        
		if(StringX.isEmpty(sFileId)) return "";
		try{                                                                                                                                                                                                                                                                             
			BizObjectManager bm=JBOFactory.getBizObjectManager("jbo.doc.DOC_FILE_CONFIG");
			BizObject bo = bm.createQuery("  O.FILEID=:FILEID ").setParameter("FILEID", sFileId).getSingleResult(false); 
			if(bo==null){
				sDFCFileName = "";
			} else {
				sDFCFileName = bo.getAttribute("FILENAME").getString();
				if(StringX.isEmpty(sDFCFileName) || "null".equals(sDFCFileName)){
					sDFCFileName = "";
				}
			}                                                                                                                                                                                                        
		}catch(Exception e){                                                                                                                                                                                                                                                             
			e.printStackTrace();                                                                                                                                                                                                                                                           
		}      
		return sDFCFileName ;   
	}
	//����userid �õ� username
	public static String getUserName(String sUserId){
		if( null == sUserId || "".equals(sUserId)) return "";
		String sUserName = "";
		try{
			BizObjectManager bm=JBOFactory.getBizObjectManager("jbo.awe.USER_INFO");
			BizObject bo = bm.createQuery(" O.USERID=:USERID ").setParameter("USERID", sUserId).getSingleResult(false); 
			if(bo==null){
			} else {
				sUserName = bo.getAttribute("USERNAME").getString(); 
			}
		}catch(Exception e){
			e.printStackTrace();
		}
		return sUserName;
	}
	//����orgid �õ� orgname
	public static String getOrgName(String sOrgId){
		if( null == sOrgId || "".equals(sOrgId)) return "";
		String sOrgName = "";
		try{
			BizObjectManager bm=JBOFactory.getBizObjectManager("jbo.awe.ORG_INFO");
			BizObject bo = bm.createQuery(" O.ORGID=:ORGID ").setParameter("ORGID", sOrgId).getSingleResult(false); 
			if(bo==null){
			} else {
				sOrgName = bo.getAttribute("ORGNAME").getString(); 
			}
		}catch(Exception e){
			e.printStackTrace();
		}
		return sOrgName;
	}
	//����docno �õ���������                                                                                                                                                                                                                                    
	public static String getAttSum(String sDOCNO){                                                                                                                                                                                                                            
		String sAttSum = "";                                                                                                                                                                                                                                                       
		if( null == sDOCNO || "".equals(sDOCNO)) return "";                                                                                                                                                                                                                    
		try{      
			String selectSql = " DOCNO=:DOCNO ";
			BusinessObjectManager bom = BusinessObjectManager.createBusinessObjectManager();
			List<BusinessObject> docList = bom.loadBusinessObjects("jbo.doc.DOC_ATTACHMENT", selectSql, "DOCNO", sDOCNO);
			if(docList==null||docList.size()==0){
				sAttSum = "0";
			} else {
				sAttSum = String.valueOf(docList.size());
			}
		}catch(Exception e){                                                                                                                                                                                                                                                             
			e.printStackTrace();                                                                                                                                                                                                                                                           
		}                                                                                                                                                                                                                                                                                
		return sAttSum ;                                                                                                                                                                                                                                                           
	}
}
