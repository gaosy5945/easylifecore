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
	 * ������ʼ��
	 * 
	 * @param bo
	 * @throws Exception
	 */
	protected void initDisplayForAdd(BizObject bo) throws Exception {
		//�������
		String sAssetStatus = asPage.getParameter("AssetStatus");
		String sDASerialNo = asPage.getParameter("DASerialNo");//��ծ�ʲ���ˮ��
		String sSerialNo = asPage.getParameter("SerialNo");//��ծ�ʲ���ծ��Ϣ��ˮ��
		String sLawCaseSerialNo = asPage.getParameter("LawCaseSerialNo");//Ҫ�����ĺ�ͬ�� 
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
	 * �༭�����£���ʼ��
	 * 
	 * @param bo
	 * @throws Exception
	 */
	protected void initDisplayForEdit(BizObject bo) throws Exception {
		bo.setAttributeValue("UPDATEDATE", DateX.format(new Date()));
	}

	/**
	 * ����ǰִ���¼�
	 * @param tx
	 * @param bo
	 * @throws Exception
	 */
	protected void beforeInsert(JBOTransaction tx, BizObject bo) throws Exception {
	}
	/**
	 * �����ִ���¼�
	 * @param tx
	 * @param bo
	 * @throws Exception
	 */
	protected void afterInsert(JBOTransaction tx, BizObject bo)
			throws Exception {
	}
	/**
	 * ����ǰ�¼�
	 * @param tx
	 * @param bo
	 * @throws Exception
	 */
	protected void beforeUpdate(JBOTransaction tx, BizObject bo)
			throws Exception {
	}

	/**
	 * ���º��¼�
	 * @param tx
	 * @param bo
	 * @throws Exception
	 */
	protected void afterUpdate(JBOTransaction tx, BizObject bo)
			throws Exception {
	}

}
