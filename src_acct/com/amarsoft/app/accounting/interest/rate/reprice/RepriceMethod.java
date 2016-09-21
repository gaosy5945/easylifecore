package com.amarsoft.app.accounting.interest.rate.reprice;


import com.amarsoft.app.accounting.config.impl.CashFlowConfig;
import com.amarsoft.app.base.businessobject.BusinessObject;
import com.amarsoft.app.base.exception.ALSException;
import com.amarsoft.are.lang.StringX;

public abstract class RepriceMethod {
	public static RepriceMethod getRepriceMethod(String repriceType) throws Exception {
		
		BusinessObject repriceTypeConfig = CashFlowConfig.getRepriceTypeConfig(repriceType);
		if(repriceTypeConfig == null)  throw new ALSException("EC3011",repriceType);
		
		String className = repriceTypeConfig.getString("script");
		
		if(StringX.isEmpty(className))//暂时这样写，后续放到配置文件中
			throw new ALSException("EC3012",repriceType);
		Class<?> c = Class.forName(className);
		RepriceMethod p=(RepriceMethod) c.newInstance();
		return p;
		
	}
	
	public abstract String getNextRepriceDate(BusinessObject loan,BusinessObject rateSegment) throws Exception;
}
