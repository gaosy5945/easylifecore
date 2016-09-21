package com.amarsoft.app.lending.bizlets;

import java.util.ArrayList;
import java.util.List;

import com.amarsoft.app.base.businessobject.BusinessObject;
import com.amarsoft.app.base.businessobject.BusinessObjectManager;
import com.amarsoft.app.base.util.DateHelper;
import com.amarsoft.app.als.assetTransfer.util.AssetProjectJBOClass;
import com.amarsoft.app.workflow.config.FlowConfig;
import com.amarsoft.app.workflow.manager.FlowManager;
import com.amarsoft.are.jbo.BizObjectManager;
import com.amarsoft.are.jbo.JBOFactory;
import com.amarsoft.are.jbo.JBOTransaction;
import com.amarsoft.are.lang.StringX;

public class CopyProjectData{
	private String userID;
	private String orgID;
	private String serialNo;
	private String applyType;
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

	public String getSerialNo() {
		return serialNo;
	}

	public void setSerialNo(String serialNo) {
		this.serialNo = serialNo;
	}

	public String getApplyType() {
		return applyType;
	}

	public void setApplyType(String applyType) {
		this.applyType = applyType;
	}
	public Object copyProjectData(JBOTransaction tx) throws Exception{	
		String objectType = "jbo.prj.PRJ_BASIC_INFO";
		BizObjectManager pbi = JBOFactory.getBizObjectManager("jbo.prj.PRJ_BASIC_INFO");
		tx.join(pbi);
		BusinessObjectManager bomanager = BusinessObjectManager.createBusinessObjectManager();
		BusinessObject newProject = copyData(tx,bomanager);
		BusinessObject apply = BusinessObject.createBusinessObject();
		apply.setAttributeValue("ApplyType", "Apply21");
		apply.setAttributeValue("UserID", userID);
		apply.setAttributeValue("orgID", orgID);
		
		List<BusinessObject> objects = new ArrayList<BusinessObject>();
		//objects.add(newProject);
		//������������PRJ_ASSET_LOG,��Ҫ�����������������,Ȼ��
		BusinessObject prjAsset = BusinessObject.createBusinessObject("jbo.prj.PRJ_ASSET_LOG");
		prjAsset.generateKey();
		prjAsset.setAttributeValue("ObjectType", objectType);
		prjAsset.setAttributeValue("ObjectNo", serialNo);
		prjAsset.setAttributeValue("ProjectSerialNo", newProject.getKeyString());
		prjAsset.setAttributeValue("AdjustUserID", newProject.getAttribute("InputUserID").getString());
		prjAsset.setAttributeValue("AdjustOrgID", newProject.getAttribute("InputOrgID").getString());
		prjAsset.setAttributeValue("AdjustDate", DateHelper.getBusinessDate());
		bomanager.updateBusinessObject(prjAsset);
		bomanager.updateDB();//����prj_relative��¼
		objects.add(prjAsset);
		apply.setAttributeValue("ProjectSerialNo", newProject.getKeyString());
		apply.setAttributeValue("ProjectName", newProject.getAttribute("ProjectName").getString());
		apply.setAttributeValue("ProjectType", newProject.getAttribute("ProjectType").getString());
		//��ʼ������
		String flowNo = "ProjectAlterFlow";
		String flowVersion = FlowConfig.getFlowDefaultVersion(flowNo);
		FlowManager fm = FlowManager.getFlowManager(bomanager);
		String result = fm.createInstance("jbo.prj.PRJ_ASSET_LOG", objects, flowNo, userID, orgID, apply);;
		//�����Ƿ�������Ӱ���������ݴ���
		String instanceID = result.split("@")[0];
		String phaseNo = result.split("@")[1];
		String taskSerialNo = result.split("@")[2];
		//functionID ����
		String functionID = FlowConfig.getFlowPhase(flowNo, flowVersion, phaseNo).getString("FunctionID");
		tx.commit();
		return "true@"+newProject.getKeyString() +"@"+functionID+"@"+instanceID+"@"+taskSerialNo+"@"+phaseNo+"@����ɹ���";
	}
	//����һ���µ�xiang
	private BusinessObject copyData(JBOTransaction tx,BusinessObjectManager bomanager) throws Exception{
		BusinessObject project = null;
		BusinessObject newProject = null;
		BusinessObject projectRelative = null;
		String newSerialNo = "";
		if(!StringX.isEmpty(serialNo)){
			if(serialNo.endsWith("@")){
				serialNo = serialNo.substring(0, serialNo.length() - 1);
			}
			String[] strs = serialNo.split("@");//��Ŀ���
			for(String bdSerialNo : strs){
				project = bomanager.loadBusinessObject(AssetProjectJBOClass.PRJ_BASIC_INFO, bdSerialNo);
				newProject = BusinessObject.createBusinessObject(project);
				newProject.setKey("");
				project.setAttributeValue("STATUS", "16");
				bomanager.updateBusinessObject(project);
				bomanager.updateDB();//����prj_basic_infoԭ��¼Ϊ��ʧЧ��
				newProject.generateKey();
				bomanager.updateBusinessObject(newProject); 
				newProject.setAttributeValue("INPUTORGID", orgID);
				newProject.setAttributeValue("STATUS","11");
				bomanager.updateDB();//����prj_basic_info��¼
				
				newSerialNo = newProject.getString("SERIALNO");
				projectRelative = BusinessObject.createBusinessObject(AssetProjectJBOClass.PRJ_RELATIVE);
				projectRelative.generateKey();
				projectRelative.setAttributeValue("OBJECTNO", newSerialNo);
				projectRelative.setAttributeValue("OBJECTTYPE", "jbo.prj.PRJ_BASIC_INFO");
				projectRelative.setAttributeValue("PROJECTSERIALNO", bdSerialNo);
				projectRelative.setAttributeValue("RELATIVETYPE", "03");
				bomanager.updateBusinessObject(projectRelative);
				bomanager.updateDB();//����prj_relative��¼
				String ProjectType = newProject.getString("ProjectType");				
				
				List<BusinessObject> assetList=bomanager.loadBusinessObjects("jbo.prj.PRJ_ASSET_INFO", "PROJECTSERIALNO = :OBJECTNO", "OBJECTNO",bdSerialNo);
				for(BusinessObject record:assetList){
					BusinessObject newSecuritization = BusinessObject.createBusinessObject(record);
					newSecuritization.setKey("");
					newSecuritization.generateKey();
					newSecuritization.setAttributeValue("PROJECTSERIALNO",newSerialNo);
					bomanager.updateBusinessObject(newSecuritization);
					bomanager.updateDB();//����prj_asset_info���¼
				}
			}
		}
		return newProject;
	}
}
