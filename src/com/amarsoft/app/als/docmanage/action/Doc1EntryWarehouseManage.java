package com.amarsoft.app.als.docmanage.action;

import java.sql.SQLException;
import java.util.ArrayList;

import com.amarsoft.app.base.businessobject.BusinessObject;
import com.amarsoft.app.base.businessobject.BusinessObjectManager;
import com.amarsoft.app.base.util.DateHelper;
import com.amarsoft.are.jbo.BizObjectManager;
import com.amarsoft.are.jbo.BizObjectQuery;
import com.amarsoft.are.jbo.JBOException;
import com.amarsoft.are.jbo.JBOFactory;
import com.amarsoft.are.jbo.JBOTransaction;
import com.amarsoft.are.lang.DateX;
import com.amarsoft.are.lang.StringX;
import com.amarsoft.are.util.json.JSONObject;
import com.amarsoft.awe.util.ASResultSet;
import com.amarsoft.awe.util.DBKeyHelp;
import com.amarsoft.awe.util.SqlObject;
import com.amarsoft.awe.util.Transaction;
import com.amarsoft.biz.bizlet.Bizlet;

/**
 * 业务资料管理一类资料
 * @author t-shenj
 *
 */
public class Doc1EntryWarehouseManage {
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
	 * 一类业务资料 入库
	 * 更新DFI DFP DO
	 * @param  
	 * @return
	 * @throws Exception
	 */
	public String Doc1EntryWarehouse(JBOTransaction tx) throws Exception{
		this.tx=tx;
		String sDFISerialNo = (String)inputParameter.getValue("DFISerialNo");
		String sObjectType = (String)inputParameter.getValue("ObjectType");
		String sObjectNo = (String)inputParameter.getValue("ObjectNo");
		String sDOSerialNo = (String)inputParameter.getValue("DOSerialNo");
		String sPackageId = (String)inputParameter.getValue("PackageId");
		return this.EntryWarehouse(sDFISerialNo,sObjectType,sObjectNo,sDOSerialNo,sPackageId);
	}
	/**
	 * 一类业务资料 入库
	 * @param  
	 * @return
	 * @throws Exception
	 */
	public String EntryWarehouse(String sDFISerialNo,String sObjectType,String sObjectNo,String sDOSerialNo,String sPackageId) throws Exception {
		try {
			
			//调用权证入库回执登记接口
			try
			{
			   Transaction Sqlca = Transaction.createTransaction(tx);
			   //OCITransaction oci = ClrInstance.WrntInStkRecptRgst(sPackageId,Sqlca.getConnection());
			}catch(Exception ex)
			{
				ex.printStackTrace();
				throw ex;
			}
			
			if(updateFileInfo(sDFISerialNo,"03") &&	
					updateFilePackage(sObjectType,sObjectNo,"03") &&	
					updateDOCOperation(sDOSerialNo,"02")){
				return "true";	
			}else{
				return "false";
			}
		} catch (Exception e) {
			this.tx.rollback();
			e.printStackTrace();
			return "false";
		}

	}
	/**
	 * 更新数据至Doc_Operation
	 * @param 
	 * @throws Exception 
	 */
  	private boolean updateDOCOperation(String sDOSerialNo,String sTatus) throws Exception{
  		try{
  			String sUserId = (String)inputParameter.getValue("UserId");
			BizObjectManager m = JBOFactory.getFactory().getManager("jbo.doc.DOC_OPERATION");
			BizObjectQuery bq = m.createQuery("update O set OPERATEDATE=:OPERATEDATE,OPERATEUSERID=:OPERATEUSERID,STATUS=:STATUS where SerialNo=:SerialNo");
			bq.setParameter("OPERATEDATE",DateHelper.getBusinessDate())
			  .setParameter("OPERATEUSERID", sUserId)
			  .setParameter("STATUS", sTatus)
			  .setParameter("SerialNo",sDOSerialNo).executeUpdate();	
			return true;
		} catch(Exception e){
			e.printStackTrace();
			return false;
		}
  	}	

	/**
	 * 更新数据 DFI
	 * @param 
	 * @throws Exception 
	 */
  	private boolean updateFileInfo(String sDFISerialNo,String sTatus) throws Exception{
		try{
			BizObjectManager m = JBOFactory.getFactory().getManager("jbo.doc.DOC_FILE_INFO");
			BizObjectQuery bq = m.createQuery("update O set STATUS=:STATUS where SerialNo=:SerialNo");
			bq.setParameter("STATUS", sTatus)
			  .setParameter("SerialNo",sDFISerialNo).executeUpdate();	
			return true;
		} catch(Exception e){
			e.printStackTrace();
			return false;
		}
  	}	

	/**
	 * 更新数据 DFP
	 * @param 
	 * @throws Exception 
	 */
  	private boolean updateFilePackage(String sObjectType,String sObjectNo,String sTatus) throws Exception{
		try{
			BizObjectManager m = JBOFactory.getFactory().getManager("jbo.doc.DOC_FILE_PACKAGE");
			BizObjectQuery bq = m.createQuery("update O set LASTOPERATEDATE=UPDATEDATE,UPDATEDATE=:UPDATEDATE,STATUS=:STATUS where PACKAGETYPE='01' and ObjectType=:ObjectType and ObjectNo=:ObjectNo");
			bq.setParameter("UPDATEDATE",DateHelper.getBusinessDate())
			  .setParameter("STATUS", sTatus)
			  .setParameter("ObjectType",sObjectType)
			  .setParameter("ObjectNo",sObjectNo).executeUpdate();	
			return true;
		} catch(Exception e){
			e.printStackTrace();
			return false;
		}
  	}	
}
