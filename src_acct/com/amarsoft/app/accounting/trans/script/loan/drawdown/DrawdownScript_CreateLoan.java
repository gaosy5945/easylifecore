package com.amarsoft.app.accounting.trans.script.loan.drawdown;

import java.util.ArrayList;
import java.util.List;

import com.amarsoft.app.accounting.cashflow.due.DueDateScript;
import com.amarsoft.app.base.util.BUSINESSOBJECT_CONSTANTS;
import com.amarsoft.app.base.util.RateHelper;
import com.amarsoft.app.base.businessobject.BusinessObject;
import com.amarsoft.app.base.trans.TransactionProcedure;
import com.amarsoft.app.base.util.DateHelper;
import com.amarsoft.are.lang.StringX;

/**
 * 表内贷款发放，创建ACCT_relativeObject对象
 * 
 */
public final class DrawdownScript_CreateLoan extends TransactionProcedure {
	
	@Override
	public int run() throws Exception {
		//1.未输入放款日的，以当前交易日期为放款日
		String putoutDate = documentObject.getString("PutoutDate");
		if (StringX.isEmpty(putoutDate)) {
			documentObject.setAttributeValue("PutoutDate", transaction.getString("TransDate"));
		}
		//2.根据BUSINESS_PUTOUT对象生成ACCT_LOAN对象
		if(this.relativeObject==null){
			createLoan();
		}
		return 1;
	}
	
	public void createLoan() throws Exception {
		relativeObject = BusinessObject.createBusinessObject(BUSINESSOBJECT_CONSTANTS.loan);
		if(!StringX.isEmpty(documentObject.getString("LoanSerialNo")))
			relativeObject.setKey(documentObject.getString("LoanSerialNo"));
		else
			relativeObject.generateKey();
		relativeObject.setAttributeValue("AccountNo", relativeObject.getKeyString());
		transaction.setAttributeValue("RelativeObjectType", BUSINESSOBJECT_CONSTANTS.loan);
		transaction.setAttributeValue("RelativeObjectNo", relativeObject.getKeyString());
		transaction.setAttributeValue(BUSINESSOBJECT_CONSTANTS.loan,relativeObject);
		relativeObject.setAttributes(documentObject);
		relativeObject.setAttributeValue("LoanStatus", "0");
		relativeObject.setAttributeValue("BusinessDate", documentObject.getObject("PutoutDate"));
		
		// 计算贷款到期日和期限
		String maturitydate = relativeObject.getString("MaturityDate");
		if (StringX.isEmpty(maturitydate)) {
			int termYear = documentObject.getInt("TermYear");
			int termMonth = documentObject.getInt("TermMonth");
			int termDay = documentObject.getInt("TermDay");
			maturitydate = DateHelper.getRelativeDate(documentObject.getString("PutoutDate"), DateHelper.TERM_UNIT_MONTH, termYear*12+termMonth);
			maturitydate = DateHelper.getRelativeDate(maturitydate, DateHelper.TERM_UNIT_DAY, termDay);
		}
		relativeObject.setAttributeValue("MaturityDate", maturitydate);// 贷款的到期日
		relativeObject.setAttributeValue("OriginalMaturityDate", maturitydate);// 贷款的到期日
		
		List<BusinessObject> l = copyRelativeObjects(documentObject.getBusinessObjects(BUSINESSOBJECT_CONSTANTS.business_account),"ObjectType","ObjectNo");
		this.bomanager.updateBusinessObjects(l);
		relativeObject.appendBusinessObjects(BUSINESSOBJECT_CONSTANTS.business_account, l);
		
		l = copyRelativeObjects(documentObject.getBusinessObjects(BUSINESSOBJECT_CONSTANTS.payment_schedule),"ObjectType","ObjectNo");
		this.bomanager.updateBusinessObjects(l);
		relativeObject.appendBusinessObjects(BUSINESSOBJECT_CONSTANTS.payment_schedule, l);
		
		this.bomanager.updateBusinessObject(relativeObject);
		this.copyRPTSegments();
		this.copyRateSegments();
		
	}

	private List<BusinessObject> copyRelativeObjects(List<BusinessObject> list,String objectTypeID,String objectNoID) throws Exception {
		List<BusinessObject> l=new ArrayList<BusinessObject>();
		for (BusinessObject o:list) {
			BusinessObject o1 = BusinessObject.createBusinessObject(o.getBizClassName());
			o1.setAttributes(o);
			o1.generateKey(true);;
			o1.setAttributeValue(objectTypeID, this.relativeObject.getBizClassName());
			o1.setAttributeValue(objectNoID, this.relativeObject.getKeyString());
			o1.setAttributeValue("Status", "1");

			l.add(o1);
		}
		return l;
	}
	
