package com.amarsoft.app.als.docmanage.action;

import com.amarsoft.app.base.util.DateHelper;
import com.amarsoft.are.jbo.BizObject;
import com.amarsoft.are.jbo.BizObjectManager;
import com.amarsoft.are.jbo.BizObjectQuery;
import com.amarsoft.are.jbo.JBOFactory;
import com.amarsoft.awe.util.DBKeyHelp;
import com.amarsoft.dict.als.cache.NameCache;

/**
 * 档案资料管理模块：
 *     
 * @author t-shenj
 *
 */
public class DocSelectChangeName {
	
	public static String getBusinessName(String sTypeNo) throws Exception{
		return NameCache.getName("BUSINESS_TYPE", "TypeName", "TypeNo", sTypeNo);
	}
	
	
	/**
	 * 合同放款成功或合作项目生效后自动生成待处理的二类业务资料入库任务
	 * @param sObjectNo  资料为业务合同时，文本合同编号 ；为合作项目时，项目协议编号
	 * @param sObjectType 对象类型：合同、合作项目类型
	 * @param sExecutiveUserID  管护人
	 * @param sExecutiveOrgID   管护机构
	 */
	public static void insertDocPackageAndOperation(String sObjectNo,String sObjectType,String sExecutiveUserID,String sExecutiveOrgID,String sCustomerName,String sContractArtificialNo){
		try {
			//获取业务资料包管理对象
			BizObjectManager bmDfp = JBOFactory.getBizObjectManager("jbo.doc.DOC_FILE_PACKAGE");
			BizObjectManager bmDo = JBOFactory.getBizObjectManager("jbo.doc.DOC_OPERATION");
			//获取业务资料包流水号
			String sPackageSerialNo = DBKeyHelp.getSerialNo("DOC_FILE_PACKAGE","SERIALNO");
			//获取业务资料包操作记录流水号
			String sOperationSerialNo = DBKeyHelp.getSerialNo("DOC_OPERATION","SERIALNO");  
			
			BizObject bo = bmDfp.newObject();
			bo.setAttributeValue("SERIALNO", sPackageSerialNo); //档案编号
  		  	bo.setAttributeValue("OBJECTTYPE", sObjectType); //档案类型：授信资料、合作项目资料
  		  	bo.setAttributeValue("OBJECTNO", sObjectNo);//对象编号：合同流水号、合作项目流水号
	  		bo.setAttributeValue("PACKAGETYPE", "02");//业务资料类别：默认为"二类业务资料"
	  		bo.setAttributeValue("STATUS", "01");//状态 默认为 "待处理"
	  	    bo.setAttributeValue("MANAGEUSERID", sExecutiveUserID);//管理人
	  		bo.setAttributeValue("MANAGEORGID", sExecutiveOrgID);//管理机构
	  		bo.setAttributeValue("INPUTUSERID", sExecutiveUserID); 
	  		bo.setAttributeValue("INPUTORGID", sExecutiveOrgID);
	  		bo.setAttributeValue("INPUTDATE", DateHelper.getBusinessDate());
	  		bo.setAttributeValue("PACKAGENAME", sCustomerName);
	  		bo.setAttributeValue("CONTRACTARTIFICIALNO", sContractArtificialNo);
	  		bmDfp.saveObject(bo);
			/*String sSQLDFP="insert into DOC_FILE_PACKAGE(SERIALNO,OBJECTTYPE,OBJECTNO,PACKAGETYPE,STATUS,INPUTUSERID,INPUTORGID,INPUTDATE)"+
				    " VALUES(:SERIALNO,:OBJECTTYPE,:OBJECTNO,:PACKAGETYPE,:STATUS,:INPUTUSERID,:INPUTORGID,:INPUTDATE)";
		    BizObjectQuery bq = bmDfp.createQuery(sSQLDFP);
		    int i = bq.setParameter("SERIALNO", sPackageSerialNo) //档案编号
		    		  .setParameter("OBJECTTYPE", sObjectType) //档案类型：授信资料、合作项目资料
		    		  .setParameter("OBJECTNO", sObjectNo)//对象编号：合同流水号、合作项目流水号
		    		  .setParameter("PACKAGETYPE", "02")//业务资料类别：默认为"二类业务资料"
		    		  .setParameter("STATUS", "01")//状态 默认为 "待处理"
		    		  .setParameter("MANAGEUSERID", sExecutiveUserID)//管理人
		    		  .setParameter("MANAGEORGID", sExecutiveOrgID)//管理机构
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
	 * 待抵质押物生效后自动生成一类业务资料待入库任务
	 * @param sObjectNo  当前押品对应的 GUARANTY_RELATIVE的流水号
	 * @param sInputUserID 当前用户ID
	 * @param sInputOrgID  当前用户所属机构
	 */
	public static void insertDoc1PackageAndOperation(String sObjectNo,String sInputUserID,String sInputOrgID){
		try {
			//获取业务资料包管理对象
			BizObjectManager bmDfp = JBOFactory.getBizObjectManager("jbo.doc.DOC_FILE_PACKAGE");
			BizObjectManager bmDo = JBOFactory.getBizObjectManager("jbo.doc.DOC_OPERATION");
			//获取业务资料包流水号
			String sPackageSerialNo = DBKeyHelp.getSerialNo("DOC_FILE_PACKAGE","SERIALNO");
			//获取业务资料包操作记录流水号
			String sOperationSerialNo = DBKeyHelp.getSerialNo("DOC_OPERATION","SERIALNO");  
			String sSQLDFP="insert into DOC_FILE_PACKAGE(SERIALNO,OBJECTTYPE,OBJECTNO,PACKAGETYPE,STATUS,INPUTUSERID,INPUTORGID,INPUTDATE)"+
				    " VALUES(:SERIALNO,:OBJECTTYPE,:OBJECTNO,:PACKAGETYPE,:STATUS,:INPUTUSERID,:INPUTORGID,:INPUTDATE)";
		    BizObjectQuery bq = bmDfp.createQuery(sSQLDFP);
		    int i = bq.setParameter("SERIALNO", sPackageSerialNo) //档案编号
		    		  .setParameter("OBJECTTYPE", "jbo.guaranty.GUARANTY_RELATIVE") //档案类型：担保合同
		    		  .setParameter("OBJECTNO", sObjectNo)//对象编号：GUARANTY_RELATIVE表的流水号
		    		  .setParameter("PACKAGETYPE", "01")//业务资料类别：默认为"一类业务资料"
		    		  .setParameter("STATUS", "01")//状态 默认为 "待处理" 
		    		  .setParameter("INPUTUSERID", sInputUserID) //当前用户ID
		    		  .setParameter("INPUTORGID", sInputOrgID)//当前用户所属机构的ID
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
