package com.amarsoft.app.oci.ws.decision.prepare;

import com.amarsoft.app.crqs2.i.bean.IReportMessage;



/**
 * ������Ϣ��ȡִ�е�Ԫ
 * @author t-liuyc
 *
 */
public interface Command {
	public Object execute(IReportMessage message) throws Exception;
}
