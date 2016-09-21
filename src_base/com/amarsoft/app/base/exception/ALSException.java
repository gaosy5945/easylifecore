package com.amarsoft.app.base.exception;

import com.amarsoft.app.base.config.impl.ErrorCodeConfig;


/**
 * 核算异常类，异常代码定义请参见errorcode-config.xml
 * 
 */
public final class ALSException extends Exception {

	private static final long serialVersionUID = 1L;
	/**
	 * 本Class实现所有程序定义的异常采用系统内标准代码的定义方式进行处理，其目的主要是方便后续问题查找和解决。
	 * @param exceptionCode 异常交易码
	 * @param parameters 异常交易参数
	 * @throws Exception
	 */
	public ALSException(String exceptionCode,String... parameters){
		super(ErrorCodeConfig.getErrorMessage(exceptionCode, parameters));
	}
}
