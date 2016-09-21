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
	 * @param sDFIInfoList：sDFISerialNo,sObjectType,sObjectNo
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
	 * 一类资料管理—— 新增操作
	 * @param tx
	 * @return
	 * @throws Exception
	 */
	public String EntryWarehousePackage(JBOTransaction tx) throws Exception{
		this.tx=tx;
		String sObjectNoList = (String)inputParameter.getValue("ObjectNoList");  
		String sObjectType = "jbo.guaranty.GUARANTY_RELATIVE";
		//通过获取流水号的方式生成"封包编号"
		String sPackageId = DBKeyHelp.getSerialNo();
		int iCount = 0;
		//获取要封包的业务资料数目
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
	 * 在进行封包操作时：更新资料包编号、业务资料状态
	 * @param sObjectNo
	 * @param sObjectType
	 * @param sPackageId
	 * @return
	 */
	private String EntryWarehousePackage(String sObjectNo,String sObjectType,String sPackageId) {
		String sReturnFlag = "false";//是否操作成功的标识
		try {
  			//1、获取对象管理实例
  			BizObjectManager m = JBOFactory.getFactory().getManager("jbo.doc.DOC_FILE_PACKAGE");
  			//2、声明操作的SQL语句
			BizObjectQuery bq = m.createQuery("update O set PACKAGEID =:PACKAGEID,STATUS=:STATUS where OBJECTNO=:OBJECTNO "
					                         + "AND OBJECTTYPE=:OBJECTTYPE AND STATUS='01'");
			//3、为SQL语句的占位符赋值并执行更新操作
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
	 * 新增已抵押生效的押品时，向业务资料包信息(doc_file_package)表中插入数据  yjhou 2015.02.27
	 *    将该业务资料 状态设置为 "待入库"
	 * @param sObjectNo  对象编号-->担保合同关联流水号
	 * @param sObjectType  对象类型 --> 担保合同
	 * @throws SQLException 
	 * @throws JBOException 
	 */
	public String insertDocFilePackage(JBOTransaction tx){
		this.tx=tx;
		//1、获取相关参数:业务资料类型、押品编号、当前用户编号、当前操作机构，如果获取的参数值为null，则设置为空字符串
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
			//2、获取业务管理对象 businessObjectManager
			businessObjectManager =  this.getBusinessObjectManager();
			//3、获取要操作的表对象:业务资料包对应的表对象
			BusinessObject bo = BusinessObject.createBusinessObject("jbo.doc.DOC_FILE_PACKAGE");
			//4、获取最新的流水号
			bo.generateKey();
			//5.为对应的表字段赋值
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
			//6、执行插入操作
			businessObjectManager.updateBusinessObject(bo); 
			businessObjectManager.updateDB();
			
			return "true";
		} catch (Exception e) {
			e.printStackTrace();
			return "false";
		}
	}
	
	
	/**
	 * 对待入库的信息进行入库操作时，将相关数据插入到对应的数据表   yjhou 2015-02-27
	 * @param tx  事务对象
	 * @return
	 * @throws Exception
	 */
	public String EntryWarehouseAdd(JBOTransaction tx) throws Exception{
		this.tx=tx;
		//获取请求参数：对象类型、对象编号(业务资料编号)
		String sObjectType = (String)inputParameter.getValue("ObjectType");
		String sObjectNo = (String)inputParameter.getValue("ObjectNo");
		String SrcStmBsnSerialNo = insertDocOperation(sObjectType,sObjectNo);

		//调用实际操作的方法 
		String sReturn = "";
		String sPackageId="";
		
		sPackageId = SrcStmBsnSerialNo;
		//insertDocOperationFile(SrcStmBsnSerialNo,sObjectNo);
		
		try{
			  	/**
			 * 进行入库操作时，
			 *   将doc_file_package表中的status的值更新为"03"(已入库)
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
	 * 对待入库的押品进行入库操作时，向业务资料管理操作记录(doc_operation)表中插入相关数据  yjhou 2015.02.27
	 * @param sObjectNo  对象编号-->押品编号
	 * @param sObjectType  对象类型 --> 担保合同
	 * @throws SQLException 
	 * @throws JBOException 
	 */
  	private String insertDocOperation(String sObjectType,String sObjectNo) throws Exception{
  		//1、获取相关参数:当前用户编号、当前操作机构，如果获取的参数值为null，则设置为空字符串
  		String sUserId =  (String)inputParameter.getValue("UserId");
  		if(StringX.isEmpty(sUserId) || "null".equals(sUserId) || null == sUserId){
  			sUserId=""; 
  		}
  		String sOrgId =  (String)inputParameter.getValue("OrgId");
  		if(StringX.isEmpty(sOrgId) || "null".equals(sOrgId) || null == sOrgId){
  			sOrgId="";
  		}
		//2、获取业务管理对象 businessObjectManager
  		businessObjectManager =  this.getBusinessObjectManager();
  		//3、获取要操作的表对象:业务资料管理操作记录对应的表对象
  		BusinessObject bo = BusinessObject.createBusinessObject("jbo.doc.DOC_OPERATION");
		//4、获取最新的流水号
  		bo.generateKey();
  		//5、为表字段赋值
  		bo.setAttributeValue("OBJECTTYPE", sObjectType);//对象类型
  		bo.setAttributeValue("OBJECTNO", sObjectNo);//对象编号
  		bo.setAttributeValue("TRANSACTIONCODE", "0020");//操作类型：默认为"入库"
  		bo.setAttributeValue("OPERATEDATE", DateHelper.getBusinessDate());//操作日期
  		bo.setAttributeValue("OPERATEUSERID", sUserId);//操作人
  		bo.setAttributeValue("STATUS", "01");//状态：默认为"待处理"
  		bo.setAttributeValue("INPUTUSERID", sUserId);//登记人
  		bo.setAttributeValue("INPUTORGID",sOrgId);//登记机构
  		bo.setAttributeValue("UPDATEDATE",DateHelper.getBusinessDate());//登记日期
  		//6、执行插入操作
		businessObjectManager.updateBusinessObject(bo);
		businessObjectManager.updateDB();//新增DOC_OPERATION信息
		//7、返回生成的操作流水号
		return bo.getString("SERIALNO");
  	}	
  	
  	/**
  	 * 对待入库的押品进行入库操作时，向业务资料管理操作关联记录(Doc_Operation_File)表中插入相关数据  yjhou 2015.02.27
  	 * @param sDOSerialNo  业务资料关联编号
  	 * @param ObjectNo  业务资料编号<担保合同关联流水号>
  	 * @return
  	 * @throws Exception
  	 */
  	private boolean insertDocOperationFile(String sDOSerialNo,String ObjectNo){
  		String sDOFSerialNo = "";
		try{
			//1、获取业务管理对象 businessObjectManager
	  		businessObjectManager =  this.getBusinessObjectManager();
			//2、获取要操作的表对象:业务资料管理操作关联记录对应的表对象
			BusinessObject bo = BusinessObject.createBusinessObject("jbo.doc.DOC_OPERATION_FILE");
			//3、获取最新的流水号
			bo.generateKey();
			//4、为操作数据表字段设置值
			bo.setAttributeValue("OPERATIONSERIALNO", sDOSerialNo);//管理操作编号<业务资料管理操作记录流水号>
			bo.setAttributeValue("FILESERIALNO", ObjectNo);//业务资料编号
			bo.setAttributeValue("OPERATEMEMO", "");//描述
			//5、执行插入操作
			businessObjectManager.updateBusinessObject(bo);
			businessObjectManager.updateDB();//新增DOC_OPERATION信息
			sDOFSerialNo = bo.getString("SERIALNO");
			return true;
		} catch(Exception e){
			e.printStackTrace();
			return false;
		}
  	}	
  	
  	/**
  	 * 当入库操作成功后，将doc_file_package标表中的"一类业务资料状态"的值变更为"03"(已入库)
  	 * @param sObjectNo
  	 * @param sObjectType
  	 * @return
  	 */
  	private boolean updateDocFilePackage(String sObjectNo, String sObjectType,String sPackageId) {
  		try{
  			//1、获取对象管理实例
  			BizObjectManager m = JBOFactory.getFactory().getManager("jbo.doc.DOC_FILE_PACKAGE");
  			//2、声明操作的SQL语句
			BizObjectQuery bq = m.createQuery("update O set STATUS=:STATUS,PACKAGEID=:PACKAGEID,UPDATEDATE=:UPDATEDATE where OBJECTNO=:OBJECTNO AND OBJECTTYPE=:OBJECTTYPE AND STATUS='02'");
			//3、为SQL语句的占位符赋值
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
	 * 批量 更新数据至Doc_Operation_File
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
  	 * 一类资料出库申请提交
  	 * @return
  	 */
  	public String commit(JBOTransaction tx) throws Exception{
  		this.tx=tx;
  		//1、获取业务请求参数
		String sDOSerialNo = (String)inputParameter.getValue("DOSerialNo");//申请流水号
		String sApplyType = (String)inputParameter.getValue("ApplyType"); //阶段类型：01 申请  02 审批通过 03退回
		String sUserId = (String)inputParameter.getValue("UserID");//当前用户编号
		String sTransactionCode = (String)inputParameter.getValue("TransactionCode");//出库方式
		
		//定义变量：申请状态、业务资料状态、返回值、操作结果
		String sDOStatus = "",sDFPStatus = "",  sReturnValue="false";
		boolean flag = false ;
		try{
			String  sDate= DateHelper.getBusinessDate();
			//申请阶段提交申请时
			if("01" == sApplyType || "01".equals(sApplyType)){
				sDOStatus = "02";
				flag = updateDO(sDOStatus,sDOSerialNo,sUserId,sDate,sApplyType);
			}//审批阶段
			 else  if("02" == sApplyType || "02".equals(sApplyType)){
				sDOStatus = "03";
				flag = updateDO(sDOStatus,sDOSerialNo,sUserId,sDate,sApplyType);
			}//申请审批退回
			else if("03" == sApplyType || "03".equals(sApplyType)){
				sDOStatus = "04";
				flag = updateDO(sDOStatus,sDOSerialNo,sUserId,sDate,sApplyType);
			}
			//若Doc_operation更新成功后，更新业务资料状态
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
				
				//6、执行插入操作 
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
  	 * 待业务资料操作(审批通过时)状态变更操作成功后，在变更业务资料状态
  	 * 		操作方式为： 出库  变更为 已出库
  	 *              出借   变更为 部分资料出库
  	 * @param sDOSerialNo   业务资料操作流水号
  	 * @param sDFPStatus    业务资料状态 (04已出库 、05 部分资料出库)
  	 */
  	private int updateDocPackageStatus(String sDOSerialNo, String sDFPStatus) {
  		 int i = 0;
		try {
			//1、获取对象管理实例
			BizObjectManager m = JBOFactory.getFactory().getManager("jbo.doc.DOC_FILE_PACKAGE");
			//2、声明操作的SQL语句
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
  	 * 出库申请各阶段的状态变更
  	 * @param sDOStatus   业务资料操作状态 (01 申请提交 02 审批通过 03 申请退回)
  	 * @param sDOSerialNo  业务资料操作流水号
   	 * @param sUserId      当前用户ID
  	 * @param sDate		         操作日期
  	 * @param sApplyType   操作阶段  (01  提交 02 审批  03  退回)
  	 * @return
  	 */
	private boolean updateDO(String sDOStatus, String sDOSerialNo,
			String sUserId, String sDate, String sApplyType) {
		boolean flag = false;
		try{
  			//1、获取对象管理实例
  			BizObjectManager m = JBOFactory.getFactory().getManager("jbo.doc.DOC_OPERATION");
  			//2、声明操作的SQL语句
			BizObjectQuery bq = m.createQuery("update O set STATUS=:STATUS,O.OPERATEUSERID=:OperateUserId"+ 
				     						  " where O.SERIALNO =:SerialNo");  
			//3、为SQL语句的占位符赋值
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
