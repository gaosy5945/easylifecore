package com.amarsoft.app.oci.ws.decision.prepare;

import com.amarsoft.app.crqs2.i.bean.IReportMessage;



/**
 * 征信信息抽取执行单元
 * @author t-liuyc
 *
 */
public interface Command {
	public Object execute(IReportMessage message) throws Exception;
}
