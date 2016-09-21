package com.amarsoft.app.als.sys.message.action;

import com.amarsoft.are.msg.SMTPDispatcher;

/**
 * 电子邮件消息分发
 * @author cjyu
 *
 */
public class EmailDispatcher  extends SMTPDispatcher{


	/**
	 * 完成从EmployeeId到邮件地址的翻译
	 * @see com.amarsoft.are.msg.impl.SMTPDispatcher#getMailAddress(java.lang.String)
	 */
	protected String getMailAddress(String appUser) {
		String ma = getMail(appUser);
		return ma==null?appUser:ma;
	}
	

	/**
	 * 获得发送人的地址,从数据库获得其他途径获得邮件地址
	 * @param id userid或customerid
	 * @return 邮件地址
	 */
	private String getMail(String id){
		String mailAddress = "support@amarsoft.com";
		return mailAddress;
	}
	
}
