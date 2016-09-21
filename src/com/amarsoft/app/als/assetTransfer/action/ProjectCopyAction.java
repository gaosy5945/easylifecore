package com.amarsoft.app.als.assetTransfer.action;

import java.sql.SQLException;
import java.util.List;
import com.amarsoft.app.als.assetTransfer.util.AssetProjectJBOClass;
import com.amarsoft.app.base.businessobject.BusinessObject;
import com.amarsoft.app.base.businessobject.BusinessObjectManager;
import com.amarsoft.are.jbo.JBOException;
import com.amarsoft.are.jbo.JBOTransaction;
import com.amarsoft.are.lang.StringX;
import com.amarsoft.are.util.json.JSONObject;

/**
 * ��������Ŀ������Ƹ���Ŀ����������Ϣ	
 * @author �����Ŷ�
 * @2015-12-25
 */
public class ProjectCopyAction {
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
	 * ����һ����Ŀ
	 * 
	 * @return
	 * @throws Exception
	 */
	public BusinessObject copyProjectData(JBOTransaction tx) throws Exception{
		BusinessObjectManager bomanager = null;
		BusinessObject project = null;
		BusinessObject newProject = null;
		BusinessObject projectRelative = null;
		this.tx = tx;
		String newSerialNo = "";

		String serialNos = inputParameter.getValue("serialNo").toString();
		String userId = inputParameter.getValue("userID").toString();
		String orgId = inputParameter.getValue("orgId").toString();
		if(!StringX.isEmpty(serialNos)){
			if(serialNos.endsWith("@")){
				serialNos = serialNos.substring(0, serialNos.length() - 1);
			}
			String[] strs = serialNos.split("@");//��Ŀ���
			for(String bdSerialNo : strs){
				bomanager = this.getBusinessObjectManager();
				project = bomanager.loadBusinessObject(AssetProjectJBOClass.PRJ_BASIC_INFO, bdSerialNo);
				newProject = BusinessObject.createBusinessObject(project);
				newProject.setKey("");
				//project.setAttributeValue("STATUS", "08");
				bomanager.updateBusinessObject(project);
				bomanager.updateDB();//����prj_basic_infoԭ��¼Ϊ��ʧЧ��
				newProject.generateKey();
				bomanager.updateBusinessObject(newProject); 
				newProject.setAttributeValue("INPUTORGID", orgId);
				newProject.setAttributeValue("STATUS","01");
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
				
				List<BusinessObject> list=bomanager.loadBusinessObjects("jbo.prj.PRJ_ASSET_SECURITIZATION", "PROJECTSERIALNO = :PROJECTSERIALNO", "PROJECTSERIALNO",bdSerialNo);
				for(BusinessObject record:list){
					BusinessObject newSecuritization = BusinessObject.createBusinessObject(record);
					newSecuritization.setKey("");
					newSecuritization.generateKey();
					newSecuritization.setAttributeValue("PROJECTSERIALNO",newSerialNo);
					bomanager.updateBusinessObject(newSecuritization);
					bomanager.updateDB();//�����ʲ�֤ȯ�����¼
				}
				
				
				List<BusinessObject> acctList=bomanager.loadBusinessObjects("jbo.acct.ACCT_FEE", "OBJECTNO = :OBJECTNO and ObjectType = 'jbo.prj.PRJ_BASIC_INFO'", "OBJECTNO",bdSerialNo);
				if(acctList!=null&&acctList.size()>0)
					for(BusinessObject record:acctList){
						BusinessObject newSecuritization = BusinessObject.createBusinessObject(record);
						newSecuritization.setKey("");
						newSecuritization.generateKey();
						newSecuritization.setAttributeValue("OBJECTNO",newSerialNo);
						bomanager.updateBusinessObject(newSecuritization);
						bomanager.updateDB();//����acct_fee���¼
					}
				
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
