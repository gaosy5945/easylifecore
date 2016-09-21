package com.amarsoft.app.oci.comm.impl.server;

import java.util.Map;

import com.amarsoft.app.oci.bean.OCITransaction;
import com.amarsoft.app.oci.exception.OCIException;

/**
 * <p>业务处理类接口<br>
 * 作为服务端时调用，用来填充响应Message</p>
 * @author xjzhao
 *
 */
public interface IResponser {
	/**
	 * 通过请求Message信息执行该方法来填充响应Message的值
	 * @param trans
	 * @throws Exception
	 */
	public void dispose(OCITransaction trans) throws Exception;
	
	/**
	 * 根据系统错误信息来返回不同系统要求的错误信息Map来拼装不同的错误报文
	 * @param e 
	 * @param trans
	 * @return	Map 错误信息Map
	 */
	public Map<String, String> getErrorMap(OCIException e, OCITransaction trans);
}
