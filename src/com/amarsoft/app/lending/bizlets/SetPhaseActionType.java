package com.amarsoft.app.lending.bizlets;


import com.amarsoft.awe.util.ASResultSet;
import com.amarsoft.awe.util.SqlObject;
import com.amarsoft.awe.util.Transaction;
import com.amarsoft.biz.bizlet.Bizlet;

/**
 * 根据双批意见判断批复登记的意见
 * @author 张万亮
 */
public class SetPhaseActionType extends Bizlet {
	public Object  run(Transaction Sqlca) throws Exception {
		//流程编号、恢复时间
		String flowSerialNo = (String)this.getAttribute("FlowSerialNo");
		String phaseNo = (String)this.getAttribute("PhaseNo");
		String phaseActionType = "";
		boolean flag = true;
		String phaseOpinion = Sqlca.getString(new SqlObject("Select PHASEOPINION from Flow_TASK where FlowSerialNo = :FlowSerialNo and PhaseNo not like 'doublereg_level%' order by TaskSerialNo desc").setParameter("FlowSerialNo", flowSerialNo));
		if(phaseOpinion == null || "".equals(phaseOpinion)) phaseOpinion = "false";
		ASResultSet rs = Sqlca.getASResultSet(new SqlObject("Select PhaseActionType from Flow_TASK where FlowSerialNo = :FlowSerialNo and PhaseNo like 'doublereg_level%'").setParameter("FlowSerialNo", flowSerialNo));
		while(rs.next()){
			phaseActionType = rs.getString("PhaseActionType");
			if(phaseActionType != null && !"".equals(phaseActionType)){
				if("02".equals(phaseActionType) || "03".equals(phaseActionType)){
					flag = false;
					break;
				}
			}
		}
		if(!rs.next()){
			ASResultSet rr = Sqlca.getASResultSet(new SqlObject("Select PhaseActionType from Flow_TASK where FlowSerialNo = :FlowSerialNo and TaskSerialNo = (Select max(TaskSerialNo) from Flow_TASK where FlowSerialNo ="
					+ " :FlowSerialNo and PhaseNo <> :PhaseNo)").setParameter("FlowSerialNo", flowSerialNo).setParameter("PhaseNo", phaseNo));
			while(rr.next()){
				phaseActionType = rr.getString("PhaseActionType");
				if(phaseActionType != null && !"".equals(phaseActionType)){
					if("02".equals(phaseActionType) || "03".equals(phaseActionType)){
						flag = false;
						break;
					}
				}
			}
			rr.close();
		}
		rs.close();
		if(!flag){
			return "03@"+phaseOpinion;
		}else{
			return "01@"+phaseOpinion;
		}
	}
}
