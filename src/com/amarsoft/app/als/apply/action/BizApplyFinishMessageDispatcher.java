package com.amarsoft.app.als.apply.action;

import com.amarsoft.app.base.businessobject.BusinessObject;
import com.amarsoft.app.als.sys.function.model.FunctionBizlet;
import com.amarsoft.app.util.ASUserObject;
import com.amarsoft.are.ARE;
import com.amarsoft.are.jbo.BizObject;
import com.amarsoft.are.jbo.JBOTransaction;
import com.amarsoft.are.msg.Message;
import com.amarsoft.are.msg.Messenger;
import com.amarsoft.are.util.DataConvert;
import com.amarsoft.dict.als.manage.NameManager;

public class BizApplyFinishMessageDispatcher  extends FunctionBizlet{

	@Override
	public boolean run(JBOTransaction tx, BusinessObject parameterPool)
			throws Exception {
				if(parameterPool.getObject("NewObject")==null) {
					ARE.getLog(this.getClass().getName()).debug("新业务对象为空，不发送消息！");
					return false ;
				}
				//获取信使服务带来
				Messenger msger = Messenger.getMessenger();

				BizObject boBusiness=(BizObject)parameterPool.getObject("NewObject");
				String customerID=boBusiness.getAttribute("CustomerID").getString();
				String applyUserID=boBusiness.getAttribute("InputUserID").getString();
				String customerName=NameManager.getCustomerName(customerID);
				double dBusinessSum=boBusiness.getAttribute("BusinessSum").getDouble();
				String  businessType=boBusiness.getAttribute("BusinessType").getString();
				int temMonth=boBusiness.getAttribute("termMonth").getInt();
				businessType=NameManager.getBusinessName(businessType);
				//标准的发送形式要构造messge
				//发送给申请人
				Message m = new Message();
				m.setSender("信贷系统");
				m.setSubject(customerName+"业务审批通过");
				m.setBody(customerName+"你好！-贵公司申请的["+businessType+"]贷款["+DataConvert.toMoney(dBusinessSum)+"],期限["+temMonth+"]月审批通过，请尽快到我行进行签约");
				m.addRecipient(customerID); //收消息人
				msger.sendMessage(m);
				
				//发送给客户经理
				Message m2 = new Message();
				ASUserObject applyUser=ASUserObject.getUser(applyUserID);
				m2.setSender("信贷系统");
				m2.setSubject(customerName+"业务审批通过通知");
				m2.setBody(applyUser.getUserName()+"你好！-您申请的"+customerName+"["+businessType+"]贷款["+DataConvert.toMoney(dBusinessSum)+"],期限["+temMonth+"]月已经审批通过，请尽快与客户进行签约");
				m2.addRecipient(applyUserID); //收消息人
				msger.sendMessage(m2);
				//使用简化形式直接发送
			//	msger.sendMessage("0001", "0005,0006,0007", "Messenger Service Test 1", "此消息通过信使服务发送，所有的分发器都会处理！");
				msger.close();
		return true;
	}

	
}
