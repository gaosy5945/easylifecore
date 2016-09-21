package com.amarsoft.app.check.apply;

import com.amarsoft.app.alarm.AlarmBiz;
import com.amarsoft.app.base.businessobject.BusinessObject;
import com.amarsoft.app.workflow.config.FlowConfig;
import com.amarsoft.awe.util.Transaction;

/**
 * 检查意见是否签署意见
 * 
 * @author xjzhao
 * @since 2014/12/10
 */

public class OpinionActionCheck extends AlarmBiz {

	@Override
	public Object run(Transaction Sqlca) throws Exception {

		// 取缓存信息
		BusinessObject fo = (BusinessObject) this.getAttribute("FlowObject");// 流程对象
		BusinessObject ft = (BusinessObject) this.getAttribute("FlowTask");// 流程签署意见
		String phaseNo = (String) this.getAttribute("PhaseNo");
		String updateTime = ft.getString("UPDATETIME");

		// 首先判断该阶段需要签署意见
		BusinessObject fm = FlowConfig.getFlowPhase(fo.getString("FlowNo"),
				fo.getString("FlowVersion"), phaseNo);
		String opinionTemplateNo = fm.getString("OPNTEMPLATENO");

		// 签署意见模板为空则表示不用签署意见
		if (opinionTemplateNo == null || "".equals(opinionTemplateNo.trim()))
			setPass(true);
		else if (ft == null || updateTime.isEmpty())
			setPass(false);
		else
			setPass(true);
		return null;
	}

}
