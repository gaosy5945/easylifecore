package com.amarsoft.app.lending.bizlets;

import com.amarsoft.awe.util.ASResultSet;
import com.amarsoft.awe.util.Transaction;
import com.amarsoft.biz.bizlet.Bizlet;

/**
 * 判断该任务是否有未完成检查问题
 * @author 张万亮
 */
public class CheckProblemmust extends Bizlet {
	public Object  run(Transaction Sqlca) throws Exception {
		String taskSerialNo = (String)this.getAttribute("TaskSerialNo");
		String phaseNo = (String)this.getAttribute("PhaseNo");
		ASResultSet sr = Sqlca.getResultSet("select * from FLOW_CHECKLIST O,Code_Library CL WHERE O.TaskSerialNo = '"+taskSerialNo+"' AND O.STATUS = CL.ITEMNO AND CL.CODENO = 'BPMCheckItemStatus' AND CL.ITEMDESCRIBE = 'false'");
		String flag = "";
		if(sr.next()){
			flag = "true";
		}else{
			flag = "false";
		}
		sr.close();
		return flag;
	}
}
