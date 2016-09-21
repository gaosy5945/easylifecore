package com.amarsoft.app.lending.bizlets;

import com.amarsoft.app.base.util.DateHelper;
public class GetUpMonths {
	private String putOutDate=null;
	private String maturityDate=null;
	public Object run() throws Exception{
		
		String putoutDate = this.putOutDate;
		String maturityDate = this.maturityDate;

		if(putoutDate == null)
		{
			putoutDate = "";
		}
		if(maturityDate == null)
		{
			maturityDate = "";
		}

		return String.valueOf(Math.floor(DateHelper.getMonths(putoutDate, maturityDate)));
	}
	public String getPutOutDate() {
		return putOutDate;
	}
	public void setPutOutDate(String putOutDate) {
		this.putOutDate = putOutDate;
	}
	public String getMaturityDate() {
		return maturityDate;
	}
	public void setMaturityDate(String maturityDate) {
		this.maturityDate = maturityDate;
	}	
}
