package com.amarsoft.app.als.awe.ow2.manager.impl;

import java.util.List;

import javax.servlet.http.HttpServletRequest;

import com.amarsoft.app.base.businessobject.BusinessObject;
import com.amarsoft.are.jbo.JBOException;
import com.amarsoft.are.lang.DataElement;
import com.amarsoft.are.lang.StringX;
import com.amarsoft.awe.control.model.Page;
import com.amarsoft.awe.dw.ASObjectModel;
import com.amarsoft.awe.dw.ASObjectWindow;

public class DefaultObjectWindowManager extends AbstractObjectWindowManager{
	public final static String DEFAULT_LIST_HTMLGENERATOR="com.amarsoft.app.als.awe.ow2.htmlgenerator.ListOWHtmlGenerator";
	public final static String DEFAULT_INFO_HTMLGENERATOR="com.amarsoft.app.als.awe.ow2.htmlgenerator.InfoOWHtmlGenerator";
	public final static String DEFAULT_BUSINESSPROCESSOR="com.amarsoft.app.als.awe.ow2.processor.OWBusinessProcessor";
	
	private ASObjectModel doTemp = null;

	@Override
	public ASObjectWindow genObjectWindow(String rightType,BusinessObject inputParameter,Page page,HttpServletRequest request) throws Exception {
		BusinessObject owconfig =this.getObjectWindowConfig();
		doTemp = new ASObjectModel();
		doTemp.setDONO(owconfig.getString("ClassName"));
		
		String businessProcessorClass=owconfig.getString("businessProcessor");
		if(StringX.isEmpty(businessProcessorClass)){
			businessProcessorClass=DEFAULT_BUSINESSPROCESSOR;
		}
		doTemp.setBusinessProcess(businessProcessorClass);
		
		/*String mainObjectName = businessProcessorConfig.getString("mainObjectName");
		String jboClassName = owconfig.getBusinessObject("bizObjects", mainObjectName).getString("classname");
		doTemp.setJBOClass(jboClassName);*/
		
		List<BusinessObject> attributeList = owconfig.getBusinessObjects("attribute");
		for(BusinessObject attribute:attributeList){
			this.setOWColumn(attribute);
		}
		
		ASObjectWindow dwTemp = new ASObjectWindow(page,doTemp,request);
		String owstyle = owconfig.getString("Style");
		if("List".equals(owstyle)){
			dwTemp.Style="1";
		}
		else if("Info".equals(owstyle)){
			dwTemp.Style="2";
		}
		
		String htmlGenerator = owconfig.getString("htmlGenerator");
		if(StringX.isEmpty(htmlGenerator)){
			if("List".equals(owstyle)){
				htmlGenerator=DEFAULT_LIST_HTMLGENERATOR;
			}
			else if("Info".equals(owstyle)){
				htmlGenerator=DEFAULT_INFO_HTMLGENERATOR;
			}
		}
		doTemp.setDataQueryClass(htmlGenerator);
		List<BusinessObject> inputParameterConfig = getObjectWindowConfig().getBusinessObjects("inputParameter");
		for(BusinessObject parameter :inputParameterConfig){
			String parameterID = parameter.getString("Name");
			if(!inputParameter.containsAttribute(parameterID)){
				throw new Exception("创建模板对象{"+this.getObjectWindowConfig().getString("name")+"}时，在传入参数集合中未找到参数{"+parameterID+"}");
			}
			Object value = inputParameter.getObject(parameterID);
			DataElement parameterElement = new DataElement(parameterID);
			parameterElement.setValue(value);
			dwTemp.getParameters().add(parameterElement);
			//this.doTemp.getParameters().add(parameterElement);
		}
		//setParameters(inputParameter);
		return dwTemp;
	}
	
	private void setParameters(BusinessObject inputParameter) throws Exception {
		
	}
	
