package com.amarsoft.app.als.awe.ow2.manager;

import javax.servlet.http.HttpServletRequest;

import com.amarsoft.app.base.businessobject.BusinessObject;
import com.amarsoft.awe.control.model.Page;
import com.amarsoft.awe.dw.ASObjectWindow;

public interface ObjectWindowManager {
	public ASObjectWindow genObjectWindow(String rightType,BusinessObject inputParameters,Page page,HttpServletRequest request) throws Exception;
	
	public BusinessObject getObjectWindowConfig() throws Exception;
}
