package com.amarsoft.app.workflow.processdata;

import java.util.List;

import com.amarsoft.app.base.businessobject.BusinessObject;
import com.amarsoft.app.base.businessobject.BusinessObjectManager;
import com.amarsoft.app.workflow.config.FlowConfig;
import com.amarsoft.app.workflow.util.FlowHelper;
import com.amarsoft.dict.als.cache.CodeCache;
import com.amarsoft.dict.als.object.Item;
/**
 * 获取当前处理机构是否有审批权限
 * @author xjzhao
 */
public class GetCurOrgAuthorize implements IProcess {

	public String process(List<BusinessObject> bos,BusinessObjectManager bomanager, String paraName, String dataType,BusinessObject otherPara) throws Exception {
		if(bos == null || bos.isEmpty()) return "1";
		
		String flowSerialNo = otherPara.getString("FlowSerialNo");
		String flowNo = otherPara.getString("FlowNo");
		String flowVersion = otherPara.getString("FlowVersion");
		String approveModel="01";
		List<BusinessObject> fts = bomanager.loadBusinessObjects("jbo.flow.FLOW_TASK", "FlowSerialNo = :FlowSerialNo and PhaseNo in(:PhaseNo)  order by UpdateTime desc ", 
				"FlowSerialNo",flowSerialNo,
				"PhaseNo",FlowHelper.getFlowPhase(FlowConfig.getFlowCatalog(flowNo, flowVersion).getString("FlowType"), "0050").split(","));
		
		if(!fts.isEmpty())
		{
			String phaseAction = fts.get(0).getString("PhaseAction");
			if(phaseAction != null && !"".equals(phaseAction))
			{
				Item item = CodeCache.getItem("BPMPhaseAction", phaseAction);
				approveModel = item.getAttribute1();
			}
		}
			
		
		boolean curAuthorize = FlowHelper.ApproveAuth("1",otherPara.getString("CurOrgID"), bos,approveModel, bomanager);
		
		return curAuthorize ? "1" : "0";
	}

}
