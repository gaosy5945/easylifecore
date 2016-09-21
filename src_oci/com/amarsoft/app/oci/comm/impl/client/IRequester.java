package com.amarsoft.app.oci.comm.impl.client;

import com.amarsoft.app.oci.bean.OCITransaction;
import com.amarsoft.app.oci.exception.OCIException;

/**
 * <p>此接口定义了通讯中的基本的发送报文的功能<br>
 *    屏蔽了不同通讯方式</p>
 * @author xjzhao
 *
 */
public interface IRequester {
	/**
	 * <p>发送报文并接受返回报文</p>
	 * @param requestedStr 未转码的待发送报文
	 * @return
	 * @throws Exception
	 */
	public Object execute(OCITransaction transaction) throws OCIException;
}
