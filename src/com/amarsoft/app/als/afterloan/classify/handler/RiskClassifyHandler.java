package com.amarsoft.app.als.afterloan.classify.handler;

import java.util.List;

import com.amarsoft.app.als.awe.ow.ALSBusinessProcess;
import com.amarsoft.are.jbo.BizObject;
import com.amarsoft.are.jbo.BizObjectManager;
import com.amarsoft.are.jbo.BizObjectQuery;
import com.amarsoft.are.jbo.JBOFactory;
import com.amarsoft.are.jbo.JBOTransaction;
import com.amarsoft.awe.dw.handler.impl.CommonHandler;
/**
 * 批量更新风险分类信息
 * @author qzhang2
 * @2015-01-21
 */

//public class RiskClassifyHandler extends CommonHandler{
	public class RiskClassifyHandler extends ALSBusinessProcess{
	protected void save(JBOTransaction tx,BizObject bo) throws Exception {
		
		String flowSerialNo = this.asPage.getParameter("FlowSerialNo");
		String serialNo = this.asPage.getParameter("SerialNo");

		BizObjectManager bom = JBOFactory.getBizObjectManager("jbo.al.CLASSIFY_RECORD");
		tx.join(bom);
		BizObjectQuery bq1 = bom.createQuery("SerialNo=:SerialNo");
		bq1.setParameter("SerialNo", serialNo);
		BizObject bo1 = bq1.getSingleResult(true);
		
		BizObjectQuery bq = bom.createQuery("SerialNo in (select FO.ObjectNo from jbo.flow.FLOW_OBJECT FO where FO.FlowSerialNo=:FlowSerialNo)");
		bq.setParameter("FlowSerialNo", flowSerialNo);
		
		List<BizObject> crList = bq.getResultList(true);
		if(crList != null)
		{
			for(BizObject arbo:crList)
			{
				arbo.setAttributeValue("ClassifyMethod", bo1.getAttribute("ClassifyMethod"));
				arbo.setAttributeValue("ADJUSTEDGRADE",  bo1.getAttribute("AdjustedGrade"));
				arbo.setAttributeValue("Remark",  bo1.getAttribute("Remark"));
				arbo.setAttributeValue("UPDATEDATE",  bo1.getAttribute("UPDATEDATE"));
				bom.saveObject(arbo);
			}
		}
	}

}
