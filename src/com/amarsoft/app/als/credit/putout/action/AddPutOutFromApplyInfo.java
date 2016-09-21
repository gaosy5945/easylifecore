package com.amarsoft.app.als.credit.putout.action;

import java.util.Date;
import java.util.List;

import com.amarsoft.app.als.credit.contract.action.FlowSendMessageUserAction;
import com.amarsoft.app.als.sys.tools.SYSNameManager;
import com.amarsoft.app.base.util.DateHelper;
import com.amarsoft.are.jbo.BizObject;
import com.amarsoft.are.jbo.BizObjectManager;
import com.amarsoft.are.jbo.BizObjectQuery;
import com.amarsoft.are.jbo.JBOFactory;
import com.amarsoft.are.jbo.JBOTransaction;
import com.amarsoft.are.util.ASValuePool;
import com.amarsoft.awe.util.DBKeyHelp;
import com.amarsoft.dict.als.cache.CodeCache;

/**
 * 将申请基本信息及其关联信息复制到合同中
 * @author xjzhao
 */
public class AddPutOutFromApplyInfo{
	
	private String userID;
	private String orgID;
	private String applySerialNo;
	private String contractSerialNo;
	private String putoutStatus;
	
	public String getUserID() {
		return userID;
	}

	public void setUserID(String userID) {
		this.userID = userID;
	}

	public String getOrgID() {
		return orgID;
	}

	public void setOrgID(String orgID) {
		this.orgID = orgID;
	}

	public String getApplySerialNo() {
		return applySerialNo;
	}

	public void setApplySerialNo(String applySerialNo) {
		this.applySerialNo = applySerialNo;
	}

	public String getContractSerialNo() {
		return contractSerialNo;
	}

	public void setContractSerialNo(String contractSerialNo) {
		this.contractSerialNo = contractSerialNo;
	}
	
	public String getPutoutStatus() {
		return putoutStatus;
	}

	public void setPutoutStatus(String putoutStatus) {
		this.putoutStatus = putoutStatus;
	}

