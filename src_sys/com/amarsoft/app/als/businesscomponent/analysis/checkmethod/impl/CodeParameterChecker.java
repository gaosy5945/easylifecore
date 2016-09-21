package com.amarsoft.app.als.businesscomponent.analysis.checkmethod.impl;

import com.amarsoft.app.base.businessobject.BusinessObject;
import com.amarsoft.app.base.config.impl.BusinessComponentConfig;
import com.amarsoft.are.lang.StringX;
import com.amarsoft.dict.als.manage.CodeManager;
import com.amarsoft.dict.als.object.Item;

public class CodeParameterChecker extends StepParamterChecker {

	@Override
	public Object getUpLevelValue(Object value, BusinessObject parameter)
			throws Exception {
		String itemNo = (String)value;
		String codeNo = BusinessComponentConfig.getParameterDefinition(parameter.getString("ParameterID")).getString("CodeScript");
		Item[] items = CodeManager.getItems(codeNo);
		String currentSortNo=CodeManager.getItem(codeNo, itemNo).getSortNo();
		if(StringX.isEmpty(currentSortNo)) return "";
		int sortNoLength=0;
		String upItemNo="";
		for(Item item:items){
			if(itemNo.equals(item.getItemNo())) continue;
			String sortNo=item.getSortNo();
			if(!StringX.isEmpty(sortNo)){
				if(currentSortNo.startsWith(sortNo)){
					if(sortNoLength<sortNo.length()){
						upItemNo=item.getItemNo();
						sortNoLength=sortNo.length();
					}
				}
			}
		}
		return upItemNo;
	}
	
	
}
