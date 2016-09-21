package com.amarsoft.app.als.credit.common.action;

import com.amarsoft.app.base.util.DateHelper;
import com.amarsoft.app.base.util.RateHelper;
import com.amarsoft.are.jbo.JBOTransaction;
import com.amarsoft.dict.als.cache.CodeCache;

public class RateAction {
	private String productID;
	private String businessType;
	private String RateTermID;
	private String baseRateType;
	private String currency;
	private String termUnit;
	private String termMonth;
	private String termDay;
	private String rateUnit;
	

	public String getProductID() {
		return productID;
	}

	public void setProductID(String productID) {
		this.productID = productID;
	}

	public String getBusinessType() {
		return businessType;
	}

	public void setBusinessType(String businessType) {
		this.businessType = businessType;
	}

	public String getRateTermID() {
		return RateTermID;
	}

	public void setRateTermID(String rateTermID) {
		RateTermID = rateTermID;
	}

	public String getBaseRateType() {
		return baseRateType;
	}

	public void setBaseRateType(String baseRateType) {
		this.baseRateType = baseRateType;
	}

	public String getCurrency() {
		return currency;
	}

	public void setCurrency(String currency) {
		this.currency = currency;
	}

	public String getTermUnit() {
		return termUnit;
	}

	public void setTermUnit(String termUnit) {
		this.termUnit = termUnit;
	}

	public String getTermMonth() {
		return termMonth;
	}

	public void setTermMonth(String termMonth) {
		this.termMonth = termMonth;
	}

	public String getTermDay() {
		return termDay;
	}

	public void setTermDay(String termDay) {
		this.termDay = termDay;
	}

	public String getRateUnit() {
		return rateUnit;
	}

	public void setRateUnit(String rateUnit) {
		this.rateUnit = rateUnit;
	}
	
	public String getBaseRate(JBOTransaction tx) throws Exception{
		int term = 0;
		if(termMonth == null || "".equals(termMonth)) termMonth = "0";
		if(termDay == null || "".equals(termDay)) termDay = "0";
		term = Integer.parseInt(termMonth)+(Integer.parseInt(termDay)%30 == 0 ? Integer.parseInt(termDay)/30 : Integer.parseInt(termDay)/30+1);
		
		com.amarsoft.dict.als.object.Item item = CodeCache.getItem("Currency", currency);
		int yearDays = 360;
		if(item.getAttribute3() != null && !"".equals(item.getAttribute3())) yearDays = Integer.parseInt(item.getAttribute3());
		
		return String.valueOf(RateHelper.getBaseRate(currency, yearDays, baseRateType, rateUnit, termUnit, term, DateHelper.getBusinessDate()));
	}
	
	public String getBaseRateGrade(JBOTransaction tx) throws Exception{
		int term = 0;
		if(termMonth == null || "".equals(termMonth)) termMonth = "0";
		if(termDay == null || "".equals(termDay)) termDay = "0";
		term = Integer.parseInt(termMonth)+(Integer.parseInt(termDay)%30 == 0 ? Integer.parseInt(termDay)/30 : Integer.parseInt(termDay)/30+1);
		return RateHelper.getBaseRateGrade(currency, baseRateType, termUnit, term, DateHelper.getBusinessDate());
	}
}