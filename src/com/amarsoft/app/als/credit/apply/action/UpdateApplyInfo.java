package com.amarsoft.app.als.credit.apply.action;

import java.util.List;

import com.amarsoft.app.als.credit.contract.action.FlowSendMessageUserAction;
import com.amarsoft.app.als.credit.putout.action.GuarantyInfoSave;
import com.amarsoft.app.als.credit.putout.action.SendCLInfo;
import com.amarsoft.app.als.credit.putout.action.UpdatePutOutInfo;
import com.amarsoft.app.als.docmanage.action.DocSelectChangeName;
import com.amarsoft.app.base.util.DateHelper;
import com.amarsoft.are.jbo.BizObject;
import com.amarsoft.are.jbo.BizObjectManager;
import com.amarsoft.are.jbo.BizObjectQuery;
import com.amarsoft.are.jbo.JBOFactory;
import com.amarsoft.are.jbo.JBOTransaction;
import com.amarsoft.are.lang.StringX;

/**
 * ���̽����������롢���ˡ���ͬ����Ϣ
 * @author xjzhao
 *
 */
public class UpdateApplyInfo{
	
	private String userID;
	private String orgID;
	private String applySerialNo;
	private String flowStatus;
	
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

	public String getFlowStatus() {
		return flowStatus;
	}

	public void setFlowStatus(String flowStatus) {
		this.flowStatus = flowStatus;
	}

