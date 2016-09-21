package com.amarsoft.app.als.dataimport.xlsimport;

/**
 * 定义写入数据异常
 * @author syang
 * @date 2011/08/18
 *
 */
public class WriteException extends Exception{

	private static final long serialVersionUID = -2299726104782771285L;

	public WriteException() {
		super();
	}

	public WriteException(String message, Throwable cause) {
		super(message, cause);
	}

	public WriteException(String message) {
		super(message);
	}

	public WriteException(Throwable cause) {
		super(cause);
	}
}
