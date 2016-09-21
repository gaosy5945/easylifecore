package com.amarsoft.app.accounting.trans.script.loan.balancechange;

import java.util.List;

import com.amarsoft.app.base.businessobject.BusinessObject;
import com.amarsoft.app.base.trans.TransactionProcedure;
import com.amarsoft.app.base.util.BUSINESSOBJECT_CONSTANTS;
import com.amarsoft.are.lang.StringX;
import com.amarsoft.are.util.Arith;
/**
 * ��Ϣ����
 * */
public class PrincipalInterestChangeExecutor extends TransactionProcedure{

	@Override
	public int run() throws Exception {
		
		if(!StringX.isEmpty(documentObject.getString("ObjectNo")))
		{
		
			//ȡ��Ϣ������Ӧ�Ļ���ƻ�
			BusinessObject paymentSchedule = relativeObject.getBusinessObjectByKey(BUSINESSOBJECT_CONSTANTS.payment_schedule, documentObject.getString("ObjectNo"));
			if(paymentSchedule == null) throw new Exception("����ƻ�δ�ҵ������飡");
			//��ȡ���������
			String businessDate = relativeObject.getString("BusinessDate");
			//����ڹ�����
			double waivePrincipalAmt = documentObject.getDouble("WaivePrincipalAmt");
			double principalAmt = paymentSchedule.getDouble("PayPrincipalAmt")-paymentSchedule.getDouble("ActualPayPrincipalAmt");
			if(waivePrincipalAmt+principalAmt < 0) throw new Exception("�����ڹ�������ܳ���δ����������飡");
			if(businessDate.compareTo(paymentSchedule.getString("PayDate")) >= 0 && waivePrincipalAmt >  paymentSchedule.getDouble("PrincipalBalance")+paymentSchedule.getDouble("WaivePrinaipalAmt"))
				throw new Exception("���ӱ�����ܳ���ʣ�౾�������������ڴΣ���");
			//����ڹ���Ϣ
			double waiveInteAmt = documentObject.getDouble("WaiveInterestAmt");
			double inteAmt = paymentSchedule.getDouble("PayInterestAmt")-paymentSchedule.getDouble("ActualPayInterestAmt");
			if(waiveInteAmt+inteAmt < 0) throw new Exception("�����ڹ���Ϣ���ܳ���δ���ڹ���Ϣ�����飡");
			//������ڷ�Ϣ
			double waiveFineAmt = documentObject.getDouble("WaivePrincipalPenaltyAmt");
			double fineAmt = paymentSchedule.getDouble("PayPrincipalPenaltyAmt")-paymentSchedule.getDouble("ActualPayPrincipalPenaltyAmt");
			if(waiveFineAmt+fineAmt < 0) throw new Exception("�������ڷ�Ϣ���ܳ���δ�����ڷ�Ϣ�����飡");
			//������ڸ���
			double waiveCompdInteAmt = documentObject.getDouble("WaiveInterestPenaltyAmt");
			double compdInteAmt = paymentSchedule.getDouble("PayInterestPenaltyAmt")-paymentSchedule.getDouble("ActualPayInterestPenaltyAmt");
			if(waiveCompdInteAmt+compdInteAmt < 0) throw new Exception("�������ڸ������ܳ���δ�����ڸ��������飡");
			
			paymentSchedule.setAttributeValue("PayPrincipalAmt", Arith.round(paymentSchedule.getDouble("PayPrincipalAmt")+waivePrincipalAmt,2));
			paymentSchedule.setAttributeValue("PayInterestAmt", Arith.round(paymentSchedule.getDouble("PayInterestAmt")+waiveInteAmt,2));
			paymentSchedule.setAttributeValue("PayPrincipalPenaltyAmt", Arith.round(paymentSchedule.getDouble("PayPrincipalPenaltyAmt")+waiveFineAmt,2));
			paymentSchedule.setAttributeValue("PayInterestPenaltyAmt", Arith.round(paymentSchedule.getDouble("PayInterestPenaltyAmt")+waiveCompdInteAmt,2));
			paymentSchedule.setAttributeValue("WaivePrincipalAmt", Arith.round(paymentSchedule.getDouble("WaivePrincipalAmt")+waivePrincipalAmt,2));
			paymentSchedule.setAttributeValue("WaiveInterestAmt",  Arith.round(paymentSchedule.getDouble("WaiveInterestAmt")+waiveInteAmt,2));
			paymentSchedule.setAttributeValue("WaivePrincipalPenaltyAmt",  Arith.round(paymentSchedule.getDouble("WaivePrincipalPenaltyAmt")+waiveFineAmt,2));
			paymentSchedule.setAttributeValue("WaiveInterestPenaltyAmt",  Arith.round(paymentSchedule.getDouble("WaiveInterestPenaltyAmt")+waiveCompdInteAmt,2));
			bomanager.updateBusinessObject(paymentSchedule);
			
			//����δ������ƻ����������ɻ���ƻ�
			if(Math.abs(waivePrincipalAmt) >= 0.0d)
			{
				//�������������ڹ��ͻ���ƻ�
				List<BusinessObject> rptList = relativeObject.getBusinessObjectsBySql(BUSINESSOBJECT_CONSTANTS.loan_rpt_segment, "Status='1'");
				for(BusinessObject rptSegment:rptList)
				{
					rptSegment.setAttributeValue("PSRestructureFlag", "2");
				}
			}
		}
		else
		{
			
		}
		
		
		return 1;
	}
	
}
