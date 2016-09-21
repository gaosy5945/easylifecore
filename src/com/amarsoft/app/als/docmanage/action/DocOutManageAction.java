package com.amarsoft.app.als.docmanage.action;

import java.sql.SQLException;

import com.amarsoft.app.base.businessobject.BusinessObject;
import com.amarsoft.app.base.businessobject.BusinessObjectManager;
import com.amarsoft.app.base.util.DateHelper;
import com.amarsoft.are.jbo.BizObject;
import com.amarsoft.are.jbo.BizObjectManager;
import com.amarsoft.are.jbo.BizObjectQuery;
import com.amarsoft.are.jbo.JBOException;
import com.amarsoft.are.jbo.JBOFactory;
import com.amarsoft.are.jbo.JBOTransaction;
import com.amarsoft.are.lang.StringX;
import com.amarsoft.are.util.json.JSONObject;

public class DocOutManageAction {
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
	 * 进行出库操作：置DFP为出库，新增DO
	 * @param tx
	 * @return
	 */
	public String doOutWarehouse(JBOTransaction tx) throws Exception{
		this.tx=tx;
		String sReturnFlag = "false";
		String sDFPSerialNo= (String)inputParameter.getValue("DFPSerialNo");
		if(null == sDFPSerialNo || sDFPSerialNo == "null" || "null".equals(sDFPSerialNo)) sDFPSerialNo = "";
		String sDoSerialNo = (String)inputParameter.getValue("DOSerialNo");
		if(null == sDoSerialNo || sDoSerialNo == "null" || "null".equals(sDoSerialNo)) sDoSerialNo = "";
		String sTransCode = (String)inputParameter.getValue("TransCode");
		if(null == sTransCode || sTransCode == "null" || "null".equals(sTransCode)) sTransCode = "";
		String sOutType = (String)inputParameter.getValue("OutType");
		if(null == sOutType || sOutType == "null" || "null".equals(sOutType)) sOutType = "";
		sReturnFlag = doOutWarehouse( sDFPSerialNo, sDoSerialNo,sTransCode,sOutType);
		return sReturnFlag;
	}

	public String doOutWarehouse(String sDFPSerialNo,String sDoSerialNo,String sTransCode,String sOutType) throws Exception{
		String sReturnFlag = "false";
		boolean blFlag = false;
		String sDFPStatus = "";
		//生成发送押品系统接口的数据
		if("0020".equals(sTransCode) || "0020" == sTransCode){
			sDFPStatus = "04";
		}
		
		//modify by lzq 20150323 归还入库
		if("0040".equals(sTransCode) || "0040" == sTransCode){
			sDFPStatus = "03";//已入库
		}
		if("02".equals(sOutType) || "02"==sOutType){
			sReturnFlag = DocOperation( sDoSerialNo, sTransCode);
		}else if("01".equals(sOutType) || "01"==sOutType){
			//modify by lzq 20150331  一类业务资料出库 修改dfp.status=已出库，do.status=01，正常出库
			//dfp.packageid :因为没有封包等操作，所以借用该字段，表示暂存的出库流水号。
			//用do.status=00表示暂存，未提交出库。
			
			blFlag = updateFilePackage(sDFPSerialNo, sDFPStatus) ;
			if(blFlag){
				//sReturnFlag = insertDO( sTransCode, sDFPSerialNo);
				sReturnFlag = String.valueOf(updateOperation( sDoSerialNo, "01"));
			}
			/*try{
				Transaction Sqlca = Transaction.createTransaction(tx);
				//调用权证拆包接口
			    OCITransaction oci = ClrInstance.WrntUnpack(sAISerialNo,sPkgId,sUserId,sOrgId,Sqlca.getConnection());
			}catch(Exception ex) {
					ex.printStackTrace();
					//throw ex;
			}*/
		}else if("03".equals(sOutType) || "03"==sOutType){//归还入库
			blFlag = updateFilePackage(sDFPSerialNo, sDFPStatus) ;
			if(blFlag){
				sReturnFlag = DocOperation( sDoSerialNo, sTransCode);
			}
		}
		
		
		return sReturnFlag;
	}
	/**
	 * 更新数据 DFP
	 * @param 
	 * @throws Exception 
	 */
  	private boolean updateFilePackage(String sSerialNo,String sTatus) throws Exception{
		try{
			BizObjectManager m = JBOFactory.getFactory().getManager("jbo.doc.DOC_FILE_PACKAGE");
			BizObjectQuery bq = m.createQuery("update O set PACKAGEID='',LASTOPERATEDATE=UPDATEDATE,UPDATEDATE=:UPDATEDATE,Status=:Status where serialNo = :SerialNo");
			bq.setParameter("UPDATEDATE",DateHelper.getBusinessDate())
			  .setParameter("STATUS", sTatus)
			  .setParameter("SerialNo",sSerialNo).executeUpdate();	
			return true;
		} catch(Exception e){
			tx.rollback();
			e.printStackTrace();
			return false;
		}
  	}	
	/**
	 * 更新数据 DFI
	 * @param 
	 * @throws Exception 
	 */
  	private boolean updateFileInfo(String sSerialNo,String sTatus) throws Exception{
		try{
			BizObjectManager m = JBOFactory.getFactory().getManager("jbo.doc.DOC_FILE_INFO");
			BizObjectQuery bq = m.createQuery("update O set STATUS=:STATUS where SerialNo in(:SerialNo)");
			bq.setParameter("STATUS", sTatus)
			  .setParameter("SerialNo",sSerialNo.replace("@", "','")).executeUpdate();	
			return true;
		} catch(Exception e){
			tx.rollback();
			e.printStackTrace();
			return false;
		}
  	}	
  	/**
  	 * 出库领用后 变更业务资料状态
  	 * @param sDOSerialNO  出库申请流水号
  	 * @param sStatus   领用成功后的状态 06  已领用
  	 * @return
  	 * @throws Exception
  	 */
  	public String  updateOperation(JBOTransaction tx){
  		String sDOSerialNO = (String) inputParameter.getValue("DOSerialNo");
  		String sUserID = (String) inputParameter.getValue("UserID");
  		String sReturnValue = " ";
		try {
			BizObjectManager bm = JBOFactory.getFactory().getManager("jbo.doc.DOC_FILE_PACKAGE");
			tx.join(bm);
			BizObjectQuery bq = bm.createQuery("UPDATE O SET STATUS=:Status WHERE SERIALNO in (SELECT do.OBJECTNO FROM jbo.doc.DOC_OPERATION do WHERE do.SERIALNO =:SerialNo)");
			int i = bq.setParameter("Status", "06").setParameter("SerialNo", sDOSerialNO).executeUpdate();   
			if(i>0){
				sReturnValue = "true";
			}
			
		} catch (Exception e) {
			e.printStackTrace();
			sReturnValue = "false";
		}
  		return sReturnValue;
  	}
  	
