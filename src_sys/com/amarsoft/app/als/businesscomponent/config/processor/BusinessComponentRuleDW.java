package com.amarsoft.app.als.businesscomponent.config.processor;

import java.lang.reflect.Method;
import java.util.List;

import javax.servlet.http.HttpServletRequest;

import com.amarsoft.app.als.awe.ow.creator.ObjectWindowCreator;
import com.amarsoft.app.base.businessobject.BusinessObject;
import com.amarsoft.app.base.businessobject.BusinessObjectManager;
import com.amarsoft.app.base.config.impl.BusinessComponentConfig;
import com.amarsoft.app.base.util.ObjectWindowHelper;
import com.amarsoft.app.base.util.StringHelper;
import com.amarsoft.app.base.util.XMLHelper;
import com.amarsoft.are.lang.StringX;
import com.amarsoft.awe.control.model.Component;
import com.amarsoft.awe.control.model.Page;
import com.amarsoft.awe.control.model.Parameter;
import com.amarsoft.awe.dw.ASDataObject;
import com.amarsoft.awe.dw.ASObjectModel;
import com.amarsoft.awe.dw.ASObjectWindow;

public class BusinessComponentRuleDW implements ObjectWindowCreator{
	private BusinessObject inputParameters;
	private Page page;
	private HttpServletRequest request;
	private String componentRightType=null;

	/**
	 * 生成ow的各个字段
	 * @param doTemp
	 * @param parameter
	 * @throws Exception
	 */
	private void createObjectWindowAttributes(ASObjectModel doTemp,BusinessObject parameter) throws Exception{
		String parameterID = parameter.getString("PARAMETERID");
		BusinessObject parameterDefination = BusinessComponentConfig.getParameterDefinition(parameterID);
		
		String valueFields = parameter.getString("OPERATOR");
		if(valueFields==null||valueFields.length()==0){
			valueFields=parameterDefination.getString("OPERATOR");
		}
		if(StringX.isEmpty(valueFields))return;
		
		String dataType = parameter.getString("DATATYPE");//选择框、文本框等等
		if(dataType==null||dataType.length()==0){
			dataType=parameterDefination.getString("DATATYPE");
		}
		if(dataType==null)dataType="";
		
		String header = parameter.getString("DISPLAYNAME");
		if(header==null||header.length()==0){
			header = parameter.getString("PARAMETERNAME");
		}
		if(header==null)header="";
		
		String htmlStyle = parameter.getString("HTMLSTYLE");
		if(htmlStyle==null||htmlStyle.length()==0){
			htmlStyle=parameterDefination.getString("HTMLSTYLE");
		}
		if(htmlStyle==null) htmlStyle="";
		
		String[] valueFieldArray = valueFields.split(",");
		for(String valueField:valueFieldArray){
			String colName = (valueField+"_"+parameterID).toUpperCase();
			int colIndex = doTemp.addColumn(colName);
			doTemp.setColumnAttribute(colIndex, "SORTNO", (colIndex+1000) + "");
			doTemp.setColumnAttribute(colName, "ColActualName", "v.''");
			
			doTemp.setHeader(colName, header);
			doTemp.setVisible(colName, true);
			doTemp.setHTMLStyle(colName, htmlStyle);
			
			if(dataType.equals("2")||dataType.equals("5")||dataType.equals("6")){//数字类
				doTemp.setAlign(colName, "3");
			}
			else{
				doTemp.setAlign(colName, "1");
			}
			
			if(dataType.equals("4")){//选项类
				this.setDWAttributeCode(doTemp, parameter, valueField);
			}
		}
		initParameterRight(doTemp,parameter);
	}
	
