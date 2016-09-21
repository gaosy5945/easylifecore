package com.amarsoft.app.oci.ws.decision.prepare;

import com.amarsoft.app.crqs2.i.bean.IReportMessage;

/**
 * 申请人是否有征信记录标识
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
