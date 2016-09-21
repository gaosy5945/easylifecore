package com.amarsoft.app.als.credit.contract.action;

import java.util.List;

import com.amarsoft.app.als.credit.putout.action.AddPutOutFromApplyInfo;
import com.amarsoft.app.als.credit.putout.action.AddPutOutInfo;
import com.amarsoft.app.als.credit.putout.action.GuarantyInfoSave;
import com.amarsoft.app.base.util.DateHelper;
import com.amarsoft.are.jbo.BizObject;
import com.amarsoft.are.jbo.BizObjectManager;
import com.amarsoft.are.jbo.BizObjectQuery;
import com.amarsoft.are.jbo.JBOFactory;
import com.amarsoft.are.jbo.JBOTransaction;
import com.amarsoft.are.lang.StringX;
import com.amarsoft.are.util.ASValuePool;
import com.amarsoft.dict.als.cache.CodeCache;

/**
 * 将申请基本信息及其关联信息复制到合同中
 * @author xjzhao
 *
 */
public class AddContractInfo{
	
	private String userID;
	private String orgID;
	private String applySerialNo;
	private String parentContractSeiralNo;
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
	
	public String getParentContractSeiralNo() {
		return parentContractSeiralNo;
	}

	public void setParentContractSeiralNo(String parentContractSeiralNo) {
		this.parentContractSeiralNo = parentContractSeiralNo;
	}

	public String getPutoutStatus() {
		return putoutStatus;
	}

	public void setPutoutStatus(String putoutStatus) {
		this.putoutStatus = putoutStatus;
	}

	/**
	 * 判断申请是否生成合同
	 * true 生成合同
	 * false 不生成合同
	 */
	
	public boolean isCreate(BizObject ba,JBOTransaction tx) throws Exception{
		boolean flag = true;
		
		BizObjectManager arm = JBOFactory.getBizObjectManager("jbo.app.APPLY_RELATIVE");
		tx.join(arm);
		BizObjectQuery arq = arm.createQuery("ApplySerialNo=:ApplySerialNo and RelativeType = :RelativeType");
		arq.setParameter("ApplySerialNo", ba.getAttribute("SerialNo").getString());
		arq.setParameter("RelativeType", "06");
		BizObject arbo = arq.getSingleResult(false); //如果有记录则是额度项下贷款
		
		
		String businessType = ba.getAttribute("BusinessType").getString();
		
		if(arbo != null && !"500".equals(businessType) 
			&& !"502".equals(businessType) && !"666".equals(businessType)
			&& !"888".equals(businessType)) //融资易\消贷易\轻松智业卡 需要生成合同
		{
			flag = false;
			if("jbo.app.BUSINESS_CONTRACT".equals(arbo.getAttribute("ObjectType").getString()))
				parentContractSeiralNo = arbo.getAttribute("ObjectNo").getString();
		}
		
		return flag;
	}