	protected void copyRPTSegments() throws Exception {
		BusinessObject loan=this.relativeObject;
		List<BusinessObject> l = documentObject.getBusinessObjects(BUSINESSOBJECT_CONSTANTS.loan_rpt_segment);
		
		l = copyRelativeObjects(l,"ObjectType","ObjectNo");
		this.updateSegmentsDate(documentObject.getString("PutoutDate"), l, DateHelper.TERM_UNIT_MONTH, 1);
		loan.setAttributeValue(BUSINESSOBJECT_CONSTANTS.loan_rpt_segment, l);
		// 初始化还款信息
		for (BusinessObject a : l) {
			String lastDueDate = a.getString("SegFromDate");
			if (StringX.isEmpty(lastDueDate)) lastDueDate = loan.getString("PutoutDate");
			a.setAttributeValue("LastDueDate", lastDueDate);

			String defaultDueDay = a.getString("DefaultDueDay");// 默认还款日
			if (StringX.isEmpty(defaultDueDay) || "0".equals(defaultDueDay)) defaultDueDay = loan.getString("PutoutDate").substring(8);
			if (defaultDueDay.length() < 2) defaultDueDay = "0" + defaultDueDay;
			if(defaultDueDay.compareTo("31") > 0) defaultDueDay = "31";
			a.setAttributeValue("DefaultDueDay", defaultDueDay);
			
			String nextPayDate = DueDateScript.getDueDateScript(loan,a,"1").generateNextDueDate();
			// 计算并重植组合计划中的下次还款日
			a.setAttributeValue("NextDueDate", nextPayDate);
			a.setAttributeValue("FirstDueDate", nextPayDate);

			// 将本区段待归还剩余本金置为本区段拟定还款金额，本金
			a.setAttributeValue("SEGRPTBalance", a.getDouble("SEGRPTAmount"));
			this.bomanager.updateBusinessObject(a);
		}
		
	}

	private void copyRateSegments() throws NumberFormatException, Exception {
		BusinessObject loan=this.relativeObject;
		List<BusinessObject> l = documentObject.getBusinessObjects(BUSINESSOBJECT_CONSTANTS.loan_rate_segment);
		l = copyRelativeObjects(l,"ObjectType","ObjectNo");
		this.updateSegmentsDate(documentObject.getString("PutoutDate"), l, DateHelper.TERM_UNIT_MONTH, 1);
		loan.setAttributeValue(BUSINESSOBJECT_CONSTANTS.loan_rate_segment, l);
		for (BusinessObject a : l) {
			String lastRepriceDate = a.getString("SegFromDate");
			if (StringX.isEmpty(lastRepriceDate)) lastRepriceDate = loan.getString("PutoutDate");
			a.setAttributeValue("LastRepriceDate", lastRepriceDate);
			double baseRate = RateHelper.getBaseRate(loan, a);
			a.setAttributeValue("BaseRate", baseRate);// 基准利率
			double businessRate = RateHelper.getBusinessRate(loan, a);
			a.setAttributeValue("BusinessRate", businessRate);// 执行利率
			bomanager.updateBusinessObject(a);
		}
		
	}
	
	public void updateSegmentsDate(String orginalFromDate,List<BusinessObject> segmentList,String stepUnit,int step) throws Exception{
		for (int i=0;i<segmentList.size();i++) {
			BusinessObject segment=segmentList.get(i);
			
			String segFromDate = segment.getString("SegFromDate");// 区段起始日期
			int segFromStage = segment.getInt("SEGFromStage");// 区段起始期次
			int segStages = segment.getInt("SEGStages");// 持续期次
			String segToDate = segment.getString("SegToDate");// 区段结束日期
			int segToStage = segment.getInt("SEGToStage");// 区段结束期次

			if(StringX.isEmpty(segFromDate)){
				if (segFromStage >0) {//有起始月数的话，那么累加
					segFromDate = DateHelper.getRelativeDate(orginalFromDate, stepUnit, (segFromStage - 1) * step);// 此处需要减一，因为录入时用户习惯从1开始
				}
				else{
					segFromDate=orginalFromDate;
				}
			}
			
			if(StringX.isEmpty(segToDate)){
				if (segToStage>0) {//有起始月数的话，那么累加
					segToDate = DateHelper.getRelativeDate(orginalFromDate, stepUnit, (segToStage - 1) * step);// 此处需要减一，因为录入时用户习惯从1开始
				}
				else if (segStages>0){
					segToDate = DateHelper.getRelativeDate(segFromDate, stepUnit, (segToStage - 1) * step);
				}
			}
			segment.setAttributeValue("SegFromDate", segFromDate);
			segment.setAttributeValue("SegToDate", segToDate);
			this.bomanager.updateBusinessObject(segment);
		}
	}

}