	private void initParameterRight(ASObjectModel doTemp,BusinessObject parameter) throws Exception{
		String parameterID=parameter.getString("ParameterID").toUpperCase();
		String colNames="VALUE_"+parameterID;
		colNames+=",MINIMUMVALUE_"+parameterID;colNames+=",MAXIMUMVALUE_"+parameterID;colNames+=",OPTIONALVALUE_"+parameterID;
		colNames+=",MANDATORYVALUE_"+parameterID;colNames+=",EXCLUDEDVALUE_"+parameterID;colNames+=",OPTIONALVALUENAME_"+parameterID;
		colNames+=",MANDATORYVALUENAME_"+parameterID;colNames+=",EXCLUDEDVALUENAME_"+parameterID;colNames+=",VALUENAME_"+parameterID;
		
		String parameterRight = "All";
		if(!StringX.isEmpty(componentRightType))parameter.getString(this.componentRightType);
		if(StringX.isEmpty(parameterRight)) parameterRight=BusinessComponentConfig.PARAMETER_RIGHT_TYPE_NONE;
		if(parameterRight.equals(BusinessComponentConfig.PARAMETER_RIGHT_TYPE_HIDE)||
				parameterRight.equals(BusinessComponentConfig.PARAMETER_RIGHT_TYPE_NONE)){
			doTemp.setVisible(colNames, false);
		}
		else if(parameterRight.equals(BusinessComponentConfig.PARAMETER_RIGHT_TYPE_READONLY)){
			doTemp.setReadOnly(colNames, true);
		}
		else if(parameterRight.equals(BusinessComponentConfig.PARAMETER_RIGHT_TYPE_REQUIRED)){
			BusinessObject parameterDefination = BusinessComponentConfig.getParameterDefinition(parameterID);
			
			String valueFields = parameter.getString("OPERATOR");
			if(valueFields==null||valueFields.length()==0){
				valueFields=parameterDefination.getString("OPERATOR");
			}
			if(StringX.isEmpty(valueFields))return;
			String[] valueFieldArray = valueFields.split(",");
			for(String valueField:valueFieldArray){
				String colName = (valueField+"_"+parameterID).toUpperCase();
				doTemp.setRequired(colName, true);
			}
		}
	}
	
 	private void setDWAttributeCode(ASObjectModel doTemp,BusinessObject parameter,String valueField) throws Exception{
		String parameterID = parameter.getString("ParameterID");
		BusinessObject parameterDefination = BusinessComponentConfig.getParameterDefinition(parameterID);
		String colName=(valueField+"_"+parameterID).toUpperCase();
		String selectType = parameter.getString("SELECTTYPE");//设置选择方式
		if(selectType==null||selectType.length()==0){
			selectType=parameterDefination.getString("SELECTTYPE");
		}
		if(StringX.isEmpty(selectType)) return;
		
		String codeType = parameter.getString("CODESOURCE");//设置选项来源
		if(codeType==null||codeType.length()==0){
			codeType=parameterDefination.getString("CODESOURCE");
		}
		if(codeType==null) codeType="";
		
		String code = parameter.getString("CODESCRIPT");
		if(code==null||code.length()==0){
			code=parameterDefination.getString("CODESCRIPT");
		}
		if(code==null) code="";
		if("JBO".equals(codeType)){//jbo查询
			doTemp.setDDDWJbo(colName, code);
		}
		else if("SQL".equals(codeType)){//sql查询
			String codeTable="";//待完成
			List<BusinessObject> list = BusinessObjectManager.createBusinessObjectManager().loadBusinessObjects_SQL(code, BusinessObject.createBusinessObject());
			for(BusinessObject l:list)
			{
				codeTable += l.getString("ID") + ",";
				codeTable += l.getString("Name") + ",";
			}
			if(!StringX.isEmpty(codeTable)) codeTable = codeTable.substring(0, codeTable.length()-1);
			doTemp.setDDDWCodeTable(colName, codeTable);
		}
		else if("Code".equals(codeType)){//code_library
			doTemp.setDDDWCode(colName, code);
		}else if("Java".equals(codeType)){//java
			String script = code;
			String args = script.substring(script.indexOf("(")+1);
			args = args.substring(0, args.lastIndexOf(")"));
			args = args.replaceAll("\"", "");
			args = args.replaceAll("'", "");
			String classMethodName = script.substring(0, script.indexOf("("));
			String className = classMethodName.substring(0, script.lastIndexOf("."));
			String methodName = classMethodName.substring(script.lastIndexOf(".")+1);
			
			Class<?>[] paras = new Class<?>[args.split(",").length];
			for(int i = 0; i < paras.length; i ++)
			{
				paras[i] = String.class;
			}
			Class<?> c = Class.forName(className);
			Method method = c.getMethod(methodName, paras);  
			
			String codeTable = (String)method.invoke(null, args.split(","));
			doTemp.setDDDWCodeTable(colName, codeTable);
		}
		else if("CodeTable".equals(codeType)){//code_table
			doTemp.setDDDWCodeTable(colName, code);
		}
		else if("XML".equals(codeType)){//code_table
			
			String[] codeArray = code.split(",");
			List<BusinessObject> list = XMLHelper.getBusinessObjectList(codeArray[0], codeArray[3], codeArray[1]);
			String codeTable="";
			for(BusinessObject l:list)
			{
				codeTable += l.getString(codeArray[1]) + ",";
				codeTable += l.getString(codeArray[2]) + ",";
			}
			if(!StringX.isEmpty(codeTable)) codeTable = codeTable.substring(0, codeTable.length()-1);
			
			doTemp.setDDDWCodeTable(colName, codeTable);
		}
		
		if(selectType.equals("06")){//横向多选择框
			doTemp.setVisible(colName, true);
			doTemp.setEditStyle(colName, "Checkbox");
			doTemp.setColumnAttribute(colName, "COLSPAN", "2");
		}else if(selectType.equals("05")){//横向选择框
			if(valueField.equals("VALUE")){//指定值单选
				doTemp.setVisible(colName, true);
				doTemp.setEditStyle(colName, "Radiobox");
				doTemp.setColumnAttribute(colName, "COLSPAN", "2");
			}
			else if(valueField.equals("MANDATORYVALUE")||valueField.equals("OPTIONALVALUE")
					||valueField.equals("EXCLUDEDVALUE")){//必选项、可选项和不可选项，多选
				doTemp.setVisible(colName, true);
				doTemp.setEditStyle(colName, "Checkbox");
				doTemp.setColumnAttribute(colName, "COLSPAN", "2");
			}
		}
		else if(selectType.equals("04")){//下拉选择框
			if(valueField.equals("VALUE")){//指定值单选，其他值无效
				doTemp.setVisible(colName, true);
				doTemp.setEditStyle(colName, "Select");
				doTemp.setColumnAttribute(colName, "COLSPAN", "2");
			}
		}
		else if(selectType.equals("01")||selectType.equals("02")||selectType.equals("03")){//弹出选择框
			doTemp.setVisible(colName, false);
			doTemp.setEditStyle(colName, "Text");
			this.setValueNameCol(doTemp, parameter, valueField);
		}
	}
	
