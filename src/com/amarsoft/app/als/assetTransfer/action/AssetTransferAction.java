/**
 * 
 */
package com.amarsoft.app.als.assetTransfer.action;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import com.amarsoft.app.als.assetTransfer.model.ProjectAssetRela;
import com.amarsoft.app.als.assetTransfer.model.ProjectInfo;
import com.amarsoft.app.als.assetTransfer.util.AssetProjectCodeConstant;
import com.amarsoft.app.als.assetTransfer.util.AssetProjectJBOClass;
import com.amarsoft.app.als.credit.common.model.CreditConst;
import com.amarsoft.app.base.util.DateHelper;
import com.amarsoft.are.jbo.BizObject;
import com.amarsoft.are.jbo.BizObjectManager;
import com.amarsoft.are.jbo.JBOException;
import com.amarsoft.are.jbo.JBOFactory;
import com.amarsoft.are.jbo.JBOTransaction;
import com.amarsoft.are.lang.StringX;

/**
 * 描述：	资产转让/受让相关处理
 * @author xyli
 * @2014-4-24
 */
public class AssetTransferAction {
	
	private String serialNo;
	private String projectNo;
	//项目状态
	private String status;
	//项下资产状态
	private String projectAssetStatus;
	//项下资产账号
	private String assetProjectNo;
	/** 资产项目类型：转让，受让 */
	private String assetProjectType;
	
	private String manageOrgId;
	
	private String manageUserId;
	
	private String serialNos;
	
	private String objectNo;
	
	private String objectType;
	
	private String orgs;
	
	/**
	 * 描述：查询项目关联的未分发资产流水号 若没有则返回空
	 * @return
	 * @throws JBOException 
	 */
	public String getRalativeSerialNo(JBOTransaction tx) throws JBOException{
		String returnValue = "";
		List<BizObject> boList = new ProjectInfo(tx, projectNo).getRelaAssetList(projectNo);
		if(boList.size() != 0 ){
			for(BizObject bo : boList){
				if("010".equals(bo.getAttribute("status").getString()))
				returnValue += bo.getAttribute("SerialNo").getString() + "@";
			}
		}
		return returnValue	;
	}
	
	/**
	 * 描述：更改项目状态
	 * @param tx
	 * @return
	 * @throws Exception
	 */
	
	public String changeProjectStatus(JBOTransaction tx) throws Exception{
		String result = "false";
		if(!StringX.isEmpty(serialNos)){
			if(serialNos.endsWith("@")){
				serialNos = serialNos.substring(0, serialNos.length() - 1);
			}
			String[] serialNo = serialNos.split("@");
			
			for(int i=0; i< serialNo.length; i++){
				ProjectInfo info = new ProjectInfo(tx, serialNo[i]);
				info.getBizObject().setAttributeValue("status", status);
				if("06".equals(status)){
					info.getBizObject().setAttributeValue("PLANPACKETDATE", DateHelper.getBusinessDate());//日期
				}else if("0605".equals(status)){
					info.getBizObject().setAttributeValue("PLANPOOLDATE", DateHelper.getBusinessDate());//日期
				}
				info.saveObject();
			}
			result = "true";
		}
		return result;
	}
	/**
	 * 描述：更改项下资产状态
	 * @param tx
	 * @return
	 * @throws Exception
	 */
	public String changeProjectAssetStatus(JBOTransaction tx)throws Exception{
		String result = "";
		
		ProjectAssetRela info = new ProjectAssetRela(tx, assetProjectNo);
		if(AssetProjectCodeConstant.ProjectAssetStatus_02.equals(projectAssetStatus)){
			info.getBizObject().setAttributeValue("Status", projectAssetStatus);
			info.saveObject();
		}else{
			info.changeStatus(projectNo, status);
		}
		
		return result;
	}
	/**
	 * 描述：资产分发
	 * @param tx
	 * @return
	 * @throws Exception
	 */
	public String assetDistribute(JBOTransaction tx)throws Exception{
			String result = "true";
			// 贷后管理方为我行时，选择项下资产，将其分发到对应的贷后管理机构进行管理，可多选,分发成功后，将以分发的资产状态改为“已分发”
			String[] serialNoArray=this.serialNos.split("@");
			Map<String,Object> map=new HashMap<String,Object>();
			map.put("UserID", this.manageUserId);
			map.put("OrgID", this.manageOrgId);
			map.put("Status", "020");//有效 已分发
	
			BizObjectManager bmBC=JBOFactory.getBizObjectManager(CreditConst.BC_JBOCLASS);
			tx.join(bmBC);
			BizObjectManager bmBD=JBOFactory.getBizObjectManager(CreditConst.BD_JBOCLASS);
			tx.join(bmBD);
			for(String serialNo:serialNoArray){
				ProjectAssetRela par=new ProjectAssetRela(tx,serialNo);
				par.setAttributesValue(map);
				par.saveObject();
				String bcSerialNO=par.getBizObject().getAttribute("BCSERIALBNO").getString();
				//String loanNo=par.getBizObject().getAttribute("LOANNO").getString();
				bmBC.createQuery("update o set ManageUserID=:userID , ManageOrgID=:orgID where SerialNo=:serialNo")
							.setParameter("userID", this.manageUserId)
							.setParameter("orgID",this.manageOrgId)
							.setParameter("serialNo",bcSerialNO).executeUpdate()
							;
				bmBD.createQuery("update o set OperateUserID=:userID , OperateOrgID=:orgID where SerialNo=:serialNo")
				.setParameter("userID", this.manageUserId)
				.setParameter("orgID",this.manageOrgId)
				.setParameter("serialNo",bcSerialNO).executeUpdate();
			}
			return result;
	}
	
