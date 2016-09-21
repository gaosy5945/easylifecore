package com.amarsoft.app.als.credit.contract.action;

import java.util.List;
import com.amarsoft.are.jbo.BizObject;
import com.amarsoft.are.jbo.BizObjectManager;
import com.amarsoft.are.jbo.BizObjectQuery;
import com.amarsoft.are.jbo.JBOFactory;
import com.amarsoft.are.jbo.JBOTransaction;
/**
 * 关联借据时复制相关基本信息
 * @author 张万亮
 *
 */

public class RelevanceBDInfo {
	
	private String serialNo;
	private String contractSerialNo;

	public String getSerialNo() {
		return serialNo;
	}

	public void setSerialNo(String serialNo) {
		this.serialNo = serialNo;
	}

	public String getContractSerialNo() {
		return contractSerialNo;
	}

	public void setContractSerialNo(String contractSerialNo) {
		this.contractSerialNo = contractSerialNo;
	}

	public String copyOldInfo(JBOTransaction tx) throws Exception{
		/**
		 * 复制CONTRACT_RELATIVE表中的数据到APPLY_RELATIVE表中,引入担保物关联关系
		 */
		/*BizObjectManager cr = JBOFactory.getBizObjectManager("jbo.app.CONTRACT_RELATIVE");
		tx.join(cr);
		BizObjectManager ar = JBOFactory.getBizObjectManager("jbo.app.APPLY_RELATIVE");
		tx.join(ar);
		BizObjectManager gr = JBOFactory.getBizObjectManager("jbo.guaranty.GUARANTY_RELATIVE");
		tx.join(gr);
		
		BizObjectQuery ncr = cr.createQuery("ContractSerialNo=:ContractSerialNo and ObjectType=:ObjectType");
		ncr.setParameter("ContractSerialNo",contractSerialNo).setParameter("ObjectType","jbo.guaranty.GUARANTY_CONTRACT");
		List<BizObject> crList = ncr.getResultList(false);
		for(BizObject crbo:crList)
		{
		    String sGCSerialNo = crbo.getAttribute("OBJECTNO").getString();
		    String sNewGCSerialNo = "";
		    //一般担保合同则复制一个，因为一般担保合同不能被重复引用
		    BizObjectManager gc = JBOFactory.getBizObjectManager("jbo.guaranty.GUARANTY_CONTRACT");
		    tx.join(gc);
		    BizObject gcbo = gc.createQuery("SerialNo=:GCSerialNo").setParameter("GCSerialNo", sGCSerialNo).getSingleResult(false);
		    if(gcbo!=null){
		    	String sContractType = gcbo.getAttribute("ContractType").getString();
		    	if(sContractType.equals("010")){
			    	BizObject gcnewbo = gc.newObject();
			    	gcnewbo.setAttributesValue(gcbo);
			    	gcnewbo.setAttributeValue("SerialNo",null);
			    	gc.saveObject(gcnewbo);
			    	sNewGCSerialNo = gcnewbo.getAttribute("SerialNo").getString();
			    	List<BizObject> ngr = gr.createQuery("GCSerialNo=:GCSerialNo").setParameter("GCSerialNo", sGCSerialNo).getResultList(false);
			    	for(BizObject grbo:ngr){
			    		BizObject newgr = gr.newObject();
			    		newgr.setAttributesValue(grbo);
			    		newgr.setAttributeValue("GCSerialNo", sNewGCSerialNo);
			    		newgr.setAttributeValue("SerialNo", null);
			    		gr.saveObject(newgr);
			    	}
			    }
		    	else
		    		sNewGCSerialNo = sGCSerialNo;
		    }else{
		    	sNewGCSerialNo = sGCSerialNo;
		    }
			BizObject arbo = ar.newObject();
			arbo.setAttributesValue(crbo);
			arbo.setAttributeValue("ApplySerialNo", serialNo);
			arbo.setAttributeValue("ObjectNo",sNewGCSerialNo);
			arbo.setAttributeValue("SerialNo", null);
			ar.saveObject(arbo);
		}*/

			
		/**
		 * 复制ACCT_BUSINESS_ACCOUNT表中的数据	
		 */
		BizObjectManager aai = JBOFactory.getBizObjectManager("jbo.acct.ACCT_BUSINESS_ACCOUNT");
		tx.join(aai);
							
		BizObjectQuery naai = aai.createQuery("ObjectNo=:ObjectNo and ObjectType=:ObjectType");
		naai.setParameter("ObjectNo", contractSerialNo);
		naai.setParameter("ObjectType", "jbo.app.BUSINESS_CONTRACT");
		List<BizObject> aaiList = naai.getResultList(false);
			for(BizObject aaibo:aaiList)
			{
				BizObject crbo = aai.newObject();
				crbo.setAttributesValue(aaibo);
				crbo.setAttributeValue("ObjectNo", serialNo);
				crbo.setAttributeValue("ObjectType", "jbo.app.BUSINESS_APPLY");
				crbo.setAttributeValue("SerialNo", null);
				aai.saveObject(crbo);
			}
		/**
		 * 复制ACCT_RPT_SEGMENT表中的数据	
		 */
		BizObjectManager rpt = JBOFactory.getBizObjectManager("jbo.acct.ACCT_RPT_SEGMENT");
		tx.join(rpt);
						
		BizObjectQuery nrpt = rpt.createQuery("ObjectNo=:ObjectNo and ObjectType=:ObjectType");
		nrpt.setParameter("ObjectNo", contractSerialNo);
		nrpt.setParameter("ObjectType", "jbo.app.BUSINESS_CONTRACT");
		List<BizObject> rptList = nrpt.getResultList(false);
			for(BizObject rptbo:rptList)
			{
				BizObject crbo = rpt.newObject();
				crbo.setAttributesValue(rptbo);
				crbo.setAttributeValue("ObjectNo", serialNo);
				crbo.setAttributeValue("ObjectType", "jbo.app.BUSINESS_APPLY");
				crbo.setAttributeValue("SerialNo", null);
				rpt.saveObject(crbo);
			}
		/**
		 * 复制ACCT_RATE_SEGMENT表中的数据	
		 */
		BizObjectManager rate = JBOFactory.getBizObjectManager("jbo.acct.ACCT_RATE_SEGMENT");
		tx.join(rate);
							
		BizObjectQuery nrate = rate.createQuery("ObjectNo=:ObjectNo and ObjectType=:ObjectType");
		nrate.setParameter("ObjectNo", contractSerialNo);
		nrate.setParameter("ObjectType", "jbo.app.BUSINESS_CONTRACT");
		List<BizObject> rateList = nrate.getResultList(false);
			for(BizObject ratebo:rateList)
			{
				BizObject crbo = rate.newObject();
				crbo.setAttributesValue(ratebo);
				crbo.setAttributeValue("ObjectNo", serialNo);
				crbo.setAttributeValue("ObjectType", "jbo.app.BUSINESS_APPLY");
				crbo.setAttributeValue("SerialNo", null);
				rate.saveObject(crbo);
			}
		/**
		 * 复制BUSINESS_INVEST表中的数据
		 */
		BizObjectManager bi = JBOFactory.getBizObjectManager("jbo.app.BUSINESS_INVEST");
		tx.join(bi);
					
		BizObjectQuery nbi = bi.createQuery("ObjectNo=:ObjectNo and ObjectType=:ObjectType");
		nbi.setParameter("ObjectNo", contractSerialNo);
		nbi.setParameter("ObjectType", "jbo.app.BUSINESS_CONTRACT");
		List<BizObject> biList = nbi.getResultList(false);
			for(BizObject bibo:biList)
			{
				BizObject crbo = bi.newObject();
				crbo.setAttributesValue(bibo);
				crbo.setAttributeValue("ObjectNo", serialNo);
				crbo.setAttributeValue("ObjectType", "jbo.app.BUSINESS_APPLY");
				crbo.setAttributeValue("SerialNo", null);
				bi.saveObject(crbo);
			}	
		/**
		 * 复制BUSINESS_APPLICANT表中的数据	
		 */
		BizObjectManager bac = JBOFactory.getBizObjectManager("jbo.app.BUSINESS_APPLICANT");
		tx.join(bac);
					
		BizObjectQuery nbac = bac.createQuery("ObjectNo=:ObjectNo and ObjectType=:ObjectType");
		nbac.setParameter("ObjectNo", contractSerialNo);
		nbac.setParameter("ObjectType", "jbo.app.BUSINESS_CONTRACT");
		List<BizObject> bacList = nbac.getResultList(false);
			for(BizObject bacbo:bacList)
			{
				BizObject crbo = bac.newObject();
				crbo.setAttributesValue(bacbo);
				crbo.setAttributeValue("ObjectNo", serialNo);
				crbo.setAttributeValue("ObjectType", "jbo.app.BUSINESS_APPLY");
				crbo.setAttributeValue("SerialNo", null);
				bac.saveObject(crbo);
			}
		/**
		 * 复制PRJ_RELATIVE表中的数据	
		 */
		BizObjectManager prj = JBOFactory.getBizObjectManager("jbo.prj.PRJ_RELATIVE");
		tx.join(prj);
						
		BizObjectQuery nprj = prj.createQuery("ObjectNo=:ObjectNo and ObjectType=:ObjectType");
		nprj.setParameter("ObjectNo", contractSerialNo);
		nprj.setParameter("ObjectType", "jbo.app.BUSINESS_CONTRACT");
		List<BizObject> prjList = nprj.getResultList(false);
			for(BizObject prjbo:prjList)
			{
				BizObject crbo = prj.newObject();
				crbo.setAttributesValue(prjbo);
				crbo.setAttributeValue("ObjectNo", serialNo);
				crbo.setAttributeValue("ObjectType", "jbo.app.BUSINESS_APPLY");
				crbo.setAttributeValue("SerialNo", null);
				prj.saveObject(crbo);
			}	
		/**
		 * 复制BUSINESS_EDUCATION表中的数据	
		*/
		BizObjectManager be = JBOFactory.getBizObjectManager("jbo.app.BUSINESS_EDUCATION");
		tx.join(be);
								
		BizObjectQuery nbe = be.createQuery("ObjectNo=:ObjectNo and ObjectType=:ObjectType");
		nbe.setParameter("ObjectNo", contractSerialNo);
		nbe.setParameter("ObjectType", "jbo.app.BUSINESS_CONTRACT");
		List<BizObject> beList = nbe.getResultList(false);
			for(BizObject bebo:beList)
			{
				BizObject crbo = be.newObject();
				crbo.setAttributesValue(bebo);
				crbo.setAttributeValue("ObjectNo", serialNo);
				crbo.setAttributeValue("ObjectType", "jbo.app.BUSINESS_APPLY");
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
		nbt.setParameter("ObjectNo", contractSerialNo);
		nbt.setParameter("ObjectType", "jbo.app.BUSINESS_CONTRACT");
		List<BizObject> btList = nbt.getResultList(false);
			for(BizObject btbo:btList)
			{
				BizObject crbo = bt.newObject();
				crbo.setAttributesValue(btbo);
				crbo.setAttributeValue("ObjectNo", serialNo);
				crbo.setAttributeValue("ObjectType", "jbo.app.BUSINESS_APPLY");
				crbo.setAttributeValue("SerialNo", null);
				bt.saveObject(crbo);
			}
		
        return "true@"+serialNo;
	}
}