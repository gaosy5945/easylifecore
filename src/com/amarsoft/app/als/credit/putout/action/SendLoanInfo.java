package com.amarsoft.app.als.credit.putout.action;

import java.util.List;

import com.amarsoft.app.base.businessobject.BusinessObject;
import com.amarsoft.app.base.businessobject.BusinessObjectManager;
import com.amarsoft.app.base.trans.TransactionHelper;
import com.amarsoft.app.base.util.BUSINESSOBJECT_CONSTANTS;
import com.amarsoft.app.base.util.DateHelper;
import com.amarsoft.app.base.util.RateHelper;
import com.amarsoft.app.accounting.config.impl.CashFlowConfig;
import com.amarsoft.are.jbo.JBOTransaction;
import com.amarsoft.are.lang.StringX;
/**
 * 
 * @author T-zhangwl
 * 功能：根据借据号查询贷款信息并调核心2208接口
 * 
 * 该类除更新状态外，不进行其他数据更新。
 */
public class SendLoanInfo {
	private String putoutNo;
	private String userID;
	private String orgID;
	
	public String getPutoutNo() {
		return putoutNo;
	}

	public void setPutoutNo(String putoutNo) {
		this.putoutNo = putoutNo;
	}


	public String getUserID() {
		return userID;
	}

	public void setUserID(String userID) {
		this.userID = userID;
	}

	public String getOrgID() {
		return orgID;
	}

	public void setOrgID(String orgID) {
		this.orgID = orgID;
	}

