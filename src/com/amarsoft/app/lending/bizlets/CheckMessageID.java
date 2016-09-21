package com.amarsoft.app.lending.bizlets;

import com.amarsoft.awe.util.ASResultSet;
import com.amarsoft.awe.util.SqlObject;
import com.amarsoft.awe.util.Transaction;
import com.amarsoft.biz.bizlet.Bizlet;

/**
 * 判断模板编号是否重复
 * @author 张万亮
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
			return "false@模板编号【"+messageID+"】已存在！";
		}else{
			return "true@";
		}
	}
}
