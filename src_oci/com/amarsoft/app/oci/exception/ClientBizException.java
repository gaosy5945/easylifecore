package com.amarsoft.app.oci.exception;

/**
 * <p>OCIException：客户端业务处理异常</p>
 * @author xjzhao
 *
 */

public class ClientBizException extends OCIException {

	/**
	 * 
	 */
	private static final long serialVersionUID = 1L;

	public ClientBizException(String errorMessage) {
		super(errorMessage);
	}
	
	public ClientBizException(String errorMessage, Throwable e) {
		super(errorMessage, e);
	}
	

}
