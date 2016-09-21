package com.amarsoft.app.als.prd.demo;

import com.amarsoft.app.base.businessobject.BusinessObject;
import com.amarsoft.are.jbo.JBOTransaction;

public interface IBusinessDataLoader {
	public BusinessObject load(JBOTransaction tx, String sceneType,String sceneNo,String objectType,String objectNo) throws Exception;
}