	private void setValueNameCol(ASObjectModel doTemp,BusinessObject parameter,String valueField) throws Exception{
		String parameterID = parameter.getString("ParameterID");
		BusinessObject parameterDefination = BusinessComponentConfig.getParameterDefinition(parameterID);
		
		String colName = (valueField+"_"+parameterID).toUpperCase();
		String colName_ValueName=(valueField+"NAME_"+parameterID).toUpperCase();
		
		String header = parameter.getString("DISPLAYNAME");
		if(header==null||header.length()==0){
			header = parameter.getString("PARAMETERNAME");
		}
		if(header==null)header="";
		if(valueField.equalsIgnoreCase("MANDATORYVALUE"))
			header+="(必选项)";
		else if(valueField.equalsIgnoreCase("OPTIONALVALUE"))
			header+="(可选项)";
		else if(valueField.equalsIgnoreCase("EXCLUDEDVALUE"))
			header+="(不可选项)";
		
		String htmlStyle = parameter.getString("HTMLSTYLE");
		if(htmlStyle==null||htmlStyle.length()==0){
			htmlStyle=parameterDefination.getString("HTMLSTYLE");
		}
		if(htmlStyle==null) htmlStyle="";
		
		
		int colIndex = doTemp.addColumn(colName_ValueName);
		doTemp.setColumnAttribute(colIndex, "SORTNO", (colIndex+1000) + "");
		doTemp.setColumnAttribute(colName_ValueName, "ColActualName", "v.''");
		doTemp.setHeader(colName_ValueName, header);
		doTemp.setReadOnly(colName_ValueName, true);
		doTemp.setVisible(colName_ValueName, true);
		doTemp.setHTMLStyle(colName_ValueName, htmlStyle);
		doTemp.setAlign(colName_ValueName, "1");
		doTemp.setEditStyle(colName_ValueName, "Text");
		
		String dwname=ObjectWindowHelper.getObjectWindowName(doTemp);
		String multiFlag="true";
		if(valueField.equals("VALUE")){//指定值单选，其他值无效
			multiFlag="false";
		}
		
		String colEvent = this.getParameterSelectEvent(dwname,colName,colName_ValueName,multiFlag,parameter);
		doTemp.setColInnerBtEvent(colName_ValueName, colEvent);
	}
	
	
 	/**
 	 * 生成一个基本的ow
 	 * @param dwname
 	 * @param parameterList
 	 * @return
 	 * @throws Exception
 	 */
 	private ASObjectWindow createBasicObjectWindow(List<BusinessObject> parameterList) throws Exception {
 		//if(parameterList==null||parameterList.isEmpty()) return null;
		ASObjectModel doTemp = new ASObjectModel();
		doTemp.setDONO(java.util.UUID.randomUUID().toString());
		doTemp.setJBOClass("jbo.sys.SYSTEM_SETUP");
		doTemp.setBusinessProcess("com.amarsoft.app.als.businesscomponent.config.processor.BusinessComponentProcess");
		doTemp.getCustomProperties().setProperty("DWName",this.inputParameters.getString("DWName"));
		String colName = "ID";
		int colIndex = doTemp.addColumn(colName);
		doTemp.setHeader(colName, "序号");
		doTemp.setVisible(colName, false);
		doTemp.setAlign(colName, "1");
		doTemp.setReadOnly(colName, true);
		doTemp.setColumnAttribute(colIndex, "SORTNO", (colIndex+1001) + "");
		doTemp.setColumnAttribute(colName, "ColActualName", "v.''");
		
		colName = "OLDVALUEBACKUPID";
		colIndex = doTemp.addColumn(colName);
		doTemp.setHeader(colName, "序号");
		doTemp.setVisible(colName, false);
		doTemp.setAlign(colName, "1");
		doTemp.setReadOnly(colName, true);
		doTemp.setColumnAttribute(colIndex, "SORTNO", (colIndex+1002) + "");
		doTemp.setColumnAttribute(colName, "ColActualName", "v.''");

		if(parameterList!=null&&!parameterList.isEmpty()){
			for(BusinessObject parameter:parameterList){
				createObjectWindowAttributes(doTemp,parameter);
			}
		}
		doTemp.setColumnAttribute("*", "COLCHECKFORMAT", "1");
		doTemp.setColumnAttribute("*", "COLLIMIT", "0");
		doTemp.setColumnAttribute("*", "ISINUSE", "1");
		doTemp.setColumnAttribute("*", "COLTYPE", "String");
		doTemp.setColumnAttribute("*", "COLCOLUMNTYPE", "1");
		doTemp.setColCount(2);
		ASObjectWindow dwTemp = new ASObjectWindow(page,doTemp,request);
		ObjectWindowHelper.setObjectWindowName(doTemp, this.inputParameters.getString("DWName"));
		return dwTemp;
	}
 	
 	
 	private ASObjectWindow createInfoObjectWindow(List<BusinessObject> parameterList) throws Exception {
 		ASObjectWindow dwTemp = this.createBasicObjectWindow(parameterList);
 		dwTemp.Style="2";
 		ASDataObject doTemp = dwTemp.getDataObject();
 		
 		for(int i=0;i<doTemp.Columns.size();i++){
 			String colName = doTemp.getColumnAttribute(i, "COLNAME");
 			if(colName.startsWith("MAXIMUMVALUE_")){
 				String minValueColumnName="MINIMUMVALUE_"+colName.substring(9);
 				String v=doTemp.getColumnAttribute(minValueColumnName, "COLVISIBLE");
 				if("1".equals(v)){
	 				doTemp.setHeader(colName, "至");
	 				doTemp.setColumnAttribute(colName, "COLSPAN", "-1");
	 				doTemp.setColumnAttribute(colName, "COLUNIT", "含");
 				}
 				else{
 					doTemp.setHeader(colName, doTemp.getColumnAttribute(colName, "COLHEADER")+"-最大(含)");
 				}
 			}
 			
 			if(colName.startsWith("MINIMUMVALUE_")){
 				String maxValueColumnName="MAXIMUMVALUE_"+colName.substring(9);
 				String v=doTemp.getColumnAttribute(maxValueColumnName, "COLVISIBLE");
 				if(!"1".equals(v)){
 					doTemp.setHeader(colName, doTemp.getColumnAttribute(colName, "COLHEADER")+"-最小");
 				}
 			}
 		}
 		doTemp.setDataQueryClass("com.amarsoft.app.als.awe.ow.processor.impl.html.ALSInfoHtmlGenerator");
 		return dwTemp;
 	}
 	
