package com.amarsoft.app.als.awe.ow.creator;


import javax.servlet.http.HttpServletRequest;

import com.amarsoft.app.base.businessobject.BusinessObject;
import com.amarsoft.app.base.util.ObjectWindowHelper;
import com.amarsoft.are.lang.StringX;
import com.amarsoft.awe.control.model.Component;
import com.amarsoft.awe.control.model.Page;
import com.amarsoft.awe.control.model.Parameter;
import com.amarsoft.awe.dw.ASObjectWindow;

public class XMLObjectWindowCreator implements ObjectWindowCreator{
	@Override
	public ASObjectWindow createObjectWindow(BusinessObject inputParameter,Page page,HttpServletRequest request) throws Exception {
		String templetNo = inputParameter.getString("TempletNo");
		if(templetNo==null) templetNo="";
		
		String dwStyle = inputParameter.getString("DWStyle");
		String dwName = inputParameter.getString("DWName");
		String owRightType=inputParameter.getString("OWRightType");
		if(StringX.isEmpty(owRightType)) owRightType= inputParameter.getString("RightType");
		if(StringX.isEmpty(owRightType)) owRightType=page.getAttribute("RightType");
		if(StringX.isEmpty(owRightType)) owRightType="0";

		String rightType="All";
		if("ReadOnly".equalsIgnoreCase(owRightType)||"1".equals(owRightType)){
			rightType = "ReadOnly";
		}
		if(StringX.isEmpty(dwName)){
			String dwcount = page.getAttribute("SYS_DWCOUNT");
			if(StringX.isEmpty(dwcount))dwcount="0";
			else dwcount=String.valueOf(Integer.valueOf(dwcount)+1);
			dwName=dwcount;
		}
		
		Component c = new Component(page.getCurComp().getCompURL(),page.getCurComp().getTargetWindow());
		c.setClientID(page.getCurComp().getClientID());
		c.setParentComponent(page.getCurComp().getParentComponent());
		for(Parameter para : page.getCurComp().getParameterList()){
			c.setAttribute(para.getName(), para.getValue());
		}
		Page p = new Page(c);
		for(Parameter para : page.getParameterList()){
			p.setAttribute(para.getName(), para.getValue());
		}
		
		if(!StringX.isEmpty(inputParameter.getString("XMLFile")))
			p.setAttribute("XMLFile", inputParameter.getString("XMLFile"));
		if(!StringX.isEmpty(inputParameter.getString("XMLTags")))
			p.setAttribute("XMLTags", inputParameter.getString("XMLTags"));
		if(!StringX.isEmpty(inputParameter.getString("Keys")))
			p.setAttribute("Keys", inputParameter.getString("Keys"));
		ASObjectWindow dwTemp = ObjectWindowHelper.createObjectWindow(templetNo, dwName,dwStyle,rightType,inputParameter, p, request);
		ObjectWindowHelper.setObjectWindowParameters(dwTemp, inputParameter);
		dwTemp.getDataObject().setBusinessProcess("com.amarsoft.app.als.businessobject.web.XMLBusinessObjectProcessor");
		return dwTemp;
	}
}
