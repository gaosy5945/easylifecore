package com.amarsoft.app.als.credit.contract.action;

import java.sql.SQLException;
import java.util.List;

import com.amarsoft.app.base.businessobject.BusinessObjectManager;
import com.amarsoft.are.jbo.BizObject;
import com.amarsoft.are.jbo.BizObjectManager;
import com.amarsoft.are.jbo.BizObjectQuery;
import com.amarsoft.are.jbo.JBOException;
import com.amarsoft.are.jbo.JBOFactory;
import com.amarsoft.are.jbo.JBOTransaction;
import com.amarsoft.are.util.json.JSONElement;
import com.amarsoft.are.util.json.JSONObject;
/**
 * 复议时复制相关基本信息
 * @author 张万亮
 *
 */

public class ResderationInfo {
	private JSONObject inputParameter;
	private BusinessObjectManager businessObjectManager;
	
	public void setInputParameter(JSONObject inputParameter) {
		this.inputParameter = inputParameter;
	}
	private JBOTransaction tx;

	public void setTx(JBOTransaction tx) {
		this.tx = tx;
	}
	
	public void setBusinessObjectManager(BusinessObjectManager businessObjectManager) {
		this.businessObjectManager = businessObjectManager;
		this.tx = businessObjectManager.getTx();
	}
	
	private BusinessObjectManager getBusinessObjectManager() throws JBOException, SQLException{
		if(businessObjectManager==null)
			businessObjectManager = BusinessObjectManager.createBusinessObjectManager(tx);
		return businessObjectManager;
	}

