package com.amarsoft.app.als.credit.putout.action;

import java.util.Date;
import java.util.List;

import com.amarsoft.app.als.sys.tools.SYSNameManager;
import com.amarsoft.app.base.util.DateHelper;
import com.amarsoft.are.jbo.BizObject;
import com.amarsoft.are.jbo.BizObjectManager;
import com.amarsoft.are.jbo.BizObjectQuery;
import com.amarsoft.are.jbo.JBOFactory;
import com.amarsoft.are.jbo.JBOTransaction;
import com.amarsoft.awe.util.ASResultSet;
import com.amarsoft.awe.util.DBKeyHelp;
import com.amarsoft.awe.util.SqlObject;
import com.amarsoft.awe.util.Transaction;

/**
 * �����������Ϣ���������Ϣ���Ƶ���ͬ��
 * @author xjzhao
 *
 */
public class AddPutOutInfo{
	
	private String userID;
	private String orgID;
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
	 * ���ɺ�ͬ��Ϣ�������º�ͬ��ˮ
	 * @param tx
	 * @throws Exception
	 */
	public BizObject createPutOut(JBOTransaction tx) throws Exception{
		//���ɺ�ͬ��Ϣ
		//��ѯ��ͬ������Ϣ
		BizObjectManager bcm = JBOFactory.getBizObjectManager("jbo.app.BUSINESS_CONTRACT");
		tx.join(bcm);
		BizObjectQuery bcq = bcm.createQuery("SerialNo=:ContractSerialNo");
		bcq.setParameter("ContractSerialNo", contractSerialNo);
		BizObject bc = bcq.getSingleResult(false);
		if(bc == null ) throw new Exception("δ�ҵ���Ӧ������Ϣ������������Ϣ��");
		
		//���ɳ��˻�����Ϣ
		BizObjectManager bpm = JBOFactory.getBizObjectManager("jbo.app.BUSINESS_PUTOUT");
		tx.join(bpm);
		
		BizObjectQuery bpq = bpm.createQuery("ContractSerialNo=:ContractSerialNo");
		bpq.setParameter("ContractSerialNo", bc.getAttribute("SerialNo").getString());
		BizObject bp = bpq.getSingleResult(true);
		String putoutSerialNo=null;
		if(bp == null)
		{
			bp = bpm.newObject();
		}
		else
		{
			putoutSerialNo = bp.getAttribute("SERIALNO").getString();
		}
		bp.setAttributesValue(bc);
		bp.setAttributeValue("SERIALNO", putoutSerialNo);
		
		String contractArtificialNo = bc.getAttribute("ContractArtificialNo").getString();
		if(contractArtificialNo != null && !"".equals(contractArtificialNo) && contractArtificialNo.length()>=14) contractArtificialNo = contractArtificialNo.substring(0, 14);
		
		if(bp.getAttribute("DuebillSerialNo").getString() == null || "".equals(bp.getAttribute("DuebillSerialNo").getString()))
		{
			String duebillNo = DBKeyHelp.getSerialNo("BUSINESS_DUEBILL", "SERIALNO", contractArtificialNo, "00", new Date());
			bp.setAttributeValue("DuebillSerialNo", duebillNo);
		}
		
		//���˽�����
		//bp.setAttributeValue("BUSINESSSUM",getPutOutSum(contractSerialNo, Transaction.createTransaction(tx)));
		//�����˵�������Ϣ����
		bp.setAttributeValue("TEMPSAVEFLAG", "0");
		if(putoutStatus == null || "".equals(putoutStatus)) putoutStatus = "01";
		bp.setAttributeValue("PUTOUTSTATUS", putoutStatus);				
		bp.setAttributeValue("InputOrgID", orgID);
		bp.setAttributeValue("InputUserID", userID);
		bp.setAttributeValue("InputDate", DateHelper.getBusinessDate());
		bp.setAttributeValue("UpdateDate", DateHelper.getBusinessDate());
		bp.setAttributeValue("CONTRACTSERIALNO", bc.getAttribute("SerialNo"));
		bpm.saveObject(bp);
			
			
		//������������
		this.copyRelative(tx, "jbo.acct.ACCT_RATE_SEGMENT", bc.getBizObjectClass().getRoot().getAbsoluteName(), contractSerialNo, bp.getBizObjectClass().getRoot().getAbsoluteName(), bp.getAttribute("SerialNo").getString());
		this.copyRelative(tx, "jbo.acct.ACCT_RPT_SEGMENT", bc.getBizObjectClass().getRoot().getAbsoluteName(), contractSerialNo, bp.getBizObjectClass().getRoot().getAbsoluteName(), bp.getAttribute("SerialNo").getString());
		this.copyRelative(tx, "jbo.acct.ACCT_BUSINESS_ACCOUNT", bc.getBizObjectClass().getRoot().getAbsoluteName(), contractSerialNo, bp.getBizObjectClass().getRoot().getAbsoluteName(), bp.getAttribute("SerialNo").getString());
		
		this.copyRelative(tx, "jbo.app.BUSINESS_TRADE", bc.getBizObjectClass().getRoot().getAbsoluteName(), contractSerialNo, bp.getBizObjectClass().getRoot().getAbsoluteName(), bp.getAttribute("SerialNo").getString());
		this.copyRelative(tx, "jbo.app.BUSINESS_INVEST", bc.getBizObjectClass().getRoot().getAbsoluteName(), contractSerialNo, bp.getBizObjectClass().getRoot().getAbsoluteName(), bp.getAttribute("SerialNo").getString());
		this.copyRelative(tx, "jbo.app.BUSINESS_EDUCATION", bc.getBizObjectClass().getRoot().getAbsoluteName(), contractSerialNo, bp.getBizObjectClass().getRoot().getAbsoluteName(), bp.getAttribute("SerialNo").getString());
		
		
		return bp;
	}
	
