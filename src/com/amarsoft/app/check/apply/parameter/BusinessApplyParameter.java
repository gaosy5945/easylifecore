package com.amarsoft.app.check.apply.parameter;

import java.text.ParseException;
import java.util.List;

import com.amarsoft.app.base.businessobject.BusinessObject;
import com.amarsoft.app.base.businessobject.BusinessObjectManager;
import com.amarsoft.app.base.util.DateHelper;
import com.amarsoft.are.lang.StringX;
import com.amarsoft.are.util.Arith;

public class BusinessApplyParameter {
	public double getTermAge(String birthDay,Integer termMonth) throws ParseException, Exception{
		double age=0.0;
		if(!StringX.isEmpty(birthDay)){
			age = DateHelper.getMonths(birthDay, DateHelper.getBusinessDate())/12.0;
		}
		
		return Arith.round(age+termMonth/12.0,1);
	}
	
	public double getCustomerAge(String birthDay) throws ParseException, Exception{
		double age=0.0;
		if(!StringX.isEmpty(birthDay)){
			age = DateHelper.getMonths(birthDay, DateHelper.getBusinessDate())/12.0;
		}
		
		return Arith.round(age,1);
	}
	
	public double getLTV(String assetSerialNo) throws ParseException, Exception{
		if(StringX.isEmpty(assetSerialNo))return 0;
		BusinessObjectManager bomanager = BusinessObjectManager.createBusinessObjectManager();
		BusinessObject asset=bomanager.keyLoadBusinessObject("jbo.app.ASSET_INFO", assetSerialNo);
		List<BusinessObject> grlist = bomanager.loadBusinessObjects("jbo.guaranty.GUARANTY_RELATIVE", "ASSETSERIALNO=:ASSETSERIALNO", "ASSETSERIALNO",assetSerialNo);

		double percent=0d;
		double amount=0d;
		double confirmValue=asset.getDouble("ConfirmValue");
		for(BusinessObject gr:grlist){
			double grpercent=gr.getDouble("GUARANTYPERCENT");
			double gramount=gr.getDouble("GUARANTYAMOUNT");
			if(gramount>0){
				amount+=gramount;
			}
			else{
				if(grpercent>0){
					percent+=grpercent;
				}
			}
		}
		double ltv=Arith.round(percent+(amount/confirmValue)*100,2);
		return ltv;
	}
}
