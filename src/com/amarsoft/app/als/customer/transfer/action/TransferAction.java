package com.amarsoft.app.als.customer.transfer.action;

import com.amarsoft.app.als.customer.model.CustomerBelong;
import com.amarsoft.app.als.customer.model.CustomerConst;
import com.amarsoft.are.jbo.BizObject;
import com.amarsoft.are.jbo.BizObjectManager;
import com.amarsoft.are.jbo.JBOException;
import com.amarsoft.are.jbo.JBOFactory;
import com.amarsoft.are.jbo.JBOTransaction;
import com.amarsoft.are.util.StringFunction;
/**
 * 客户转移处理类
 * @author wmZhu
 *
 */
public class TransferAction {
	
	private String customerID;//客户编号
	private String userID;//当前用户编号
	private String orgID;//当前用户编号
	private String receiveUserID;//待转移的用户编号
	private String receiveOrgID;//待转移的用户机构
	private String rightType;//转移类型
	private String afrightFlag;//业务管户权转移标识
	private String serialNo;//流水号
	private String transferType;//转让状态
	private String manaTime;//维护时限
	private String customerType;//客户类型
	
	/**
	 * 创建转出申请记录
	 * @throws Exception 
	 * @return2012-8-25
	 */
	public String saveTransferOut(JBOTransaction tx){
		String result = "true";
		try {
			BizObjectManager bomTransfer = JBOFactory.getBizObjectManager(CustomerConst.CUSTOMER_TRANSFER);
			tx.join(bomTransfer);
			BizObject bo;
			String sCustomers[] = customerID.split("@");
			for(int i=0;i<sCustomers.length;i++){
				checkApply(sCustomers[i],CustomerConst.tOperateType_20,userID,tx);
				//检查申请记录
				bo = bomTransfer.newObject();
				bo.setAttributeValue("TransferType",CustomerConst.TransferType_10);//转让状态 10:未确认
				saveTransfer(tx,bo,bomTransfer,sCustomers[i],"out");
			}
		} catch (Exception e) {
			result = "false";
			e.printStackTrace();
		}
		return result;
	}
	
	/**
	 * 创建转入申请记录
	 * @throws Exception 
	 * @return2012-8-25
	 */
	public String saveTransferIn(JBOTransaction tx){
		String result = "true";
		try {
			BizObjectManager bomTransfer = JBOFactory.getBizObjectManager(CustomerConst.CUSTOMER_TRANSFER);
			tx.join(bomTransfer);
			BizObject bo;
			String sCustomers[] = customerID.split("@");
			for(int i=0;i<sCustomers.length;i++){
				checkApply(sCustomers[i],CustomerConst.tOperateType_10,userID,tx);
				//检查申请记录
				bo = bomTransfer.newObject();
				bo.setAttributeValue("TransferType",CustomerConst.TransferType_10);//转让状态 10:未确认
				saveTransfer(tx,bo,bomTransfer,sCustomers[i],"in");
			}
		} catch (Exception e) {
			result = "false";
			e.printStackTrace();
		}
		return result;
	}
	
	/**
	 * 同意客户转移申请
	 * @throws Exception 
	 * @return
	 */
	@SuppressWarnings("deprecation")
	public String consentTransfer(JBOTransaction tx){
		String result = "true";
		try {
			BizObjectManager bom = JBOFactory.getBizObjectManager(CustomerConst.CUSTOMER_TRANSFER);
			tx.join(bom);
			BizObject biz = bom.createQuery("SerialNo=:serialNo").setParameter("serialNo", serialNo).getSingleResult(true);
			if(biz != null){
				String unOperateType = biz.getAttribute("UnOperateType").getString();//转移标志
				String newUser = biz.getAttribute("InputUserID").getString();//申请人
				String newOrg = biz.getAttribute("InputOrgID").getString();//申请机构
				String oldUser = userID;
				String oldOrg = orgID;
				if(CustomerConst.tOperateType_10.equals(unOperateType)){//转入
					oldUser = newUser;
					oldOrg = newOrg;
					newUser = userID;
					newOrg = orgID;
				}
				setBelong(tx,newUser,newOrg,oldUser,oldOrg,customerID);
				
				//更新转移申请信息
				biz.setAttributeValue("AFFIRMUSERID", userID);//确认人
				biz.setAttributeValue("AFFIRMORGID", orgID);//确认机构
				biz.setAttributeValue("AFFIRMDate", StringFunction.getToday());//确认日期
				biz.setAttributeValue("TRANSFERTYPE", CustomerConst.TransferType_20);//已确认
				biz.setAttributeValue("MainTainTime", manaTime);
				bom.saveObject(biz);
			}
		} catch (Exception e) {
			result = "false";
			e.printStackTrace();
		}
		return result;
	}
	
