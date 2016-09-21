package com.amarsoft.app.als.credit.apply.action;

import com.amarsoft.awe.util.SqlObject;
import com.amarsoft.awe.util.Transaction;
import com.amarsoft.biz.bizlet.Bizlet;

/**
 * 通过FlowSerialNo查询第一道审查岗的PhaseNo
 * @author 张万亮
 */
public class QueryFistSCPhaseNo extends Bizlet {
	public String  run(Transaction Sqlca) throws Exception {
		String flowSerialNo = (String)this.getAttribute("FlowSerialNo");
		String scPhaseNo = Sqlca.getString(new SqlObject("select FT.PhaseNo from FLOW_TASK FT,FLOW_OBJECT FO,FLOW_MODEL FM where "
					+ "FT.FlowSerialNo=FO.FlowSerialNo and FO.FlowNo=FM.FlowNo and FO.FlowVersion=FM.FlowVersion and FM.PhaseType='0050'"
					+ "and FT.FlowSerialNo = :FlowSerialNo and FT.PhaseNo=FM.PhaseNo order by FT.TaskSerialNo").setParameter("FlowSerialNo", flowSerialNo));
		if(scPhaseNo == null) scPhaseNo = "还没有经过审查岗";
		return scPhaseNo;
	}
}
