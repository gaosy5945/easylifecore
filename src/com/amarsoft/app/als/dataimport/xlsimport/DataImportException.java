package com.amarsoft.app.als.dataimport.xlsimport;

/**
 * 定义导入数据异常
 * @author syang
 * @date 2011/08/222
 *
 */
public class DataImportException extends Exception {

	private static final long serialVersionUID = 7101739787013090276L;

	public DataImportException() {
		super();
	}

	public DataImportException(String message, Throwable cause) {
		super(message, cause);
	}

	public DataImportException(String message) {
		super(message);
	}

	public DataImportException(Throwable cause) {
		super(cause);
	}

}
