package com.amarsoft.app.lending.bizlets;

import java.util.ArrayList;
import java.util.List;

import com.amarsoft.app.base.businessobject.BusinessObject;
import com.amarsoft.app.base.businessobject.BusinessObjectManager;
import com.amarsoft.app.base.util.DateHelper;
import com.amarsoft.app.workflow.config.FlowConfig;
import com.amarsoft.app.workflow.manager.FlowManager;
import com.amarsoft.are.jbo.BizObject;
import com.amarsoft.are.jbo.BizObjectManager;
import com.amarsoft.are.jbo.BizObjectQuery;
import com.amarsoft.are.jbo.JBOFactory;
import com.amarsoft.are.jbo.JBOTransaction;
import com.amarsoft.awe.util.Transaction;
import com.amarsoft.biz.bizlet.Bizlet;

public class InitProjectAlterApplyInfo extends Bizlet{
	
	public Object run(Transaction Sqlca) throws Exception {
		   JBOTransaction tx = null; 
		   
		   try{
			   tx = JBOFactory.createJBOTransaction();
			   tx.join(Sqlca);
			   JBOFactory f = JBOFactory.getFactory();
			   BusinessObject apply = BusinessObject.createBusinessObject();
			   for(int i=0;i<this.getAttributes().getKeys().length;i++){
				   String key = this.getAttributes().getKeys()[i].toString();
				   Object value = this.getAttribute(key);
				   apply.setAttributeValue(key, value);
			   }
				
			   String userID = apply.getString("UserID");
			   String orgID = apply.getString("OrgID");
			   String objectType = "jbo.prj.PRJ_ASSET_LOG";
				
			    //申请信息处理
				BizObjectManager pal = f.getManager("jbo.prj.PRJ_ASSET_LOG");
				tx.join(pal);
				String serialNo = apply.getString("SerialNo");
				BizObject bo = null;
				if(serialNo == null || "".equals(serialNo.trim()))
				{
					bo = pal.newObject();
					bo.setAttributeValue("ProjectSerialNo", apply.getString("ProjectSerialNo"));
					bo.setAttributeValue("AdjustType", apply.getString("AdjustType"));
					bo.setAttributeValue("AdjustUserID", userID);
					bo.setAttributeValue("AdjustOrgID", orgID);
					bo.setAttributeValue("AdjustDate", DateHelper.getBusinessDate());
					pal.saveObject(bo);
					serialNo = bo.getAttribute("SerialNo").getString();
					pal.saveObject(bo);
				}
				else
				{
					BizObjectQuery palq =  pal.createQuery("SerialNo=:SerialNo");
					palq.setParameter("SerialNo", serialNo);
					List<BizObject> bos = palq.getResultList(true);
					if(bos == null || bos.isEmpty()) throw new Exception("未找到申请信息，请检查！");
					bo = bos.get(0);
					bo.setAttributeValue("ProjectSerialNo", apply.getString("ProjectSerialNo"));
					bo.setAttributeValue("AdjustType", apply.getString("AdjustType"));
					pal.saveObject(bo);
				}
				
				List<BusinessObject> objects = new ArrayList<BusinessObject>();
				objects.add(BusinessObject.convertFromBizObject(bo));
				
				//项目信息处理
				BizObjectManager pbi = f.getManager("jbo.prj.PRJ_BASIC_INFO");
				tx.join(pbi);
				String ProjectSerialNo = apply.getString("ProjectSerialNo");
				if(ProjectSerialNo == null || "".equals(ProjectSerialNo.trim()))
				{
					bo = pbi.newObject();
					bo.setAttributeValue("CustomerID", apply.getString("CustomerID"));
					bo.setAttributeValue("ProjectType", apply.getString("ProjectType"));
					bo.setAttributeValue("AdjustUserID", userID);
					bo.setAttributeValue("AdjustOrgID", orgID);
					bo.setAttributeValue("AdjustDate", DateHelper.getBusinessDate());
					pbi.saveObject(bo);
				}
				
				//客户的处理
				String customerID = apply.getString("CustomerID");
				String PartnerType = apply.getString("PartnerType");
				if(customerID == null || "".equals(customerID))
				{
						
					BizObjectManager cp = f.getManager("jbo.customer.CUSTOMER_PARTNER");
					tx.join(cp);
					bo = cp.newObject();
					bo.setAttributeValue("CustomerID", customerID);
					bo.setAttributeValue("PartnerType", PartnerType);
					cp.saveObject(bo);
				}				
				
				
				String flowNo = "S0215.Hypothecated_load.Flow_002_02";
				String flowVersion = "1.0.0";
				tx.getConnection(Sqlca);
				BusinessObjectManager bomanager = BusinessObjectManager.createBusinessObjectManager(tx);
				FlowManager fm = FlowManager.getFlowManager(bomanager);
				String result = fm.createInstance(objectType, objects, flowNo, userID, orgID, apply);
				
				String instanceID = result.split("@")[0];
				String phaseNo = result.split("@")[1];
				String taskSerialNo = result.split("@")[2];
				String functionID = FlowConfig.getFlowPhase(flowNo, flowVersion, phaseNo).getString("FunctionID");
				return "true@"+serialNo +"@"+apply.getString("CustomerID")+"@"+functionID+"@"+instanceID+"@"+taskSerialNo+"@保存成功！";
			}catch(Exception ex){
				if(tx != null) tx.rollback();
				throw ex;
			}
	    } 
}
