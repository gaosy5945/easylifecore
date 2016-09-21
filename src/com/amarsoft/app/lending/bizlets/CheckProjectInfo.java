package com.amarsoft.app.lending.bizlets;

import com.amarsoft.awe.util.ASResultSet;
import com.amarsoft.awe.util.SqlObject;
import com.amarsoft.awe.util.Transaction;
import com.amarsoft.biz.bizlet.Bizlet;

/**
 * 判断项目基本信息是否保存
 * @author xtliu
 */
public class CheckProjectInfo extends Bizlet {
	public Object  run(Transaction Sqlca) throws Exception {
		String flowSerialNo = (String)this.getAttribute("FlowSerialNo");
		boolean flag = true;
		ASResultSet ss = Sqlca.getResultSet(new SqlObject("select pbi.tempSaveFlag from flow_object fo,prj_basic_info pbi where fo.objecttype='jbo.prj.PRJ_BASIC_INFO' and fo.ObjectNo=pbi.serialNo and fo.flowserialno=:flowserialno").setParameter("flowserialno", flowSerialNo));
		if(ss.next()){
			String tempSaveFlag = ss.getString("tempSaveFlag");
				if("".equals(tempSaveFlag) || tempSaveFlag == null || "1".equals(tempSaveFlag)){
					flag = false;
				}
		}
		ss.close();
		if(flag){
			return "true";
		}else{
			return "false";
		}
	}
}
