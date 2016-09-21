package com.amarsoft.app.als.dataimport.bill;

import java.util.Map;

import com.amarsoft.app.als.dataimport.xlsimport.AbstractExcelImport;
import com.amarsoft.are.jbo.JBOTransaction;
import com.amarsoft.are.lang.DataElement;


public class TestReader extends AbstractExcelImport{

	@Override
	public void start(JBOTransaction tx) {
		
	}

	@Override
	public boolean process(Map<String, DataElement> excelMap) {
	DataElement deName=	excelMap.get("CUSTOMERNAME");
	DataElement deCert=excelMap.get("CERTID");
	this.writeLog("客户名称："+deName.getString()+"  证件编号  ："+deCert.getString() );
		return true;
	}

	@Override
	public void end() {
		
	}

}
