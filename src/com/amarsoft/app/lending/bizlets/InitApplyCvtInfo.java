package com.amarsoft.app.lending.bizlets;

import java.util.ArrayList;
import java.util.Date;
import java.util.List;

import com.amarsoft.app.base.businessobject.BusinessObject;
import com.amarsoft.app.base.businessobject.BusinessObjectManager;
import com.amarsoft.app.base.util.DateHelper;
import com.amarsoft.app.als.prd.analysis.ProductAnalysisFunctions;
import com.amarsoft.app.workflow.config.FlowConfig;
import com.amarsoft.app.workflow.manager.FlowManager;
import com.amarsoft.are.jbo.BizObject;
import com.amarsoft.are.jbo.BizObjectManager;
import com.amarsoft.are.jbo.BizObjectQuery;
import com.amarsoft.are.jbo.JBOFactory;
import com.amarsoft.are.jbo.JBOTransaction;
import com.amarsoft.awe.util.DBKeyHelp;
import com.amarsoft.awe.util.Transaction;
import com.amarsoft.biz.bizlet.Bizlet;

public class InitApplyCvtInfo extends Bizlet {

	public Object run(Transaction Sqlca) throws Exception{
		
		JBOTransaction tx = null;
		try{
			tx = JBOFactory.createJBOTransaction();
			JBOFactory f = JBOFactory.getFactory();
			
			BusinessObject apply = BusinessObject.createBusinessObject();
			for(int i=0;i<this.getAttributes().getKeys().length;i++){
				String key = this.getAttributes().getKeys()[i].toString();
				Object value = this.getAttribute(key);
				apply.setAttributeValue(key, value);
			}
			
			String userID = apply.getString("UserID");
			String orgID = apply.getString("OrgID");
			String objectType = "jbo.app.BUSINESS_APPLY";
			
			String CLFlag = apply.getString("CLFlag");
			String CLNoFlag = apply.getString("CLNoFlag");
			
			//关联单笔或额度信息对象
			BizObjectManager bc = f.getManager("jbo.app.BUSINESS_CONTRACT");
			tx.join(bc);
			BizObjectQuery boq = bc.createQuery("SerialNo=:SerialNo");
			BizObject bcbo = null;
			if("1".equals(CLFlag))
			{
				boq.setParameter("SerialNo", apply.getString("CLSerialNo"));
				bcbo = boq.getSingleResult(false);
			}
			else
			{
				boq.setParameter("SerialNo", apply.getString("SingleSerialNo"));
				bcbo = boq.getSingleResult(false);
			}
			
				
			//申请信息处理
			BizObjectManager ba = f.getManager("jbo.app.BUSINESS_APPLY");
			BizObjectManager bapplicant = f.getManager("jbo.app.BUSINESS_APPLICANT");
			tx.join(ba);
			tx.join(bapplicant);
			String serialNo = apply.getString("SerialNo");
			BizObject bo = null,applicant = null;
			if(serialNo == null || "".equals(serialNo.trim()))
			{
				bo = ba.newObject();
				bo.setAttributesValue(bcbo);
				bo.setAttributeValue("SerialNo",null);
				bo.setAttributeValue("BusinessType", "555");
				bo.setAttributeValue("ProductID", "555");
				bo.setAttributeValue("OccurDate", DateHelper.getBusinessDate());
				bo.setAttributeValue("BusinessPriority", apply.getString("BusinessPriority"));
				bo.setAttributeValue("NonstdIndicator", apply.getString("NonstdIndicator"));
				bo.setAttributeValue("OperateUserID", userID);
				bo.setAttributeValue("OperateOrgID", orgID);
				bo.setAttributeValue("OperateDate", DateHelper.getBusinessDate());
				bo.setAttributeValue("InputUserID", userID);
				bo.setAttributeValue("InputOrgID", orgID);
				bo.setAttributeValue("InputDate", DateHelper.getBusinessDate());
				bo.setAttributeValue("UpdateDate", DateHelper.getBusinessDate());
				bo.setAttributeValue("ApproveStatus", "01");
				ba.saveObject(bo);
				serialNo = bo.getAttribute("SerialNo").getString();
				if("1".equals(CLNoFlag) && "1".equals(CLFlag))
				{
					bo.setAttributeValue("ContractArtificialNo", bcbo.getAttribute("ContractArtificialNo").getString());
				}
				else
				{
					String contractArtificialNo = DBKeyHelp.getSerialNo("BUSINESS_CONTRACT", "ContractArtificialNo", orgID+"yyyy"+"1", "00000", new Date(), Sqlca);
					bo.setAttributeValue("ContractArtificialNo", contractArtificialNo);
				}
				ba.saveObject(bo);
				
				applicant = bapplicant.newObject();
				applicant.setAttributeValue("ObjectType", "jbo.app.BUSINESS_APPLY");
				applicant.setAttributeValue("ObjectNo", serialNo);
				applicant.setAttributeValue("ApplicantID", apply.getString("CustomerID"));
				applicant.setAttributeValue("ApplicantName", apply.getString("CustomerName"));
				applicant.setAttributeValue("InputUserID", userID);
				applicant.setAttributeValue("InputOrgID", orgID);
				applicant.setAttributeValue("InputDate", DateHelper.getBusinessDate());
				applicant.setAttributeValue("UpdateDate", DateHelper.getBusinessDate());
				applicant.setAttributeValue("ApplicantType", "01");//主申请人
				applicant.setAttributeValue("Status", "01");//主申请人状态
				bapplicant.saveObject(applicant);
			}
			
			//关联合同处理
			String singleSerialNo = apply.getString("SingleSerialNo");
			if(singleSerialNo != null && !"".equals(singleSerialNo))
			{
				BizObjectManager ar = f.getManager("jbo.app.APPLY_RELATIVE");
				tx.join(ar);
				BizObjectQuery arq =  ar.createQuery("SerialNo=:SerialNo and RelativeType in('02','03') ");
				arq.setParameter("SerialNo", serialNo);
				List<BizObject> ls = arq.getResultList(false);
				for(BizObject l:ls)
					ar.deleteObject(l);
				BizObject boar = ar.newObject();
				boar.setAttributeValue("ApplySerialNo", serialNo);
				boar.setAttributeValue("ObjectType", "jbo.app.BUSINESS_CONTRACT");
				boar.setAttributeValue("ObjectNo",singleSerialNo);
				boar.setAttributeValue("RelativeType","02");
				ar.saveObject(boar);
				
				if("1".equals(CLFlag))
				{
					boar = ar.newObject();
					boar.setAttributeValue("ApplySerialNo", serialNo);
					boar.setAttributeValue("ObjectType", "jbo.app.BUSINESS_CONTRACT");
					boar.setAttributeValue("ObjectNo",apply.getString("CLSerialNo"));
					boar.setAttributeValue("RelativeType","03");
					ar.saveObject(boar);
				}
			}
			
			List<BusinessObject> objects = new ArrayList<BusinessObject>();
			objects.add(BusinessObject.convertFromBizObject(bo));
			
			
			String productID = apply.getString("ProductID");
			if(productID == null || "".equals(productID)) productID = bo.getAttribute("BusinessType").getString();
			if(productID == null || "".equals(productID)) productID = "555";
			
			//业务资料定义
			String docs = ProductAnalysisFunctions.getComponentMandatoryValue(BusinessObject.convertFromBizObject(bo), "PRD04-01", "BusinessDocs","0010", "01");
			if(docs != null && !"".equals(docs)){
				BizObjectManager dfi = f.getManager("jbo.doc.DOC_FILE_INFO");
				tx.join(dfi);
				String[] docArray = docs.split(",");
				for(String docID:docArray){
					BizObject dfiBo = dfi.newObject();
					dfiBo.setAttributeValue("FILEID", docID);
					dfiBo.setAttributeValue("OBJECTTYPE", "contract");
					dfiBo.setAttributeValue("OBJECTNO", bo.getAttribute("ContractArtificialNo").getString());
					dfiBo.setAttributeValue("IMAGEDATE", DateHelper.getBusinessDate());
					dfiBo.setAttributeValue("STATUS", "02");
					dfiBo.setAttributeValue("FILEFORMAT", "03");
					dfi.saveObject(dfiBo);
				}
			}
			//业务流程定义
			String flowNo = ProductAnalysisFunctions.getComponentDefaultValue(BusinessObject.convertFromBizObject(bo), "PRD04-02", "CreditApproveFlowNo","0010", "01");
			if(flowNo == null || "".equals(flowNo)) throw new Exception("未取到对应业务流程定义，请联系系统管理员。");
			
			String flowVersion = FlowConfig.getFlowDefaultVersion(flowNo);
			BusinessObjectManager bomanager = BusinessObjectManager.createBusinessObjectManager(tx);
			FlowManager fm = FlowManager.getFlowManager(bomanager);
			//流程是否启动不影响整个数据处理
			String result = fm.createInstance(objectType, objects, flowNo, userID, orgID, apply);
			//流程是否启动不影响整个数据处理
			String instanceID = result.split("@")[0];
			String phaseNo = result.split("@")[1];
			String taskSerialNo = result.split("@")[2];
			
			String functionID = FlowConfig.getFlowPhase(flowNo, flowVersion, phaseNo).getString("FunctionID");
			tx.commit();
			return "true@"+serialNo +"@"+apply.getString("CustomerID")+"@"+functionID+"@"+instanceID+"@"+taskSerialNo+"@"+phaseNo+"@保存成功！";
		}catch(Exception ex){
			if(tx != null) tx.rollback();
			ex.printStackTrace();
			return "error@"+ex.getMessage();
		}
	}		
}
