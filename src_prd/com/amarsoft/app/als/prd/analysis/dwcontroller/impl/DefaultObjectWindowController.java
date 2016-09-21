package com.amarsoft.app.als.prd.analysis.dwcontroller.impl;

import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;

import com.amarsoft.app.als.awe.ow.creator.ObjectWindowCreator;
import com.amarsoft.app.als.businesscomponent.analysis.BusinessComponentAnalysisFunctions;
import com.amarsoft.app.base.businessobject.BusinessObject;
import com.amarsoft.app.base.businessobject.BusinessObjectHelper;
import com.amarsoft.app.base.businessobject.BusinessObjectManager;
import com.amarsoft.app.base.config.impl.BusinessComponentConfig;
import com.amarsoft.app.base.util.ObjectWindowHelper;
import com.amarsoft.app.base.util.StringHelper;
import com.amarsoft.app.als.prd.analysis.ProductAnalysisFunctions;
import com.amarsoft.app.als.prd.analysis.dwcontroller.ObjectWindowController;
import com.amarsoft.app.als.prd.config.loader.ProductConfig;
import com.amarsoft.are.lang.StringX;
import com.amarsoft.are.util.DataConvert;
import com.amarsoft.awe.control.model.Page;
import com.amarsoft.awe.dw.ASColumn;
import com.amarsoft.awe.dw.ASDataObject;
import com.amarsoft.awe.dw.ASDataWindow;
import com.amarsoft.awe.dw.ASObjectWindow;
import com.amarsoft.awe.dw.ui.control.Support;
import com.amarsoft.awe.dw.ui.validator.ValidateRule;

/**
 * 组件校验类
 * @author amarsoft
 *
 */
public class DefaultObjectWindowController implements ObjectWindowController,ObjectWindowCreator{
	
	
	public ASObjectWindow createObjectWindow(BusinessObject inputParameters,Page page, HttpServletRequest request) throws Exception {
		String termID = inputParameters.getString("TermID");
		String templeteNo = inputParameters.getString("TempletNo");
		String businessType = inputParameters.getString("BusinessType");
		String productID = inputParameters.getString("ProductID");
		String specificID = inputParameters.getString("SpecificID");
		String rightType = inputParameters.getString("RightType");
		String dwname = inputParameters.getString("DWName");
		if(StringX.isEmpty(rightType)) rightType=inputParameters.getString("DWRightType");
		if(StringX.isEmpty(rightType)) rightType=page.getAttribute("RightType");
		String dwstyle="2";
		
		if(StringX.isEmpty(dwname)){
			String dwcount = page.getAttribute("SYS_DWCOUNT");
			if(StringX.isEmpty(dwcount))dwcount="0";
			else dwcount=String.valueOf(Integer.valueOf(dwcount)+1);
			dwname=dwcount;
		}
		
		if(StringX.isEmpty(termID)||termID.trim().equals("")) 
			return ObjectWindowHelper.createObjectWindow(templeteNo,dwname, dwstyle, rightType, inputParameters, page, request);
		
		BusinessObject termComponent=null;
		if(!StringX.isEmpty(productID)){
			if(StringX.isEmpty(specificID)){
				specificID="000";
			}
			BusinessObject specific = ProductConfig.getSpecific(businessType,productID, specificID);
			termComponent=specific.getBusinessObjectBySql(BusinessComponentConfig.BUSINESS_COMPONENT, "ID=:ID","ID",termID);
		}
		
		if(termComponent==null) termComponent = BusinessComponentConfig.getComponent(termID);
		String componentFormat = termComponent.getString("Format");
		if(BusinessComponentConfig.BUSINESS_COMPONENT_FORMAT_PARAMETER_SET.equals(componentFormat)){
			dwstyle="2";
		}
		else if(BusinessComponentConfig.BUSINESS_COMPONENT_FORMAT_COMPLEX.equals(componentFormat)){
			dwstyle="1";
		}
		
		ASObjectWindow dwTemp = ObjectWindowHelper.createObjectWindow(templeteNo,dwname, dwstyle, rightType, inputParameters, page, request);
		
		Map<String, BusinessObject> componentparameters = BusinessComponentAnalysisFunctions.getValidParameterList(inputParameters, termComponent, "", "0010", "02",
				BusinessObjectManager.createBusinessObjectManager());
		this.initDataWindow(dwTemp, componentparameters);
		return dwTemp;
	}

