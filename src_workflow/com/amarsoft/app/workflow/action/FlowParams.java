package com.amarsoft.app.workflow.action;

import java.util.List;

import com.amarsoft.app.base.businessobject.BusinessObject;
import com.amarsoft.app.base.businessobject.BusinessObjectManager;
import com.amarsoft.app.workflow.config.FlowConfig;
import com.amarsoft.app.workflow.util.FlowHelper;
import com.amarsoft.app.als.prd.analysis.ProductAnalysisFunctions;
import com.amarsoft.are.jbo.BizObject;
import com.amarsoft.are.jbo.BizObjectManager;
import com.amarsoft.are.jbo.BizObjectQuery;
import com.amarsoft.are.jbo.JBOFactory;

/**
 * 获取参数
 * @author qzhang1
 *
 */
public class FlowParams{
	
	/**
	 * 判断当前业务是否需要调用决策
	 * @param flowSerialNo
	 * @return 1 需调用决策、0 不需调用决策
	 * @throws Exception
	 */
	public static String isInvestigate(String flowSerialNo) throws Exception{
		
		BusinessObjectManager bom = BusinessObjectManager.createBusinessObjectManager();
		
		List<BusinessObject> bos = bom.loadBusinessObjects("jbo.app.BUSINESS_APPLY", "SerialNo in(select FO.ObjectNo from jbo.flow.FLOW_OBJECT FO where FO.FlowSerialNo=:FlowSerialNo)", "FlowSerialNo",flowSerialNo);
		if(bos != null)
		{
			for(BusinessObject bo:bos)
			{
				List<BusinessObject> relaBos = bom.loadBusinessObjects("jbo.app.BUSINESS_CONTRACT", "SerialNo in(select AR.ObjectNo from jbo.app.APPLY_RELATIVE AR where AR.ApplySerialNo=:ApplySerialNo and AR.ObjectType = 'jbo.app.BUSINESS_CONTRACT' and AR.RelativeType = '06')", "ApplySerialNo",bo.getString("SerialNo"));
				if(relaBos != null && relaBos.size() > 0 && "999".equals(relaBos.get(0).getString("BusinessType")))
				{
					return "0";
				}
				else
				{
					List<BusinessObject> relaBas = bom.loadBusinessObjects("jbo.app.BUSINESS_APPLY", "SerialNo in(select AR.ObjectNo from jbo.app.APPLY_RELATIVE AR where AR.ApplySerialNo=:ApplySerialNo and AR.ObjectType = 'jbo.app.BUSINESS_APPLY' and AR.RelativeType = '04')", "ApplySerialNo",bo.getString("SerialNo"));
					if(relaBas != null && relaBas.size() > 0)
					{
						String approveModel = ProductAnalysisFunctions.getComponentOptionalValue(relaBas.get(0), "PRD04-04", "CreditApproveModel","0010", "02");
						if(approveModel != null && "01".equals(approveModel)) return "1";
					}
					else
					{
						String approveModel = ProductAnalysisFunctions.getComponentOptionalValue(bo, "PRD04-04", "CreditApproveModel","0010", "02");
						if(approveModel != null && "01".equals(approveModel)) return "1";
					}
				}
			}
		}
		return "0";
	}

	/**
	 * 获取业务流程是否有单独的录入岗
	 * @param flowSerialNo
	 * @return
	 * @throws Exception
	 */
	public static String getEntryFlag(String flowSerialNo) throws Exception{
		BizObjectManager fom=JBOFactory.getBizObjectManager("jbo.flow.FLOW_OBJECT");
		BizObjectQuery foq = fom.createQuery("FlowSerialNo=:FlowSerialNo"); 
		foq.setParameter("FlowSerialNo", flowSerialNo);
		BizObject fo = foq.getSingleResult(false);
		
		List<BusinessObject> flowModels = FlowConfig.getFlowPhases(fo.getAttribute("FlowNo").getString());
		String entryFlag = "0";
		for(BusinessObject fm:flowModels){
			if("0030".equals(fm.getString("PhaseType")))
			{
				entryFlag = "1";
			}
		}
		
		BizObjectManager bm=JBOFactory.getBizObjectManager(fo.getAttribute("ObjectType").getString());
		BizObjectQuery bq = bm.createQuery("SerialNo=:SerialNo"); 
		bq.setParameter("SerialNo", fo.getAttribute("ObjectNo").getString());
		BizObject bo = bq.getSingleResult(false);
		
		if("S0215.plbs_business04.Flow_008".equals(fo.getAttribute("FlowNo").getString()) && "0".equals(FlowHelper.getImageFlag(BusinessObject.convertFromBizObject(bo))))
			entryFlag = "0";
		
		return entryFlag;
	}
	
	
	public static String getFlowPhaseAttribute(String flowSerialNo,String phaseType,String attribute) throws Exception{
		BusinessObjectManager bomanager = BusinessObjectManager.createBusinessObjectManager();
		BusinessObject fo = bomanager.loadBusinessObjects("jbo.flow.FLOW_OBJECT", "FlowSerialNo=:FlowSerialNo", "FlowSerialNo",flowSerialNo).get(0);
		
		BusinessObject fc = FlowConfig.getFlowCatalog(fo.getString("FlowNo"), fo.getString("FlowVersion"));
		String phaseNos = FlowHelper.getFlowPhase(fc.getString("FlowType"), phaseType);
		
		List<BusinessObject> fts = bomanager.loadBusinessObjects("jbo.flow.FLOW_TASK","FlowSerialNo=:FlowSerialNo and PhaseNo in(:PhaseNo) order by CreateTime","FlowSerialNo",flowSerialNo,"PhaseNo",phaseNos.split(","));
		if(fts.isEmpty())
			return "";
		else
			return fts.get(0).getString(attribute);
	}
}
