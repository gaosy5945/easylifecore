package com.amarsoft.app.als.finance.analyse.model;

import com.amarsoft.are.jbo.BizObject;
import com.amarsoft.are.util.DataConvert;
import com.amarsoft.are.util.StringFunction;
import java.math.*;
import com.amarsoft.biz.finance.FinanceAnalyse;

public class ReportSubject
{
	private String rowNo;
	private String displayOrder;
	private String rowName;
	private String rowSubject;
	private String RowDimType;
	private double col1Value;
	private double col2Value;
	//格式化显示值方式1：
	private String col1ValueString;
	private String col2ValueString;
	//格式化显示值方式2:采用三位一逗，数据取整
	private String col1IntString;
	private String col2IntString;
	
	public String toString(){
		return null;
	}
	
	public void setValue(BizObject o) throws Exception{
		//设置对象值，不进行显示格式换转
		this.setRowNo(o.getAttribute("RowNo").getString());
		this.setRowName(o.getAttribute("RowName").getString());
		this.setRowSubject(o.getAttribute("RowSubject").getString());
		this.setRowDimType(o.getAttribute("RowDimType").getString());
		this.setDisplayOrder(o.getAttribute("DisplayOrder").getString());
		this.setCol1Value(o.getAttribute("Col1Value").getDouble());
		this.setCol2Value(o.getAttribute("Col2Value").getDouble());
		this.setCol1ValueString(o.getAttribute("Col1Value").getString());
		this.setCol2ValueString(o.getAttribute("Col2Value").getString());
		this.setCol1IntString(formatSubjectValue2(o.getAttribute("Col1Value").getDouble()));
		this.setCol2IntString(formatSubjectValue2(o.getAttribute("Col2Value").getDouble()));
	}
	
	public void setValueDisplay(BizObject o,String sReportUnit) throws Exception{
		int unit = 1;
		//万元的显示
		if("10000".equals(sReportUnit)){
			unit = 10000;
		}
		
		this.setRowNo(o.getAttribute("RowNo").getString());
		this.setRowName(o.getAttribute("RowName").getString());
		this.setRowSubject(o.getAttribute("RowSubject").getString());
		this.setRowDimType(o.getAttribute("RowDimType").getString());
		this.setDisplayOrder(o.getAttribute("DisplayOrder").getString());
		
		/**
		 * 行量纲类型RowDimType的控制：
		 * RowDimType =1 || RowDimType = null  || RowDimType=""  data/10000 
		 * RowDimType =2  data*100（百分比）
		 * RowDimType =3  data （无量纲 如0.1天）
		 */
		double d1 = o.getAttribute("Col1Value").getDouble();
		double d2 = o.getAttribute("Col2Value").getDouble();
		String s1 = o.getAttribute("Col1Value").getString();
		String s2 = o.getAttribute("Col2Value").getString();
		
		if("2".equals(this.getRowDimType())){
			if(s1==null||"".equals(s1)){
				this.setCol1Value(0);
				this.setCol1ValueString("");
				this.setCol1IntString("");
			}else{
				this.setCol1Value(d1*100);
				this.setCol1ValueString(StringFunction.replace(FinanceAnalyse.formatNumber(d1*100),",",""));
				this.setCol1IntString(formatSubjectValue1(d1*100));
			}
			
			if(s2==null||"".equals(s2)){
				this.setCol2Value(0);
				this.setCol2ValueString("");
				this.setCol2IntString("");
			}else{
				this.setCol2Value(d2*100);
				this.setCol2ValueString(StringFunction.replace(FinanceAnalyse.formatNumber(d2*100),",",""));
				this.setCol2IntString(formatSubjectValue1(d2*100));
			}
			
		}else if("3".equals(this.getRowDimType())){
			if(s1==null||"".equals(s1)){
				this.setCol1Value(0);
				this.setCol1ValueString("");
				this.setCol1IntString("");
			}else{
				this.setCol1Value(d1);
				this.setCol1ValueString(StringFunction.replace(FinanceAnalyse.formatNumber(d1),",",""));
				this.setCol1IntString(formatSubjectValue1(d1));
			}
			
			if(s2==null||"".equals(s2)){
				this.setCol2Value(0);
				this.setCol2ValueString("");
				this.setCol2IntString("");
			}else{
				this.setCol2Value(d2);
				this.setCol2ValueString(StringFunction.replace(FinanceAnalyse.formatNumber(d2),",",""));
				this.setCol2IntString(formatSubjectValue1(d2));
			}
		}else{
			this.setCol1Value(d1/unit);
			this.setCol2Value(d2/unit);
			this.setCol1ValueString(StringFunction.replace(FinanceAnalyse.formatNumber(d1/unit),",",""));
			this.setCol2ValueString(StringFunction.replace(FinanceAnalyse.formatNumber(d2/unit),",",""));
			this.setCol1IntString(formatSubjectValue1(d1/unit));
			this.setCol2IntString(formatSubjectValue1(d2/unit));
		}
	}
	
	/**
	 * 财务数据显示格式转换，四舍五入后，三位一逗
	 */
	public String formatSubjectValue1(double d){
		try{
			int value = (int)Math.round(d);            //转换整数
			String svalue = DataConvert.toMoney(value);//三位一逗
			int length = svalue.length();
			return svalue.substring(0, length-3);
		}catch(Exception e){
			e.printStackTrace();
			return "0.00";
		}
	}
	
	/**
	 * 财务数据显示格式转换，四舍五入后，直接返回
	 */
	public String formatSubjectValue2(double d){
		int value = (int)Math.round(d);
		return String.valueOf(value);
	}

	public String getRowNo() {
		return rowNo;
	}

	public void setRowNo(String rowNo) {
		this.rowNo = rowNo;
	}

	public String getDisplayOrder() {
		return displayOrder;
	}

	public void setDisplayOrder(String displayOrder) {
		this.displayOrder = displayOrder;
	}

	public String getRowName() {
		return rowName;
	}

	public void setRowName(String rowName) {
		this.rowName = rowName;
	}

	public String getRowSubject() {
		return rowSubject;
	}

	public void setRowSubject(String rowSubject) {
		this.rowSubject = rowSubject;
	}

	public String getRowDimType() {
		return RowDimType;
	}

	public void setRowDimType(String rowDimType) {
		RowDimType = rowDimType;
	}

	public double getCol1Value() {
		return col1Value;
	}

	public void setCol1Value(double col1Value) {
		this.col1Value = col1Value;
	}

	public double getCol2Value() {
		return col2Value;
	}

	public void setCol2Value(double col2Value) {
		this.col2Value = col2Value;
	}

	public String getCol1ValueString() {
		return col1ValueString;
	}

	public void setCol1ValueString(String col1ValueString) {
		this.col1ValueString = col1ValueString;
	}

	public String getCol2ValueString() {
		return col2ValueString;
	}

	public void setCol2ValueString(String col2ValueString) {
		this.col2ValueString = col2ValueString;
	}

	public String getCol1IntString() {
		return col1IntString;
	}

	public void setCol1IntString(String col1IntString) {
		this.col1IntString = col1IntString;
	}

	public String getCol2IntString() {
		return col2IntString;
	}

	public void setCol2IntString(String col2IntString) {
		this.col2IntString = col2IntString;
	}
}
