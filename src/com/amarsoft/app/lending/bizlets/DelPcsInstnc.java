package com.amarsoft.app.lending.bizlets;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.Map;

import com.amarsoft.awe.util.Transaction;
import com.amarsoft.biz.bizlet.Bizlet;

/**
 * 调用流程引擎删除流程实例接口
 * @author 张万亮
 */
public class DelPcsInstnc extends Bizlet {
	public Object  run(Transaction Sqlca) throws Exception {
		//流程编号、用户编号
		String taskSerialNo = (String)this.getAttribute("TaskSerialNo");
		String pcsInstncId = (String)this.getAttribute("PcsInstncId");
		
		//调用流程引擎删除流程实例接口
		try{
			//BPMPInstance.DelPcsInstnc(pcsInstncId, Sqlca.getConnection());
		}catch(Exception ex)
		{
			ex.printStackTrace();
			return "false@"+ex.getMessage();
		}
		return "true@获取成功";
		
	}
	
}
