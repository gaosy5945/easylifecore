package com.amarsoft.app.als.docmanage.action;

import java.sql.SQLException;

import com.amarsoft.app.base.businessobject.BusinessObject;
import com.amarsoft.app.base.businessobject.BusinessObjectManager;
import com.amarsoft.app.base.util.DateHelper;
import com.amarsoft.app.als.customer.model.CustomerConst;
import com.amarsoft.app.als.dataimport.xlsimport.ExcelAddressExcpetion;
import com.amarsoft.are.jbo.BizObject;
import com.amarsoft.are.jbo.BizObjectManager;
import com.amarsoft.are.jbo.BizObjectQuery;
import com.amarsoft.are.jbo.JBOException;
import com.amarsoft.are.jbo.JBOFactory;
import com.amarsoft.are.jbo.JBOTransaction;
import com.amarsoft.are.lang.StringX;
import com.amarsoft.are.util.json.JSONObject;
import com.amarsoft.awe.util.Transaction;

public class Doc1EntryWarehousePackage {
	//参数
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
	 * 一类业务资料 封包
	 * @param  
	 * @return
	 * @throws Exception
	 */
	public String EntryWarehousePackage(JBOTransaction tx) throws Exception{
		this.tx=tx;
		String sAISerialNoList = (String)inputParameter.getValue("AISerialNoList");
		String sDFISerialNoList = (String)inputParameter.getValue("DFISerialNoList");
		String sObjectNoList = (String)inputParameter.getValue("ObjectNoList");
		//String sDFISerialNo = (String)inputParameter.getValue("DFISerialNo");
		//String sObjectType = (String)inputParameter.getValue("ObjectType");
		//String sObjectNo = (String)inputParameter.getValue("ObjectNo");
		String sUserId =  (String)inputParameter.getValue("UserId");
		String sOrgId =  (String)inputParameter.getValue("OrgId");
		String sDataDate =  (String)inputParameter.getValue("DataDate");
		String sObjectType = "jbo.guaranty.GUARANTY_RELATIVE";
		String sPackageId = "";
		int iCount = 0;
		iCount = sDFISerialNoList.split("@").length;
		String ObjectInfo[][] = new String[3][iCount];
		ObjectInfo[0] = sDFISerialNoList.split("@");
		ObjectInfo[1] = sAISerialNoList.split("@");
		ObjectInfo[2] = sObjectNoList.split("@");
		String sReturnFlag = "false";
		
		String SrcStmBsnSerialNo =  (String)inputParameter.getValue("DOSerialNo");
		String ApplyType = "01";
		String ApplyRsnType = "";
		String ApplyStatus = "03";
		
		//调用保存权证出入库申请信息接口
		try
		{
			Transaction Sqlca = Transaction.createTransaction(tx);
		    //OCITransaction oci = ClrInstance.WrntInOutStkAplSave(SrcStmBsnSerialNo,ApplyType,ApplyRsnType,ApplyStatus,sUserId,sOrgId,sDataDate,sAISerialNoList,Sqlca.getConnection());
			
			//调用权证封包接口
			Transaction Sqlca1 = Transaction.createTransaction(tx);
		    //OCITransaction oci1 = ClrInstance.WrntPack(sAISerialNoList,sUserId,sOrgId,sDataDate,Sqlca.getConnection());
		    //sPackageId = oci1.getOMessage("SysBody").getFieldByTag("SvcBody").getObjectMessage().getFieldValue("PkgId");
		}catch(Exception ex)
		{
			ex.printStackTrace();
			throw ex;
		}
		for(int i=0;i<iCount;i++){
			sReturnFlag = this.EntryWarehousePackage(ObjectInfo[0][i],sObjectType,ObjectInfo[2][i],sPackageId);
			if("false".equals(sReturnFlag) || "false"==sReturnFlag){
				continue;
			}
		}
		return sReturnFlag;
	}

