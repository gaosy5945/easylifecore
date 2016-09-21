package com.amarsoft.app.lending.bizlets;

import com.amarsoft.awe.util.ASResultSet;
import com.amarsoft.awe.util.SqlObject;
import com.amarsoft.awe.util.Transaction;
import com.amarsoft.biz.bizlet.Bizlet;

/**
 * 判断当前阶段是否为第一道审查岗并调用过评级
 * @author 张万亮
 */
public class CheckIsCallGrade extends Bizlet {
	public Object  run(Transaction Sqlca) throws Exception {
		String flowSerialNo = (String)this.getAttribute("FlowSerialNo");
		String phaseNo = (String)this.getAttribute("PhaseNo");
		String taskSerialNo = (String)this.getAttribute("TaskSerialNo");
		String flag = "false";
		return flag;
	}
}
