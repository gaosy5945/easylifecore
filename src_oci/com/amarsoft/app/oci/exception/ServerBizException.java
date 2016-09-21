package com.amarsoft.app.oci.exception;

/**
 * <p>OCIException�������ҵ�����쳣</p>
 * @author xjzhao
 *
 */

public class ServerBizException extends OCIException {

	/**
	 * 
	 */
	private static final long serialVersionUID = 1L;

	public ServerBizException(String errorMessage) {
		super(errorMessage);
	}
	
	public ServerBizException(String errorMessage, Throwable e) {
		super(errorMessage, e);
	}

}