	/**
	 * ���ɺ�ͬ��Ϣ�������º�ͬ��ˮ
	 * @param tx
	 * @throws Exception
	 */
	public String update(JBOTransaction tx) throws Exception{
		//���ɺ�ͬ��Ϣ
		//��ѯ���������Ϣ
		BizObjectManager bam = JBOFactory.getBizObjectManager("jbo.app.BUSINESS_APPLY");
		tx.join(bam);
		BizObjectQuery baq = bam.createQuery("SerialNo=:ApplySerialNo");
		baq.setParameter("ApplySerialNo", applySerialNo);
		BizObject ba = baq.getSingleResult(true);
		BizObjectManager arm = JBOFactory.getBizObjectManager("jbo.app.APPLY_RELATIVE");
		tx.join(arm);
		BizObjectQuery arb = arm.createQuery("ApplySerialNo=:ApplySerialNo and ObjectType='jbo.app.BUSINESS_APPLY' and RelativeType in('04','07') ");
		arb.setParameter("ApplySerialNo", applySerialNo);
		if(ba == null ) throw new Exception("δ�ҵ���Ӧ������Ϣ������������Ϣ��");
		BizObjectManager bcm = JBOFactory.getBizObjectManager("jbo.app.BUSINESS_CONTRACT");
		tx.join(bcm);
		BizObjectManager bpm = JBOFactory.getBizObjectManager("jbo.app.BUSINESS_PUTOUT");
		tx.join(bpm);
		//����BA����״̬
		if("1".equals(flowStatus))
		{
			
		}
		else if("3".equals(flowStatus))
		{
			/* ����ͨ��״̬���ں�ͬ����ʱ�����ô�����
			ba.setAttributeValue("APPROVEORGID", this.orgID);
			ba.setAttributeValue("APPROVEUSERID", this.userID);
			ba.setAttributeValue("APPROVEDATE", SystemConfig.getBusinessDate());
			ba.setAttributeValue("APPROVESTATUS", "03");
			List<BizObject> arbList = arb.getResultList(false);
			for(BizObject ar:arbList){
				String serialNo = ar.getAttribute("ObjectNo").toString();
				bam.createQuery("UPDATE O SET APPROVESTATUS = '03',APPROVEORGID = :APPROVEORGID,APPROVEUSERID = :APPROVEUSERID,APPROVEDATE = :APPROVEDATE WHERE SERIALNO = :SERIALNO")
				.setParameter("APPROVEORGID", this.orgID).setParameter("APPROVEUSERID", this.userID).setParameter("APPROVEDATE", SystemConfig.getBusinessDate()).setParameter("SERIALNO", serialNo).executeUpdate();
			}
			*/
			
			
			BizObjectQuery bcq = bcm.createQuery("ApplySerialNo=:ApplySerialNo");
			bcq.setParameter("ApplySerialNo", applySerialNo);
			BizObject bc = bcq.getSingleResult(true);//ȡ�����Ӧ��ͬ��Ϣ
			
			BizObjectQuery bpq = bpm.createQuery("ApplySerialNo in(select BA.SerialNo from jbo.app.BUSINESS_APPLY BA where BA.SerialNo=:ApplySerialNo union select AR.ObjectNo from jbo.app.APPLY_RELATIVE AR where AR.ApplySerialNo=:ApplySerialNo and AR.ObjectType = 'jbo.app.BUSINESS_APPLY' and AR.RelativeType in('04','07'))");
			bpq.setParameter("ApplySerialNo", applySerialNo);
			List<BizObject> bols = bpq.getResultList(false);
			if(bols != null && !bols.isEmpty())
			{
				for(BizObject bo:bols)
				{
					UpdatePutOutInfo upoi = new UpdatePutOutInfo();
					upoi.setFlowStatus(flowStatus);
					upoi.setOrgID(orgID);
					upoi.setUserID(userID);
					upoi.setPutoutSerialNo(bo.getAttribute("SerialNo").getString());
					upoi.update(tx);
				}
			}
			
			
			if(bc != null)
			{
				String businessType = bc.getAttribute("BusinessType").getString();
				
				BizObjectManager clbom = JBOFactory.getBizObjectManager("jbo.cl.CL_INFO"); //�������
				tx.join(clbom);
				BizObjectQuery clbq = clbom.createQuery("ObjectNo=:ObjectNo and ObjectType=:ObjectType");
				
				if(businessType != null){
					if ("555".equals(businessType)){ //�����ۺ����Ŷ��
						
						clbq.setParameter("ObjectNo", bc.getAttribute("SerialNo").getString());
						clbq.setParameter("ObjectType","jbo.app.BUSINESS_CONTRACT");
						BizObject clbo = clbq.getSingleResult(true);
						
						bc.setAttributeValue("ContractStatus", "03");
						bc.setAttributeValue("BusinessStatus", "L0");
						clbo.setAttributeValue("Status", "20");
						
						String contractDate = bc.getAttribute("CONTRACTDATE").getString();
						if(contractDate == null || "".equals(contractDate))
						{
							contractDate = DateHelper.getBusinessDate();
						}
						String maturityDate = bc.getAttribute("MaturityDate").getString();
						bc.setAttributeValue("CONTRACTDATE",contractDate);
						clbo.setAttributeValue("STARTDATE", contractDate);
						if(maturityDate == null || "".equals(maturityDate))
						{
							int businessTerm = bc.getAttribute("BusinessTerm").getInt();
							maturityDate = DateHelper.getRelativeDate(contractDate, DateHelper.TERM_UNIT_MONTH, businessTerm);
							int businessTermDay = bc.getAttribute("BusinessTermDay").getInt();
							maturityDate = DateHelper.getRelativeDate(maturityDate, DateHelper.TERM_UNIT_DAY, businessTermDay);
							bc.setAttributeValue("MATURITYDATE",maturityDate);
							clbo.setAttributeValue("MATURITYDATE",maturityDate);
						}
						else
						{
							int month = (int) Math.floor(DateHelper.getMonths(contractDate, maturityDate));
							int day = DateHelper.getDays(DateHelper.getRelativeDate(contractDate, DateHelper.TERM_UNIT_MONTH, month), maturityDate);
							bc.setAttributeValue("BusinessTerm",month);
							bc.setAttributeValue("BusinessTermDay",day);
							clbo.setAttributeValue("CLTerm",month);
							clbo.setAttributeValue("CLTermDay",day);
						}
						
						ba.setAttributeValue("BusinessTerm",bc.getAttribute("BusinessTerm").getInt());
						ba.setAttributeValue("BusinessTermDay",bc.getAttribute("BusinessTermDay").getInt());
						clbom.saveObject(clbo);
						bcm.saveObject(bc);
						//����ת���Ź�������ҵ��
						BizObjectQuery bcrq1 = bcm.createQuery("SerialNo in(select CR.ObjectNo from jbo.app.CONTRACT_RELATIVE CR where CR.ObjectType=:ObjectType and CR.ContractSerialNo=:ContractSerialNo and CR.RelativeType = '02')");
						bcrq1.setParameter("ObjectType", "jbo.app.BUSINESS_CONTRACT");
						bcrq1.setParameter("ContractSerialNo", bc.getAttribute("SerialNo").getString());
						BizObject bcbo1 = bcrq1.getSingleResult(true);
						if(bcbo1 != null){
							String DBContractSerialNo = bcbo1.getAttribute("SerialNo").getString();
							bcm.createQuery("UPDATE O SET ContractStatus = '05' WHERE SerialNo = :SerialNo")
							.setParameter("SerialNo", DBContractSerialNo).executeUpdate();
							BizObjectManager bdm = JBOFactory.getBizObjectManager("jbo.app.BUSINESS_DUEBILL");
							tx.join(bdm);
							bdm.createQuery("UPDATE O SET ContractSerialNo = :NewContractSerialNo WHERE ContractSerialNo = :OldContractSerialNo")
							.setParameter("NewContractSerialNo", bc.getAttribute("SerialNo").getString())
							.setParameter("OldContractSerialNo", DBContractSerialNo).executeUpdate();
						}
						
						
						//����ҵ��
						BizObjectQuery bcrq = bcm.createQuery("SerialNo in(select CR.ObjectNo from jbo.app.CONTRACT_RELATIVE CR where CR.ObjectType=:ObjectType and CR.ContractSerialNo=:ContractSerialNo and CR.RelativeType = '04')");
						bcrq.setParameter("ObjectType", "jbo.app.BUSINESS_CONTRACT");
						bcrq.setParameter("ContractSerialNo", bc.getAttribute("SerialNo").getString());
						BizObject bcbo = bcrq.getSingleResult(true);
						
						if(bcbo != null)
						{
							String businessType1 = bcbo.getAttribute("BusinessType").getString();
							
							if("502".equals(businessType1) || "666".equals(businessType1) || "500".equals(businessType1))
							{
								clbq.setParameter("ObjectNo", bcbo.getAttribute("SerialNo").getString());
								clbq.setParameter("ObjectType","jbo.app.BUSINESS_CONTRACT");
								BizObject clbo1 = clbq.getSingleResult(true);
								bcbo.setAttributeValue("ContractStatus", "03");
								bcbo.setAttributeValue("BusinessStatus", "L0");
								clbo1.setAttributeValue("Status", "20");
								updateBCCL(bcbo,clbo1);
								
								clbom.saveObject(clbo1);
								bcm.saveObject(bcbo);
								
								SendCLInfo scli = new SendCLInfo();
								scli.setContractNo(bcbo.getAttribute("SerialNo").getString());
								scli.send(tx);
							}
						}	
						
					}else if("502".equals(businessType) || "666".equals(businessType) || "500".equals(businessType)){
						clbq.setParameter("ObjectNo", bc.getAttribute("SerialNo").getString());
						clbq.setParameter("ObjectType","jbo.app.BUSINESS_CONTRACT");
						BizObject clbo = clbq.getSingleResult(true);
						bc.setAttributeValue("ContractStatus", "03");
						bc.setAttributeValue("BusinessStatus", "L0");
						clbo.setAttributeValue("Status", "20");
						updateBCCL(bc,clbo);
						
						clbom.saveObject(clbo);
						bcm.saveObject(bc);
						
						SendCLInfo scli = new SendCLInfo();
						scli.setContractNo(bc.getAttribute("SerialNo").getString());
						scli.send(tx);
					}
					else{			
						if(!"03".equals(bc.getAttribute("ContractStatus").getString()))
						{
							bc.setAttributeValue("ContractStatus", "02");
							bcm.saveObject(bc);
						}
					}
				}
				//�ſ�ɹ����Զ�����ҵ������"�����"���� 
				String sBCSerialNo = bc.getAttribute("SERIALNO").getString();//ҵ���ͬ��ˮ��
				String sExecutiveOrgID= bc.getAttribute("EXECUTIVEORGID").getString();//�ܻ�����
				String sExecutiveUserID= bc.getAttribute("EXECUTIVEUSERID").getString();//�ܻ���
				String sCustomerName= bc.getAttribute("CUSTOMERNAME").getString();//�ͻ�����
				String sObjectType = "jbo.app.BUSINESS_CONTRACT";
				String sContractArtificialNo = bc.getAttribute("CONTRACTARTIFICIALNO").getString();//��ͬ���
				//�����Զ����ɴ��������ķ���
				DocSelectChangeName.insertDocPackageAndOperation(sBCSerialNo, sObjectType, sExecutiveUserID, sExecutiveOrgID, sCustomerName,sContractArtificialNo);
				
			}
			//��Ч������ͬ
			BizObjectManager gcm = JBOFactory.getBizObjectManager("jbo.guaranty.GUARANTY_CONTRACT");
			tx.join(gcm);
			
			/*BizObjectManager arm = JBOFactory.getBizObjectManager("jbo.app.APPLY_RELATIVE");
			tx.join(arm);*/
			BizObjectQuery arq = arm.createQuery("ApplySerialNo=:ApplySerialNo and ObjectType='jbo.guaranty.GUARANTY_CONTRACT' and RelativeType='05' ");
			arq.setParameter("ApplySerialNo", applySerialNo);
			List<BizObject> arList = arq.getResultList(false);
			for(BizObject ar:arList){
				String gcNo = ar.getAttribute("ObjectNo").getString();
				if(StringX.isEmpty(gcNo)){
					break;
				}
				BizObject gcBo = gcm.createQuery("SerialNo=:SerialNo").setParameter("SerialNo", gcNo).getSingleResult(true);
				if(gcBo != null){
					if(gcBo.getAttribute("ContractStatus").getString().equals("01")){
						gcBo.setAttributeValue("ContractStatus", "02");//��Ч
						gcBo.setAttributeValue("ContractDate", DateHelper.getBusinessDate());//��Ч��
						gcBo.setAttributeValue("UpdateDate", DateHelper.getBusinessDate());
						//���õ����������������Ϣ����ӿ�
						GuarantyInfoSave gs = new GuarantyInfoSave();
						gs.saveGuaranty(gcBo.getAttribute("SerialNo").getString(),applySerialNo,tx);
						gcm.saveObject(gcBo);
					}
				}
			}
		}
		else if("0".equals(flowStatus))
		{
			ba.setAttributeValue("APPROVEORGID", this.orgID);
			ba.setAttributeValue("APPROVEUSERID", this.userID);
			ba.setAttributeValue("APPROVEDATE", DateHelper.getBusinessDate());
			ba.setAttributeValue("APPROVESTATUS", "04");
			//���ʱ���¶��״̬
			BizObjectManager clbom = JBOFactory.getBizObjectManager("jbo.cl.CL_INFO");
			tx.join(clbom);
			clbom.createQuery("update O set Status = '50' where ObjectType = 'jbo.app.BUSINESS_CONTRACT' and ObjectNo = :ObjectNo and Status = '10'")
			.setParameter("ObjectNo",ba.getAttribute("CONTRACTARTIFICIALNO").getString()).executeUpdate();
			bcm.createQuery("update O set ContractStatus = '05' where ApplySerialNo = :ApplySerialNo")
			.setParameter("ApplySerialNo",applySerialNo).executeUpdate();
			bpm.createQuery("update O set PutOutStatus = '06' where ApplySerialNo = :ApplySerialNo")
			.setParameter("ApplySerialNo",applySerialNo).executeUpdate();
			List<BizObject> arbList = arb.getResultList(false);
			for(BizObject ar:arbList){
				String serialNo = ar.getAttribute("ObjectNo").toString();
				//���ʱ�����ױʵĶ��״̬
				BizObjectQuery clbc = bam.createQuery("SerialNo=:SerialNo");
				clbc.setParameter("SerialNo", serialNo);
				BizObject clbcs = clbc.getSingleResult(false);
				clbom.createQuery("update O set Status = '50' where ObjectType = 'jbo.app.BUSINESS_CONTRACT' and ObjectNo = :ObjectNo and Status = '10'")
				.setParameter("ObjectNo",clbcs.getAttribute("CONTRACTARTIFICIALNO").getString()).executeUpdate();
				
				bam.createQuery("UPDATE O SET APPROVESTATUS = '04',APPROVEORGID = :APPROVEORGID,APPROVEUSERID = :APPROVEUSERID,APPROVEDATE = :APPROVEDATE WHERE SERIALNO = :SERIALNO")
				.setParameter("APPROVEORGID", this.orgID).setParameter("APPROVEUSERID", this.userID).setParameter("APPROVEDATE", DateHelper.getBusinessDate()).setParameter("SERIALNO", serialNo).executeUpdate();
				bcm.createQuery("update O set ContractStatus = '05' where ApplySerialNo = :ApplySerialNo")
				.setParameter("ApplySerialNo",serialNo).executeUpdate();
				bpm.createQuery("update O set PutOutStatus = '06' where ApplySerialNo = :ApplySerialNo")
				.setParameter("ApplySerialNo",serialNo).executeUpdate();
			}
			try
			{
				FlowSendMessageUserAction fsmua = new FlowSendMessageUserAction();
				fsmua.setMessageID("016");
				fsmua.setObjectNo(applySerialNo);
				fsmua.setObjectType("jbo.app.BUSINESS_APPLY");
				fsmua.setUserID(ba.getAttribute("OperateUserID").getString());
				fsmua.sendMessage(tx);
			}catch(Exception ex)
			{
				ex.printStackTrace();
			}
		}
		else{
			//�˻�ʱ���¶��״̬
			BizObjectManager clbom = JBOFactory.getBizObjectManager("jbo.cl.CL_INFO");
			tx.join(clbom);
			clbom.createQuery("update O set Status = '50' where ObjectType = 'jbo.app.BUSINESS_CONTRACT' and ObjectNo = :ObjectNo and Status = '10'")
			.setParameter("ObjectNo",ba.getAttribute("CONTRACTARTIFICIALNO").getString()).executeUpdate();
			ba.setAttributeValue("APPROVESTATUS", "02");
			bcm.createQuery("update O set ContractStatus = '05' where ApplySerialNo = :ApplySerialNo")
			.setParameter("ApplySerialNo",applySerialNo).executeUpdate();
			bpm.createQuery("update O set PutOutStatus = '04' where ApplySerialNo = :ApplySerialNo")
			.setParameter("ApplySerialNo",applySerialNo).executeUpdate();
			List<BizObject> arbList = arb.getResultList(false);
			for(BizObject ar:arbList){
				String serialNo = ar.getAttribute("ObjectNo").toString();
				//�˻�ʱ�����ױʵĶ��״̬
				BizObjectQuery clbc = bam.createQuery("SerialNo=:SerialNo");
				clbc.setParameter("SerialNo", serialNo);
				BizObject clbcs = clbc.getSingleResult(false);
				clbom.createQuery("update O set Status = '50' where ObjectType = 'jbo.app.BUSINESS_CONTRACT' and ObjectNo = :ObjectNo and Status = '10'")
				.setParameter("ObjectNo",clbcs.getAttribute("CONTRACTARTIFICIALNO").getString()).executeUpdate();
				
				bam.createQuery("UPDATE O SET APPROVESTATUS = '02' WHERE SERIALNO = :SERIALNO")
				.setParameter("SERIALNO", serialNo).executeUpdate();
				bcm.createQuery("update O set ContractStatus = '05' where ApplySerialNo = :ApplySerialNo")
				.setParameter("ApplySerialNo",serialNo).executeUpdate();
				bpm.createQuery("update O set PutOutStatus = '04' where ApplySerialNo = :ApplySerialNo")
				.setParameter("ApplySerialNo",serialNo).executeUpdate();
			}
		}
		bam.saveObject(ba);
		
		
		return ba.getAttribute("SerialNo").getString();
	}
	
	
	private void updateBCCL(BizObject bc,BizObject clbo) throws Exception
	{
		String contractDate = DateHelper.getBusinessDate();
		String maturityDate = clbo.getAttribute("MaturityDate").getString();
		bc.setAttributeValue("CONTRACTDATE",contractDate);
		clbo.setAttributeValue("STARTDATE", contractDate);

		
		int month = (int) Math.floor(DateHelper.getMonths(contractDate, DateHelper.getRelativeDate(maturityDate, DateHelper.TERM_UNIT_DAY, 1)));
		int day = DateHelper.getDays(DateHelper.getRelativeDate(contractDate, DateHelper.TERM_UNIT_MONTH, month), DateHelper.getRelativeDate(maturityDate, DateHelper.TERM_UNIT_DAY, 1));
		bc.setAttributeValue("BusinessTerm",month);
		bc.setAttributeValue("BusinessTermDay",day);
		
		bc.setAttributeValue("MATURITYDATE",DateHelper.getRelativeDate(maturityDate, DateHelper.TERM_UNIT_DAY, 1));
	} 
	
	/**
	 * ����Ӱ���ϴ��ĵ�״̬
	 * @param tx
	 * @throws Exception
	 */
	public String updateDOC(JBOTransaction tx) throws Exception{
		//���ɺ�ͬ��Ϣ
		//��ѯ���������Ϣ
		BizObjectManager bam = JBOFactory.getBizObjectManager("jbo.app.BUSINESS_APPLY");
		tx.join(bam);
		BizObjectQuery baq = bam.createQuery("SerialNo=:ApplySerialNo");
		baq.setParameter("ApplySerialNo", applySerialNo);
		BizObject ba = baq.getSingleResult(false);
		if(ba == null ) throw new Exception("δ�ҵ���Ӧ������Ϣ������������Ϣ��");
		
		BizObjectManager dcm = JBOFactory.getBizObjectManager("jbo.doc.DOC_FILE_INFO");
		tx.join(dcm);
		BizObjectQuery dcq = dcm.createQuery("update O set status='03' where objectNo = :objectNo and objectType='contract'");
		dcq.setParameter("objectNo", ba.getAttribute("contractartificialno").getString());
		dcq.executeUpdate();
		
		return "true";
	}
	
}