	private void setOWColumn(BusinessObject dataElement) throws JBOException{
		int colIndex = doTemp.addColumn(dataElement.getString("name"));
		doTemp.setColumnAttribute(colIndex, "DONO", doTemp.getDONO());
		doTemp.setColumnAttribute(colIndex, "COLHEADER", dataElement.getString("Label"));
		//doTemp.setColumnAttribute(colIndex, "COLINDEX", colIndex + "");
		//doTemp.setColumnAttribute(colIndex, "SORTNO", colIndex + "");
		doTemp.setColumnAttribute(colIndex, "ISINUSE", "1");
		//doTemp.setColumnAttribute(colIndex, "COLTABLENAME", classAlias);
		//doTemp.setColumnAttribute(colIndex, "COLACTUALNAME", element.getName());
		//doTemp.setColumnAttribute(colIndex, "COLNAME", dataElement.getName());
		
		String datatype=dataElement.getString("type");
		if(datatype.equals("SUBOW"))datatype="STRING";
		doTemp.setColumnAttribute(colIndex, "COLTYPE",datatype);
		//设置长度限制
		doTemp.setColumnAttribute(colIndex, "COLLIMIT", dataElement.getString("Length"));
		//设置默认值
		doTemp.setColumnAttribute(colIndex, "COLDEFAULTVALUE", dataElement.getString("Save.DefaultValue"));
		//设置后缀
		doTemp.setColumnAttribute(colIndex, "COLUNIT", dataElement.getString("UI.Unit"));
		//设置HTML样式
	    doTemp.setColumnAttribute(colIndex, "COLHTMLSTYLE", dataElement.getString("UI.HTMLStyle"));
	    //是否可见
	    String visibleFlag = dataElement.getString("UI.Visible");
	    if(StringX.isEmpty(visibleFlag)||visibleFlag.equalsIgnoreCase("true")) visibleFlag="1";
	    doTemp.setColumnAttribute(colIndex, "COLVISIBLE", visibleFlag);
	    
	    String readOnly = dataElement.getString("UI.ReadOnly");
	    if(StringX.isEmpty(readOnly)) readOnly="0";
	    else if(readOnly.equalsIgnoreCase("true")){
	    	readOnly="1";
	    }
	    else readOnly="0";
	    doTemp.setColumnAttribute(colIndex, "COLREADONLY", readOnly);
	    
	    String requiredFlag = dataElement.getString("Required");
	    if(StringX.isEmpty(requiredFlag)) requiredFlag="0";
	    else if(requiredFlag.equalsIgnoreCase("true")) requiredFlag="1";
	    else requiredFlag="0";
	    doTemp.setColumnAttribute(colIndex, "COLREQUIRED", requiredFlag);
	    
	    //设置横跨几列
	    String span = dataElement.getString("UI.Span");
	    doTemp.setColumnAttribute(colIndex, "COLSPAN", span);
	    
	    //所属组别
	    String groupID = dataElement.getString("UI.GroupID");
	    doTemp.setColumnAttribute(colIndex, "GROUPID", groupID);
	    
	    //编辑样式
	    String editStyle = dataElement.getString("UI.EditStyle");
	    if(StringX.isEmpty(editStyle)){
	    	editStyle="Text";
	    }
	    doTemp.setColumnAttribute(colIndex, "COLEDITSTYLE", editStyle);
	    
	    //设置对齐方式
		String colAlign=dataElement.getString("UI.Align");
		if(StringX.isEmpty(colAlign)){
			if (datatype.equalsIgnoreCase("Number"))
				colAlign="3";
			else if(editStyle.equalsIgnoreCase("Date"))
				colAlign="2";
			else
				colAlign="1";
		}
		doTemp.setColumnAttribute(colIndex, "COLALIGN", colAlign);
	    
	    //选项定义
	    String codeType=dataElement.getString("UI.CodeType");
	    String codeString=dataElement.getString("UI.CodeString");
	    doTemp.setColumnAttribute(colIndex, "COLEDITSOURCETYPE", codeType);
	    doTemp.setColumnAttribute(colIndex, "COLEDITSOURCE", codeString);
	}
}
