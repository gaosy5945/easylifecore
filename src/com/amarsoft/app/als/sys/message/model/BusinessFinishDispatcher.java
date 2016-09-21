package com.amarsoft.app.als.sys.message.model;

import com.amarsoft.are.msg.SMSDispatcher;


public class BusinessFinishDispatcher    extends SMSDispatcher {

	@Override
	protected boolean sendMessage(String phoneNumber, String messageContent) {
		return super.sendMessage(phoneNumber, messageContent);
	}

	@Override
	protected void setInitOk(boolean ok) {
		super.setInitOk(ok);
	}
 
	
	
}
