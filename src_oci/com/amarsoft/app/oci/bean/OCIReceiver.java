package com.amarsoft.app.oci.bean;

/**
 * <p>作为客户端时调用接口返回Message的封装类，该对象将携带返回的信息暴露给调用者</p>
 * @author xjzhao
 *
 */
public class OCIReceiver {

	/**
	 * enable 表示该交易的返回对象是否可用，<br>
	 * 如果为true，则可以使用返回的Message，否则根据returnInfo知道错误原因
	 */
	private boolean enable; 
	
	/**
	 * 交易返回的系统信息
	 */
	private String returnInfo; 
	/**
	 * 交易成功时的返回Message对象
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
