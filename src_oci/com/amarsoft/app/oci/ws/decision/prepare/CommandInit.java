package com.amarsoft.app.oci.ws.decision.prepare;

import com.amarsoft.app.crqs2.i.bean.IReportMessage;


/**
 * 征信执行单元初始化
 * @author t-liuyc
 *
 */
public interface CommandInit {
	public IReportMessage init(String certNo, String certType, String name,String userId) throws Exception;
}
