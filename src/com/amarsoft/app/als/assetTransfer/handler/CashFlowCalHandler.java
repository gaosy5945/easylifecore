/**
 * 
 */
package com.amarsoft.app.als.assetTransfer.handler;

import java.util.HashSet;
import java.util.List;
import java.util.Set;

import com.amarsoft.app.als.assetTransfer.model.ProjectAssetRela;
import com.amarsoft.are.jbo.BizObject;
import com.amarsoft.awe.dw.handler.impl.CommonHandler;

/**
 * 描述：现金流预测
 * @author xyli
 * @2014-5-7
 */
public class CashFlowCalHandler extends CommonHandler {

	@Override
	protected void initDisplayForAdd(BizObject bo) throws Exception {
		String relaSerialNos = asPage.getParameter("relaSerialNos");
		String startDate = asPage.getParameter("startDate");
		String endDate = asPage.getParameter("endDate");
		String term = asPage.getParameter("term");
		
		if(relaSerialNos.endsWith("@")){
			relaSerialNos = relaSerialNos.substring(0, relaSerialNos.length() - 1);
		}
		relaSerialNos = relaSerialNos.replaceAll("@", "','");
		
		ProjectAssetRela rela = new ProjectAssetRela(null);
		List<BizObject> list = rela.getRelaList(relaSerialNos);
		
		Set<String> orgs = new HashSet<String>();//涉及机构数
		double totalSum = 0.0;//资产规模合计（折合人民币）
		for(BizObject biz : list){
			orgs.add(biz.getAttribute("ORGID").getString());
			String currency = biz.getAttribute("CURRENCY").getString();
			double businessSum = biz.getAttribute("BUSINESSSUM").getDouble();
			//TODO 币种转换
			totalSum =+ businessSum;
		}
		
		bo.setAttributeValue("BUSINESSCOUNT", list.size());
		bo.setAttributeValue("ORGCOUNT", orgs.size());
		bo.setAttributeValue("ASSETTOTAL", totalSum);
		bo.setAttributeValue("StartDate", startDate);
		bo.setAttributeValue("EndDate", endDate);
		bo.setAttributeValue("CapitalTotal", totalSum);//预测期本金收回合计
		bo.setAttributeValue("InterestTotal", totalSum);//预测期利息收回合计
	}
	
	
	
}