	/**
	 * 生成合同信息并返回新合同流水
	 * @param tx
	 * @throws Exception
	 */
	public String createPutOut(JBOTransaction tx) throws Exception{
		//生成合同信息
		//查询申请基本信息
		BizObjectManager bam = JBOFactory.getBizObjectManager("jbo.app.BUSINESS_APPLY");
		tx.join(bam);
		BizObjectQuery baq = bam.createQuery("SerialNo=:ApplySerialNo");
		baq.setParameter("ApplySerialNo", applySerialNo);
		BizObject ba = baq.getSingleResult(true);
		if(ba == null ) throw new Exception("未找到对应申请信息，请检查配置信息！");
		//设置BA审批状态
		ba.setAttributeValue("APPROVEORGID", this.orgID);
		ba.setAttributeValue("APPROVEUSERID", this.userID);
		ba.setAttributeValue("APPROVEDATE", DateHelper.getBusinessDate());
		ba.setAttributeValue("UPDATEDATE", DateHelper.getBusinessDate());
		ba.setAttributeValue("APPROVESTATUS", "03");
		bam.saveObject(ba);
		
		//生成合同基本信息
		BizObjectManager bpm = JBOFactory.getBizObjectManager("jbo.app.BUSINESS_PUTOUT");
		tx.join(bpm);
		BizObjectQuery bpq = bpm.createQuery("ApplySerialNo=:ApplySerialNo");
		bpq.setParameter("ApplySerialNo", applySerialNo);
		BizObject bp = bpq.getSingleResult(true);
		String putoutSerialNo = null;
		boolean addFlag = false;
		if(bp == null)
		{
			bp = bpm.newObject();
			addFlag = true;
		}
		else
		{
			putoutSerialNo = bp.getAttribute("SerialNo").getString();
		}
		bp.setAttributesValue(ba);
		bp.setAttributeValue("SerialNo", putoutSerialNo);
		bp.setAttributeValue("ApplySerialNo", applySerialNo);
		bp.setAttributeValue("ContractSerialNo", contractSerialNo);
		
		String contractArtificialNo = ba.getAttribute("ContractArtificialNo").getString();
		if(contractArtificialNo != null && !"".equals(contractArtificialNo) && contractArtificialNo.length()>=14) contractArtificialNo = contractArtificialNo.substring(0, 14);
		
		if(bp.getAttribute("DuebillSerialNo").getString() == null || "".equals(bp.getAttribute("DuebillSerialNo").getString()))
		{
			String duebillNo = DBKeyHelp.getSerialNo("BUSINESS_DUEBILL", "SERIALNO", contractArtificialNo, "00", new Date());
			bp.setAttributeValue("DuebillSerialNo", duebillNo);
		}
		bp.setAttributeValue("TEMPSAVEFLAG", "0");
		if(putoutStatus == null || "".equals(putoutStatus)) putoutStatus = "01";
		bp.setAttributeValue("PUTOUTSTATUS", putoutStatus);	
		bp.setAttributeValue("InputDate", DateHelper.getBusinessDate());
		bp.setAttributeValue("UpdateDate", DateHelper.getBusinessDate());
		bpm.saveObject(bp);
		
		//查询审批意见信息
		BizObjectManager bapm = JBOFactory.getBizObjectManager("jbo.app.BUSINESS_APPROVE");
		tx.join(bapm);
		BizObjectQuery bapq = bapm.createQuery("ApplySerialNo=:ApplySerialNo order by SerialNo desc ");
		bapq.setParameter("ApplySerialNo", applySerialNo);
		BizObject bap = bapq.getSingleResult(false);
		if(bap!=null)
		{
			bp.setAttributeValue("ApproveSerialNo", bap.getAttribute("SerialNo").getString());
			bp.setAttributeValue("BUSINESSCURRENCY", bap.getAttribute("BUSINESSCURRENCY").getString());
			bp.setAttributeValue("BUSINESSSUM", bap.getAttribute("BUSINESSSUM").getDouble());
			bp.setAttributeValue("BUSINESSTERM", bap.getAttribute("BUSINESSTERM").getInt());
			bp.setAttributeValue("BUSINESSTERMDAY", bap.getAttribute("BUSINESSTERMDAY").getInt());
			bp.setAttributeValue("BUSINESSTERMUNIT", bap.getAttribute("BUSINESSTERMUNIT").getString());
			bp.setAttributeValue("RPTTERMID", bap.getAttribute("RPTTERMID").getString());
			bp.setAttributeValue("LOANRATETERMID", bap.getAttribute("LOANRATETERMID").getString());
			bp.setAttributeValue("CHECKFREQUENCY", bap.getAttribute("CHECKFREQUENCY").getInt());
			bp.setAttributeValue("PUTOUTCLAUSE", bap.getAttribute("PUTOUTCLAUSE").getString());
			bp.setAttributeValue("AFTERREQUIREMENT", bap.getAttribute("AFTERREQUIREMENT").getString());
			bp.setAttributeValue("SPECIALARGEEMENT", bap.getAttribute("SPECIALARGEEMENT").getString());
			//拷贝关联对象
			this.copyRelative(tx, "jbo.acct.ACCT_RATE_SEGMENT", bap.getBizObjectClass().getRoot().getAbsoluteName(), bap.getAttribute("SerialNo").getString(), bp.getBizObjectClass().getRoot().getAbsoluteName(), bp.getAttribute("SerialNo").getString(),null);
			this.copyRelative(tx, "jbo.acct.ACCT_RPT_SEGMENT", bap.getBizObjectClass().getRoot().getAbsoluteName(), bap.getAttribute("SerialNo").getString(), bp.getBizObjectClass().getRoot().getAbsoluteName(), bp.getAttribute("SerialNo").getString(),null);
			bpm.saveObject(bp);
		}
		else
		{
			
			//拷贝关联对象
			this.copyRelative(tx, "jbo.acct.ACCT_RATE_SEGMENT", ba.getBizObjectClass().getRoot().getAbsoluteName(), applySerialNo, bp.getBizObjectClass().getRoot().getAbsoluteName(), bp.getAttribute("SerialNo").getString(),null);
			this.copyRelative(tx, "jbo.acct.ACCT_RPT_SEGMENT", ba.getBizObjectClass().getRoot().getAbsoluteName(), applySerialNo, bp.getBizObjectClass().getRoot().getAbsoluteName(), bp.getAttribute("SerialNo").getString(),null);
		}
		
		
		this.copyRelative(tx, "jbo.acct.ACCT_BUSINESS_ACCOUNT", ba.getBizObjectClass().getRoot().getAbsoluteName(), applySerialNo, bp.getBizObjectClass().getRoot().getAbsoluteName(), bp.getAttribute("SerialNo").getString(),null);
		
		this.copyRelative(tx, "jbo.app.BUSINESS_TRADE", ba.getBizObjectClass().getRoot().getAbsoluteName(), applySerialNo, bp.getBizObjectClass().getRoot().getAbsoluteName(), bp.getAttribute("SerialNo").getString(),null);
		this.copyRelative(tx, "jbo.app.BUSINESS_INVEST", ba.getBizObjectClass().getRoot().getAbsoluteName(), applySerialNo, bp.getBizObjectClass().getRoot().getAbsoluteName(), bp.getAttribute("SerialNo").getString(),null);
		this.copyRelative(tx, "jbo.app.BUSINESS_EDUCATION", ba.getBizObjectClass().getRoot().getAbsoluteName(), applySerialNo, bp.getBizObjectClass().getRoot().getAbsoluteName(), bp.getAttribute("SerialNo").getString(),null);
		

		//放款前落实条件
		BizObjectManager fckm = JBOFactory.getBizObjectManager("jbo.flow.FLOW_CHECKLIST");
		tx.join(fckm);
		BizObjectQuery fckq = fckm.createQuery("ObjectType=:ObjectType and ObjectNo=:ObjectNo and CheckItem = '0040' ");
		fckq.setParameter("ObjectType", bp.getBizObjectClass().getRoot().getAbsoluteName());
		fckq.setParameter("ObjectNo", bp.getAttribute("SerialNo").getString());
		List<BizObject> fckbl = fckq.getResultList(false);
		String putOutClauses = bp.getAttribute("PUTOUTCLAUSE").getString();
		if(putOutClauses!= null)
		{
			String[] putOutClauseArray = putOutClauses.split(",");
			for(String putOutClause:putOutClauseArray)
			{
				String putOutClauseName = CodeCache.getItemName("PutoutClause", putOutClause);
				if(putOutClauseName == null || "".equals(putOutClauseName)) putOutClauseName = putOutClause;
				
				
				boolean flag = false;
				if(fckbl!=null)
				{
					for(BizObject fckb:fckbl)
					{
						if(putOutClauseName!=null && putOutClauseName.equals(fckb.getAttribute("CheckItemName").getString()))
							flag = true;
					}
				}
				
				if(!flag)
				{
					BizObject fckbo = fckm.newObject();
					fckbo.setAttributeValue("ObjectType", bp.getBizObjectClass().getRoot().getAbsoluteName());
					fckbo.setAttributeValue("ObjectNo", bp.getAttribute("SerialNo").getString());
					fckbo.setAttributeValue("CheckItem", "0040");
					fckbo.setAttributeValue("CheckItemName", putOutClauseName);
					fckbo.setAttributeValue("InputOrgID", orgID);
					fckbo.setAttributeValue("InputUserID", userID);
					fckbo.setAttributeValue("InputTime", DateHelper.getBusinessDate());
					fckm.saveObject(fckbo);
				}
			}
		}
		
		bpm.saveObject(bp);
		
		
		if(addFlag)
		{
			FlowSendMessageUserAction fsua = new FlowSendMessageUserAction();
			fsua.setMessageID("015");
			fsua.setObjectNo(applySerialNo);
			fsua.setObjectType("jbo.app.BUSINESS_APPLY");
			fsua.setUserID(userID);
			fsua.sendMessage(tx);
		}
		
		return bp.getAttribute("SerialNo").getString();
	}
	
	
	