	public String addUser(JBOTransaction tx) throws Exception{
		this.tx=tx;
		/**
		 * 复制BA表中的数据
		 */
		BizObjectManager arm = JBOFactory.getBizObjectManager("jbo.app.BUSINESS_APPLY");
		tx.join(arm);
		String SerialNo = (String)inputParameter.getValue("SerialNo");
		String newSerialNo = (String)inputParameter.getValue("NewSerialNo");
		String serialNo = "",contractArtificialNo = "";		
		BizObjectQuery arq = arm.createQuery("SerialNo=:SerialNo");
		arq.setParameter("SerialNo", SerialNo);
		List<BizObject> arboList = arq.getResultList(false);
			for(BizObject arbo:arboList)
			{
				BizObject crbo = arm.newObject();
				crbo.setAttributesValue(arbo);
				crbo.setAttributeValue("SerialNo", null);
				crbo.setAttributeValue("ApproveStatus", "02");
				crbo.setAttributeValue("NONSTDINDICATOR", "03");
				arm.saveObject(crbo);
				serialNo = crbo.getAttribute("SerialNo").toString();
				contractArtificialNo = crbo.getAttribute("ContractArtificialNo").toString();
			}
		/**
		 * 改变原数据审批状态为已发起复议
		 */
		arm.createQuery("UPDATE O SET APPROVESTATUS = '06' WHERE SERIALNO = :SERIALNO")
		.setParameter("SERIALNO", SerialNo).executeUpdate();
			
			
			
		/**
		 * 复制BA表中的数据
		 */
		BizObjectManager cl = JBOFactory.getBizObjectManager("jbo.cl.CL_INFO");
		tx.join(cl);
		
		BizObjectQuery ncl = cl.createQuery("ObjectType = 'jbo.app.BUSINESS_APPLY' and ObjectNo=:ApplySerialNo");
		ncl.setParameter("ApplySerialNo", SerialNo);	
		List<BizObject> clList = ncl.getResultList(false);
		for(BizObject clbo:clList)
		{
			BizObject crbo = cl.newObject();
			crbo.setAttributesValue(clbo);
			crbo.setAttributeValue("ObjectNo", serialNo);
			crbo.setAttributeValue("SerialNo", null);
			cl.saveObject(crbo);
		}	
			
		/**
		 * 复制APPLY_RELATIVE表中的数据	
		 */
		BizObjectManager ar = JBOFactory.getBizObjectManager("jbo.app.APPLY_RELATIVE");
		tx.join(ar);
		
		BizObjectQuery nar = ar.createQuery("ApplySerialNo=:ApplySerialNo and RelativeType <> '11'");
		nar.setParameter("ApplySerialNo", SerialNo);
		List<BizObject> arList = nar.getResultList(false);
			for(BizObject arbo:arList)
			{
				BizObject ncrbo = ar.newObject();
				ncrbo.setAttributesValue(arbo);
				String relativeType = arbo.getAttribute("RelativeType").getString();
				String objectType = arbo.getAttribute("ObjectType").getString();
				if("jbo.app.BUSINESS_APPLY".equals(objectType) && "04".equals(relativeType)){
					String objectNo = arbo.getAttribute("ObjectNo").getString();
					ResderationInfo SSS = new ResderationInfo();
					JSONObject dd = JSONObject.createObject();
					dd.appendElement(JSONElement.valueOf("SerialNo",objectNo));
					dd.appendElement(JSONElement.valueOf("NewSerialNo",serialNo));
					SSS.setInputParameter(dd);
					String newObjectNo = SSS.addUser(tx).split("@")[1];
					ncrbo.setAttributeValue("ObjectNo", newObjectNo);
				}else if("jbo.app.BUSINESS_APPLY".equals(objectType) && "06".equals(relativeType)){
					ncrbo.setAttributeValue("ObjectNo", newSerialNo);
				}
				ncrbo.setAttributeValue("ApplySerialNo", serialNo);
				ncrbo.setAttributeValue("SerialNo", null);
				ar.saveObject(ncrbo);
			}
		BizObject nnnar = ar.newObject();
		nnnar.setAttributeValue("ApplySerialNo",serialNo);
		nnnar.setAttributeValue("ObjectType","jbo.app.BUSINESS_APPLY");
		nnnar.setAttributeValue("ObjectNo",SerialNo);
		nnnar.setAttributeValue("RELATIVETYPE","11");
	    ar.saveObject(nnnar);
		
		/**
		 * 复制ACCT_BUSINESS_ACCOUNT表中的数据	
		 */
		BizObjectManager aai = JBOFactory.getBizObjectManager("jbo.acct.ACCT_BUSINESS_ACCOUNT");
		tx.join(aai);
							
		BizObjectQuery naai = aai.createQuery("ObjectNo=:ObjectNo and ObjectType=:ObjectType");
		naai.setParameter("ObjectNo", SerialNo);
		naai.setParameter("ObjectType", "jbo.app.BUSINESS_APPLY");
		List<BizObject> aaiList = naai.getResultList(false);
			for(BizObject aaibo:aaiList)
			{
				BizObject crbo = aai.newObject();
				crbo.setAttributesValue(aaibo);
				crbo.setAttributeValue("ObjectNo", serialNo);
				crbo.setAttributeValue("SerialNo", null);
				aai.saveObject(crbo);
			}
		/**
		 * 复制ACCT_RPT_SEGMENT表中的数据	
		 */
		BizObjectManager rpt = JBOFactory.getBizObjectManager("jbo.acct.ACCT_RPT_SEGMENT");
		tx.join(rpt);
						
		BizObjectQuery nrpt = rpt.createQuery("ObjectNo=:ObjectNo and ObjectType=:ObjectType");
		nrpt.setParameter("ObjectNo", SerialNo);
		nrpt.setParameter("ObjectType", "jbo.app.BUSINESS_APPLY");
		List<BizObject> rptList = nrpt.getResultList(false);
			for(BizObject rptbo:rptList)
			{
				BizObject crbo = rpt.newObject();
				crbo.setAttributesValue(rptbo);
				crbo.setAttributeValue("ObjectNo", serialNo);
				crbo.setAttributeValue("SerialNo", null);
				rpt.saveObject(crbo);
			}
		/**
		 * 复制ACCT_RATE_SEGMENT表中的数据	
		 */
		BizObjectManager rate = JBOFactory.getBizObjectManager("jbo.acct.ACCT_RATE_SEGMENT");
		tx.join(rate);
							
		BizObjectQuery nrate = rate.createQuery("ObjectNo=:ObjectNo and ObjectType=:ObjectType");
		nrate.setParameter("ObjectNo", SerialNo);
		nrate.setParameter("ObjectType", "jbo.app.BUSINESS_APPLY");
		List<BizObject> rateList = nrate.getResultList(false);
			for(BizObject ratebo:rateList)
			{
				BizObject crbo = rate.newObject();
				crbo.setAttributesValue(ratebo);
				crbo.setAttributeValue("ObjectNo", serialNo);
				crbo.setAttributeValue("SerialNo", null);
				rate.saveObject(crbo);
			}
		/**
		 * 复制BUSINESS_INVEST表中的数据
		 */
		BizObjectManager bi = JBOFactory.getBizObjectManager("jbo.app.BUSINESS_INVEST");
		tx.join(bi);
					
		BizObjectQuery nbi = bi.createQuery("ObjectNo=:ObjectNo and ObjectType=:ObjectType");
		nbi.setParameter("ObjectNo", SerialNo);
		nbi.setParameter("ObjectType", "jbo.app.BUSINESS_APPLY");
		List<BizObject> biList = nbi.getResultList(false);
			for(BizObject bibo:biList)
			{
				BizObject crbo = bi.newObject();
				crbo.setAttributesValue(bibo);
				crbo.setAttributeValue("ObjectNo", serialNo);
				crbo.setAttributeValue("SerialNo", null);
				bi.saveObject(crbo);
			}	
			
		/**
		 * 复制BUSINESS_APPLICANT表中的数据	
		 */
		BizObjectManager bac = JBOFactory.getBizObjectManager("jbo.app.BUSINESS_APPLICANT");
		tx.join(bac);
					
		BizObjectQuery nbac = bac.createQuery("ObjectNo=:ObjectNo and ObjectType=:ObjectType");
		nbac.setParameter("ObjectNo", SerialNo);
		nbac.setParameter("ObjectType", "jbo.app.BUSINESS_APPLY");
		List<BizObject> bacList = nbac.getResultList(false);
			for(BizObject bacbo:bacList)
			{
				BizObject crbo = bac.newObject();
				crbo.setAttributesValue(bacbo);
				crbo.setAttributeValue("ObjectNo", serialNo);
				crbo.setAttributeValue("SerialNo", null);
				bac.saveObject(crbo);
			}
		/**
		 * 复制PRJ_RELATIVE表中的数据	
		 */
		BizObjectManager prj = JBOFactory.getBizObjectManager("jbo.prj.PRJ_RELATIVE");
		tx.join(prj);
						
		BizObjectQuery nprj = prj.createQuery("ObjectNo=:ObjectNo and ObjectType=:ObjectType");
		nprj.setParameter("ObjectNo", SerialNo);
		nprj.setParameter("ObjectType", "jbo.app.BUSINESS_APPLY");
		List<BizObject> prjList = nprj.getResultList(false);
			for(BizObject prjbo:prjList)
			{
				BizObject crbo = prj.newObject();
				crbo.setAttributesValue(prjbo);
				crbo.setAttributeValue("ObjectNo", serialNo);
				crbo.setAttributeValue("SerialNo", null);
				prj.saveObject(crbo);
			}	
		/**
		 * 复制BUSINESS_EDUCATION表中的数据	
		*/
		BizObjectManager be = JBOFactory.getBizObjectManager("jbo.app.BUSINESS_EDUCATION");
		tx.join(be);
								
		BizObjectQuery nbe = be.createQuery("ObjectNo=:ObjectNo and ObjectType=:ObjectType");
		nbe.setParameter("ObjectNo", SerialNo);
		nbe.setParameter("ObjectType", "jbo.app.BUSINESS_APPLY");
		List<BizObject> beList = nbe.getResultList(false);
			for(BizObject bebo:beList)
			{
				BizObject crbo = be.newObject();
				crbo.setAttributesValue(bebo);
				crbo.setAttributeValue("ObjectNo", serialNo);
				crbo.setAttributeValue("SerialNo", null);
				be.saveObject(crbo);
			}	
		/**
		 * 复制BUSINESS_TRADE表中的数据
		 */
		BizObjectManager bt = JBOFactory.getBizObjectManager("jbo.app.BUSINESS_TRADE");
		tx.join(bt);
		String assetSerialNo = "";			
		BizObjectQuery nbt = bt.createQuery("ObjectNo=:ObjectNo and ObjectType=:ObjectType");
		nbt.setParameter("ObjectNo", SerialNo);
		nbt.setParameter("ObjectType", "jbo.app.BUSINESS_APPLY");
		List<BizObject> btList = nbt.getResultList(false);
			for(BizObject btbo:btList)
			{
				BizObject crbo = bt.newObject();
				crbo.setAttributesValue(btbo);
				crbo.setAttributeValue("ObjectNo", serialNo);
				crbo.setAttributeValue("SerialNo", null);
				bt.saveObject(crbo);
			}	
		
			
		
        return "true@"+serialNo;
	}
}