package com.amarsoft.app.oci.exception;

/**
 * <p>OCIException��ͨѶʱ�쳣</p>
 * @author xjzhao
 *
 */

public class CommException extends OCIException {

	/**
	 * 
	 */
	private static final long serialVersionUID = -5387726446259140432L;

	public CommException(String errorMessage) {
		super(errorMessage);
	}
	
	public CommException(String errorMessage, Throwable e) {
		super(errorMessage, e);
	}

}