	/**
	 * 一类业务资料 封包
	 * @param  
	 * @return
	 * @throws Exception
	 */
	public String EntryWarehousePackage(String sDFISerialNo,String sObjectType,String sObjectNo,String sPackageId) throws Exception {
		try {
				String sDFPSerialNo = insertDocFilePackage(sObjectType,sObjectNo,sPackageId,"01");
				if (!"".equals(sDFPSerialNo) || "" != sDFPSerialNo || sDFPSerialNo.length() > 0) {
					updateFileInfo(sDFPSerialNo,sDFISerialNo,"02");	
					updateFilePackage(sDFPSerialNo,"02");	
				}
			return "true";
		} catch (Exception e) {
			e.printStackTrace();
			return "false";
		}

	}
	/**
	 * 插入数据至DOC_FILE_PACKAGE
	 * @param 
	 * @throws Exception 
	 */
  	private String insertDocFilePackage(String sObjectType,String sObjectNo,String sPackageId,String sPackageType) throws Exception{
  		businessObjectManager =  this.getBusinessObjectManager();
		String sDOSerialNo = "";
		String sUserId =  (String)inputParameter.getValue("UserId");
		if(StringX.isEmpty(sUserId) || "null".equals(sUserId) || null == sUserId)sUserId="";
		String sOrgId =  (String)inputParameter.getValue("OrgId");
		if(StringX.isEmpty(sOrgId) || "null".equals(sOrgId) || null == sOrgId)sOrgId="";
		
		try{
			//sDOSerialNo = DBKeyHelp.getSerialNo("Doc_Operation","SerialNo",""); 
			BusinessObject todo = BusinessObject.createBusinessObject("jbo.doc.DOC_FILE_PACKAGE");
			todo.generateKey();
			//todo.setAttributeValue("SERIALNO", sDOSerialNo);
			//String sPackageType = "02";
			todo.setAttributeValue("PACKAGEID", sPackageId);//入库
			todo.setAttributeValue("OBJECTTYPE", sObjectType);
			todo.setAttributeValue("OBJECTNO", sObjectNo);
			todo.setAttributeValue("PACKAGETYPE", sPackageType);
			todo.setAttributeValue("STATUS", "01");
			todo.setAttributeValue("MANAGEORGID", sOrgId);
			todo.setAttributeValue("MANAGEUSERID", sUserId);
			todo.setAttributeValue("INPUTORGID", sOrgId);
			todo.setAttributeValue("INPUTUSERID", sUserId);
			todo.setAttributeValue("INPUTDATE", DateHelper.getBusinessDate());
			todo.setAttributeValue("UPDATEDATE", DateHelper.getBusinessDate());
			businessObjectManager.updateBusinessObject(todo);
			businessObjectManager.updateDB();//新增DOC_OPERATION信息
			sDOSerialNo = todo.getString("SERIALNO");
			return sDOSerialNo;
		} catch(Exception e){
			e.printStackTrace();
			return "";
		}
  	}	

	/**
	 * 更新数据 DFI
	 * @param 
	 * @throws Exception 
	 */
  	private String updateFileInfo(String sDFPSerialNo,String sDFISerialNo,String sTatus) throws Exception{
		try{
			BizObjectManager m = JBOFactory.getFactory().getManager("jbo.doc.DOC_FILE_INFO");
			BizObjectQuery bq = m.createQuery("update O set PACKAGESERIALNO=:PACKAGESERIALNO,STATUS=:STATUS where SerialNo=:SerialNo");
			bq.setParameter("PACKAGESERIALNO",sDFPSerialNo)
			  .setParameter("STATUS", sTatus)
			  .setParameter("SerialNo",sDFISerialNo).executeUpdate();	
			return "true";
		} catch(Exception e){
			e.printStackTrace();
			return "";
		}
  	}	

  	/**
	 * 更新数据 DFP
	 * @param 
	 * @throws Exception 
	 */
  	private boolean updateFilePackage(String sSerialNo,String sTatus) throws Exception{
		try{
			BizObjectManager m = JBOFactory.getFactory().getManager("jbo.doc.DOC_FILE_PACKAGE");
			BizObjectQuery bq = m.createQuery("update O set LASTOPERATEDATE=UPDATEDATE,UPDATEDATE=:UPDATEDATE where serialNo =:SerialNo");
			bq.setParameter("UPDATEDATE",DateHelper.getBusinessDate())
			  .setParameter("STATUS", sTatus)
			  .setParameter("SerialNo",sSerialNo).executeUpdate();	
			return true;
		} catch(Exception e){
			e.printStackTrace();
			return false;
		}
  	}	
}
