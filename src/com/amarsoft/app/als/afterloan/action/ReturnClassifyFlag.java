package com.amarsoft.app.als.afterloan.action;

import com.amarsoft.are.jbo.BizObject;
import com.amarsoft.are.jbo.BizObjectManager;
import com.amarsoft.are.jbo.BizObjectQuery;
import com.amarsoft.are.jbo.JBOFactory;
import com.amarsoft.are.jbo.JBOTransaction;

public class ReturnClassifyFlag {
	private String serialNo;
	
	public String getSerialNo() {
		return serialNo;
	}

	public void setSerialNo(String serialNo) {
		this.serialNo = serialNo;
	}

	/**
	 * 流程至分类调整申请修改状态
	 * @param tx
	 * @throws Exception
	 */
	public String changeToApplyFlag(JBOTransaction tx) throws Exception{				
		BizObjectManager bom = JBOFactory.getBizObjectManager("jbo.al.CLASSIFY_RECORD");
		tx.join(bom);
		BizObjectQuery baq = bom.createQuery("SerialNo=:SerialNo");
		baq.setParameter("SerialNo", serialNo);
		BizObject ba = baq.getSingleResult(true);
		if(ba == null ) throw new Exception("未找到对应流程信息，请检查配置信息！");
		ba.setAttributeValue("CLASSIFYSTATUS", "0010");
		bom.saveObject(ba);
		return ba.getAttribute("SerialNo").getString();
	}

	/**
	 * 流程至分类调整申请修改状态
	 * @param tx
	 * @throws Exception
	 */
	public String changeToApproveFlag(JBOTransaction tx) throws Exception{				
		BizObjectManager bom = JBOFactory.getBizObjectManager("jbo.al.CLASSIFY_RECORD");
		tx.join(bom);
		BizObjectQuery baq = bom.createQuery("SerialNo=:SerialNo");
		baq.setParameter("SerialNo", serialNo);
		BizObject ba = baq.getSingleResult(true);
		if(ba == null ) throw new Exception("未找到对应流程信息，请检查配置信息！");
		ba.setAttributeValue("CLASSIFYSTATUS", "0020");
		bom.saveObject(ba);
		return ba.getAttribute("SerialNo").getString();
	}
}
