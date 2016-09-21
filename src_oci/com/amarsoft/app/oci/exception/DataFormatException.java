package com.amarsoft.app.oci.exception;
/**
 * <p>OCIException：报文数据格式异常</p>
 * @author xjzhao
 *
 */
public class DataFormatException extends OCIException {

	/**
	 * 
	 */
	private static final long serialVersionUID = 1L;

	public DataFormatException(String errorMessage) {
		super(errorMessage);
	}
	
	public DataFormatException(String errorMessage, Throwable e) {
		super(errorMessage, e);
	}

}
