package com.amarsoft.app.check.apply;

import java.util.List;

import com.amarsoft.app.alarm.AlarmBiz;
import com.amarsoft.app.base.businessobject.BusinessObject;
import com.amarsoft.awe.util.Transaction;


/**
 * 确认是否存在有效信用记录提示
 * @author 张万亮
 * @since 2015/04/27
 */
public class ApproveCheck1 extends AlarmBiz {
	
	public Object run(Transaction Sqlca) throws Exception {
		
		/** 取参数 **/
		List<BusinessObject> baList = (List<BusinessObject>)this.getAttribute("Main");	//获取申请信息
		
		if(baList == null || baList.isEmpty())
			putMsg("申请基本信息未找到，请检查！");
		else
		{
			putMsg("如尚未查询个人征信信息或最近一次查询在30天前，请立即发起查询！");
		}
		
		/** 返回结果处理 **/
		if(messageSize() > 0){
			setPass(false);
		}else{
			setPass(true);
		}
		
		return null;
	}
}