 	private ASObjectWindow createListObjectWindow(BusinessObject inputParameter,List<BusinessObject> parameterList,boolean buttonFlag) throws Exception {
 		ASObjectWindow dwTemp = this.createBasicObjectWindow(parameterList);
 		dwTemp.Style="1";
 		ASDataObject doTemp = dwTemp.getDataObject();
 		if(buttonFlag) addListOWActionColumn(inputParameter,doTemp);
 		for(int i=0;i<doTemp.Columns.size();i++){
 			String colName = doTemp.getColumnAttribute(i, "COLNAME");
 			if(colName.startsWith("MAXIMUMVALUE_"))
 				doTemp.setHeader(colName, doTemp.getColumnAttribute(i, "COLHEADER")+"-最大(含)");
 			if(colName.startsWith("MINIMUMVALUE_"))
 				doTemp.setHeader(colName, doTemp.getColumnAttribute(i, "COLHEADER")+"-最小");
 			if(colName.startsWith("MANDATORYVALUENAME_")||colName.startsWith("OPTIONALVALUENAME_")
					||colName.startsWith("EXCLUDEDVALUENAME_")||colName.startsWith("VALUENAME_")){
 				doTemp.setReadOnly(colName, false);
 			}
 		}
 		doTemp.setVisible("ID", false);
 		doTemp.setReadOnly("ID", true);
 		doTemp.setDataQueryClass("com.amarsoft.app.als.awe.ow.processor.impl.html.ALSListHtmlGenerator");
 		doTemp.setLockCount(0);
 		return dwTemp;
 	}
 	
 	
 	private void addListOWActionColumn(BusinessObject inputParameter,ASDataObject dataObject) throws Exception{
 		String addFunction=inputParameter.getString("AddFunction");
 		String editFunction=inputParameter.getString("EditFunction");
 		String deleteFunction=inputParameter.getString("DeleteFunction");
 		String dwname = ObjectWindowHelper.getObjectWindowName(dataObject);
 		
 		addFunction=StringHelper.replaceAllIgnoreCase(addFunction, "{#dwname}", dwname);
 		editFunction=StringHelper.replaceAllIgnoreCase(editFunction, "{#dwname}", dwname);
 		deleteFunction=StringHelper.replaceAllIgnoreCase(deleteFunction, "{#dwname}", dwname);
 		
		int iIndex = dataObject.addColumn("TMP_ACTION");
		dataObject.setColumnAttribute(iIndex, "COLINDEX", iIndex + "");
		dataObject.setColumnAttribute(iIndex, "SORTNO", iIndex + "");
		dataObject.setColumnAttribute(iIndex, "ISINUSE", "1");
		dataObject.setColumnAttribute(iIndex, "COLTYPE", "String");
		if(!StringX.isEmpty(addFunction)){
			String colheader="<a href=# onclick="+addFunction+">新增</a>";
			dataObject.setColumnAttribute(iIndex, "COLHEADER", colheader);
		}
		else{
			dataObject.setColumnAttribute(iIndex, "COLHEADER", "");
		}
		dataObject.setColumnAttribute(iIndex, "COLCOLUMNTYPE", "1");
		dataObject.setColumnAttribute(iIndex, "COLCHECKFORMAT", "1");
		dataObject.setColumnAttribute(iIndex, "COLALIGN", "2");
		dataObject.setColumnAttribute(iIndex, "COLHTMLSTYLE", "style={width:50px}");
		
		dataObject.setColumnAttribute(iIndex, "COLEDITSTYLE", "Text");
		dataObject.setColumnAttribute(iIndex, "COLLIMIT", "0");
		dataObject.setColumnAttribute(iIndex, "COLVISIBLE", "1");
		dataObject.setColumnAttribute(iIndex, "COLREADONLY", "1"); //为空时非只读
		dataObject.setColumnAttribute(iIndex, "COLREQUIRED", "0");
		dataObject.setColumnAttribute(iIndex, "COLSORTABLE", "0");
		dataObject.setColumnAttribute(iIndex, "ISFILTER", "0");
		dataObject.setColumnAttribute(iIndex, "ISAUTOCOMPLETE", "0");
		dataObject.setColumnAttribute(iIndex, "COLSPAN", "1");
		dataObject.setColumnAttribute(iIndex, "GROUPID", "");
		String colunit="";
		if(!StringX.isEmpty(editFunction)){
			colunit+="<a onclick="+editFunction+">编辑</a>";
		}
		if(!StringX.isEmpty(deleteFunction)){
			if(!StringX.isEmpty(colunit)){
				colunit+="  ";
			}
			colunit+="<a onclick="+deleteFunction+">删除</a>";
		}
		dataObject.setColumnAttribute(iIndex,"COLUNIT", colunit);
	}

