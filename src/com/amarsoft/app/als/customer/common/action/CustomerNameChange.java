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
	//个人客户名称变更
	public void changeIndCustomerName(String CustomerID,String CustomerName,JBOTransaction tx) throws Exception{
		
		//遍历申请表，将客户姓名进行修改
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
		
		//遍历贷款表，将客户姓名进行修改
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
		
		//遍历借据表，将客户姓名进行修改
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
		
		//遍历放款表，将客户姓名进行修改
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
		
		//遍历共同还款人表，将客户姓名进行修改
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
		
		//遍历押品所有人表，将客户姓名进行修改
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
		
		//遍历客户关联人信息表，将客户姓名进行修改
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
		
		//遍历担保信息表，将客户姓名进行修改
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
		
		//遍历担保变更信息表，将客户姓名进行修改
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
		
		//遍历担保变更信息表，将客户姓名进行修改
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
	//公司客户名称变更
	public void changeEntCustomerName(String CustomerID,String CustomerName,JBOTransaction tx) throws Exception{
		
		//遍历客户关联人信息表，将客户姓名进行修改
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
		
		//当合作方名称更新时，同步更新Customer_List表中的名称
		BizObjectManager tableCL = JBOFactory.getBizObjectManager("jbo.customer.CUSTOMER_LIST");
		tx.join(tableCL);

		BizObjectQuery qCL = tableCL.createQuery("CustomerID=:CustomerID and ListType like '00%' and ListType <> '00'").setParameter("CustomerID", CustomerID);
		BizObject cl = qCL.getSingleResult(true);
		
		if(cl != null)
		{
			cl.setAttributeValue("CUSTOMERNAME", CustomerName);
			tableCL.saveObject(cl);
		}
		
		//遍历开发商信息表，将客户姓名进行修改
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
		
		//遍历业务调查信息表，将客户姓名进行修改
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
		
		//遍历担保信息表，将客户姓名进行修改
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
		
		//遍历担保变更信息表，将客户姓名进行修改
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