	public String getPutOutSum(String contractSerialNo, Transaction Sqlca) throws Exception {
		String sSql = null,sSql1 = null,sSql2 = null, putOutSum = "", revolveFlag = "";
		double dBCBusinessSum = 0.0, dBCBalance = 0.0, dPutOutSum = 0.0,dPutOutSum1 = 0.0,dPutOutSum2 = 0.0;
		// ��ѯ�����
		ASResultSet rs = null;
		// ���ݺ�ͬ��ˮ�Ż�ȡѭ����־
		sSql = " select BusinessSum,Balance,RevolveFlag "
				+ " from BUSINESS_CONTRACT " + " where SerialNo = :contractSerialNo";
		rs = Sqlca.getASResultSet(new SqlObject(sSql).setParameter("contractSerialNo", contractSerialNo));
		if (rs.next()) {
			dBCBalance = rs.getDouble("Balance");
			dBCBusinessSum = rs.getDouble("BusinessSum");
			revolveFlag = rs.getString("RevolveFlag");
			if (revolveFlag == null)
				revolveFlag = "";
		}
		rs.getStatement().close();
		
		//����ú�ͬ�������С��ලͨ�����ѷ��ͺ��ĵķſ����ܺ�
		sSql1 = " select sum(BUSINESSSUM) as BusinessSum"
				+ " from BUSINESS_PUTOUT " + " where PutOutStatus in ('01','02','03') and CONTRACTSERIALNO = :sContractSerialNo";
		rs = Sqlca.getASResultSet(new SqlObject(sSql1).setParameter("sContractSerialNo", this.contractSerialNo));
		if (rs.next()) {
			dPutOutSum1 = rs.getDouble("BusinessSum");
		}
		rs.getStatement().close();
		
		//����ú�ͬ�º����ѷ��Ž��
		sSql2 = " select sum(BUSINESSSUM) as BusinessSum"
				+ " from BUSINESS_PUTOUT " + " where PutOutStatus ='05' and CONTRACTSERIALNO = :sContractSerialNo";
		rs = Sqlca.getASResultSet(new SqlObject(sSql2).setParameter("sContractSerialNo", this.contractSerialNo));
		if (rs.next()) {
			dPutOutSum2 = rs.getDouble("BusinessSum");
		}
		rs.getStatement().close();
		
		if (revolveFlag.equals("1")) // ѭ����־��1���ǣ�2����
			// ��ѭ����ͬ�Ŀɳ��˽�� = ��ͬ��� - ���˱��ѳ����޽�ݵĽ�� - ��ͬ���			
			dPutOutSum = dBCBusinessSum - dPutOutSum1 + dPutOutSum2 - dBCBalance;
		else
			// ����ѭ����ͬ�Ŀɳ��˽�� = ��ͬ��� - ���˱��ѳ�������������н�� 
			dPutOutSum = dBCBusinessSum - dPutOutSum1 - dPutOutSum2;		
		putOutSum = String.valueOf(dPutOutSum);
		
		return putOutSum;
	}
	
	
	private void copyRelative(JBOTransaction tx,String copyObject,String fromObjectType,String fromObjectNo,String toObjectType,String toObjectNo) throws Exception{
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
				m.saveObject(newBo);
			}
		}
	}
}