	/**
	 * 拒绝客户转移申请
	 * @throws Exception 
	 * @return
	 */
	@SuppressWarnings("deprecation")
	public String rejectTransfer(JBOTransaction tx){
		String result = "true";
		try {
			BizObjectManager bom = JBOFactory.getBizObjectManager(CustomerConst.CUSTOMER_TRANSFER);
			tx.join(bom);
			BizObject biz = bom.createQuery("SerialNo=:serialNo").setParameter("serialNo", serialNo).getSingleResult(true);
			if(biz != null){
				biz.setAttributeValue("REFUSEDATE", StringFunction.getToday());//拒绝日期
				biz.setAttributeValue("TRANSFERTYPE", CustomerConst.TransferType_30);//已拒绝
				bom.saveObject(biz);
			}
		} catch (Exception e) {
			result = "false";
			e.printStackTrace();
		}
		return result;
	}
	
	/**
	 * 维护权回收
	 * @throws JBOException 
	 * @return2012-8-28
	 */
	public String recover(JBOTransaction tx){
		String result = "true";
		try {
			BizObjectManager bomTransfer = JBOFactory.getBizObjectManager(CustomerConst.CUSTOMER_TRANSFER);
			tx.join(bomTransfer);
			
			BizObject bo = null;
			if( CustomerConst.TransferType_20.equals(this.transferType)){//如果状态为已确认,则先修改对应用户的权限
				CustomerBelong cb = new CustomerBelong(tx, this.customerID, this.userID);
				cb.setManageRight("2");
				cb.saveBelong();
			}
			//删除对应的申请记录
			bo = bomTransfer.createQuery("serialNo = :serialNo").setParameter("serialNo",this.serialNo).getSingleResult(true);
			bomTransfer.deleteObject(bo);
		} catch (Exception e) {
			result = "false";
			e.printStackTrace();
		}
		return result;
	}
	
	/**
	 * 设置管户记录
	 * @param tx
	 * @param newUser 新用户
	 * @param newOrg 新机构
	 * @param oldUser 旧用户
	 * @param oldOrg 旧机构
	 * @param customerID 客户编号
	 * @throws Exception
	 */
	private void setBelong(JBOTransaction tx,String newUser,String newOrg,String oldUser,String oldOrg,String customerID) throws Exception{
		CustomerBelong cb = new CustomerBelong(tx, customerID, newUser);
		cb.setInputUserID(userID);
		cb.setInputOrgID(orgID);
		if(CustomerConst.RightType_10.equals(rightType)){//管户权
				//管户权时,需将旧管户人的管户权限取消
				CustomerBelong cb2 = new CustomerBelong(tx, customerID, oldUser);
				cb2.setApplyRight("2");
				cb2.setManageRight("2");
				cb2.setModifyRight("2");
				cb2.saveBelong();
				
				cb.setManageRight("1");
				cb.setApplyRight("1");
		}
		cb.setViewyRight("1");
		cb.setModifyRight("1");
		cb.saveBelong();
	}
	
