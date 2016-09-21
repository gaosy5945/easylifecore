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
			String mn = (String)mto.get(i); //�ֻ�����
			logger.info("�����û�["+mn+"],��Ϣ["+messageBody+"]\n������Ϣ ֻ�Ǵ�ӡ������Ŀ�����ʵ��������ӿڷ���");
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
