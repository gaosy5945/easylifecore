package com.amarsoft.app.base.exception;

import com.amarsoft.app.base.config.impl.ErrorCodeConfig;


/**
 * �����쳣�࣬�쳣���붨����μ�errorcode-config.xml
 * 
 */
public final class ALSException extends Exception {

	private static final long serialVersionUID = 1L;
	/**
	 * ��Classʵ�����г�������쳣����ϵͳ�ڱ�׼����Ķ��巽ʽ���д�����Ŀ����Ҫ�Ƿ������������Һͽ����
	 * @param exceptionCode �쳣������
	 * @param parameters �쳣���ײ���
	 * @throws Exception
	 */
	public ALSException(String exceptionCode,String... parameters){
		super(ErrorCodeConfig.getErrorMessage(exceptionCode, parameters));
	}
}
