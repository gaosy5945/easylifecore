package com.amarsoft.app.als.awe.ow.processor.impl.html;

import java.text.DecimalFormat;
import java.util.ArrayList;

import com.amarsoft.app.als.awe.ow.ALSBusinessProcess;
import com.amarsoft.app.als.awe.ow.processor.BusinessObjectOWQuerier;
import com.amarsoft.app.als.awe.ow.processor.OWHTMLGenrerator;
import com.amarsoft.app.als.awe.ow.validator.ALSObjectWindowValidateRulesFactory;
import com.amarsoft.app.base.businessobject.BusinessObject;
import com.amarsoft.app.base.util.ObjectWindowHelper;
import com.amarsoft.app.base.util.StringHelper;
import com.amarsoft.are.jbo.BizObject;
import com.amarsoft.are.lang.StringX;
import com.amarsoft.are.util.Arith;
import com.amarsoft.awe.dw.ASColumn;
import com.amarsoft.awe.dw.handler.BusinessProcessData;
import com.amarsoft.awe.dw.ui.htmlfactory.imp.DefaultListHtmlGenerator;
import com.amarsoft.awe.dw.ui.util.WordConvertor;
import com.amarsoft.awe.dw.ui.validator.IValidateRulesFactory;

public class ALSListHtmlGenerator extends DefaultListHtmlGenerator implements OWHTMLGenrerator{
	private String html="";
	private String javascript="";

	public void run(BusinessProcessData bpData) throws Exception {
		try{
			BusinessObject inputParameters = BusinessObject.createBusinessObject();
			ALSBusinessProcess businessProcess = ALSBusinessProcess.createBusinessProcess(request, this.asObj,this.transaction);
			BusinessObjectOWQuerier querier = businessProcess.getBusinessObjectQuerier();
			
			querier.query(inputParameters, businessProcess);
			this.rowCount = querier.getTotalCount();//总记录数
			this.firstRow = (this.curPage * this.pageSize);
			if(firstRow>rowCount){
				firstRow=0;
				curPage=0;
			}
			BusinessObject[] businessObjectList = querier.getBusinessObjectList(firstRow, firstRow+pageSize);
			
			if(businessObjectList==null )this.rowCount=0;
			if (this.rowCount <= 0) this.rowCount = querier.getTotalCount();// businessObjectList.length;
			//计算总页数
			this.pageCount = ((this.rowCount + this.pageSize - 1) / this.pageSize);
	
			this.searchedDataList = new ArrayList<BizObject>();
			if (this.rowCount> 0){
				for(BusinessObject businessObject:businessObjectList){
					this.searchedDataList.add(businessObject);
				}
			}
			if (this.transaction != null){
		        this.transaction.commit();
		    }
		}
		catch(Exception e){
			if (this.transaction != null){
		        this.transaction.rollback();
		    }
			throw e;
		}
	}

	public String getHtmlResult() throws Exception {
		String dwname = ObjectWindowHelper.getObjectWindowName(asObj);
		BusinessObject dwParameters = ObjectWindowHelper.getDataObjectParameters(asObj);//输入参数
		for(int i=0;i<asObj.Columns.size();i++){
			ASColumn column = asObj.getColumn(i);
			String editSource = column.getAttribute("COLEDITSOURCE");
			if(editSource!= null){
				editSource = StringHelper.replaceString(editSource, dwParameters);//然后使用dw传入参数，这个顺序不能调整，因为新增对象时dw传入的参数为空，但对象流水是有值的。
				column.setAttribute("COLEDITSOURCE", editSource);
			}
		}
		//生成验证脚本
		IValidateRulesFactory factory = new ALSObjectWindowValidateRulesFactory(asObj);
		asObj.validateRules = factory.getValidateRules();
		
		javascript +="if(typeof(ALSObjectWindowFunctions)==\"undefined\"||!ALSObjectWindowFunctions){ALSObjectWindowFunctions={};ALSObjectWindowFunctions.objectWindowMetaData=[];ALSObjectWindowFunctions.ObjectWindowData=[];}\n";
		javascript += "ALSObjectWindowFunctions.objectWindowMetaData["+dwname+"] = "+ObjectWindowHelper.getDWMetaJSONString(asObj)+";\n";
		javascript += "ALSObjectWindowFunctions.ObjectWindowData["+dwname+"] = [];\n";
		for(int i=0;i<this.searchedDataList.size();i++){
			BusinessObject businessObject=(BusinessObject)this.searchedDataList.get(i);
			javascript += "ALSObjectWindowFunctions.ObjectWindowData["+dwname+"]["+i+"] ="+ObjectWindowHelper.generateClientObjectData(asObj,businessObject) +";\n";
		}
		if(!StringX.isEmpty(this.asObj.getDONO())) javascript += "DisplayDONO='"+this.asObj.getDONO()+"';";
		this.tableName="myiframe"+dwname;
		javascript+=super.getHtmlResult();
		return javascript;
	}

	public String getJavaScript() throws Exception {
		return this.javascript;
	}

	public String getHTML() throws Exception {
		return this.html;
	}
	
	
	public String getValue(ASColumn column, BizObject obj) throws Exception {
		String sColName = column.getAttribute("colname");
		String sColName2 = sColName;
		if (sColName.toUpperCase().startsWith("V."))
			sColName2 = sColName.substring(2);
		String sValue = "";
		if (this.virtualFieldValues.containsKey(sColName2)) {
			sValue = this.virtualFieldValues.get(sColName2).toString();
		} else {
			
			if(obj instanceof BusinessObject)
			{
				sValue = ((BusinessObject)obj).getString(sColName2);
			}
			else{
				int iIndex = obj.indexOfAttribute(sColName2);
				if (iIndex < 0) {
					sValue = "";
				} else {
					sValue = getAttribute(obj.getAttribute(iIndex));
				}
			}
		}
		if (this.asObj.getColumn(sColName) == null)
			throw new Exception("不存在字段：" + sColName);
		if (sValue.length() > 0) {
			String sFormatCheck = this.asObj.getColumn(sColName).getAttribute(
					"COLCHECKFORMAT");
			if (sFormatCheck == null)
				sFormatCheck = "";
			if (sFormatCheck.equals("2")) {
				double dValue = Double.parseDouble(sValue.replaceAll(",", ""));
				DecimalFormat df = new DecimalFormat("###,###.00");
				sValue = df.format(Arith.round(dValue, 2));
			} else if (sFormatCheck.equals("5")) {
				double dValue = Double.parseDouble(sValue.replaceAll(",", ""));
				DecimalFormat df = new DecimalFormat("###,###");
				sValue = df.format(Arith.round(dValue, 0));
			} else if (sFormatCheck.matches("[0-9]+")) {
				int iSize = Integer.parseInt(sFormatCheck) - 10;
				if (iSize > 0) {
					String sPattern = "###,###.";
					double dValue = Double.parseDouble(sValue.replaceAll(",",
							""));
					for (int ii = 0; ii < iSize; ++ii)
						sPattern = sPattern + "0";
					DecimalFormat df = new DecimalFormat(sPattern);
					sValue = df.format(Arith.round(dValue, iSize));
				}

			}

			sValue = WordConvertor.convertJava2Js(sValue);
		}
		return sValue;
	}
}