	/**
	 * 获得一个参数的内置按钮事件
	 * @param parameter
	 * @return
	 * @throws Exception
	 */
	private String getParameterSelectEvent(String dwname,String idcol,String namecol,String multiFlag,BusinessObject parameter) throws Exception{
 		String parameterID = parameter.getString("ParameterID");
 		BusinessObject parameterDefination = BusinessComponentConfig.getParameterDefinition(parameterID);
 		String selectType = parameterDefination.getString("SELECTTYPE");
 		String selectSource = parameterDefination.getString("SELECTSCRIPT");
		if(StringX.isEmpty(selectType)) return "";
		String event = "ProductComponentFunctions.popSelectParameterValues('"+selectType+"','"+selectSource+"','"+parameterID+"',"+dwname+",'"+idcol+"','"+namecol+"',"+multiFlag+");";
		return event;
 	}
	

	@Override
	public ASObjectWindow createObjectWindow(BusinessObject inputParameters,Page page, HttpServletRequest request) throws Exception {
		this.inputParameters=inputParameters;
		
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
		
		if(!StringX.isEmpty(inputParameters.getString("XMLFile")))
			p.setAttribute("XMLFile", inputParameters.getString("XMLFile"));
		if(!StringX.isEmpty(inputParameters.getString("XMLTags")))
			p.setAttribute("XMLTags", inputParameters.getString("XMLTags"));
		if(!StringX.isEmpty(inputParameters.getString("Keys")))
			p.setAttribute("Keys", inputParameters.getString("Keys"));
		page=p;
		this.page=p;
		
		this.request=request;
		String xmlFile = page.getAttribute("XMLFile");
		String xmlTags = page.getAttribute("XMLTags");
		String keys = page.getAttribute("Keys");
		componentRightType = inputParameters.getString("ComponentRightType");
		
		String componentID = inputParameters.getString("ComponentID");
		if(StringX.isEmpty(componentID)) return null;
		page.setAttribute("ComponentID", componentID);
		String componentFormat = inputParameters.getString("Format");
		
		
		if(StringX.isEmpty(componentFormat)){
			List<BusinessObject> components = XMLHelper.getBusinessObjectList(xmlFile, xmlTags+"|| id='"+componentID+"'", keys);
			if(components != null && !components.isEmpty())
				componentFormat=components.get(0).getString("Format");
		}
		
		if(StringX.isEmpty(componentFormat)){
			componentFormat=BusinessComponentConfig.BUSINESS_COMPONENT_FORMAT_PARAMETER_SET;
		}
		page.setAttribute("Format", componentFormat);
		List<BusinessObject> parameterList = XMLHelper.getBusinessObjectList(xmlFile, xmlTags+"|| id='"+componentID+"'//Parameters//Parameter", "PARAMETERID");
		
		String rightType = inputParameters.getString("RightType");
		String dwRightType = "1";
		if(!rightType.equals("ReadOnly")){
			if(StringX.isEmpty(componentRightType)) 
				dwRightType="0";
			else {
				dwRightType="1";
				for(BusinessObject parameter:parameterList){
					String parameterRightType=parameter.getString(componentRightType);
					if(!parameterRightType.equalsIgnoreCase("ReadOnly")&&!parameterRightType.equalsIgnoreCase("Hide")
							&&!parameterRightType.equalsIgnoreCase("None")){
						dwRightType="0";
					}
				}
			}
		}
		else dwRightType="1";

		ASObjectWindow dwTemp = null;
		if(componentFormat.equals(BusinessComponentConfig.BUSINESS_COMPONENT_FORMAT_PARAMETER_SET)){
			dwTemp = this.createInfoObjectWindow(parameterList);
		}
		else{
			boolean buttonFlag=false;
			if(dwRightType.equals("0")){
				buttonFlag=true;
				inputParameters.setAttributeValue("AddFunction", "ALSObjectWindowFunctions.addRow({#dwname})");
				inputParameters.setAttributeValue("DeleteFunction", "ALSObjectWindowFunctions.deleteSelectRow({#dwname})");
				if(componentFormat.equals(BusinessComponentConfig.BUSINESS_COMPONENT_FORMAT_COMPLEX)){
					inputParameters.setAttributeValue("EditFunction", "ProductComponentFunctions.editSubComponent({#dwname})");
				}
			}
			dwTemp=this.createListObjectWindow(inputParameters,parameterList, buttonFlag);
		}
		dwTemp.ReadOnly=dwRightType;
		
		dwTemp.getDataObject().getCustomProperties().setProperty("DWSTYLE", dwTemp.Style);
		ObjectWindowHelper.setObjectWindowParameters(dwTemp, inputParameters);
		
		return dwTemp;
	}
}
