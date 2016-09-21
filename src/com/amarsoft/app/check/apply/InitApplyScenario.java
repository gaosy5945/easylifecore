package com.amarsoft.app.check.apply;

import java.util.List;

import com.amarsoft.app.base.businessobject.BusinessObject;
import com.amarsoft.app.base.businessobject.BusinessObjectManager;
import com.amarsoft.app.base.util.DateHelper;
import com.amarsoft.app.workflow.config.FlowConfig;
import com.amarsoft.app.workflow.util.FlowHelper;
import com.amarsoft.are.jbo.JBOFactory;
import com.amarsoft.are.jbo.JBOTransaction;
import com.amarsoft.are.util.ASValuePool;
import com.amarsoft.awe.util.SqlObject;
import com.amarsoft.awe.util.Transaction;
import com.amarsoft.biz.bizlet.Bizlet;

/**
 * ҵ�������Զ�����̽�ⳡ��������ʼ����
 * �ڱ����У�ʹ����JBO������JBO��ʹ�ã���ο�JBO����ĵ�
 * @author xjzhao
 * @date 2015/01/01
 *
 */
public class InitApplyScenario extends Bizlet{
	
	/**
	 * ����ִ�г�ʼ��ʱ�����Զ����ô˷���
	 */
	public Object run(Transaction Sqlca) throws Exception {
		
		String flowSerialNo = (String)this.getAttribute("FlowSerialNo");//����ʵ�����
		String taskSerialNo = (String)this.getAttribute("TaskSerialNo");//����������
		String phaseNo = (String)this.getAttribute("PhaseNo");//���̽׶α��
		JBOTransaction tx = null;
		
		ASValuePool as = new ASValuePool();
		try
		{
			tx = JBOFactory.createJBOTransaction();
			
			BusinessObjectManager bom = BusinessObjectManager.createBusinessObjectManager(tx);
			
			//����������Ϣ
			List<BusinessObject> baList = bom.loadBusinessObjects("jbo.app.BUSINESS_APPLY", "SerialNo in(select FO.ObjectNo from jbo.flow.FLOW_OBJECT FO where FO.FlowSerialNo = :FlowSerialNo and FO.ObjectType='jbo.app.BUSINESS_APPLY')","FlowSerialNo",flowSerialNo);
			this.calcBusinessTerm(baList);
			
			this.setAttribute("CustomerID", "${CustomerID}");
			this.setAttribute("ObjectType", "jbo.app.BUSINESS_APPLY");
			this.setAttribute("ObjectNo", "${SerialNo}");
			this.setAttribute("RelativeType", "01");
			
			//������������ױ�ҵ����Ϣ
			bom.loadBusinessObjects(baList, "jbo.app.BUSINESS_APPLY", "SerialNo in(select AR.ObjectNo from jbo.app.APPLY_RELATIVE AR where AR.ApplySerialNo =:ObjectNo and AR.ObjectType=:ObjectType and AR.RelativeType in('04','07'))", getAttributes());
			//���ؿͻ���Ϣ
			bom.loadBusinessObjects(baList, "jbo.customer.CUSTOMER_INFO", "select * from O,jbo.customer.IND_INFO ii where O.CustomerID = II.CustomerID and O.CustomerID = :CustomerID", getAttributes());
			bom.loadBusinessObjects(baList, "jbo.customer.IND_INFO", "select * from O where O.CustomerID = :CustomerID", getAttributes());
			//��������
			bom.loadBusinessObjects(baList, "jbo.acct.ACCT_RATE_SEGMENT", " ObjectType=:ObjectType and ObjectNo=:ObjectNo ", getAttributes());
			//���ػ��ʽ
			bom.loadBusinessObjects(baList, "jbo.acct.ACCT_RPT_SEGMENT", " ObjectType=:ObjectType and ObjectNo=:ObjectNo ", getAttributes());
			//���ػ����˺�
			bom.loadBusinessObjects(baList, "jbo.acct.ACCT_BUSINESS_ACCOUNT", " ObjectType=:ObjectType and ObjectNo=:ObjectNo ", getAttributes());
			//���غ�����Ŀ��Ϣ
			bom.loadBusinessObjects(baList, "jbo.prj.PRJ_BASIC_INFO", " SerialNo in(select PR.ProjectSerialNo from jbo.prj.PRJ_RELATIVE PR where PR.ObjectType=:ObjectType and PR.ObjectNo=:ObjectNo and PR.RelativeType = :RelativeType) ", getAttributes());
			//���ع�ͬ������
			bom.loadBusinessObjects(baList, "jbo.app.BUSINESS_APPLICANT", " ObjectType=:ObjectType and ObjectNo=:ObjectNo ", getAttributes());
			//���ع����Ľ����Ϣ������ʱ
			bom.loadBusinessObjects(baList,"jbo.app.BUSINESS_DUEBILL"," SerialNo in (select AR.objectno from jbo.app.APPLY_RELATIVE AR where AR.objecttype='jbo.app.BUSINESS_DUEBILL' and AR.applyserialno=:ObjectNo)",getAttributes());
			//���ص�����ͬ��Ϣ
			bom.loadBusinessObjects(baList,"jbo.guaranty.GUARANTY_CONTRACT","SerialNo in (select AR.ObjectNo from jbo.app.APPLY_RELATIVE AR where AR.ApplySerialNo=:ObjectNo and AR.ObjectType = 'jbo.guaranty.GUARANTY_CONTRACT')",getAttributes());
			//���ص�����ͬ������Ϣ
			if(baList != null)
			{
				for(BusinessObject ba:baList)
				{
					List<BusinessObject> gcList = ba.getBusinessObjects("jbo.guaranty.GUARANTY_CONTRACT");
					if(gcList != null)
					{
						ASValuePool para = new ASValuePool();
						para.setAttribute("GCserialNo", "${SerialNo}");
						bom.loadBusinessObjects(gcList,"jbo.guaranty.GUARANTY_RELATIVE","GCserialNo =:GCserialNo",para);
						for(BusinessObject gc:gcList){
							ba.appendBusinessObjects("jbo.guaranty.GUARANTY_RELATIVE",gc.getBusinessObjects("jbo.guaranty.GUARANTY_RELATIVE"));
						}
					}
					//����ѺƷ��Ϣ
					bom.loadBusinessObjects(baList,"jbo.app.ASSET_INFO"," serialno in (select GR.assetserialno from jbo.guaranty.GUARANTY_RELATIVE GR where GR.gcSerialNo in (select AR.ObjectNo from jbo.app.APPLY_RELATIVE AR where AR.ApplySerialNo=:ObjectNo and AR.ObjectType = 'jbo.guaranty.GUARANTY_CONTRACT'))",getAttributes());
				}
			}
			
			
			//���غ�ͬ��Ϣ
			bom.loadBusinessObjects(baList,"jbo.app.BUSINESS_CONTRACT","ApplySerialNo=:ObjectNo",getAttributes());
			if(baList != null)
			{
				for(BusinessObject ba:baList)
				{
					List<BusinessObject> bcList = ba.getBusinessObjects("jbo.app.BUSINESS_CONTRACT");
					if(bcList != null)
					{
						this.calcBusinessTerm(bcList);
						ASValuePool para = new ASValuePool();
						para.setAttribute("ObjectType", "jbo.app.BUSINESS_CONTRACT");
						para.setAttribute("ObjectNo", "${SerialNo}");
						bom.loadBusinessObjects(bcList,"jbo.flow.FLOW_CHECKLIST","ObjectType=:ObjectType and ObjectNo=:ObjectNo",para);
					}
				}
			}
			
			//���س�����Ϣ
			bom.loadBusinessObjects(baList,"jbo.app.BUSINESS_PUTOUT","ContractSerialNo in(select BC.SerialNo from jbo.app.BUSINESS_CONTRACT BC where BC.ApplySerialNo=:ObjectNo)",getAttributes());
			
			if(baList != null)
			{
				for(BusinessObject ba:baList)
				{
					List<BusinessObject> bpList = ba.getBusinessObjects("jbo.app.BUSINESS_PUTOUT");
					if(bpList != null)
					{
						ASValuePool para = new ASValuePool();
						para.setAttribute("ObjectType", "jbo.app.BUSINESS_PUTOUT");
						para.setAttribute("ObjectNo", "${SerialNo}");
						bom.loadBusinessObjects(bpList,"jbo.flow.FLOW_CHECKLIST","ObjectType=:ObjectType and ObjectNo=:ObjectNo",para);
					}
				}
			}
			
			//������Ϣ
			BusinessObject ft = bom.keyLoadBusinessObject("jbo.flow.FLOW_TASK",taskSerialNo);
			BusinessObject fo = bom.loadBusinessObjects("jbo.flow.FLOW_OBJECT","select distinct FlowNo,FlowVersion from O where FlowSerialNo=:FlowSerialNo","FlowSerialNo",flowSerialNo).get(0);
			bom.loadBusinessObjects(baList,"jbo.app.BUSINESS_APPROVE"," TaskSerialNo=:TaskSerialNo and ApplySerialNo=:ObjectNo ",getAttributes());
			if(baList != null)
			{
				for(BusinessObject ba:baList)
				{
					List<BusinessObject> bapList = ba.getBusinessObjects("jbo.app.BUSINESS_APPROVE");
					if(bapList != null)
					{
						this.calcBusinessTerm(bapList);
					}
				}
			}
			
			//���ؼ���嵥
			fo.appendBusinessObjects("jbo.flow.FLOW_CHECKLIST", bom.loadBusinessObjects("jbo.flow.FLOW_CHECKLIST","ObjectType=:ObjectType and ObjectNo=:ObjectNo", "ObjectType", "jbo.flow.FLOW_OBJECT","ObjectNo", flowSerialNo));
			String productID = baList.get(0).getString("ProductID");
			String businessType = baList.get(0).getString("BusinessType");
			String occurType = baList.get(0).getString("OccurType");
			//��Ʒ��Ϣ
			BusinessObject prd = bom.keyLoadBusinessObject("jbo.prd.PRD_PRODUCT_LIBRARY", businessType);
			
			
			as.setAttribute("Main", baList);//������Ϣ
			as.setAttribute("FlowTask", ft);
			as.setAttribute("FlowObject", fo);
			as.setAttribute("FlowNo", fo.getString("FlowNo"));
			as.setAttribute("FlowVersion", fo.getString("FlowVersion"));
			BusinessObject flowCatalog = FlowConfig.getFlowCatalog(fo.getString("FlowNo"), fo.getString("FlowVersion"));
			BusinessObject flowModel = FlowConfig.getFlowPhase(fo.getString("FlowNo"), fo.getString("FlowVersion"), phaseNo);
			//�ж��Ƿ����¼��
			List<BusinessObject> flowModels = FlowConfig.getFlowPhases(fo.getString("FlowNo"));
			boolean inputFlag = false;
			for(BusinessObject fm:flowModels){
				if("0030".equals(fm.getString("PhaseType")))
				{
					inputFlag = true;
				}
			}
			String phaseType = flowModel.getString("PhaseType");
			if(!inputFlag && ("0010".equals(phaseType) || "0020".equals(phaseType))) phaseType = "0030";
			
			if("S0215.plbs_business04.Flow_008".equals(fo.getString("FlowNo")) && "0".equals(FlowHelper.getImageFlag(baList.get(0))) && ("0010".equals(phaseType) || "0020".equals(phaseType))) phaseType = "0030";
			
			as.setAttribute("FlowType", flowCatalog.getString("FlowType"));
			as.setAttribute("PhaseType", phaseType);
			as.setAttribute("FunctionID", flowModel.getString("FunctionID"));
			as.setAttribute("OpnTemplateNo", flowModel.getString("OpnTemplateNo"));
			as.setAttribute("OccurType", occurType);
			as.setAttribute("ProductID", productID);
			as.setAttribute("BusinessType", businessType);
			as.setAttribute("ProductType1", prd.getString("ProductType1"));
			as.setAttribute("ProductType2", prd.getString("ProductType2"));
			as.setAttribute("ProductType3", prd.getString("ProductType3"));
			as.setAttribute("ProductType4", prd.getString("ProductType4"));
			Boolean flag = false;
			if(baList != null)
			{
				for(BusinessObject ba:baList)
				{
					String CLSerialNo = Sqlca.getString(new SqlObject("select AR.OBJECTNO from APPLY_RELATIVE AR where AR.OBJECTTYPE = 'jbo.app.BUSINESS_CONTRACT' "
							+ "AND AR.RELATIVETYPE = '06' AND AR.APPLYSERIALNO = :APPLYSERIALNO").setParameter("APPLYSERIALNO", ba.getAttribute("SerialNo").getString()));
					if(CLSerialNo != null){
						as.setAttribute("CLSerialNo", CLSerialNo);
					}
					else
					{
						as.setAttribute("CLSerialNo", "");
					}
				}
			}
			bom.clear();
			tx.commit();
		}catch(Exception e)
		{
			if(tx != null) tx.rollback();
			throw e;
		}
		
		return as;	//����ҵ����󼯺�
	}
	
	private void calcBusinessTerm(List<BusinessObject> bos) throws Exception{
		if(bos == null) return;
		for(BusinessObject bo:bos)
		{
			if("500".equals(bo.getString("BusinessType")) || "502".equals(bo.getString("BusinessType")) || "666".equals(bo.getString("BusinessType"))) continue;
			if(bo.getInt("BusinessTerm") == 0 && bo.getInt("BusinessTermDay") == 0 
					&& bo.getString("MaturityDate") != null && !"".equals(bo.getString("MaturityDate")))
			{
				String maturityDate = bo.getString("MaturityDate");
				
				int month = (int) Math.floor(DateHelper.getMonths(DateHelper.getBusinessDate(), maturityDate));
				int day = DateHelper.getDays(DateHelper.getRelativeDate(DateHelper.getBusinessDate(), DateHelper.TERM_UNIT_MONTH, month), maturityDate);
				bo.setAttributeValue("BusinessTerm",month);
				bo.setAttributeValue("BusinessTermDay",day);
			}
		}
	}
}
