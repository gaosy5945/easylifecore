package com.amarsoft.app.check;

import java.util.List;

import com.amarsoft.app.alarm.AlarmBiz;
import com.amarsoft.are.jbo.BizObject;
import com.amarsoft.are.jbo.BizObjectManager;
import com.amarsoft.are.jbo.BizObjectQuery;
import com.amarsoft.are.jbo.JBOFactory;
import com.amarsoft.are.jbo.JBOTransaction;
import com.amarsoft.awe.util.ASResultSet;
import com.amarsoft.awe.util.SqlObject;
import com.amarsoft.awe.util.Transaction;
import com.amarsoft.biz.bizlet.Bizlet;

/**
 * �ж��A�����ԭ���Ƿ��
 * @author zwcui
 */
public class CheckRemoveRiskOpinion extends AlarmBiz{

	public Object run(Transaction Sqlca) throws Exception{
		
		String flowSerialNo = (String)this.getAttribute("FlowSerialNo");

		BizObject boFO = JBOFactory.createBizObjectQuery("jbo.flow.FLOW_OBJECT","O.FlowSerialNo=:FlowSerialNo and O.ObjectType='jbo.al.RISK_WARNING_SIGNAL'")
				.setParameter("FlowSerialNo", flowSerialNo)
				.getSingleResult(false);
		String objectNo = boFO.getAttribute("ObjectNo").toString();
		
		BizObject boRWS = JBOFactory.createBizObjectQuery("jbo.al.RISK_WARNING_SIGNAL","O.SerialNo=:SerialNo ")
				.setParameter("SerialNo", objectNo)
				.getSingleResult(false);
		String denyReason = boRWS.getAttribute("DenyReason").toString();
		
		if(denyReason == null || "".equals(denyReason))
			putMsg( "������дԤ�����ԭ�����ύ��");
		
		/* ���ؽ������  */
		if(messageSize() > 0){
			setPass(false);
		}else{
			setPass(true);
		}
		return false;
		
	}
}