  	private String insertDO(String sTransCode,String sDFPSerialNo){
  		String sObjectType = "jbo.doc.DOC_FILE_PACKAGE";
  		String sNewDOSerialNo = "";
		String sUserId =  (String)inputParameter.getValue("UserId");
		if(StringX.isEmpty(sUserId) || "null".equals(sUserId) || null == sUserId)sUserId="";
		String sOrgId =  (String)inputParameter.getValue("OrgId");
		if(StringX.isEmpty(sOrgId) || "null".equals(sOrgId) || null == sOrgId)sOrgId="";
		
		try{
			businessObjectManager =  this.getBusinessObjectManager();
			BusinessObject todo = BusinessObject.createBusinessObject("jbo.doc.DOC_OPERATION");
			todo.generateKey();
			//todo.setAttributeValue("SERIALNO", sDOSerialNo);
			todo.setAttributeValue("TRANSACTIONCODE", sTransCode);
			todo.setAttributeValue("OBJECTTYPE", sObjectType);
			todo.setAttributeValue("OBJECTNO", sDFPSerialNo);
			todo.setAttributeValue("INPUTUSERID", sUserId);
			todo.setAttributeValue("STATUS", "01");
			businessObjectManager.updateBusinessObject(todo);
			businessObjectManager.updateDB();//新增DOC_OPERATION信息
			sNewDOSerialNo = todo.getString("SERIALNO");
		} catch(Exception e){
			e.printStackTrace();
			return "";
		}
		return sNewDOSerialNo;
  	}
  	