	public void initDataWindow(ASDataWindow dwTemp,BusinessObject inputParameters) throws Exception {
		Map<String, BusinessObject> parameters = ProductAnalysisFunctions.getProductParameters(inputParameters,"0010","02");
		initDataWindow(dwTemp,parameters);
	}
	
	
	
	protected void initDataWindow(ASDataWindow dwTemp,Map<String, BusinessObject> componentParameters)throws Exception {
		for(String parameterID:componentParameters.keySet()){
			BusinessObject parameter=componentParameters.get(parameterID);
			String attributeID=BusinessComponentAnalysisFunctions.getJBOAttributeID(parameterID,dwTemp.getDataObject().getJboClass());
			if(StringX.isEmpty(attributeID)) continue;
			ASColumn column = dwTemp.getDataObject().getColumn(attributeID);
			if(column==null) continue;
			this.initColumnRight(dwTemp.getDataObject(), column, parameter);
			if(!dwTemp.ReadOnly.equals("1")){
				this.initColumnValue(dwTemp.getDataObject(), column, parameter);
			}
		}
	}
	
	protected void initColumnRight(ASDataObject doTemp,ASColumn column,BusinessObject parameter) throws Exception{
		//控制权限
		String accountRightType=parameter.getString("ARightType");
		String colName=column.getAttribute("COLNAME");
		if(accountRightType.equalsIgnoreCase(BusinessComponentConfig.PARAMETER_RIGHT_TYPE_ALL)){
			doTemp.setVisible(colName, true);
			doTemp.setReadOnly(colName, false);
		}
		else if(accountRightType.equalsIgnoreCase(BusinessComponentConfig.PARAMETER_RIGHT_TYPE_READONLY)){
			doTemp.setVisible(colName, true);
			doTemp.setReadOnly(colName, true);
		}
		else if(accountRightType.equalsIgnoreCase(BusinessComponentConfig.PARAMETER_RIGHT_TYPE_HIDE)){
			doTemp.setVisible(colName, false);
			doTemp.setReadOnly(colName, true);
		}
		else if(accountRightType.equalsIgnoreCase(BusinessComponentConfig.PARAMETER_RIGHT_TYPE_REQUIRED)){
			doTemp.setVisible(colName, true);
			doTemp.setReadOnly(colName, false);
			doTemp.setRequired(colName, true);
		}
		//如果有默认值，则赋值默认值
		String displayName = parameter.getString("DisplayName");
		if(!StringX.isEmpty(displayName)){
			//doTemp.setHeader(colName, displayName); //先不使用该方法。
		}
	}
	