	/**
	 * 保存申请记录
	 * @param bo
	 * @param bom
	 * @param sCustomerID 客户编号
	 * @param typeFlag  转入转出标识
	 * @throws Exception 
	 */
	@SuppressWarnings("deprecation")
	private void saveTransfer(JBOTransaction tx,BizObject bo,BizObjectManager bom,String customerID,String typeFlag) throws Exception{
		if("in".equals(typeFlag)){//转入
			//获取客户管户人信息
			CustomerBelong cb = new CustomerBelong(null, customerID, null);
			String[] users = cb.getManageUser();
			if(users == null || checkAbandon(customerID)){//如果没有管户人或者为放弃户则直接转入
				users = new String[2];
				bo.setAttributeValue("TransferType",CustomerConst.TransferType_20);//转让状态 20:已确认
				bo.setAttributeValue("AFFIRMUSERID",userID);//确认人
				bo.setAttributeValue("AFFIRMORGID",orgID);//确认机构
				bo.setAttributeValue("AFFIRMDATE",StringFunction.getToday());//确认日期
				
				//更改管户记录
				setBelong(tx,userID,orgID,null,null,customerID);
			}
			bo.setAttributeValue("OperateType",CustomerConst.tOperateType_10);//操作类型  10:客户转入
			bo.setAttributeValue("UnOperateType", CustomerConst.tOperateType_20);//反操作类型  20:客户转出
			bo.setAttributeValue("receiveUserID",users[0]);//接受用户号
			bo.setAttributeValue("receiveOrgID",users[1]);
		}else{//转出
			bo.setAttributeValue("OperateType",CustomerConst.tOperateType_20);//操作类型 20:客户转出
			bo.setAttributeValue("UnOperateType", CustomerConst.tOperateType_10);//反操作类型  10:客户转入
			bo.setAttributeValue("receiveUserID",receiveUserID);//接受用户号
			bo.setAttributeValue("receiveOrgID",receiveOrgID);
		}
		bo.setAttributeValue("rightType",rightType);//转移类型
		bo.setAttributeValue("afrightFlag",afrightFlag);//业务转移标识
		bo.setAttributeValue("InputUserID", userID);
		bo.setAttributeValue("InputOrgID", orgID);
		bo.setAttributeValue("InputDate", StringFunction.getToday());
		bo.setAttributeValue("CustomerID",customerID);//客户编号
		if(this.manaTime != null && !"".equals(this.manaTime)){
			bo.setAttributeValue("MaintainTime",this.manaTime);//维护权期限			
		}
		bom.saveObject(bo);
	}
	
	/**
	 * 检查客户是否已经存在转移申请，如果存在则删除记录(新申请覆盖旧申请)
	 * @param sCustomerID 客户编号
	 * @param sOperateType 操作类型
	 * @param sUserID 申请人
	 * @param tx
	 * @throws Exception
	 */
	private void checkApply(String sCustomerID,String sOperateType,String sUserID,JBOTransaction tx) throws Exception{
		BizObjectManager bom = JBOFactory.getFactory().getManager(CustomerConst.CUSTOMER_TRANSFER);
		tx.join(bom);
		BizObject bo = bom.createQuery("CustomerID=:customerID and OperateType=:operateType and InputUserID=:userID and AFFIRMDATE is null and REFUSEDATE is null")
				.setParameter("customerID", sCustomerID).setParameter("operateType", sOperateType)
				.setParameter("userID", sUserID).getSingleResult(true);
		if(bo != null){
			bom.deleteObject(bo);
		}
	}
	
	/**
	 * 检查客户是否为放弃户
	 * @param customerID
	 * @return
	 */
	private boolean checkAbandon(String customerID){
		boolean result = false;
		//TODO 检查客户是否为放弃户
		return result;
	}

	public String getCustomerID() {
		return customerID;
	}

	public void setCustomerID(String customerID) {
		this.customerID = customerID;
	}

	public String getUserID() {
		return userID;
	}

	public void setUserID(String userID) {
		this.userID = userID;
	}

	public String getOrgID() {
		return orgID;
	}

	public void setOrgID(String orgID) {
		this.orgID = orgID;
	}

	public String getReceiveUserID() {
		return receiveUserID;
	}

	public void setReceiveUserID(String receiveUserID) {
		this.receiveUserID = receiveUserID;
	}

	public String getReceiveOrgID() {
		return receiveOrgID;
	}

	public void setReceiveOrgID(String receiveOrgID) {
		this.receiveOrgID = receiveOrgID;
	}

	public String getRightType() {
		return rightType;
	}

	public void setRightType(String rightType) {
		this.rightType = rightType;
	}

	public String getAfrightFlag() {
		return afrightFlag;
	}

	public void setAfrightFlag(String afrightFlag) {
		this.afrightFlag = afrightFlag;
	}

	public String getSerialNo() {
		return serialNo;
	}

	public void setSerialNo(String serialNo) {
		this.serialNo = serialNo;
	}

	public String getTransferType() {
		return transferType;
	}

	public void setTransferType(String transferType) {
		this.transferType = transferType;
	}

	public String getManaTime() {
		return manaTime;
	}

	public void setManaTime(String manaTime) {
		this.manaTime = manaTime;
	}

	public String getCustomerType() {
		return customerType;
	}

	public void setCustomerType(String customerType) {
		this.customerType = customerType;
	}

}
