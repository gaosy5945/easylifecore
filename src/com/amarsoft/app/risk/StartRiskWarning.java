package com.amarsoft.app.risk;
/**
 * add by bhxiao 
 * edit by zwcui
 * 发起预警
 * */
import java.util.ArrayList;
import java.util.List;

import com.amarsoft.app.base.businessobject.BusinessObject;
import com.amarsoft.app.base.businessobject.BusinessObjectManager;
import com.amarsoft.app.base.util.DateHelper;
import com.amarsoft.app.util.ASUserObject;
import com.amarsoft.app.workflow.config.FlowConfig;
import com.amarsoft.app.workflow.manager.FlowManager;
import com.amarsoft.app.workflow.util.FlowHelper;
import com.amarsoft.are.jbo.BizObject;
import com.amarsoft.are.jbo.BizObjectManager;
import com.amarsoft.are.jbo.JBOFactory;
import com.amarsoft.are.jbo.JBOTransaction;
import com.amarsoft.awe.util.Transaction;
import com.amarsoft.biz.bizlet.Bizlet;


public class StartRiskWarning extends Bizlet {

	@Override
	public Object run(Transaction Sqlca) throws Exception {//预警发起
		String valueList = (String) this.getAttribute("ValueList");
		String riskSignalType = (String) this.getAttribute("RiskSignalType");
		String userid = (String) this.getAttribute("UserID");
		String flowNo = (String) this.getAttribute("FlowNo");
		if(valueList==null||valueList.length()==0)valueList="";
		if(riskSignalType==null||riskSignalType.length()==0)riskSignalType="";
		if(userid==null||userid.length()==0)userid="";
		
		if(valueList.length()==0)
			throw new Exception("传入预警对象为空，无法发起风险预警！");
		
		ASUserObject curUser = ASUserObject.getUser(userid);
		
		JBOTransaction tx = null;
		try
		{
			tx = JBOFactory.createJBOTransaction();
			JBOFactory f = JBOFactory.getFactory();
			BizObjectManager rws = f.getManager("jbo.al.RISK_WARNING_SIGNAL");
			BizObjectManager rwo = f.getManager("jbo.al.RISK_WARNING_OBJECT");
			if("01".equals(riskSignalType)){
				String [] values = valueList.split("~", -1);
				for(int i=0;i<values.length;i++)
				{
					tx.join(rws);
					tx.join(rwo);
					String objectno = values[i];
					if(objectno==null||objectno.length()==0)continue;
					
					BizObject rwsbo = rws.newObject();
					rwsbo.setAttributeValue("TASKCHANNEL","01");
					rwsbo.setAttributeValue("SIGNALID","2015011500000001");//初始化一个预警信号
					rwsbo.setAttributeValue("SIGNALLEVEL","1");
					rwsbo.setAttributeValue("STATUS", "1");//预警发起
					rwsbo.setAttributeValue("SIGNALTYPE",riskSignalType);
					rwsbo.setAttributeValue("INPUTUSERID", curUser.getUserID());
					rwsbo.setAttributeValue("INPUTORGID", curUser.getOrgID());
					rwsbo.setAttributeValue("INPUTDATE", DateHelper.getBusinessDate());
					rws.saveObject(rwsbo);
					
					
					BizObject rwobo = rwo.newObject();
					rwobo.setAttributeValue("SIGNALSERIALNO", rwsbo.getAttribute("SerialNo").getString());
					/*rwobo.setAttributeValue("OBJECTTYPE","jbo.app.BUSINESS_DUEBILL");*/
					rwobo.setAttributeValue("OBJECTTYPE","jbo.acct.ACCT_LOAN");
					rwobo.setAttributeValue("OBJECTNO", objectno);
					rwo.saveObject(rwobo);
					
					BusinessObject apply = BusinessObject.createBusinessObject();
					for(int k=0;k<this.getAttributes().getKeys().length;k++){
						String key = this.getAttributes().getKeys()[k].toString();
						Object value = this.getAttribute(key);
						apply.setAttributeValue(key, value);
					}
					String CustomerName = "";
					BizObjectManager bmFO = JBOFactory.getFactory().getManager("jbo.acct.ACCT_LOAN");
					BizObject boFO = bmFO.createQuery(" SerialNo = :SerialNo")
										 .setParameter("SerialNo", objectno)
										 .getSingleResult(false);
					if(boFO != null){
						CustomerName = boFO.getAttribute("CustomerName").getString();
					}
					apply.setAttributeValue("OrgID", curUser.getOrgID());
					apply.setAttributeValue("CustomerName", CustomerName);
					apply.setAttributeValue("LoanSerialNo", objectno);
					apply.setAttributeValue("SignalType", riskSignalType);
					List<BusinessObject> objects = new ArrayList<BusinessObject>();
					objects.add(BusinessObject.convertFromBizObject(rwsbo));
					String flowVersion = FlowConfig.getFlowDefaultVersion(flowNo);
					BusinessObjectManager bomanager = BusinessObjectManager.createBusinessObjectManager(tx);
					FlowManager fm = FlowManager.getFlowManager(bomanager);
					fm.createInstance("jbo.al.RISK_WARNING_SIGNAL", objects, flowNo, curUser.getUserID(), curUser.getOrgID(),apply);
					tx.commit();
				}
			}else if("02".equals(riskSignalType)){//预警解除
				String[] rwsValue = valueList.split("~",-1);
				for(int i=0;i<rwsValue.length;i++){
					
					tx.join(rws);
					tx.join(rwo);
					String rwsSerialNo = rwsValue[i];
					if(rwsSerialNo==null||rwsSerialNo.length()==0)continue;
					
					BizObjectManager bmRWS = JBOFactory.getFactory().getManager("jbo.al.RISK_WARNING_OBJECT");
					BizObjectManager bmS = JBOFactory.getFactory().getManager("jbo.al.RISK_WARNING_SIGNAL");
					
					//获取关联业务借据编号
					BizObject boRWS = bmRWS.createQuery("SIGNALSERIALNO =:SIGNALSERIALNO and OBJECTTYPE = 'jbo.acct.ACCT_LOAN'")
										   .setParameter("SIGNALSERIALNO", rwsSerialNo)
										   .getSingleResult(false);
					String duebillSerialNo = boRWS.getAttribute("ObjectNo").getString();
					//获取预警信号编号 signalID
					BizObject boS = bmS.createQuery("SerialNo=:SerialNo").setParameter("SerialNo", rwsSerialNo).getSingleResult(false);
					String signalID = boS.getAttribute("SignalID").getString();
					String signalLevel = boS.getAttribute("SignalLevel").getString();
					String dealMethod = boS.getAttribute("DealMethod").getString();
					String taskChannel = boS.getAttribute("TaskChannel").getString();
					String isExclude = boS.getAttribute("IsExclude").getString();
					String remark = boS.getAttribute("Remark").getString();
					//创建一条新 预警解除 记录
					BizObject rwsbo = rws.newObject();
					rwsbo.setAttributeValue("STATUS", "1");
					rwsbo.setAttributeValue("SignalID",signalID);
					rwsbo.setAttributeValue("SIGNALTYPE",riskSignalType);
					rwsbo.setAttributeValue("SIGNALLEVEL",signalLevel);
					rwsbo.setAttributeValue("DEALMETHOD",dealMethod);
					rwsbo.setAttributeValue("TASKCHANNEL",taskChannel);
					rwsbo.setAttributeValue("ISEXCLUDE",isExclude);
					rwsbo.setAttributeValue("REMARK",remark);
					rwsbo.setAttributeValue("INPUTUSERID", curUser.getUserID());
					rwsbo.setAttributeValue("INPUTORGID", curUser.getOrgID());
					rwsbo.setAttributeValue("INPUTDATE", DateHelper.getBusinessDate());
					rws.saveObject(rwsbo);
					//创建 RISK_WARNING_OBJECT 与  RISK_WARNING_SIGNAL 解除对应关系
					BizObject rwobo01 = rwo.newObject();
					rwobo01.setAttributeValue("SIGNALSERIALNO", rwsbo.getAttribute("SerialNo").getString());
					rwobo01.setAttributeValue("OBJECTTYPE","jbo.al.RISK_WARNING_SIGNAL");
					rwobo01.setAttributeValue("OBJECTNO", rwsSerialNo);
					rwo.saveObject(rwobo01);
					
					BizObject rwobo02 = rwo.newObject();
					rwobo02.setAttributeValue("SIGNALSERIALNO", rwsbo.getAttribute("SerialNo").getString());
					rwobo02.setAttributeValue("OBJECTTYPE","jbo.acct.ACCT_LOAN");
					rwobo02.setAttributeValue("OBJECTNO", duebillSerialNo);
					rwo.saveObject(rwobo02);
					//创建流程
					BusinessObject apply = BusinessObject.createBusinessObject();
					for(int k=0;k<this.getAttributes().getKeys().length;k++){
						String key = this.getAttributes().getKeys()[k].toString();
						Object value = this.getAttribute(key);
						apply.setAttributeValue(key, value);
					}
					String LoanSerialNo = "";
					BizObjectManager bmFO = JBOFactory.getFactory().getManager("jbo.al.RISK_WARNING_OBJECT");
					BizObject boFO = bmFO.createQuery(" SignalSerialNo = :SerialNo and ObjectType='jbo.acct.ACCT_LOAN' ")
										 .setParameter("SerialNo", rwsSerialNo)
										 .getSingleResult(false);
					if(boFO != null){
						LoanSerialNo = boFO.getAttribute("ObjectNo").getString();
					}
					String CustomerName = "";
					BizObjectManager bmFOAL = JBOFactory.getFactory().getManager("jbo.acct.ACCT_LOAN");
					BizObject boFOAL = bmFOAL.createQuery(" SerialNo = :SerialNo")
										 .setParameter("SerialNo", LoanSerialNo)
										 .getSingleResult(false);
					if(boFOAL != null){
						CustomerName = boFOAL.getAttribute("CustomerName").getString();
					}
					apply.setAttributeValue("OrgID", curUser.getOrgID());
					apply.setAttributeValue("CustomerName", CustomerName);
					apply.setAttributeValue("LoanSerialNo", LoanSerialNo);
					apply.setAttributeValue("SignalType", riskSignalType);
					List<BusinessObject> objects = new ArrayList<BusinessObject>();
					objects.add(BusinessObject.convertFromBizObject(rwsbo));
					String flowVersion = FlowConfig.getFlowDefaultVersion(flowNo);
					BusinessObjectManager bomanager = BusinessObjectManager.createBusinessObjectManager(tx);
					FlowManager fm = FlowManager.getFlowManager(bomanager);
					fm.createInstance("jbo.al.RISK_WARNING_SIGNAL", objects,flowNo, curUser.getUserID(), curUser.getOrgID(),apply);
					tx.commit();
				}
			}
			tx.commit();
			return "true@新增成功！";
		}catch(Exception ex)
		{
			ex.printStackTrace();
			tx.rollback();
			return "false@流程启动失败，请重新选择！";
		}
	}

}
