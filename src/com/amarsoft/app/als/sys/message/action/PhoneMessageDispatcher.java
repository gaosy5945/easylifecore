package com.amarsoft.app.als.sys.message.action;

import com.amarsoft.are.msg.SMSDispatcher;


public class PhoneMessageDispatcher  extends   SMSDispatcher {
	

	protected boolean sendMessage(String phoneNumber, String messageContent) {
		boolean sendOk = false;
		sendOk = true;
		return sendOk;
	}

	@Override
	public void close() {
		super.close();
	}
	
	
	
}
