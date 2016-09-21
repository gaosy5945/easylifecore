package com.amarsoft.app.oci.exception;

/**
 * <p>实时接口的异常基类，定义了在实时接口处理中需要处理的异常</p>
 * @author xjzhao
 *
 */
public class OCIException extends Exception {

	/**
	 * 
	 */
	private static final long serialVersionUID = 1L;

	public OCIException(String errorMessage, Throwable e) {
		super(errorMessage, e);
		// TODO Auto-generated constructor stub
	}

	public OCIException(String errorMessage) {
		super(errorMessage);
		// TODO Auto-generated constructor stub
	}

}
