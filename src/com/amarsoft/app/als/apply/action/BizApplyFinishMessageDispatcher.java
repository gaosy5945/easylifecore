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
					ARE.getLog(this.getClass().getName()).debug("��ҵ�����Ϊ�գ���������Ϣ��");
					return false ;
				}
				//��ȡ��ʹ�������
				Messenger msger = Messenger.getMessenger();

				BizObject boBusiness=(BizObject)parameterPool.getObject("NewObject");
				String customerID=boBusiness.getAttribute("CustomerID").getString();
				String applyUserID=boBusiness.getAttribute("InputUserID").getString();
				String customerName=NameManager.getCustomerName(customerID);
				double dBusinessSum=boBusiness.getAttribute("BusinessSum").getDouble();
				String  businessType=boBusiness.getAttribute("BusinessType").getString();
				int temMonth=boBusiness.getAttribute("termMonth").getInt();
				businessType=NameManager.getBusinessName(businessType);
				//��׼�ķ�����ʽҪ����messge
				//���͸�������
				Message m = new Message();
				m.setSender("�Ŵ�ϵͳ");
				m.setSubject(customerName+"ҵ������ͨ��");
				m.setBody(customerName+"��ã�-��˾�����["+businessType+"]����["+DataConvert.toMoney(dBusinessSum)+"],����["+temMonth+"]������ͨ�����뾡�쵽���н���ǩԼ");
				m.addRecipient(customerID); //����Ϣ��
				msger.sendMessage(m);
				
				//���͸��ͻ�����
				Message m2 = new Message();
				ASUserObject applyUser=ASUserObject.getUser(applyUserID);
				m2.setSender("�Ŵ�ϵͳ");
				m2.setSubject(customerName+"ҵ������ͨ��֪ͨ");
				m2.setBody(applyUser.getUserName()+"��ã�-�������"+customerName+"["+businessType+"]����["+DataConvert.toMoney(dBusinessSum)+"],����["+temMonth+"]���Ѿ�����ͨ�����뾡����ͻ�����ǩԼ");
				m2.addRecipient(applyUserID); //����Ϣ��
				msger.sendMessage(m2);
				//ʹ�ü���ʽֱ�ӷ���
			//	msger.sendMessage("0001", "0005,0006,0007", "Messenger Service Test 1", "����Ϣͨ����ʹ�����ͣ����еķַ������ᴦ��");
				msger.close();
		return true;
	}

	
}
