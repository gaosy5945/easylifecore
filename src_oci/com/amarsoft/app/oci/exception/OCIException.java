package com.amarsoft.app.oci.exception;

/**
 * <p>ʵʱ�ӿڵ��쳣���࣬��������ʵʱ�ӿڴ�������Ҫ������쳣</p>
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