	private void copyRelative(JBOTransaction tx,String copyObject,String fromObjectType,String fromObjectNo,String toObjectType,String toObjectNo,ASValuePool as) throws Exception{
		BizObjectManager m = JBOFactory.getBizObjectManager(copyObject);
		tx.join(m);
		BizObjectQuery q = m.createQuery("delete from O where ObjectType=:ObjectType and ObjectNo=:ObjectNo");
		q.setParameter("ObjectType", toObjectType);
		q.setParameter("ObjectNo", toObjectNo);
		q.executeUpdate();
		
		q = m.createQuery("ObjectType=:ObjectType and ObjectNo=:ObjectNo order by SerialNo");
		q.setParameter("ObjectType", fromObjectType);
		q.setParameter("ObjectNo", fromObjectNo);
		List<BizObject> boList = q.getResultList(false);
		if(boList!=null)
		{
			for(BizObject bo:boList)
			{
				BizObject newBo = m.newObject();
				newBo.setAttributesValue(bo);
				newBo.setAttributeValue("SerialNo", null);
				newBo.setAttributeValue("ObjectType", toObjectType);
				newBo.setAttributeValue("ObjectNo", toObjectNo);
				if(as != null)
				{
					for(Object key:as.getKeys())
					{
						String value = (String)as.getAttribute((String)key);
						newBo.setAttributeValue((String)key, value);
					}
				}
				m.saveObject(newBo);
			}
		}
	}
}
