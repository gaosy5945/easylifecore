package com.amarsoft.app.als.project;

import java.util.Map;

import com.amarsoft.app.als.dataimport.xlsimport.AbstractExcelImport;
import com.amarsoft.app.als.sys.tools.CodeGenerater;
import com.amarsoft.are.ARE;
import com.amarsoft.are.jbo.BizObject;
import com.amarsoft.are.jbo.BizObjectManager;
import com.amarsoft.are.jbo.JBOException;
import com.amarsoft.are.jbo.JBOFactory;
import com.amarsoft.are.jbo.JBOTransaction;
import com.amarsoft.are.lang.DataElement;

/**
 * 描述：楼盘库导入
 * @author 柳显涛
 * @2014
 */

public class BuildingExcelImport extends AbstractExcelImport {
	private JBOTransaction trans;
	private boolean rollBack = false;
	BizObjectManager bmBI;
	BizObjectManager bmBD;
	BizObjectManager bmPB;
	
	public void start(JBOTransaction tx) {
		try {
			trans = tx;
			bmBI = JBOFactory.getBizObjectManager("jbo.app.BUILDING_INFO");
			bmBD = JBOFactory.getBizObjectManager("jbo.app.BUILDING_DEVELOPER");
			bmPB = JBOFactory.getBizObjectManager("jbo.prj.PRJ_BUILDING");
			trans.join(bmBI);
			trans.join(bmBD);
			trans.join(bmPB);
		} catch (JBOException e) {
			ARE.getLog().error("", e);
		}
	}

	public boolean process(Map<String, DataElement> excelMap){
		boolean result = false;
		try {
			String buildingName = excelMap.get("BUILDINGNAME").getString();
			String statusName = excelMap.get("STATUS").getString();
			String status = CodeGenerater.getItemNoByName(statusName, "BuildingStatus");
			String customerName = excelMap.get("CUSTOMERNAME").getString();
			String customerID = excelMap.get("CUSTOMERID").getString();
			String inputUserID = excelMap.get("INPUTUSERID").getString();
			String inputOrgID = excelMap.get("INPUTORGID").getString();
			String inputDate = excelMap.get("INPUTDATE").getString();
			
			BizObject boBI = bmBI.newObject();
			boBI.setAttributeValue("BUILDINGNAME", buildingName);
			boBI.setAttributeValue("STATUS", status);
			boBI.setAttributeValue("INPUTUSERID", inputUserID);
			boBI.setAttributeValue("INPUTORGID", inputOrgID);
			boBI.setAttributeValue("INPUTDATE", inputDate);
			bmBI.saveObject(boBI);
			
			String buildingSerialNo = boBI.getAttribute("SerialNo").toString();
			BizObject boBD = bmBD.newObject();
			boBD.setAttributeValue("BUILDINGSERIALNO", buildingSerialNo);
			boBD.setAttributeValue("CUSTOMERNAME", customerName);	
			boBD.setAttributeValue("CUSTOMERID", customerID);
			bmBD.saveObject(boBD);
					
			BizObject boPB = bmPB.newObject();
			boPB.setAttributeValue("BUILDINGSERIALNO", buildingSerialNo);
			bmPB.saveObject(boPB);
			
			result = true;
		} catch (Exception e) {
			rollBack = true;
			e.printStackTrace();
		}
		
		return result;
	}

	public void end() {
		if(rollBack){
			try {
				trans.rollback();
			} catch (JBOException e) {
				ARE.getLog("事务回滚出错");
			}
		}else{
			try {
				trans.commit();
			} catch (JBOException e) {
				ARE.getLog("事务提交出错");
			}
		}
	}
}
