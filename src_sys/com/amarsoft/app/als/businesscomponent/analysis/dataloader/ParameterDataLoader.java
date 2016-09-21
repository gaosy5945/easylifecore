package com.amarsoft.app.als.businesscomponent.analysis.dataloader;

import java.util.List;

import com.amarsoft.app.als.businesscomponent.analysis.dataloader.impl.AmarScriptDataFetcher;
import com.amarsoft.app.als.businesscomponent.analysis.dataloader.impl.JBODataFetcher;
import com.amarsoft.app.als.businesscomponent.analysis.dataloader.impl.JavaMethodFetcher;
import com.amarsoft.app.als.businesscomponent.analysis.dataloader.impl.SQLDataFetcher;
import com.amarsoft.app.base.businessobject.BusinessObject;
import com.amarsoft.app.base.businessobject.BusinessObjectManager;
import com.amarsoft.app.base.config.impl.BusinessComponentConfig;
import com.amarsoft.are.lang.StringX;
import com.amarsoft.dict.als.manage.CodeManager;

/**
 * 组件导入器
 * @author amarsoft
 *
 */
public abstract class ParameterDataLoader{
	
	public abstract List<Object> getParameterData(BusinessObject parameter,BusinessObject businessObject,BusinessObjectManager bomanager) throws Exception;
	
	public static ParameterDataLoader getParameterDataLoader(BusinessObject parameter) throws Exception{
		String parameterID = parameter.getString("ParameterID");
		String methodType = parameter.getString("MethodType");
		if(StringX.isEmpty(methodType)){
			methodType = BusinessComponentConfig.getParameterDefinition(parameterID).getString("MethodType");
		}
		if(BusinessComponentConfig.PARAMETER_METHOD_TYPE_JBO.equals(methodType)){
			return new JBODataFetcher();
		}
		else if(BusinessComponentConfig.PARAMETER_METHOD_TYPE_SQL.equals(methodType)){
			return new SQLDataFetcher();
		}
		else if(BusinessComponentConfig.PARAMETER_METHOD_TYPE_AMARSCIPT.equals(methodType)){
			return new AmarScriptDataFetcher();
		}
		else if(BusinessComponentConfig.PARAMETER_METHOD_TYPE_JAVA.equals(methodType)){
			return new JavaMethodFetcher();
		}
		else{
			String className=CodeManager.getItem("ComponentParameterMethodType", methodType).getItemAttribute();
			if(StringX.isEmpty(className)){
				return null;
			}
			else{
				Class<?> c = Class.forName(className);
				return (ParameterDataLoader)c.newInstance();
			}
		}
	}
}
