package com.amarsoft.app.oci.ws.decision.prepare;

import com.amarsoft.app.crqs2.i.bean.IReportMessage;

/**
 * �������Ƿ������ż�¼��ʶ
 * 
 * @author t-liuyc
 * 
 */
public class CmdCheckInfoFlag implements Command {

	@Override
	public Object execute(IReportMessage message) throws Exception {
		return "1";
	}

}
