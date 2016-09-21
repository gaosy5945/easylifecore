package com.amarsoft.app.als.customer.common.action;

/**
 * Author:t-liuxt
 */

import java.util.List;

import com.amarsoft.are.jbo.BizObject;
import com.amarsoft.are.jbo.BizObjectManager;
import com.amarsoft.are.jbo.BizObjectQuery;
import com.amarsoft.are.jbo.JBOFactory;
import com.amarsoft.are.jbo.JBOTransaction;

public class CustomerNameChange {
	private JBOTransaction tx;

	public void setTx(JBOTransaction tx) {
		this.tx = tx;
	}
	//���˿ͻ����Ʊ��
	public void changeIndCustomerName(String CustomerID,String CustomerName,JBOTransaction tx) throws Exception{
		
		//������������ͻ����������޸�
		BizObjectManager tableBA = JBOFactory.getBizObjectManager("jbo.app.BUSINESS_APPLY");
		tx.join(tableBA);
		BizObjectQuery qBA = tableBA.createQuery("CustomerID=:CustomerID").setParameter("CustomerID", CustomerID);
		List<BizObject> baList = qBA.getResultList(true);
		if(baList!=null){
			for(BizObject bo:baList){
				bo.setAttributeValue("CUSTOMERNAME", CustomerName);
				tableBA.saveObject(bo);
			}
		}
		
		//������������ͻ����������޸�
		BizObjectManager tableBC = JBOFactory.getBizObjectManager("jbo.app.BUSINESS_CONTRACT");
		tx.join(tableBC);
		BizObjectQuery qBC = tableBC.createQuery("CustomerID=:CustomerID").setParameter("CustomerID", CustomerID);
		List<BizObject> bcList = qBC.getResultList(true);
		if(bcList!=null){
			for(BizObject bo:bcList){
				bo.setAttributeValue("CUSTOMERNAME", CustomerName);
				tableBC.saveObject(bo);
			}
		}
		
		//������ݱ����ͻ����������޸�
		BizObjectManager tableBD = JBOFactory.getBizObjectManager("jbo.app.BUSINESS_DUEBILL");
		tx.join(tableBD);
		BizObjectQuery qBD = tableBD.createQuery("CustomerID=:CustomerID").setParameter("CustomerID", CustomerID);
		List<BizObject> bdList = qBD.getResultList(true);
		if(bdList!=null){
			for(BizObject bo:bdList){
				bo.setAttributeValue("CUSTOMERNAME", CustomerName);
				tableBD.saveObject(bo);
			}
		}
		
		//�����ſ�����ͻ����������޸�
		BizObjectManager tableBP = JBOFactory.getBizObjectManager("jbo.app.BUSINESS_PUTOUT");
		tx.join(tableBP);
		BizObjectQuery qBP = tableBP.createQuery("CustomerID=:CustomerID").setParameter("CustomerID", CustomerID);
		List<BizObject> bpList = qBP.getResultList(true);
		if(bpList!=null){
			for(BizObject bo:bpList){
				bo.setAttributeValue("CUSTOMERNAME", CustomerName);
				tableBP.saveObject(bo);
			}
		}
		
		//������ͬ�����˱����ͻ����������޸�
		BizObjectManager tableBAP = JBOFactory.getBizObjectManager("jbo.app.BUSINESS_APPLICANT");
		tx.join(tableBAP);
		BizObjectQuery qBAP = tableBAP.createQuery("ApplicantID=:ApplicantID").setParameter("ApplicantID", CustomerID);
		List<BizObject> bapList = qBAP.getResultList(true);
		if(bapList!=null){
			for(BizObject bo:bapList){
				bo.setAttributeValue("APPLICANTNAME", CustomerName);
				tableBAP.saveObject(bo);
			}
		}
		
		//����ѺƷ�����˱����ͻ����������޸�
		BizObjectManager tableAO = JBOFactory.getBizObjectManager("jbo.app.ASSET_OWNER");
		tx.join(tableAO);
		BizObjectQuery qAO = tableAO.createQuery("CustomerID=:CustomerID").setParameter("CustomerID", CustomerID);
		List<BizObject> baoList = qAO.getResultList(true);
		if(baoList!=null){
			for(BizObject bo:baoList){
				bo.setAttributeValue("CUSTOMERNAME", CustomerName);
				tableAO.saveObject(bo);
			}
		}
		
		//�����ͻ���������Ϣ�����ͻ����������޸�
		BizObjectManager tableCR = JBOFactory.getBizObjectManager("jbo.customer.CUSTOMER_RELATIVE");
		tx.join(tableCR);
		BizObjectQuery qCR = tableCR.createQuery("RelativeCustomerID=:RelativeCustomerID").setParameter("RelativeCustomerID", CustomerID);
		List<BizObject> bcrList = qCR.getResultList(true);
		if(bcrList!=null){
			for(BizObject bo:bcrList){
				bo.setAttributeValue("RELATIVECUSTOMERNAME", CustomerName);
				tableCR.saveObject(bo);
			}
		}
		
		//����������Ϣ�����ͻ����������޸�
		BizObjectManager tableGC = JBOFactory.getBizObjectManager("jbo.guaranty.GUARANTY_CONTRACT");
		tx.join(tableGC);
		BizObjectQuery qGC = tableGC.createQuery("GuarantorID=:GuarantorID").setParameter("GuarantorID", CustomerID);
		List<BizObject> bgcList = qGC.getResultList(true);
		if(bgcList!=null){
			for(BizObject bo:bgcList){
				bo.setAttributeValue("GUARANTORNAME", CustomerName);
				tableGC.saveObject(bo);
			}
		}
		
		//�������������Ϣ�����ͻ����������޸�
		BizObjectManager tableGCC = JBOFactory.getBizObjectManager("jbo.guaranty.GUARANTY_CONTRACT_CHANGE");
		tx.join(tableGCC);
		BizObjectQuery qGCC = tableGCC.createQuery("GuarantorID=:GuarantorID").setParameter("GuarantorID", CustomerID);
		List<BizObject> bgccList = qGCC.getResultList(true);
		if(bgccList!=null){
			for(BizObject bo:bgccList){
				bo.setAttributeValue("GUARANTORNAME", CustomerName);
				tableGCC.saveObject(bo);
			}
		}
		
		//�������������Ϣ�����ͻ����������޸�
		BizObjectManager tablePP = JBOFactory.getBizObjectManager("jbo.prj.PRJ_PARTICIPANT");
		tx.join(tablePP);
		BizObjectQuery qPP = tablePP.createQuery("CustomerID=:CustomerID").setParameter("CustomerID", CustomerID);
		List<BizObject> bppList = qPP.getResultList(true);
		if(bppList!=null){
			for(BizObject bo:bppList){
				bo.setAttributeValue("CUSTOMERNAME", CustomerName);
				tablePP.saveObject(bo);
			}
		}
	}
	//��˾�ͻ����Ʊ��
	public void changeEntCustomerName(String CustomerID,String CustomerName,JBOTransaction tx) throws Exception{
		
		//�����ͻ���������Ϣ�����ͻ����������޸�
		BizObjectManager tableCR = JBOFactory.getBizObjectManager("jbo.customer.CUSTOMER_RELATIVE");
		tx.join(tableCR);
		BizObjectQuery qCR = tableCR.createQuery("RelativeCustomerID=:RelativeCustomerID").setParameter("RelativeCustomerID", CustomerID);
		List<BizObject> bcrList = qCR.getResultList(true);
		if(bcrList!=null){
			for(BizObject bo:bcrList){
				bo.setAttributeValue("RELATIVECUSTOMERNAME", CustomerName);
				tableCR.saveObject(bo);
			}
		}
		
		//�����������Ƹ���ʱ��ͬ������Customer_List���е�����
		BizObjectManager tableCL = JBOFactory.getBizObjectManager("jbo.customer.CUSTOMER_LIST");
		tx.join(tableCL);

		BizObjectQuery qCL = tableCL.createQuery("CustomerID=:CustomerID and ListType like '00%' and ListType <> '00'").setParameter("CustomerID", CustomerID);
		BizObject cl = qCL.getSingleResult(true);
		
		if(cl != null)
		{
			cl.setAttributeValue("CUSTOMERNAME", CustomerName);
			tableCL.saveObject(cl);
		}
		
		//������������Ϣ�����ͻ����������޸�
		BizObjectManager tableBD = JBOFactory.getBizObjectManager("jbo.app.BUILDING_DEVELOPER");
		tx.join(tableBD);
		BizObjectQuery qBD = tableBD.createQuery("CustomerID=:CustomerID").setParameter("CustomerID", CustomerID);
		List<BizObject> bbdList = qBD.getResultList(true);
		if(bbdList!=null){
			for(BizObject bo:bbdList){
				bo.setAttributeValue("CUSTOMERNAME", CustomerName);
				tableBD.saveObject(bo);
			}
		}
		
		//����ҵ�������Ϣ�����ͻ����������޸�
		BizObjectManager tableBI = JBOFactory.getBizObjectManager("jbo.app.BUSINESS_INVEST");
		tx.join(tableBI);
		BizObjectQuery qBI = tableBI.createQuery("RelaCustomerID=:RelaCustomerID").setParameter("RelaCustomerID", CustomerID);
		List<BizObject> bbiList = qBI.getResultList(true);
		if(bbiList!=null){
			for(BizObject bo:bbiList){
				bo.setAttributeValue("RELACUSTOMERNAME", CustomerName);
				tableBI.saveObject(bo);
			}
		}
		
		//����������Ϣ�����ͻ����������޸�
		BizObjectManager tableGC = JBOFactory.getBizObjectManager("jbo.guaranty.GUARANTY_CONTRACT");
		tx.join(tableGC);
		BizObjectQuery qGC = tableGC.createQuery("GuarantorID=:GuarantorID").setParameter("GuarantorID", CustomerID);
		List<BizObject> bgcList = qGC.getResultList(true);
		if(bgcList!=null){
			for(BizObject bo:bgcList){
				bo.setAttributeValue("GUARANTORNAME", CustomerName);
				tableGC.saveObject(bo);
			}
		}
		
		//�������������Ϣ�����ͻ����������޸�
		BizObjectManager tableGCC = JBOFactory.getBizObjectManager("jbo.guaranty.GUARANTY_CONTRACT_CHANGE");
		tx.join(tableGCC);
		BizObjectQuery qGCC = tableGCC.createQuery("GuarantorID=:GuarantorID").setParameter("GuarantorID", CustomerID);
		List<BizObject> bgccList = qGCC.getResultList(true);
		if(bgccList!=null){
			for(BizObject bo:bgccList){
				bo.setAttributeValue("GUARANTORNAME", CustomerName);
				tableGCC.saveObject(bo);
			}
		}
	}
	
}