	/**
	 * 生成合同信息并返回新合同流水
	 * @param tx
	 * @throws Exception
	 */
	public String createContract(JBOTransaction tx) throws Exception{
		//生成合同信息
		//查询申请基本信息
		BizObjectManager bam = JBOFactory.getBizObjectManager("jbo.app.BUSINESS_APPLY");
		tx.join(bam);
		BizObjectQuery baq = bam.createQuery("SerialNo=:ApplySerialNo");
		baq.setParameter("ApplySerialNo", applySerialNo);
		BizObject ba = baq.getSingleResult(true);
		if(ba == null ) throw new Exception("未找到对应申请信息，请检查配置信息！");
		String baOperateUserID = ba.getAttribute("OperateUserID").getString();
		//设置BA审批状态
		ba.setAttributeValue("APPROVEORGID", this.orgID);
		ba.setAttributeValue("APPROVEUSERID", this.userID);
		ba.setAttributeValue("APPROVEDATE", DateHelper.getBusinessDate());
		ba.setAttributeValue("UPDATEDATE", DateHelper.getBusinessDate());
		ba.setAttributeValue("APPROVESTATUS", "03");
		bam.saveObject(ba);
		
		BizObjectManager arbm = JBOFactory.getBizObjectManager("jbo.app.APPLY_RELATIVE");
		tx.join(arbm);
		BizObjectQuery arb = arbm.createQuery("ApplySerialNo=:ApplySerialNo and ObjectType='jbo.app.BUSINESS_APPLY' and RelativeType in('04','07') ");
		arb.setParameter("ApplySerialNo", applySerialNo);
		List<BizObject> arbList = arb.getResultList(false);
		for(BizObject ar:arbList){
			String serialNo = ar.getAttribute("ObjectNo").toString();
			bam.createQuery("UPDATE O SET APPROVESTATUS = '03',APPROVEORGID = :APPROVEORGID,APPROVEUSERID = :APPROVEUSERID,APPROVEDATE = :APPROVEDATE WHERE SERIALNO = :SERIALNO")
			.setParameter("APPROVEORGID", this.orgID).setParameter("APPROVEUSERID", this.userID).setParameter("APPROVEDATE", DateHelper.getBusinessDate()).setParameter("SERIALNO", serialNo).executeUpdate();
		}
		
		//判断是否需要生成合同
		if(!this.isCreate(ba, tx))
		{
			//如果不生成合同，则直接生成出账信息
			
			AddPutOutFromApplyInfo apofai = new AddPutOutFromApplyInfo();
			apofai.setApplySerialNo(applySerialNo);
			apofai.setContractSerialNo(parentContractSeiralNo);
			apofai.setOrgID(orgID);
			apofai.setUserID(userID);
			apofai.setPutoutStatus(putoutStatus);
			apofai.createPutOut(tx);
			return "";
		}
		
		//生成合同基本信息
		BizObjectManager bcm = JBOFactory.getBizObjectManager("jbo.app.BUSINESS_CONTRACT");
		tx.join(bcm);
		BizObjectQuery bcq = bcm.createQuery("SerialNo=:SerialNo");
		bcq.setParameter("SerialNo", ba.getAttribute("contractartificialno").getString());
		BizObject bc = bcq.getSingleResult(true);
		boolean addFlag = false;//是否新增合同信息
		if(bc == null)
		{
			bc = bcm.newObject();
			addFlag = true;
		}
		bc.setAttributesValue(ba);
		bc.setAttributeValue("SerialNo", ba.getAttribute("contractartificialno"));
		bc.setAttributeValue("ApplySerialNo", applySerialNo);
		bc.setAttributeValue("ApplySerialNo", applySerialNo);
		bc.setAttributeValue("ExecutiveOrgID", bc.getAttribute("OperateOrgID").getString());
		bc.setAttributeValue("ExecutiveUserID", bc.getAttribute("OperateUserID").getString());
		bc.setAttributeValue("ContractStatus", "01");
		bc.setAttributeValue("CLASSIFYMETHOD", "02");
		bc.setAttributeValue("InputDate", DateHelper.getBusinessDate());
		bc.setAttributeValue("UpdateDate", DateHelper.getBusinessDate());
		
		//查询审批意见信息
		BizObjectManager bapm = JBOFactory.getBizObjectManager("jbo.app.BUSINESS_APPROVE");
		tx.join(bapm);
		BizObjectQuery bapq = bapm.createQuery("ApplySerialNo=:ApplySerialNo order by SerialNo desc ");
		bapq.setParameter("ApplySerialNo", applySerialNo);
		BizObject bap = bapq.getSingleResult(false);
		double approveBusinessSum = 0d;//审批方案中的最终审批金额
		if(bap!=null)
		{
			bc.setAttributeValue("ApproveSerialNo", bap.getAttribute("SerialNo").getString());
			bc.setAttributeValue("REVOLVEFLAG", bap.getAttribute("REVOLVEFLAG").getString());
			bc.setAttributeValue("BUSINESSCURRENCY", bap.getAttribute("BUSINESSCURRENCY").getString());
			bc.setAttributeValue("BUSINESSSUM", bap.getAttribute("BUSINESSSUM").getDouble());
			bc.setAttributeValue("BUSINESSTERM", bap.getAttribute("BUSINESSTERM").getInt());
			bc.setAttributeValue("BUSINESSTERMDAY", bap.getAttribute("BUSINESSTERMDAY").getInt());
			bc.setAttributeValue("BUSINESSTERMUNIT", bap.getAttribute("BUSINESSTERMUNIT").getString());
			bc.setAttributeValue("RPTTERMID", bap.getAttribute("RPTTERMID").getString());
			bc.setAttributeValue("LOANRATETERMID", bap.getAttribute("LOANRATETERMID").getString());
			bc.setAttributeValue("CHECKFREQUENCY", bap.getAttribute("CHECKFREQUENCY").getInt());
			bc.setAttributeValue("PUTOUTCLAUSE", bap.getAttribute("PUTOUTCLAUSE").getString());
			bc.setAttributeValue("AFTERREQUIREMENT", bap.getAttribute("AFTERREQUIREMENT").getString());
			bc.setAttributeValue("SPECIALARGEEMENT", bap.getAttribute("SPECIALARGEEMENT").getString());
			bc.setAttributeValue("MATURITYDATE", bap.getAttribute("MATURITYDATE").getString());
			
			//拷贝关联对象
			this.copyRelative(tx, "jbo.acct.ACCT_RATE_SEGMENT", bap.getBizObjectClass().getRoot().getAbsoluteName(), bap.getAttribute("SerialNo").getString(), bc.getBizObjectClass().getRoot().getAbsoluteName(), bc.getAttribute("SerialNo").getString(),null);
			this.copyRelative(tx, "jbo.acct.ACCT_RPT_SEGMENT", bap.getBizObjectClass().getRoot().getAbsoluteName(), bap.getAttribute("SerialNo").getString(), bc.getBizObjectClass().getRoot().getAbsoluteName(), bc.getAttribute("SerialNo").getString(),null);
			//this.copyRelative(tx, "jbo.acct.ACCT_FEE", bap.getBizObjectClass().getRoot().getAbsoluteName(), bap.getAttribute("SerialNo").getString(), bc.getBizObjectClass().getRoot().getAbsoluteName(), bc.getAttribute("SerialNo").getString());
			
			approveBusinessSum = bap.getAttribute("BUSINESSSUM").getDouble();
		}
		else
		{
			
			//拷贝关联对象
			this.copyRelative(tx, "jbo.acct.ACCT_RATE_SEGMENT", ba.getBizObjectClass().getRoot().getAbsoluteName(), applySerialNo, bc.getBizObjectClass().getRoot().getAbsoluteName(), bc.getAttribute("SerialNo").getString(),null);
			this.copyRelative(tx, "jbo.acct.ACCT_RPT_SEGMENT", ba.getBizObjectClass().getRoot().getAbsoluteName(), applySerialNo, bc.getBizObjectClass().getRoot().getAbsoluteName(), bc.getAttribute("SerialNo").getString(),null);
			//this.copyRelative(tx, "jbo.acct.ACCT_FEE", ba.getBizObjectClass().getRoot().getAbsoluteName(), applySerialNo, bc.getBizObjectClass().getRoot().getAbsoluteName(), bc.getAttribute("SerialNo").getString());
		}
		
		bcm.saveObject(bc);
		
		this.copyRelative(tx, "jbo.acct.ACCT_BUSINESS_ACCOUNT", ba.getBizObjectClass().getRoot().getAbsoluteName(), applySerialNo, bc.getBizObjectClass().getRoot().getAbsoluteName(), bc.getAttribute("SerialNo").getString(),null);
		this.copyRelative(tx, "jbo.cl.CL_RELATIVE", ba.getBizObjectClass().getRoot().getAbsoluteName(), applySerialNo, bc.getBizObjectClass().getRoot().getAbsoluteName(), bc.getAttribute("SerialNo").getString(),null);
		this.copyRelative(tx, "jbo.app.BUSINESS_APPLICANT", ba.getBizObjectClass().getRoot().getAbsoluteName(), applySerialNo, bc.getBizObjectClass().getRoot().getAbsoluteName(), bc.getAttribute("SerialNo").getString(),null);
		ASValuePool as = new ASValuePool();
		as.setAttribute("RelativeType", "02");
		this.copyRelative(tx, "jbo.prj.PRJ_RELATIVE", ba.getBizObjectClass().getRoot().getAbsoluteName(), applySerialNo, bc.getBizObjectClass().getRoot().getAbsoluteName(), bc.getAttribute("SerialNo").getString(),as);
		
		this.copyRelative(tx, "jbo.app.BUSINESS_TRADE", ba.getBizObjectClass().getRoot().getAbsoluteName(), applySerialNo, bc.getBizObjectClass().getRoot().getAbsoluteName(), bc.getAttribute("SerialNo").getString(),null);
		this.copyRelative(tx, "jbo.app.BUSINESS_INVEST", ba.getBizObjectClass().getRoot().getAbsoluteName(), applySerialNo, bc.getBizObjectClass().getRoot().getAbsoluteName(), bc.getAttribute("SerialNo").getString(),null);
		this.copyRelative(tx, "jbo.app.BUSINESS_EDUCATION", ba.getBizObjectClass().getRoot().getAbsoluteName(), applySerialNo, bc.getBizObjectClass().getRoot().getAbsoluteName(), bc.getAttribute("SerialNo").getString(),null);
		as = new ASValuePool();
		as.setAttribute("BUSINESSAPPAMT", bc.getAttribute("BusinessSum").getString());
		as.setAttribute("BUSINESSAVAAMT", bc.getAttribute("BusinessSum").getString());
		as.setAttribute("CLTerm", bc.getAttribute("BUSINESSTERM").getString());
		as.setAttribute("CLTermDay", bc.getAttribute("BUSINESSTERMDAY").getString());
		as.setAttribute("MATURITYDATE", bc.getAttribute("MATURITYDATE").getString());
		this.copyCLRelative(tx, "jbo.cl.CL_INFO", ba.getBizObjectClass().getRoot().getAbsoluteName(), applySerialNo, bc.getBizObjectClass().getRoot().getAbsoluteName(), bc.getAttribute("SerialNo").getString(),as);
		

		//放款前落实条件
		BizObjectManager fckm = JBOFactory.getBizObjectManager("jbo.flow.FLOW_CHECKLIST");
		tx.join(fckm);
		fckm.createQuery("Delete from O where ObjectType = :ObjectType and ObjectNo = :ObjectNo and CheckItem = '0040'")
		.setParameter("ObjectType",bc.getBizObjectClass().getRoot().getAbsoluteName()).setParameter("ObjectNo",bc.getAttribute("SerialNo").getString()).executeUpdate();
		BizObjectQuery fckq = fckm.createQuery("ObjectType=:ObjectType and ObjectNo=:ObjectNo and CheckItem = '0040' ");
		fckq.setParameter("ObjectType", bc.getBizObjectClass().getRoot().getAbsoluteName());
		fckq.setParameter("ObjectNo", bc.getAttribute("SerialNo").getString());
		List<BizObject> fckbl = fckq.getResultList(false);
		String putOutClauses = bc.getAttribute("PUTOUTCLAUSE").getString();
		if(!StringX.isEmpty(putOutClauses))
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
					fckbo.setAttributeValue("ObjectType", bc.getBizObjectClass().getRoot().getAbsoluteName());
					fckbo.setAttributeValue("ObjectNo", bc.getAttribute("SerialNo").getString());
					fckbo.setAttributeValue("CheckItem", "0040");
					fckbo.setAttributeValue("CheckItemName", putOutClauseName);
					fckbo.setAttributeValue("InputOrgID", orgID);
					fckbo.setAttributeValue("InputUserID", userID);
					fckbo.setAttributeValue("InputTime", DateHelper.getBusinessTime());
					fckm.saveObject(fckbo);
				}
			}
		}
		
		//合同关联对象处理
		BizObjectManager arm = JBOFactory.getBizObjectManager("jbo.app.APPLY_RELATIVE");
		tx.join(arm);
		BizObjectQuery arq = arm.createQuery("ApplySerialNo=:ApplySerialNo");
		arq.setParameter("ApplySerialNo", this.applySerialNo);
		List<BizObject> arboList = arq.getResultList(false);
		if(arboList != null)
		{
			BizObjectManager crm = JBOFactory.getBizObjectManager("jbo.app.CONTRACT_RELATIVE");
			tx.join(crm);
			BizObjectQuery q = crm.createQuery("delete from O where ContractSerialNo=:ContractSerialNo");
			q.setParameter("ContractSerialNo", bc.getAttribute("SerialNo").getString());
			q.executeUpdate();
			
			for(BizObject arbo:arboList)
			{	
				String childApplySerialNo="", childbcSerialNo ="";
				if("04".equals(arbo.getAttribute("RELATIVETYPE").getString()) 
						|| "07".equals(arbo.getAttribute("RELATIVETYPE").getString())){
					childApplySerialNo = arbo.getAttribute("OBJECTNO").getString();					
					AddContractInfo add = new AddContractInfo();
					add.setUserID(userID);
					add.setOrgID(orgID);
					add.setApplySerialNo(childApplySerialNo);
					add.setParentContractSeiralNo(bc.getAttribute("SerialNo").getString());
					childbcSerialNo =  add.createContract(tx);
					if(childbcSerialNo != null && !"".equals(childbcSerialNo))
					{
						BizObjectManager clbom = JBOFactory.getBizObjectManager("jbo.cl.CL_INFO");
						tx.join(clbom);
						BizObjectQuery clbq = clbom.createQuery("ObjectNo=:ObjectNo and ObjectType=:ObjectType");
						clbq.setParameter("ObjectNo", bc.getAttribute("SerialNo").getString());
						clbq.setParameter("ObjectType","jbo.app.BUSINESS_CONTRACT");
						
						BizObject clbo = clbq.getSingleResult(false);
						
						clbq.setParameter("ObjectNo", childbcSerialNo);
						clbq.setParameter("ObjectType","jbo.app.BUSINESS_CONTRACT");
						BizObject clbo1 = clbq.getSingleResult(true);
						
						if(clbo1 != null && clbo != null)
						{
							clbo1.setAttributeValue("ParentSerialNo", clbo.getAttribute("SerialNo").getString());
							clbo1.setAttributeValue("RootSerialNo", clbo.getAttribute("SerialNo").getString());
							clbom.saveObject(clbo1);
						}
						
						BizObject crbo = crm.newObject();
						crbo.setAttributesValue(arbo);
						crbo.setAttributeValue("SerialNo", null);
						crbo.setAttributeValue("ContractSerialNo", bc.getAttribute("SerialNo").getString());
						crbo.setAttributeValue("ObjectType", "jbo.app.BUSINESS_CONTRACT");
						crbo.setAttributeValue("ObjectNo", childbcSerialNo);
						crm.saveObject(crbo);
					}
					
				}else if("06".equals(arbo.getAttribute("RELATIVETYPE").getString())){
					String parentSerialNo = arbo.getAttribute("OBJECTNO").getString();	
					String parentObjectType = arbo.getAttribute("OBJECTTYPE").getString();	
					if("jbo.app.BUSINESS_APPLY".equals(parentObjectType)) //额度+首笔
					{
						BizObjectQuery bcq1 = bcm.createQuery("ApplySerialNo=:ApplySerialNo");
						bcq1.setParameter("ApplySerialNo", parentSerialNo);
						BizObject bc1 = bcq1.getSingleResult(false);
						
						BizObject crbo = crm.newObject();
						crbo.setAttributesValue(arbo);
						crbo.setAttributeValue("SerialNo", null);
						crbo.setAttributeValue("ContractSerialNo", bc.getAttribute("SerialNo").getString());
						crbo.setAttributeValue("ObjectType", "jbo.app.BUSINESS_CONTRACT");
						crbo.setAttributeValue("ObjectNo", bc1.getAttribute("SerialNo").getString());
						crm.saveObject(crbo);
					}
					else //额度项下支用
					{
						BizObject crbo = crm.newObject();
						crbo.setAttributesValue(arbo);
						crbo.setAttributeValue("SerialNo", null);
						crbo.setAttributeValue("ContractSerialNo", bc.getAttribute("SerialNo").getString());
						crm.saveObject(crbo);
						
						
						BizObjectManager clbom = JBOFactory.getBizObjectManager("jbo.cl.CL_INFO");
						tx.join(clbom);
						BizObjectQuery clbq = clbom.createQuery("ObjectNo=:ObjectNo and ObjectType=:ObjectType");
						clbq.setParameter("ObjectNo", bc.getAttribute("SerialNo").getString());
						clbq.setParameter("ObjectType","jbo.app.BUSINESS_CONTRACT");
						
						BizObject clbo1 = clbq.getSingleResult(true);
						
						clbq.setParameter("ObjectNo", parentSerialNo);
						clbq.setParameter("ObjectType","jbo.app.BUSINESS_CONTRACT");
						BizObject clbo = clbq.getSingleResult(true);
						
						if(clbo1 != null && clbo != null)
						{
							clbo1.setAttributeValue("ParentSerialNo", clbo.getAttribute("SerialNo").getString());
							clbo1.setAttributeValue("RootSerialNo", clbo.getAttribute("SerialNo").getString());
							clbom.saveObject(clbo1);
						}
					}
					
				}else if("05".equals(arbo.getAttribute("RELATIVETYPE").getString())){	
					//初始化Guaranty_Relative的状态,zhangq2
					if(arbo.getAttribute("ObjectType").getString().equals("jbo.guaranty.GUARANTY_CONTRACT")){
						String gcNo = arbo.getAttribute("ObjectNo").getString();
						
						BizObjectManager gcm1 = JBOFactory.getBizObjectManager("jbo.guaranty.GUARANTY_CONTRACT");
						tx.join(gcm1);
						BizObjectQuery gcq1 = gcm1.createQuery("SerialNo=:SerialNo");
						gcq1.setParameter("SerialNo", gcNo);
						BizObject gc1 = gcq1.getSingleResult(true);
						if(gc1 != null){
							String guarantyType = gc1.getAttribute("GuarantyType").getString();
							String contractType = gc1.getAttribute("ContractType").getString();
							
							//一般担保合同，由于不需要录入担保金额，此处赋值为最终审批金额
							if(approveBusinessSum>0d&&"010".equals(contractType)){
								gc1.setAttributeValue("GuarantyValue", approveBusinessSum);
								gcm1.saveObject(gc1);
							}
							
							//初始化抵质押状态
							BizObjectManager grm = JBOFactory.getBizObjectManager("jbo.guaranty.GUARANTY_RELATIVE");
							tx.join(grm);
							BizObjectQuery grq = grm.createQuery("GCSerialNo=:GCSerialNo");
							grq.setParameter("GCSerialNo", gcNo);
							List<BizObject> grboList = grq.getResultList(true);
							if(grboList != null && grboList.size() != 0){
								for(BizObject gr:grboList){
									BizObjectManager aim = JBOFactory.getBizObjectManager("jbo.app.ASSET_INFO");
									tx.join(aim);
									BizObjectQuery aiq = aim.createQuery("SerialNo=:AISerialNo");
									aiq.setParameter("AISerialNo", gr.getAttribute("AssetSerialNo").getString());
									BizObject asset = aiq.getSingleResult(true);
									
									if(guarantyType.startsWith("020")){//抵押
										if(gr.getAttribute("Status").getString() == null 
											|| "".equals(gr.getAttribute("Status").getString())
											|| "06".equals(gr.getAttribute("Status").getString()))
										{
											gr.setAttributeValue("Status", "0100");//未办理抵押
										}
										//asset.setAttributeValue("AssetStatus", "0000");//未抵押
										GuarantyInfoSave gs = new GuarantyInfoSave();
										gs.saveGuaranty(gcNo,applySerialNo,tx);
									}
									if("040".equals(guarantyType) && asset != null){//质押
										gr.setAttributeValue("Status", "05");//办妥正式抵押
										asset.setAttributeValue("AssetStatus", "0100");//已质押
										aim.saveObject(asset);
										GuarantyInfoSave gs = new GuarantyInfoSave();
										gs.saveGuaranty(gcNo,applySerialNo,tx);
									}
									
									grm.saveObject(gr);
								}
							}
							
							
							//初始化保证金账户
							if("01010".equals(guarantyType) || "01030".equals(guarantyType) || "01080".equals(guarantyType) || "01090".equals(guarantyType)){
								BizObjectManager cmim = JBOFactory.getBizObjectManager("jbo.guaranty.CLR_MARGIN_INFO");
								tx.join(cmim);
								BizObjectQuery clrq = cmim.createQuery("ObjectType=:ObjectType and ObjectNo=:ObjectNo");
								clrq.setParameter("ObjectType", "jbo.guaranty.GUARANTY_CONTRACT");
								clrq.setParameter("ObjectNo", gcNo);
								List<BizObject> clrList = clrq.getResultList(true);
								if(clrList!=null && clrList.size()!=0){
									for(BizObject clr:clrList){
										clr.setAttributeValue("Status", "4");//待启用
										cmim.saveObject(clr);
									}
								}
							}
						}
					}
					
					BizObject crbo = crm.newObject();
					crbo.setAttributesValue(arbo);
					crbo.setAttributeValue("SerialNo", null);
					crbo.setAttributeValue("ContractSerialNo", bc.getAttribute("SerialNo").getString());
					crm.saveObject(crbo);
				}
				else{
					BizObject crbo = crm.newObject();
					crbo.setAttributesValue(arbo);
					crbo.setAttributeValue("SerialNo", null);
					crbo.setAttributeValue("ContractSerialNo", bc.getAttribute("SerialNo").getString());
					crm.saveObject(crbo);
				}
			}
		}
		
		bcm.saveObject(bc);
		String businessType = bc.getAttribute("BusinessType").getString();
		if(!("555".equals(businessType) || "666".equals(businessType) ||"500".equals(businessType)||"502".equals(businessType))){
			AddPutOutInfo add = new AddPutOutInfo();
			add.setUserID(userID);
			add.setOrgID(orgID);
			add.setContractSerialNo( bc.getAttribute("SerialNo").getString());
			add.setPutoutStatus(putoutStatus);
			add.createPutOut(tx);
		}
		/*
		try{
			InitContractInfo ic = new InitContractInfo();
			ic.setContractNo(bc.getAttribute("SerialNo").getString());
			ic.createDoc(tx);
		}catch(Exception e){
			e.printStackTrace();
		}*/
		
		if(addFlag)
		{
			FlowSendMessageUserAction fsua = new FlowSendMessageUserAction();
			fsua.setMessageID("015");
			fsua.setObjectNo(applySerialNo);
			fsua.setObjectType("jbo.app.BUSINESS_APPLY");
			fsua.setUserID(baOperateUserID);
			fsua.sendMessage(tx);
		}
		
		return bc.getAttribute("SerialNo").getString();
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
	private void copyCLRelative(JBOTransaction tx,String copyObject,String fromObjectType,String fromObjectNo,String toObjectType,String toObjectNo,ASValuePool as) throws Exception{
		BizObjectManager m = JBOFactory.getBizObjectManager(copyObject);
		tx.join(m);
		BizObjectQuery q = m.createQuery("delete from O where ObjectType=:ObjectType and ObjectNo=:ObjectNo");
		q.setParameter("ObjectType", toObjectType);
		q.setParameter("ObjectNo", toObjectNo);
		q.executeUpdate();
		
		q = m.createQuery("ObjectType=:ObjectType and ObjectNo=:ObjectNo and (parentSerialNo is null or parentSerialNo = '') order by SerialNo");
		q.setParameter("ObjectType", fromObjectType);
		q.setParameter("ObjectNo", fromObjectNo);
		BizObject clbo = q.getSingleResult();
		if(clbo != null){
			BizObject newclBo = m.newObject();
			newclBo.setAttributesValue(clbo);
			newclBo.setAttributeValue("SerialNo", null);
			newclBo.setAttributeValue("ObjectType", toObjectType);
			newclBo.setAttributeValue("ObjectNo", toObjectNo);
			if(as != null)
			{
				for(Object key:as.getKeys())
				{
					String value = (String)as.getAttribute((String)key);
					newclBo.setAttributeValue((String)key, value);
				}
			}
			m.saveObject(newclBo);
			String parentSerialNo = newclBo.getAttribute("SerialNo").getString();
			
			q = m.createQuery("ObjectType=:ObjectType and ObjectNo=:ObjectNo and parentSerialNo is not null and parentSerialNo <> '' order by SerialNo");
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
					newBo.setAttributeValue("ParentSerialNo", parentSerialNo);
					m.saveObject(newBo);
				}
			}
		}
	}
}
