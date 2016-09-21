package com.amarsoft.app.als.sys.message.action;

import com.amarsoft.are.msg.SMTPDispatcher;

/**
 * �����ʼ���Ϣ�ַ�
 * @author cjyu
 *
 */
public class EmailDispatcher  extends SMTPDispatcher{


	/**
	 * ��ɴ�EmployeeId���ʼ���ַ�ķ���
	 * @see com.amarsoft.are.msg.impl.SMTPDispatcher#getMailAddress(java.lang.String)
	 */
	protected String getMailAddress(String appUser) {
		String ma = getMail(appUser);
		return ma==null?appUser:ma;
	}
	

	/**
	 * ��÷����˵ĵ�ַ,�����ݿ�������;������ʼ���ַ
	 * @param id userid��customerid
	 * @return �ʼ���ַ
	 */
	private String getMail(String id){
		String mailAddress = "support@amarsoft.com";
		return mailAddress;
	}
	
}
