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
 * �ж�Ԥ����Ϣ�Ƿ�����
 * @author zwcui
 */
public class CheckRiskWarningInfo extends AlarmBiz{

	public Object run(Transaction Sqlca) throws Exception{
		
		String flowSerialNo = (String)this.getAttribute("FlowSerialNo");
		String s = (String)this.getAttribute("PhaseNo");

		BizObject boFO = JBOFactory.createBizObjectQuery("jbo.flow.FLOW_OBJECT","O.FlowSerialNo=:FlowSerialNo and O.ObjectType='jbo.al.RISK_WARNING_SIGNAL'")
				.setParameter("FlowSerialNo", flowSerialNo)
				.getSingleResult(false);
		String objectNo = boFO.getAttribute("ObjectNo").toString();
		
		BizObject boRWS = JBOFactory.createBizObjectQuery("jbo.al.RISK_WARNING_SIGNAL","O.SerialNo=:SerialNo ")
				.setParameter("SerialNo", objectNo)
				.getSingleResult(false);
		String signalID = boRWS.getAttribute("SignalID").toString();
		String dealMethod = boRWS.getAttribute("DealMethod").toString();
		String isExclude = boRWS.getAttribute("IsExclude").toString();
		
		if(signalID == null || "".equals(signalID) || dealMethod == null || "".equals(dealMethod) || isExclude == null || "".equals(isExclude))
			putMsg( "Ԥ����Ϣ���������뱣����Ϣ��");
		
		/* ���ؽ������  */
		if(messageSize() > 0){
			setPass(false);
		}else{
			setPass(true);
		}
		return false;
		
	}
}
