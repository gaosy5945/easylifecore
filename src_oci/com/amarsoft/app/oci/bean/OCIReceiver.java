package com.amarsoft.app.oci.bean;

/**
 * <p>��Ϊ�ͻ���ʱ���ýӿڷ���Message�ķ�װ�࣬�ö���Я�����ص���Ϣ��¶��������</p>
 * @author xjzhao
 *
 */
public class OCIReceiver {

	/**
	 * enable ��ʾ�ý��׵ķ��ض����Ƿ���ã�<br>
	 * ���Ϊtrue�������ʹ�÷��ص�Message���������returnInfo֪������ԭ��
	 */
	private boolean enable; 
	
	/**
	 * ���׷��ص�ϵͳ��Ϣ
	 */
	private String returnInfo; 
	/**
	 * ���׳ɹ�ʱ�ķ���Message����
	 */
	private Message ResponseMsgr;
	
	public boolean isEnable() {
		return enable;
	}

	public void setEnable(boolean enable) {
		this.enable = enable;
	}

	public String getReturnInfo() {
		return returnInfo;
	}

	public void setReturnInfo(String returnInfo) {
		this.returnInfo = returnInfo;
	}

	public Message getResponseMsgr() {
		return ResponseMsgr;
	}

	public void setResponseMsgr(Message responseMsgr) {
		ResponseMsgr = responseMsgr;
	}

}
