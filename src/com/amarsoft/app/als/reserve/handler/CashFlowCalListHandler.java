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
 * 描述：减值计提未来现金流预测
 * @author xyli
 * @2014-5-13
 */
public class CashFlowCalListHandler extends CommonHandler {


	@Override
	protected void afterInsert(JBOTransaction tx, BizObject bo)throws Exception {
		String serialNo = bo.getAttribute("SerialNo").getString();
		String objectNo = asPage.getParameter("ObjectNo");
		
		//现金流信息
		ReservePredictdata data = new ReservePredictdata(tx, serialNo);
		data.getBizObject().setAttributeValue("ObjectNo", objectNo);//关联对象编号
		data.saveObject();
		
		//
		ReserveApply apply = new ReserveApply(tx, objectNo);
		double totalFlowSum = 0.0;//总的未来现金流预测金额
		List<BizObject> relaList = apply.getRelaCashFlow(tx,objectNo);
		for(BizObject bizData : relaList){
			double sum = bizData.getAttribute("SUM").getDouble();
			totalFlowSum += sum;
		}
		
		apply.getBizObject().setAttributeValue("PRDDISCOUNT", totalFlowSum);//未来现金流预测合计
		apply.getBizObject().setAttributeValue("RMBRESERVESUM", apply.getBizObject().getAttribute("Balance").getDouble() - totalFlowSum);//应计提减值准备总额
		
		apply.saveObject();
		
	}

	@Override
	protected void afterUpdate(JBOTransaction tx, BizObject bo)
			throws Exception {
		this.afterInsert(tx, bo);
	}
	
	
	
}