	protected void initColumnValue(ASDataObject doTemp,ASColumn column,BusinessObject validParameter) throws Exception{
		String colName=column.getAttribute("COLNAME");
		String colHeader = doTemp.getColumnAttribute(colName, "COLHEADER");
		//如果有默认值，则赋值默认值
		String defaultValue = validParameter.getString("Value");
		if(!StringX.isEmpty(defaultValue)){
			doTemp.setDefaultValue(colName, defaultValue);
		}
		
		//如果是下拉选项，定义选项范围
		String colEditSourceType=column.getAttribute("COLEDITSOURCETYPE");
		if(!StringX.isEmpty(colEditSourceType)){//是选项时
			String codeTable ="";
			String optionalValue=validParameter.getString("OptionalValue");
			String[] code = null;
			if("XML".equalsIgnoreCase(colEditSourceType))
			{
				String[] codeArray = column.getAttribute("COLEDITSOURCE").split(",");
				List<BusinessObject> list = com.amarsoft.app.base.util.XMLHelper.getBusinessObjectList(codeArray[0], codeArray[3], codeArray[1]);
				for(BusinessObject l:list)
				{
					codeTable += l.getString(codeArray[1])+",";
					codeTable += l.getString(codeArray[2])+",";
				}
				
				if(!StringX.isEmpty(codeTable)) codeTable = codeTable.substring(0, codeTable.length()-1);
				
				code = codeTable.split(",");
			}
			else
				code = Support.getCodes(column.getAttribute("COLEDITSOURCE"),column.getAttribute("COLEDITSOURCETYPE"));
			codeTable ="";
			if(code.length==2) doTemp.setDefaultValue(colName, code[0]);//只有一个选项时，赋默认值
			if(!StringX.isEmpty(optionalValue) && code.length > 1){
				int icnt = 0;
				String singleValue = "";
				for(int i=0;i<code.length;i=i+2){
					String itemNo=code[i];
					String itemName=code[i+1];
					if(StringHelper.contains(optionalValue, itemNo, ",")){
						codeTable+=","+itemNo+","+itemName;
						icnt++;
						singleValue = itemNo;
					}
				}
				if(icnt == 1)
					doTemp.setDefaultValue(colName, singleValue);//只有一个选项时，赋默认值
			}
			if(!StringX.isEmpty(codeTable)){
				codeTable=codeTable.substring(1);
				doTemp.setDDDWCodeTable(colName, codeTable);
			}
		}
		
		//如果是数字范围，则增加校验
		String arightType=validParameter.getString("ARIGHTTYPE");
		if(arightType.equalsIgnoreCase(BusinessComponentConfig.PARAMETER_RIGHT_TYPE_ALL)||
			arightType.equalsIgnoreCase(BusinessComponentConfig.PARAMETER_RIGHT_TYPE_REQUIRED)){//只有可修改的字段才校验
			String colType=column.getAttribute("COLTYPE");
			if("Number".equalsIgnoreCase(colType)){
				Double minValue=StringX.isEmpty((String)validParameter.getObject("MinimumValue")) ? null : DataConvert.toDouble((String)validParameter.getObject("MinimumValue"));
				Double maxValue=StringX.isEmpty((String)validParameter.getObject("MaximumValue")) ? null : DataConvert.toDouble((String)validParameter.getObject("MaximumValue"));
				
				ValidateRule rule = new ValidateRule();
		        rule.setName("PRODUCTCHECK_" + colName.toUpperCase());
		        rule.setType("Double");
		        rule.setErrmsg(colHeader+"-输入范围不符合产品约定！");
		        rule.setControlto(colName.toUpperCase());
		        rule.setRegular("");
		        rule.setFunction("");
		        rule.setSortno("9999");
		        rule.setUseStatus("all");
		        
		        String validFields=BusinessComponentConfig.getParameterDefinition(validParameter.getString("ParameterID")).getString("OPERATOR");
		        boolean b=false;
				if(StringHelper.contains(validFields, "MINIMUMVALUE")&&StringHelper.contains(validFields, "MAXIMUMVALUE")){
					if(minValue==null&&maxValue==null) return;
					if(minValue.doubleValue()==0&&maxValue.doubleValue()==0) return;
					if(minValue!=null)
						rule.setMin(String.valueOf(minValue));
					if(maxValue!=null)
						rule.setMax(String.valueOf(maxValue));
					rule.setErrmsg(colHeader+"-不符合产品约定范围["+minValue+"-"+maxValue+"]！");
					b=true;
				}
				else if(StringHelper.contains(validFields, "MINIMUMVALUE")){
					if(minValue==null) return;
					rule.setMin(String.valueOf(minValue));
					rule.setMax("9999999999999");
					rule.setErrmsg(colHeader+"-小于产品约定最小值["+minValue+"]！");
					b=true;
				}
				else if(StringHelper.contains(validFields, "MAXIMUMVALUE")){
					if(maxValue==null) return;
					rule.setMin("-9999999999999");
					rule.setMax(String.valueOf(maxValue));
					rule.setErrmsg(colHeader+"-大于产品约定最大值["+maxValue+"]！");
					b=true;
				}
				if(b) doTemp.getValidateRules().add(rule);
			}
		}
	}
	
}
