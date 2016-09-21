package com.amarsoft.app.als.businesscomponent.analysis.dataloader.impl;

import java.sql.ResultSet;
import java.sql.Statement;
import java.util.ArrayList;
import java.util.List;

import com.amarsoft.app.als.businesscomponent.analysis.dataloader.ParameterDataLoader;
import com.amarsoft.app.base.businessobject.BusinessObject;
import com.amarsoft.app.base.businessobject.BusinessObjectManager;
import com.amarsoft.app.base.config.impl.BusinessComponentConfig;
import com.amarsoft.app.base.util.StringHelper;
import com.amarsoft.are.ARE;
import com.amarsoft.are.sql.Connection;

public class SQLDataFetcher extends ParameterDataLoader{

	@Override
	public List<Object> getParameterData(BusinessObject parameter,BusinessObject businessObject, BusinessObjectManager bomanager)throws Exception {
		List<Object> valueList = new ArrayList<Object>();
		
		String parameterID = parameter.getString("ParameterID");
		String method = parameter.getString("MethodScript");
		if(method==null||method.length()==0){
			method = BusinessComponentConfig.getParameterDefinition(parameterID).getString("MethodScript");
		}
		if(method==null||method.length()==0) throw new Exception("参数{"+parameterID+"}的取值逻辑定义不正确！");
		method = StringHelper.replaceStringFullName(method, businessObject);
		Connection connection = ARE.getDBConnection("als");
		Statement stmt =null;
		try{
			stmt = connection.createStatement();
			stmt.execute(method);
			ResultSet rs=stmt.getResultSet();
			while(rs.next()){
				valueList.add(rs.getObject(1));
			}
			rs.close();
			stmt.close();
			connection.close();
			return valueList;
		}
		catch(Exception e){
			connection.close();
			throw e;
		}
	}
	
}
