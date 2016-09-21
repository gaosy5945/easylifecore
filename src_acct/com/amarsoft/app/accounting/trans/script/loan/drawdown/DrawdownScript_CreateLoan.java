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
 * ���ڴ���ţ�����ACCT_relativeObject����
 * 
 */
public final class DrawdownScript_CreateLoan extends TransactionProcedure {
	
	@Override
	public int run() throws Exception {
		//1.δ����ſ��յģ��Ե�ǰ��������Ϊ�ſ���
		String putoutDate = documentObject.getString("PutoutDate");
		if (StringX.isEmpty(putoutDate)) {
			documentObject.setAttributeValue("PutoutDate", transaction.getString("TransDate"));
		}
		//2.����BUSINESS_PUTOUT��������ACCT_LOAN����
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
		
		// ���������պ�����
		String maturitydate = relativeObject.getString("MaturityDate");
		if (StringX.isEmpty(maturitydate)) {
			int termYear = documentObject.getInt("TermYear");
			int termMonth = documentObject.getInt("TermMonth");
			int termDay = documentObject.getInt("TermDay");
			maturitydate = DateHelper.getRelativeDate(documentObject.getString("PutoutDate"), DateHelper.TERM_UNIT_MONTH, termYear*12+termMonth);
			maturitydate = DateHelper.getRelativeDate(maturitydate, DateHelper.TERM_UNIT_DAY, termDay);
		}
		relativeObject.setAttributeValue("MaturityDate", maturitydate);// ����ĵ�����
		relativeObject.setAttributeValue("OriginalMaturityDate", maturitydate);// ����ĵ�����
		
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
		// ��ʼ��������Ϣ
		for (BusinessObject a : l) {
			String lastDueDate = a.getString("SegFromDate");
			if (StringX.isEmpty(lastDueDate)) lastDueDate = loan.getString("PutoutDate");
			a.setAttributeValue("LastDueDate", lastDueDate);

			String defaultDueDay = a.getString("DefaultDueDay");// Ĭ�ϻ�����
			if (StringX.isEmpty(defaultDueDay) || "0".equals(defaultDueDay)) defaultDueDay = loan.getString("PutoutDate").substring(8);
			if (defaultDueDay.length() < 2) defaultDueDay = "0" + defaultDueDay;
			if(defaultDueDay.compareTo("31") > 0) defaultDueDay = "31";
			a.setAttributeValue("DefaultDueDay", defaultDueDay);
			
			String nextPayDate = DueDateScript.getDueDateScript(loan,a,"1").generateNextDueDate();
			// ���㲢��ֲ��ϼƻ��е��´λ�����
			a.setAttributeValue("NextDueDate", nextPayDate);
			a.setAttributeValue("FirstDueDate", nextPayDate);

			// �������δ��黹ʣ�౾����Ϊ�������ⶨ���������
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
			a.setAttributeValue("BaseRate", baseRate);// ��׼����
			double businessRate = RateHelper.getBusinessRate(loan, a);
			a.setAttributeValue("BusinessRate", businessRate);// ִ������
			bomanager.updateBusinessObject(a);
		}
		
	}
	
	public void updateSegmentsDate(String orginalFromDate,List<BusinessObject> segmentList,String stepUnit,int step) throws Exception{
		for (int i=0;i<segmentList.size();i++) {
			BusinessObject segment=segmentList.get(i);
			
			String segFromDate = segment.getString("SegFromDate");// ������ʼ����
			int segFromStage = segment.getInt("SEGFromStage");// ������ʼ�ڴ�
			int segStages = segment.getInt("SEGStages");// �����ڴ�
			String segToDate = segment.getString("SegToDate");// ���ν�������
			int segToStage = segment.getInt("SEGToStage");// ���ν����ڴ�

			if(StringX.isEmpty(segFromDate)){
				if (segFromStage >0) {//����ʼ�����Ļ�����ô�ۼ�
					segFromDate = DateHelper.getRelativeDate(orginalFromDate, stepUnit, (segFromStage - 1) * step);// �˴���Ҫ��һ����Ϊ¼��ʱ�û�ϰ�ߴ�1��ʼ
				}
				else{
					segFromDate=orginalFromDate;
				}
			}
			
			if(StringX.isEmpty(segToDate)){
				if (segToStage>0) {//����ʼ�����Ļ�����ô�ۼ�
					segToDate = DateHelper.getRelativeDate(orginalFromDate, stepUnit, (segToStage - 1) * step);// �˴���Ҫ��һ����Ϊ¼��ʱ�û�ϰ�ߴ�1��ʼ
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
