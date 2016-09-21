/**
 * 
 */
package com.amarsoft.app.als.reserve.handler;

import java.util.List;

import com.amarsoft.app.als.reserve.model.ReserveApply;
import com.amarsoft.app.als.reserve.model.ReservePredictdata;
import com.amarsoft.are.jbo.BizObject;
import com.amarsoft.are.jbo.JBOTransaction;
import com.amarsoft.awe.dw.handler.impl.CommonHandler;

/**
 * ��������ֵ����δ���ֽ���Ԥ��
 * @author xyli
 * @2014-5-13
 */
public class CashFlowCalListHandler extends CommonHandler {


	@Override
	protected void afterInsert(JBOTransaction tx, BizObject bo)throws Exception {
		String serialNo = bo.getAttribute("SerialNo").getString();
		String objectNo = asPage.getParameter("ObjectNo");
		
		//�ֽ�����Ϣ
		ReservePredictdata data = new ReservePredictdata(tx, serialNo);
		data.getBizObject().setAttributeValue("ObjectNo", objectNo);//����������
		data.saveObject();
		
		//
		ReserveApply apply = new ReserveApply(tx, objectNo);
		double totalFlowSum = 0.0;//�ܵ�δ���ֽ���Ԥ����
		List<BizObject> relaList = apply.getRelaCashFlow(tx,objectNo);
		for(BizObject bizData : relaList){
			double sum = bizData.getAttribute("SUM").getDouble();
			totalFlowSum += sum;
		}
		
		apply.getBizObject().setAttributeValue("PRDDISCOUNT", totalFlowSum);//δ���ֽ���Ԥ��ϼ�
		apply.getBizObject().setAttributeValue("RMBRESERVESUM", apply.getBizObject().getAttribute("Balance").getDouble() - totalFlowSum);//Ӧ�����ֵ׼���ܶ�
		
		apply.saveObject();
		
	}

	@Override
	protected void afterUpdate(JBOTransaction tx, BizObject bo)
			throws Exception {
		this.afterInsert(tx, bo);
	}
	
	
	
}
