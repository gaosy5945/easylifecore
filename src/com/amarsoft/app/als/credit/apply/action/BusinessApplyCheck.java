package com.amarsoft.app.als.credit.apply.action;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import com.amarsoft.app.als.awe.script.WebBusinessProcessor;
import com.amarsoft.app.base.businessobject.BusinessObject;
import com.amarsoft.app.base.businessobject.BusinessObjectManager;
import com.amarsoft.app.base.util.ObjectWindowHelper;
import com.amarsoft.are.jbo.JBOTransaction;
import com.amarsoft.are.util.Arith;
import com.amarsoft.are.util.DataConvert;
import com.amarsoft.are.util.json.JSONObject;
import com.amarsoft.awe.util.ASResultSet;
import com.amarsoft.awe.util.SqlObject;
import com.amarsoft.awe.util.Transaction;
import com.amarsoft.dict.als.cache.CodeCache;
import com.amarsoft.dict.als.object.Item;

public class BusinessApplyCheck extends WebBusinessProcessor {
	public String checkRPT(JBOTransaction tx) throws Exception{
		BusinessObject inputObject = this.getInputParameters();
		int businessTermMonth=inputObject.getInt("BusinessTerm");
		List<String> resultInfo=new ArrayList<String>();
		JSONObject rptdata = (JSONObject)this.inputParameter.getValue("rptdata");
		List<BusinessObject> businessObjectArray = new ArrayList<BusinessObject>();
		boolean existsFixPrincipal=false;
		boolean existsOther=false;
		double businessBalance = inputObject.getDouble("BusinessSum");
		String paymentFrequencyType = inputObject.getString("PayFrequencyType");
		String defaultDueDay = inputObject.getString("DefaultDueDay");
		int paymentFrequencyTerm = inputObject.getInt("PayFrequency");
		String objectType = inputObject.getString("ObjectType");
		String objectNo = inputObject.getString("ObjectNo");
		int dueTerm = 0;//已还期次
		BusinessObjectManager bom = BusinessObjectManager.createBusinessObjectManager(tx);
		if("jbo.acct.ACCT_LOAN_CHANGE".equals(objectType)){
			BusinessObject loanchange = bom.keyLoadBusinessObject(objectType, objectNo);
			String relativeObjectType = loanchange.getString("ObjectType");
			String relativeObjectNo = loanchange.getString("ObjectNo");
			BusinessObject businessobject = bom.keyLoadBusinessObject(relativeObjectType, relativeObjectNo);
			businessBalance = businessobject.getDouble("Balance");
			
			Transaction sqlca = Transaction.createTransaction(tx);
			SqlObject asql = new SqlObject("select max(SeqID) from acct_payment_schedule where duebillno=:DueBillNo and Status='L2' ")
				.setParameter("DueBillNo", relativeObjectNo);
			ASResultSet rs = sqlca.getASResultSet(asql);
			if(rs.next()){
				dueTerm = rs.getInt(1);
			}
			rs.close();
		}
		
		
		if(!"99".equals(paymentFrequencyType))
		{
			Item item = CodeCache.getItem("PaymentFrequencyType", paymentFrequencyType);
			if(item != null)
			{
				paymentFrequencyTerm = DataConvert.toInt(item.getRelativeCode());
			}
		}
		
		if(paymentFrequencyTerm <= 0) paymentFrequencyTerm = 1;
		
		Map<Integer,BusinessObject> segMap=new HashMap<Integer,BusinessObject>();
		
		int lastsegtostage=0;
		if("jbo.acct.ACCT_LOAN_CHANGE".equals(objectType)){
			lastsegtostage = dueTerm;
		}
		
		for(int i=0;i<rptdata.size();i++){
			JSONObject data = (JSONObject)rptdata.get(i).getValue();
			int rowNum = (Integer)data.getValue("RowNum")+1;
			BusinessObject rptObject = ObjectWindowHelper.createBusinessObject_JSON(data);
			businessObjectArray.add(rptObject);
			int segtostage = rptObject.getInt("SEGTOSTAGE");
			if(segtostage<=0){
				resultInfo.add("在组合还款方式下，第"+rowNum+"个阶段的截止期次不能为空!");
			}
			
			String SEGRPTTERMID = rptObject.getString("SEGRPTTERMID");
			double SEGRPTAMOUNT = rptObject.getDouble("SEGRPTAMOUNT");
			if("5".equals(SEGRPTTERMID)&&SEGRPTAMOUNT<=0d){
				resultInfo.add("在组合还款方式下，第"+rowNum+"个阶段还款方式为固定本金时，还款金额必须大于零!");
			}
			else if(!"5".equals(SEGRPTTERMID)&&SEGRPTAMOUNT>0d){
				resultInfo.add("在组合还款方式下，第"+rowNum+"个阶段还款方式不为固定本金时，还款金额必须等于零!");
			}
			if("5".equals(SEGRPTTERMID)){
				existsFixPrincipal=true;
			}
			
			if(!"5".equals(SEGRPTTERMID) && !"3".equals(SEGRPTTERMID))
			{
				existsOther=true;
			}
			
			if("3".equals(SEGRPTTERMID)){
				businessBalance=businessBalance-SEGRPTAMOUNT;
			}
			else{
				businessBalance=businessBalance-SEGRPTAMOUNT*(segtostage-lastsegtostage);
			}
			
			if(i==rptdata.size()-1){//最后一条
				if("3".equals(SEGRPTTERMID)){
					resultInfo.add("分次付息不能作为最后一阶段还款方式!");
				}
				if(segtostage*paymentFrequencyTerm!=businessTermMonth){
					resultInfo.add("最后一个还款阶段的截止期次必须等于贷款期限!");
				}
				if("4".equals(SEGRPTTERMID)&&(segtostage-lastsegtostage)!=1){
					resultInfo.add("若选择一次还本时，必须是最后一阶段的最后一期!");
				}
			}
			else{
				if("4".equals(SEGRPTTERMID)){
					resultInfo.add("若选择一次还本时，必须是最后一阶段!");
				}
				if(segtostage*paymentFrequencyTerm > businessTermMonth){
					resultInfo.add("非最后一段还款阶段的截止期次必须小于贷款期限!");
				}
			}
			
			
			
			if(segMap.get(segtostage)==null)
				segMap.put(segtostage,rptObject);
			else{
				resultInfo.add("期数不能重叠，缺漏!");
			}
			lastsegtostage=segtostage;
		}
		if(existsFixPrincipal&&(Arith.round(businessBalance,2)>1||Arith.round(businessBalance,2)<-1)){
			resultInfo.add("当选择“固定本金+分次付息”时，录入的各期贷款本金之和与贷款金额相差必须小于1元!");
		}
		
		if(!existsFixPrincipal){//不存在固定则通过
		}
		else if(existsFixPrincipal&&!existsOther){//存在固定，但是不存在其他方式，则通过
		}
		else{
			resultInfo.add("在组合还款方式下，如果存在固定本金方式，则所有阶段的还款方式都必须是固定本金或者分次付息!");
		}
		if(rptdata.size()<2||rptdata.size()>8){
			resultInfo.add("在组合还款方式下，至少应该有2个阶段，最多可以有8个阶段!");
		}
		
		if(resultInfo.isEmpty())
			return "1";
		else{
			String s="";
			for(String s1:resultInfo){
				s+=s1+"\n";
			}
			return "2@"+s;
		}
	}
	
	
	public String checkRAT(JBOTransaction tx) throws Exception{
		BusinessObject inputObject = this.getInputParameters();
		int businessTermMonth=inputObject.getInt("BusinessTerm");
		List<String> resultInfo=new ArrayList<String>();
		JSONObject ratdata = (JSONObject)this.inputParameter.getValue("ratdata");
		List<BusinessObject> businessObjectArray = new ArrayList<BusinessObject>();
		
		for(int i=0;i<ratdata.size();i++){
			JSONObject data = (JSONObject)ratdata.get(i).getValue();
			int rowNum = (Integer)data.getValue("RowNum")+1;
			BusinessObject rptObject = ObjectWindowHelper.createBusinessObject_JSON(data);
			businessObjectArray.add(rptObject);
			int segtostage = rptObject.getInt("SEGTOSTAGE");
			String rateMode = rptObject.getString("RateMode");
			if(segtostage<=0){
				resultInfo.add("在组合利率方式下，第"+rowNum+"个阶段的截止期次不能为空!");
			}
			
			if(i==ratdata.size()-1){//最后一条
				if(segtostage!=businessTermMonth){
					resultInfo.add("在组合利率方式下，最后一个阶段的截止期限必须等于贷款期限!");
				}
			}
			else{
				if("1".equals(rateMode)){
					resultInfo.add("在组合利率方式下，浮动利率只能出现在最后一阶段!");
				}
			}
		}
		if(ratdata.size()<2||ratdata.size()>5){
			resultInfo.add("在组合利率方式下，至少应该有2个阶段，最多可以有5个阶段!");
		}
		
		if(resultInfo.isEmpty())
			return "1";
		else{
			String s="";
			for(String s1:resultInfo){
				s+=s1+"\n";
			}
			return "2@"+s;
		}
	}
}
