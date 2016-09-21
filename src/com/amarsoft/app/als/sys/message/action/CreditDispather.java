package com.amarsoft.app.als.sys.message.action;

import java.util.List;
import java.util.Properties;

import com.amarsoft.are.ARE;
import com.amarsoft.are.log.Log;
import com.amarsoft.are.msg.Dispatcher;
import com.amarsoft.are.msg.Message;

public class CreditDispather  implements Dispatcher{

	protected Log logger = ARE.getLog(getClass().getName());
	@Override
	public void close() {
		
	}

	@Override
	public void dispatchMessage(Message message) {
		String messageBody=message.getBody();
		List mto = message.getRecipients();
		if(mto.size()<1) {
			logger.debug("Dispatch failed, No recipient!");
			return;
		}
		for(int i=0;i<mto.size();i++){
			String mn = (String)mto.get(i); //手机号码
			logger.info("发送用户["+mn+"],消息["+messageBody+"]\n以上信息 只是打印，请项目组根据实际情况做接口发送");
		}
		
	}

	@Override
	public void init(Properties arg0) {
		
	}

	@Override
	public boolean isInitOk() {
		return true;
	}

}
