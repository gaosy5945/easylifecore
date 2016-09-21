package com.amarsoft.app.als.businesscomponent.analysis.checker;

import java.util.List;

import com.amarsoft.app.base.businessobject.BusinessObject;
import com.amarsoft.app.base.businessobject.BusinessObjectManager;

/**
 * 组件校验器
 * @author amarsoft
 *
 */
public interface ComponentAnalysisor{
	public boolean check(List<BusinessObject> componentData,BusinessObject component,String outputParameterID,BusinessObjectManager bomanager) throws Exception;
	
	public List<String> getValidRuleList() throws Exception;
	
	public List<String> getInvalidRuleList() throws Exception;
	
	public List<String> getErrorMessage() throws Exception;
}
