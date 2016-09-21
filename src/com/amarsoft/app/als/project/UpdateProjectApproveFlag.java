package com.amarsoft.app.als.project;

import com.amarsoft.are.jbo.BizObject;
import com.amarsoft.are.jbo.BizObjectManager;
import com.amarsoft.are.jbo.BizObjectQuery;
import com.amarsoft.are.jbo.JBOFactory;
import com.amarsoft.are.jbo.JBOTransaction;

public class UpdateProjectApproveFlag {
	private String serialNo;
	
	public String getSerialNo() {
		return serialNo;
	}

	public void setSerialNo(String serialNo) {
		this.serialNo = serialNo;
	}
	
	public String update(JBOTransaction tx) throws Exception{				
		BizObjectManager bom = JBOFactory.getBizObjectManager("jbo.prj.PRJ_BASIC_INFO");
		tx.join(bom);
		BizObjectQuery baq = bom.createQuery("SerialNo=:SerialNo");
		baq.setParameter("SerialNo", serialNo);
		BizObject ba = baq.getSingleResult(true);
		if(ba == null ) throw new Exception("未找到对应流程信息，请检查配置信息！");
		ba.setAttributeValue("STATUS", "12");
		bom.saveObject(ba);
		return ba.getAttribute("SerialNo").getString();
	}
}