  	/**
	 * 依据当前DOserialno 新增数据至Doc_Operation
	 * @param 
	 * @throws Exception 
	 */
  	private String DocOperation(String sDoSerialNo,String sTransCode) throws Exception{
  		businessObjectManager =  this.getBusinessObjectManager();
  		String sObjectType = "";
  		String sObjectNo = "";
  		String sUseUserId = "";
  		String sUseOrgId = "";
  		String sNewDOSerialNo = "";
		String sUserId =  (String)inputParameter.getValue("UserId");
		if(StringX.isEmpty(sUserId) || "null".equals(sUserId) || null == sUserId)sUserId="";
		String sOrgId =  (String)inputParameter.getValue("OrgId");
		if(StringX.isEmpty(sOrgId) || "null".equals(sOrgId) || null == sOrgId)sOrgId="";
		String status = "1000"; //归还入库提交，该笔do信息状态转为1000，不出现
		if("0020".equals(sTransCode)||"0020"==sTransCode){
			status = "03"; //已入库提交出库不变更状态;
		}
		String sNextDOStatus = "";
		sNextDOStatus = "03";
		try{
			BizObjectManager bm=JBOFactory.getBizObjectManager("jbo.doc.DOC_OPERATION");
			BizObject bo = bm.createQuery(" SERIALNO=:SERIALNO ").setParameter("SERIALNO", sDoSerialNo).getSingleResult(false); 
			if(bo==null){
			} else {
				sObjectType = bo.getAttribute("OBJECTTYPE").getString();
				sObjectNo = bo.getAttribute("OBJECTNO").getString();
				sUseUserId = bo.getAttribute("USEUSERID").getString();
				sUseOrgId = bo.getAttribute("USEORGID").getString();
			}                  
			if(updateOperation(sDoSerialNo,status) ){
				BusinessObject todo = BusinessObject.createBusinessObject("jbo.doc.DOC_OPERATION");
				todo.generateKey();
				//todo.setAttributeValue("SERIALNO", sDOSerialNo);
				todo.setAttributeValue("TRANSACTIONCODE", sTransCode);
				todo.setAttributeValue("OBJECTTYPE", sObjectType);
				todo.setAttributeValue("OBJECTNO", sObjectNo);
				todo.setAttributeValue("OPERATEDATE", DateHelper.getBusinessDate());
				todo.setAttributeValue("OPERATEUSERID", sUseUserId);
				todo.setAttributeValue("INPUTUSERID", sUserId);
				todo.setAttributeValue("INPUTDATE", DateHelper.getBusinessDate());
				todo.setAttributeValue("USEUSERID", sUseUserId);
				todo.setAttributeValue("USEORGID", sUseOrgId);
				todo.setAttributeValue("STATUS", sNextDOStatus );
				businessObjectManager.updateBusinessObject(todo);
				businessObjectManager.updateDB();//新增DOC_OPERATION信息
				sNewDOSerialNo = todo.getString("SERIALNO");

			}else{
			}
			
		} catch(Exception e){
			tx.rollback();
			e.printStackTrace();
		}

		return sNewDOSerialNo;
  	}	
  	
	public boolean updateOperation(String sSerialNo,String status) throws Exception{
		boolean bFlag=false;
		try{
			//1、获取对象管理实例
			BizObjectManager m = JBOFactory.getFactory().getManager("jbo.doc.DOC_OPERATION");
			//2、声明操作的SQL语句
			BizObjectQuery bq = m.createQuery("update O set STATUS=:STATUS  where O.SERIALNO =:SerialNo"); 
			bq.setParameter("STATUS",status).setParameter("SerialNo", sSerialNo).executeUpdate();
			bFlag=true;
		} catch (Exception e) {
			e.printStackTrace();
			bFlag=false;
		}
		return bFlag;
	}
	
	/**
  	 * 入库提交出库后 变更业务资料状态
  	 * @param SerialNo  出库申请流水号
  	 * @param BeforeDOSerialNo  入库申请流水号
  	 * @param Status   成功入库的状态为01
  	 * @return
  	 * @throws Exception
  	 */
  	public String  updateOperation1(JBOTransaction tx) throws Exception{
  		this.tx=tx;
  		String sSerialNo = (String) inputParameter.getValue("SerialNo");
  		String sBeforeDOSerialNo = (String) inputParameter.getValue("BeforeDOSerialNo");
  		String status = (String) inputParameter.getValue("Status");
  		String sReturnValue = " ";
  		
		try {
			//1、获取对象管理实例
			BizObjectManager m = JBOFactory.getFactory().getManager("jbo.doc.DOC_OPERATION");
			//2、声明操作的SQL语句
			//已入库提交出库，入库数据状态改为1000，隐藏
			BizObjectQuery bq = m.createQuery("update O set STATUS=:STATUS  where O.SERIALNO =:SerialNo"); 
			bq.setParameter("STATUS",1000).setParameter("SerialNo", sBeforeDOSerialNo).executeUpdate();
			//已入库提交出库，修改出库状态
			BizObjectQuery bq1 = m.createQuery("update O set STATUS=:STATUS  where O.SERIALNO =:SerialNo"); 
			bq1.setParameter("STATUS",status).setParameter("SerialNo", sSerialNo).executeUpdate();
			sReturnValue= "true";
		} catch (Exception e) {
			e.printStackTrace();
			sReturnValue = "false";
		}
  		return sReturnValue;
  	}
  	
  	/**
  	 * 入库提交出库后 变更业务资料状态
  	 * @param SerialNo 出库库申请流水号
  	 * @param Status   成功出库的状态为04
  	 * @return
	 * @throws Exception 
	 */
  	public String updateFilePackage1(JBOTransaction tx) throws Exception{
  		this.tx=tx;
  		String sSerialNo = (String) inputParameter.getValue("SerialNo");
  		String status = (String) inputParameter.getValue("Status");
		try{
			BizObjectManager m = JBOFactory.getFactory().getManager("jbo.doc.DOC_FILE_PACKAGE");
			BizObjectQuery bq = m.createQuery("update O set PACKAGEID='',LASTOPERATEDATE=UPDATEDATE,UPDATEDATE=:UPDATEDATE,Status=:Status where serialNo = :SerialNo");
			bq.setParameter("UPDATEDATE",DateHelper.getBusinessDate())
			  .setParameter("STATUS", status)
			  .setParameter("SerialNo",sSerialNo).executeUpdate();	
			return "true";
		} catch(Exception e){
			e.printStackTrace();
			return "false";
		}
  	}	
}
