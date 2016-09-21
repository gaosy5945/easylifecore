package com.amarsoft.app.als.recoverymanage.handler;

import java.util.Date;

import com.amarsoft.are.jbo.BizObject;
import com.amarsoft.are.jbo.BizObjectManager;
import com.amarsoft.are.jbo.JBOFactory;
import com.amarsoft.are.jbo.JBOTransaction;
import com.amarsoft.are.lang.DateX;
import com.amarsoft.are.lang.StringX;
import com.amarsoft.awe.dw.handler.impl.CommonHandler;

public class PDAAssetLawCaseInfo  extends CommonHandler   {
	/**
	 * 新增初始化
	 * 
	 * @param bo
	 * @throws Exception
	 */
	protected void initDisplayForAdd(BizObject bo) throws Exception {
		//定义变量
		String sAssetStatus = asPage.getParameter("AssetStatus");
		String sDASerialNo = asPage.getParameter("DASerialNo");//抵债资产流水号
		String sSerialNo = asPage.getParameter("SerialNo");//抵债资产抵债信息流水号
		String sLawCaseSerialNo = asPage.getParameter("LawCaseSerialNo");//要关联的合同号 
		if(sDASerialNo == null ) sDASerialNo = "";		
		if(sSerialNo == null ) sSerialNo = "";
		if(sLawCaseSerialNo == null ) sLawCaseSerialNo = "";
		if(sAssetStatus == null ) sAssetStatus = "";
		BizObjectManager bmBD = JBOFactory.getBizObjectManager("jbo.preservation.LAWCASE_INFO");
		BizObject boBD = bmBD.createQuery("select * from O where SerialNo=:SerialNo").setParameter("SerialNo",sLawCaseSerialNo).getSingleResult(false);
		if(null != boBD){
			bo.setAttributeValue("LawCaseName",boBD.getAttribute("LawCaseName").getString());
			bo.setAttributeValue("LawCaseType",boBD.getAttribute("LawCaseType").getString());
			//bo.setAttributeValue("LawCaseTypeName",NameManager.getItemName("LawCaseType",boBD.getAttribute("LawCaseType").getString()));
			bo.setAttributeValue("LAWSUITSTATUS",boBD.getAttribute("LAWSUITSTATUS").getString());	
			//bo.setAttributeValue("LawSuitStatusName",NameManager.getItemName("LawSuitStatus",boBD.getAttribute("LawSuitStatus").getString()));
			bo.setAttributeValue("CaseBrief",boBD.getAttribute("CaseBrief").getString());
			//bo.setAttributeValue("CaseBriefName",NameManager.getItemName("CaseBrief",boBD.getAttribute("CaseBrief").getString()));
			bo.setAttributeValue("Currency",boBD.getAttribute("Currency").getString());	
			//bo.setAttributeValue("CurrencyName",NameManager.getItemName("Currency",boBD.getAttribute("Currency").getString()));		
			bo.setAttributeValue("Aimsum",boBD.getAttribute("Aimsum").getString());		
		}
		//NPA_DEBTASSET_OBJECT
		//bo.setAttributeValue("SerialNo",sSerialNo);
		bo.setAttributeValue("OBJECTNO",sLawCaseSerialNo);
		bo.setAttributeValue("DEBTASSETSERIALNO",sDASerialNo);
		bo.setAttributeValue("OBJECTTYPE","jbo.preservation.LAWCASE_INFO");
		bo.setAttributeValue("EXPIATEAMOUNT","0.00");
		bo.setAttributeValue("PRINCIPALAMOUNT","0.00");
		bo.setAttributeValue("INTERESTAMOUNT","0.00");
		bo.setAttributeValue("OTHERAMOUNT","0.00");
		bo.setAttributeValue("UNEXPIATEAMOUNT","0.00");
		bo.setAttributeValue("InputUserID",curUser.getUserID());
		bo.setAttributeValue("InputUserName",curUser.getUserName());
		bo.setAttributeValue("InputOrgID",curUser.getOrgID());		
		bo.setAttributeValue("InputOrgName",curUser.getOrgName());		
		bo.setAttributeValue("InputDate",DateX.format(new Date()));
		
		String sAimSum = bo.getAttribute("AIMSUM").toString();
		if(sAimSum == null || StringX.isEmpty(sAimSum)) sAimSum = "0.00";		
		String sExpiatAmout = bo.getAttribute("EXPIATEAMOUNT").toString();
		if(sExpiatAmout == null || StringX.isEmpty(sExpiatAmout) ) sExpiatAmout = "0.00";		
		double sUnExpiatAmout = 0.00;
		sUnExpiatAmout = Double.parseDouble(sAimSum)+Double.parseDouble(sExpiatAmout);
		bo.setAttributeValue("UNEXPIATEAMOUNT", String.valueOf(sUnExpiatAmout));
	}

	/**
	 * 编辑（更新）初始化
	 * 
	 * @param bo
	 * @throws Exception
	 */
	protected void initDisplayForEdit(BizObject bo) throws Exception {
		bo.setAttributeValue("UPDATEDATE", DateX.format(new Date()));
	}

	/**
	 * 插入前执行事件
	 * @param tx
	 * @param bo
	 * @throws Exception
	 */
	protected void beforeInsert(JBOTransaction tx, BizObject bo) throws Exception {
	}
	/**
	 * 插入后执行事件
	 * @param tx
	 * @param bo
	 * @throws Exception
	 */
	protected void afterInsert(JBOTransaction tx, BizObject bo)
			throws Exception {
	}
	/**
	 * 更新前事件
	 * @param tx
	 * @param bo
	 * @throws Exception
	 */
	protected void beforeUpdate(JBOTransaction tx, BizObject bo)
			throws Exception {
	}

	/**
	 * 更新后事件
	 * @param tx
	 * @param bo
	 * @throws Exception
	 */
	protected void afterUpdate(JBOTransaction tx, BizObject bo)
			throws Exception {
	}

}
