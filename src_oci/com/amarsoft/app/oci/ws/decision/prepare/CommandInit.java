package com.amarsoft.app.oci.ws.decision.prepare;

import com.amarsoft.app.crqs2.i.bean.IReportMessage;


/**
 * ����ִ�е�Ԫ��ʼ��
 * @author t-liuyc
 *
 */
public interface CommandInit {
	public IReportMessage init(String certNo, String certType, String name,String userId) throws Exception;
}
