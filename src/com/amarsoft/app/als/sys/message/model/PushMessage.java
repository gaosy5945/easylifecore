package com.amarsoft.app.als.sys.message.model;
/**
 * 推送消息类
 * @author Administrator
 *
 */
public class PushMessage {

	private String userId="";

	private String messageType="";
		
	public String getUserId() {
		return userId;
	}

	public void setUserId(String userId) {
		this.userId = userId;
	}

	public String getMessageType() {
		return messageType;
	}

	public void setMessageType(String messageType) {
		this.messageType = messageType;
	}	
}
