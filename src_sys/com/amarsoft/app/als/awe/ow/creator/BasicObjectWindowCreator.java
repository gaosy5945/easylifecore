package com.amarsoft.app.als.awe.ow.creator;

import javax.servlet.http.HttpServletRequest;

import com.amarsoft.app.base.businessobject.BusinessObject;
import com.amarsoft.app.base.util.ObjectWindowHelper;
import com.amarsoft.are.lang.StringX;
import com.amarsoft.awe.control.model.Page;
import com.amarsoft.awe.dw.ASObjectWindow;

public class BasicObjectWindowCreator implements ObjectWindowCreator{
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
		ASObjectWindow dwTemp = ObjectWindowHelper.createObjectWindow(templetNo, dwName,dwStyle,rightType,inputParameter, page, request);
		ObjectWindowHelper.setObjectWindowParameters(dwTemp, inputParameter);
		return dwTemp;
	}
}
