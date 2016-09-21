package com.amarsoft.app.lending.bizlets;

import com.amarsoft.awe.util.ASResultSet;
import com.amarsoft.awe.util.SqlObject;
import com.amarsoft.awe.util.Transaction;
import com.amarsoft.biz.bizlet.Bizlet;

/**
 * �ж�ģ�����Ƿ��ظ�
 * @author ������
 */
public class CheckMessageID extends Bizlet {
	public Object  run(Transaction Sqlca) throws Exception {
		String messageID = (String)this.getAttribute("MessageID");
		boolean flag = true;
		ASResultSet ss = Sqlca.getResultSet(new SqlObject("select * from PUB_MESSAGE_CONFIG where MessageID = :MessageID")
								.setParameter("MessageID", messageID));
		if(ss.next()){
			flag = false;
		}
		ss.close();
		if(!flag){
			return "false@ģ���š�"+messageID+"���Ѵ��ڣ�";
		}else{
			return "true@";
		}
	}
}
