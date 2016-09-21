package com.amarsoft.app.als.awe.ow.creator;

import javax.servlet.http.HttpServletRequest;

import com.amarsoft.app.base.businessobject.BusinessObject;
import com.amarsoft.awe.control.model.Page;
import com.amarsoft.awe.dw.ASObjectWindow;

public interface ObjectWindowCreator {
	public ASObjectWindow createObjectWindow(BusinessObject inputParameters,Page page,HttpServletRequest request)  throws Exception ;
}