	/**
	 * 描述：新增参与机构
	 * @param tx
	 * @return
	 * @throws Exception
	 */
	public String addJoinOrgs(JBOTransaction tx)throws Exception{
		String result = "false";
		
		BizObjectManager bmORG = JBOFactory.getBizObjectManager(AssetProjectJBOClass.TRANSFER_JOIN_ORGS);
		tx.join(bmORG);
		
		String[] joinOrgs = orgs.split("~");//选择机构
		for(String joinOrg : joinOrgs){
			String orgId = joinOrg.split("@")[0];
			//当前机构是否已存在
			BizObject biz = bmORG.createQuery("ObjectNo=:sObjectNo and ObjectType=:sObjectType and JoinOrgId=:sJoinOrgId")
								 .setParameter("sObjectNo", objectNo)
								 .setParameter("sObjectType", objectType)
								 .setParameter("sJoinOrgId", orgId).getSingleResult(false);
			if(null == biz){
				//增加
				BizObject newBiz = bmORG.newObject();
				newBiz.setAttributeValue("ObjectNo", objectNo);
				newBiz.setAttributeValue("ObjectType", objectType);
				newBiz.setAttributeValue("JoinOrgId", orgId);
				bmORG.saveObject(newBiz);
			}
			result = "true";
		}
		
		return result;
	}
	
	/**
	 * 描述：设置账户信息
	 * @param tx
	 * @return
	 * @throws Exception
	 */
	public String setAccountInfo(JBOTransaction tx)throws Exception{
		String result = "false";
		
		BizObjectManager bmAccount = JBOFactory.getBizObjectManager(AssetProjectJBOClass.ACCT_DEPOSIT_ACCOUNTS);
		tx.join(bmAccount);
		
		BizObject boAccount = bmAccount.createQuery("SerialNo=:serialNo").setParameter("serialNo", serialNos).getSingleResult(false);
		if(null != boAccount){
			String str1 = boAccount.getAttribute("ACCOUNTNAME").getString();//存款账户名称
			String str2 = boAccount.getAttribute("ACCOUNTTYPE").getString();//存款账户类型
			String str3 = boAccount.getAttribute("ACCOUNTNO").getString();//存款账户账号
			String str4 = boAccount.getAttribute("ACCOUNTCURRENCY").getString();//存款账户币种
			
			result = str1+"@"+str2+"@"+str3+"@"+str4;
		}
		
		return result;
	}

	
	/**
	 * 描述：设置复核意见信息
	 * @param tx
	 * @return
	 * @throws Exception
	 */
	public String setReCheckInfo(JBOTransaction tx)throws Exception{
		String result = "false";
		
		BizObjectManager assetInfo = JBOFactory.getBizObjectManager(AssetProjectJBOClass.PUB_TODO_LIST);
		tx.join(assetInfo);
		
		assetInfo.createQuery("update o set INPUTUSERID=:INPUTUSERID , INPUTORGID=:INPUTORGID , INPUTDATE=:INPUTDATE where TRACEOBJECTNO=:serialNo")
		.setParameter("INPUTUSERID", this.manageUserId)
		.setParameter("INPUTORGID",this.manageOrgId)
		.setParameter("INPUTDATE", status)
		.setParameter("serialNo",serialNo).executeUpdate();
		
		return result;
	}
	
	public String getProjectNo() {
		return projectNo;
	}

	public void setProjectNo(String projectNo) {
		this.projectNo = projectNo;
	}

	public String getSerialNo() {
		return serialNo;
	}

	public void setSerialNo(String serialNo) {
		this.serialNo = serialNo;
	}
	
	public String getStatus() {
		return status;
	}

	public void setStatus(String status) {
		this.status = status;
	}
	
	public String getProjectAssetStatus() {
		return projectAssetStatus;
	}

	public void setProjectAssetStatus(String projectAssetStatus) {
		this.projectAssetStatus = projectAssetStatus;
	}
	
	public String getAssetProjectNo() {
		return assetProjectNo;
	}

	public void setAssetProjectNo(String assetProjectNo) {
		this.assetProjectNo = assetProjectNo;
	}

	public String getAssetProjectType() {
		return assetProjectType;
	}

	public void setAssetProjectType(String assetProjectType) {
		this.assetProjectType = assetProjectType;
	}

	public String getManageOrgId() {
		return manageOrgId;
	}

	public void setManageOrgId(String manageOrgId) {
		this.manageOrgId = manageOrgId;
	}

	public String getManageUserId() {
		return manageUserId;
	}

	public void setManageUserId(String manageUserId) {
		this.manageUserId = manageUserId;
	}

	public String getSerialNos() {
		return serialNos;
	}

	public void setSerialNos(String serialNos) {
		this.serialNos = serialNos;
	}

	public String getObjectNo() {
		return objectNo;
	}

	public void setObjectNo(String objectNo) {
		this.objectNo = objectNo;
	}

	public String getObjectType() {
		return objectType;
	}

	public void setObjectType(String objectType) {
		this.objectType = objectType;
	}

	public String getOrgs() {
		return orgs;
	}

	public void setOrgs(String orgs) {
		this.orgs = orgs;
	}
	
}