	public String Determine(JBOTransaction tx) throws Exception{
		BusinessObjectManager bomanager = BusinessObjectManager.createBusinessObjectManager(tx);
		
		BusinessObject bp = bomanager.keyLoadBusinessObject("jbo.app.BUSINESS_PUTOUT", this.putoutNo);
		if(bp == null) throw new Exception("未找到对应出账信息！");
		if (StringX.isEmpty(bp.getString("DuebillSerialNo")))
			bp.setAttributeValue("DuebillSerialNo", bp.getKeyString());
		
		String businessCurrency = bp.getString("BusinessCurrency");//币种（转）
		
		String putoutDate = DateHelper.getBusinessDate();
		String businessTermUnit = bp.getString("BusinessTermUnit");
		int businessTerm = bp.getInt("BusinessTerm");
		String maturityDate = DateHelper.getRelativeDate(putoutDate, businessTermUnit, businessTerm);
		int businessTermDay = bp.getInt("BusinessTermDay");
		maturityDate = DateHelper.getRelativeDate(maturityDate, DateHelper.TERM_UNIT_DAY, businessTermDay);
		
		int term = businessTerm + businessTermDay/30 + (businessTermDay%30>0 ? 1 : 0);
		
		bp.setAttributeValue("PutOutDate", putoutDate);
		bp.setAttributeValue("MaturityDate", maturityDate);
		
		
		List<BusinessObject> bcs = bomanager.loadBusinessObjects("jbo.app.BUSINESS_CONTRACT", "ApplySerialNo=:ApplySerialNo","ApplySerialNo",bp.getString("ApplySerialNo"));
		if(bcs != null && bcs.size() > 0){
			BusinessObject bc = bcs.get(0);
			bc.setAttributeValue("CONTRACTDATE", putoutDate);
			bc.setAttributeValue("MATURITYDATE", DateHelper.getRelativeDate(DateHelper.getRelativeDate(putoutDate, DateHelper.TERM_UNIT_MONTH, bc.getInt("BusinessTerm")), DateHelper.TERM_UNIT_DAY, bc.getInt("BusinessTermDay")));
			bc.setAttributeValue("ContractStatus", "02");
			bomanager.updateBusinessObject(bc);
		}
		
		
		BusinessObject ap = bomanager.keyLoadBusinessObject(BUSINESSOBJECT_CONSTANTS.putout, bp.getString("DuebillSerialNo"));
		if(ap == null)
		{
			ap = BusinessObject.createBusinessObject(BUSINESSOBJECT_CONSTANTS.putout);
			ap.generateKey();
		}
		
		
		ap.setAttributes(bp);
		ap.setAttributeValue("SerialNo", bp.getString("DuebillSerialNo"));
		ap.setAttributeValue("LoanSerialNo", bp.getString("DuebillSerialNo"));
		ap.setAttributeValue("PutoutSerialNo", bp.getString("SerialNo"));
		ap.setAttributeValue("ORIGINALMATURITYDATE", maturityDate);
		ap.setAttributeValue("CLASSIFYRESULT", "01");
		ap.setAttributeValue("CURRENCY", businessCurrency);
		
		
		//还款方式
		List<BusinessObject> apRptList = bomanager.loadBusinessObjects("jbo.acct.ACCT_RPT_SEGMENT", "ObjectType=:ObjectType and ObjectNo=:ObjectNo", "ObjectType",ap.getBizClassName(),"ObjectNo",ap.getKeyString());
		bomanager.deleteBusinessObjects(apRptList);
		
		List<BusinessObject> rptList = bomanager.loadBusinessObjects("jbo.acct.ACCT_RPT_SEGMENT", "ObjectType=:ObjectType and ObjectNo=:ObjectNo and TermID=:RPTTermID order by SegToStage", "ObjectType",bp.getBizClassName(),"ObjectNo",bp.getKeyString(),"RPTTermID",bp.getString("RPTTermID"));
		for(BusinessObject rpt:rptList)
		{
			BusinessObject n = BusinessObject.createBusinessObject(rpt.getBizClassName());
			n.setAttributes(rpt);
			n.generateKey(true);
			n.setAttributeValue("ObjectType", ap.getBizClassName());
			n.setAttributeValue("ObjectNo", ap.getKeyString());
			n.setAttributeValue("Status", "1");
			BusinessObject rule = BusinessObject.createBusinessObject("rule");
			rule.setAttributeValue("PostponeFlag", "1");
			rule.setAttributeValue("HolidayFlag", "");
			n.setAttributeValue("POSTPONERULE", rule.toJSONString());
			bomanager.updateBusinessObject(n);
			ap.appendBusinessObject(n.getBizClassName(), n);
		}
		
		//利率信息
		List<BusinessObject> apRateList = bomanager.loadBusinessObjects("jbo.acct.ACCT_RATE_SEGMENT", "ObjectType=:ObjectType and ObjectNo=:ObjectNo", "ObjectType",ap.getBizClassName(),"ObjectNo",ap.getKeyString());
		bomanager.deleteBusinessObjects(apRateList);
		
		
		List<BusinessObject> rateList = bomanager.loadBusinessObjects("jbo.acct.ACCT_RATE_SEGMENT", "ObjectType=:ObjectType and ObjectNo=:ObjectNo and RateType=:RateType and TermID=:RateTermID order by SegToStage", "ObjectType",bp.getBizClassName(),"ObjectNo",bp.getKeyString(),"RateType","01","RateTermID",bp.getString("LoanRateTermID"));
		for(BusinessObject rate:rateList)
		{
			
			String defaultRepriceDate = rate.getString("DefaultRepriceDate");
			if(!StringX.isEmpty(defaultRepriceDate))
				rate.setAttributeValue("DefaultRepriceDate", DateHelper.getBusinessDate().substring(0, 4)+"/"+defaultRepriceDate);
			if("RAT01".equals(rate.getString("TermID")))
			{
				rate.setAttributeValue("BASERATE", RateHelper.getBaseRate(bp.getString("BusinessCurrency"), 360, rate.getString("BaseRateType"), "01", DateHelper.TERM_UNIT_MONTH, term, DateHelper.getBusinessDate()));
				rate.setAttributeValue("BUSINESSRATE", rate.getDouble("BaseRate")*(1+rate.getDouble("RateFloat")/100.0));
			}
			
			BusinessObject n = BusinessObject.createBusinessObject(rate.getBizClassName());
			n.setAttributes(rate);
			n.generateKey(true);
			n.setAttributeValue("ObjectType", ap.getBizClassName());
			n.setAttributeValue("ObjectNo", ap.getKeyString());
			n.setAttributeValue("Status", "1");
			
			
			bomanager.updateBusinessObject(n);
			ap.appendBusinessObject(n.getBizClassName(), n);
		}
		
		//罚息利率
		List<BusinessObject> fineList = bomanager.loadBusinessObjects("jbo.acct.ACCT_RATE_SEGMENT", "ObjectType=:ObjectType and ObjectNo=:ObjectNo and RateType=:RateType", "ObjectType",bp.getBizClassName(),"ObjectNo",bp.getKeyString(),"RateType","02");
		for(BusinessObject fine:fineList)
		{
			BusinessObject n = BusinessObject.createBusinessObject(fine.getBizClassName());
			n.setAttributes(fine);
			n.generateKey(true);
			n.setAttributeValue("ObjectType", ap.getBizClassName());
			n.setAttributeValue("ObjectNo", ap.getKeyString());
			n.setAttributeValue("Status", "1");
			n.setAttributeValue("RateUnit", rateList.get(0).getString("RateUnit"));
			n.setAttributeValue("BaseRateGrade", rateList.get(0).getString("BaseRateGrade"));
			n.setAttributeValue("BaseRateType", rateList.get(0).getString("BaseRateType"));
			n.setAttributeValue("BaseRate", rateList.get(0).getString("BusinessRate"));
			n.setAttributeValue("RateFloatType", "0");
			
			if("FIN01".equals(fine.getString("TermID")))
			{
				n.setAttributeValue("BusinessRate", n.getDouble("BaseRate")*(1+n.getDouble("RateFloat")/100.0));
			}
			else
			{
				n.setAttributeValue("RateFloat", (n.getDouble("BusinessRate")/n.getDouble("BaseRate")-1)*100.0);
			}
				
			n.setAttributeValue("RepriceType", rateList.get(0).getString("RepriceType"));
			n.setAttributeValue("RepriceTermUnit", rateList.get(0).getString("RepriceTermUnit"));
			n.setAttributeValue("RepriceTerm", rateList.get(0).getString("RepriceTerm"));
			n.setAttributeValue("DefaultRepriceDate", rateList.get(0).getString("DefaultRepriceDate"));
			
			bomanager.updateBusinessObject(n);
			ap.appendBusinessObject(n.getBizClassName(), n);
		}
		
		//其他费用
		
		List<BusinessObject> feeList = bomanager.loadBusinessObjects("jbo.acct.ACCT_RATE_SEGMENT", "ObjectType=:ObjectType and ObjectNo=:ObjectNo and RateType not in('01','02') ", "ObjectType",bp.getBizClassName(),"ObjectNo",bp.getKeyString());
		for(BusinessObject fee:feeList)
		{
			BusinessObject n = BusinessObject.createBusinessObject(fee.getBizClassName());
			n.setAttributes(fee);
			n.generateKey(true);
			n.setAttributeValue("ObjectType", ap.getBizClassName());
			n.setAttributeValue("ObjectNo", ap.getKeyString());
			n.setAttributeValue("Status", "1");
			
			bomanager.updateBusinessObject(n);
			ap.appendBusinessObject(n.getBizClassName(), n);
		}
		
		
		
		List<BusinessObject> apAccountList = bomanager.loadBusinessObjects("jbo.acct.ACCT_BUSINESS_ACCOUNT", "ObjectType=:ObjectType and ObjectNo=:ObjectNo", "ObjectType",ap.getBizClassName(),"ObjectNo",ap.getKeyString());
		bomanager.deleteBusinessObjects(apAccountList);
		
		
		List<BusinessObject> accountList = bomanager.loadBusinessObjects("jbo.acct.ACCT_BUSINESS_ACCOUNT", "ObjectType=:ObjectType and ObjectNo=:ObjectNo", "ObjectType",bp.getBizClassName(),"ObjectNo",bp.getKeyString());
		for(BusinessObject account:accountList)
		{
			if(StringX.isEmpty(account.getString("AccountNo"))) continue;
			BusinessObject n = BusinessObject.createBusinessObject(account.getBizClassName());
			n.setAttributes(account);
			n.generateKey(true);
			n.setAttributeValue("ObjectType", ap.getBizClassName());
			n.setAttributeValue("ObjectNo", ap.getKeyString());
			n.setAttributeValue("Status", "1");
			bomanager.updateBusinessObject(n);
			ap.appendBusinessObject(n.getBizClassName(), n);
		}
		
		
		bp.setAttributeValue("PutOutStatus", "05");
		bomanager.updateBusinessObject(bp);
		bomanager.updateBusinessObject(ap);
		
		BusinessObject transaction = TransactionHelper.createTransaction("1001", ap, null, 
				userID, orgID, DateHelper.getBusinessDate(),bomanager);
		TransactionHelper.executeTransaction(transaction, bomanager);
		
		bomanager.updateDB();
		return "true@放款成功。";
	}
}
