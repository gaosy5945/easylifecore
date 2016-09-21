package com.amarsoft.app.oci.exception;

/**
 * <p>OCIException���ͻ���ҵ�����쳣</p>
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
