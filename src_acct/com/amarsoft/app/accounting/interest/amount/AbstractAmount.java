package com.amarsoft.app.accounting.interest.amount;

import com.amarsoft.app.accounting.interest.accrue.InterestAccruer;
import com.amarsoft.app.base.businessobject.BusinessObject;

public abstract class AbstractAmount {
	protected InterestAccruer interestAccruer = null;
	protected BusinessObject businessObject = null;
	protected BusinessObject interestObject = null;
	
	public InterestAccruer getInterestAccruer() {
		return interestAccruer;
	}

	public void setInterestAccruer(InterestAccruer interestAccruer) {
		this.interestAccruer = interestAccruer;
	}

	public BusinessObject getInterestObject() {
		return interestObject;
	}

	public void setInterestObject(BusinessObject interestObject) {
		this.interestObject = interestObject;
	}
	
	public BusinessObject getBusinessObject() {
		return businessObject;
	}

	public void setBusinessObject(BusinessObject businessObject) {
		this.businessObject = businessObject;
	}

	public abstract double getAmount() throws Exception;
	
}
