package com.amarsoft.app.check.apply;

import com.amarsoft.app.alarm.AlarmBiz;
import com.amarsoft.app.base.businessobject.BusinessObject;
import com.amarsoft.app.workflow.config.FlowConfig;
import com.amarsoft.awe.util.Transaction;

/**
 * �������Ƿ�ǩ�����
 * 
 * @author xjzhao
 * @since 2014/12/10
 */

public class OpinionActionCheck extends AlarmBiz {

	@Override
	public Object run(Transaction Sqlca) throws Exception {

		// ȡ������Ϣ
		BusinessObject fo = (BusinessObject) this.getAttribute("FlowObject");// ���̶���
		BusinessObject ft = (BusinessObject) this.getAttribute("FlowTask");// ����ǩ�����
		String phaseNo = (String) this.getAttribute("PhaseNo");
		String updateTime = ft.getString("UPDATETIME");

		// �����жϸý׶���Ҫǩ�����
		BusinessObject fm = FlowConfig.getFlowPhase(fo.getString("FlowNo"),
				fo.getString("FlowVersion"), phaseNo);
		String opinionTemplateNo = fm.getString("OPNTEMPLATENO");

		// ǩ�����ģ��Ϊ�����ʾ����ǩ�����
		if (opinionTemplateNo == null || "".equals(opinionTemplateNo.trim()))
			setPass(true);
		else if (ft == null || updateTime.isEmpty())
			setPass(false);
		else
			setPass(true);
		return null;
	}

}
