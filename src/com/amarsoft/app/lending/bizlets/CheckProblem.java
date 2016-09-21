package com.amarsoft.app.lending.bizlets;

import com.amarsoft.awe.util.ASResultSet;
import com.amarsoft.awe.util.Transaction;
import com.amarsoft.biz.bizlet.Bizlet;

/**
 * 判断该任务是否有未完成检查问题
 * @author 张万亮
 */
public class CheckProblem extends Bizlet {
	public Object  run(Transaction Sqlca) throws Exception {
		String flowSerialNo = (String)this.getAttribute("FlowSerialNo");
		String phaseNo = (String)this.getAttribute("PhaseNo");
		ASResultSet ss = Sqlca.getResultSet("select * from flow_model fm,flow_object fo where fo.flowserialno = '"+flowSerialNo+"' and fo.flowno = fm.flowno and (fm.opntemplateno is not null or fm.opntemplateno <> '') and fm.phaseno = '"+phaseNo+"'");
		if(ss.next()){
			return "true";
		}else{
			ASResultSet sr = Sqlca.getResultSet("select * from FLOW_CHECKLIST O,Code_Library CL WHERE O.OBJECTNO = '"+flowSerialNo+"' AND O.STATUS = CL.ITEMNO AND CL.CODENO = 'BPMCheckItemStatus' AND CL.ITEMDESCRIBE = 'false'");
			if(sr.next()){
				return "true";
			}else{
				return "false";
			}
		}
	}
}
