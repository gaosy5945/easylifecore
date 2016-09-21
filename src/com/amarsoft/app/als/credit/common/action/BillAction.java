package com.amarsoft.app.als.credit.common.action;

import com.amarsoft.app.util.RunJavaMethodAssistant;
import com.amarsoft.are.jbo.BizObject;
import com.amarsoft.are.jbo.BizObjectManager;
import com.amarsoft.are.jbo.BizObjectQuery;
import com.amarsoft.are.jbo.JBOException;
import com.amarsoft.are.jbo.JBOFactory;
import com.amarsoft.are.jbo.JBOTransaction;
import com.amarsoft.are.util.DataConvert;
import com.amarsoft.are.util.StringFunction;
import com.amarsoft.awe.util.Transaction;
/**
 * ��ȡ���õ������̲���
 * @author xfliu
 * 07/27/2011
 */
public class BillAction {
	private String BankID; //֧���к�
	private String BankName; //֧������
	private String ObjectNo; //������
	private String ObjectType; //������
	private String cnapsID;//���֧���к�
	
	public String getBankID() {
		return BankID;
	}

	public void setBankID(String bankID) {
		this.BankID = bankID;
	}
	
	public String getBankName() {
		return BankName;
	}

	public void setBankName(String bankName) {
		this.BankName = bankName;
	}
	public String getObjectNo() {
		return ObjectNo;
	}

	public void setObjectNo(String objectNo) {
		this.ObjectNo = objectNo;
	}
	
	public String getObjectType() {
		return ObjectType;
	}

	public void setObjectType(String objectType) {
		this.ObjectType = objectType;
	}

	public String getCustomerID() throws JBOException {
		BizObject bo = null,task = null;
		BizObjectManager bm = null;
		BizObjectQuery bq = null;
		bm = JBOFactory.getFactory().getManager("jbo.sys.CODE_LIBRARY");
		bq = bm.createQuery("CodeNo = 'BankName' and ItemNo=:ItemNo").setParameter("ItemNo", BankID);
		bo = bq.getSingleResult();
		String sReturn = "false";
		if(bo != null){			
			String BankName = bo.getAttribute("ItemName").toString();
			bm = JBOFactory.getFactory().getManager("jbo.app.ENT_INFO");
			bq = bm.createQuery("(ENTERPRISENAME like v.'%'|| :BankName v.||'%' or :BankName like v.'%'|| ENTERPRISENAME v.||'%' or SimpleName like v.'%'|| :BankName v.||'%' or :BankName like v.'%'|| SimpleName v.||'%') and O.SimpleName is not null and exists(select 'X' from jbo.app.CUSTOMER_INFO CI where CI.CustomerID = O.CustomerID and CI.CustomerType = '04') ").setParameter("BankName", BankName);
			bo = bq.getSingleResult();
			if(bo == null)
				return "false";
			else
			{
				String sCustomerID = bo.getAttribute("CustomerID").getString();
				String sCustomerName = bo.getAttribute("ENTERPRISENAME").getString();
				sReturn = sCustomerID+"@"+sCustomerName;
			}
		}
		return sReturn;
	}
	
	//��Ӹ�����صĻ�Ʊ���� add by gftang 2013-12-24
	public void UpdateBusinessSum() throws Exception
    {
    	//����Ʊ�������������ͻ�Ʊ����
    	try
    	{
	    	String sObjectType = this.ObjectType;
			String sObjectNo  = this.ObjectNo;
			BizObjectManager bm = com.amarsoft.are.jbo.JBOFactory.getFactory().getManager("jbo.app.BILL_INFO");
	    	BizObjectQuery bq=bm.createQuery(" select sum(BillSum),count(*) from o where ObjectNo=:ObjectNo and ObjectType=:ObjectType");
			bq.setParameter("ObjectType",sObjectType);
			bq.setParameter("ObjectNo",sObjectNo);
			BizObject bo = bq.getSingleResult();
			if(bo != null) 
			{
				//double dBillSum = bo.getAttribute("1").getDouble();//db2�¿��ã�oracle�º�̨����
				//int count=bo.getAttribute("2").getInt();
				double dBillSum = bo.getAttribute(54).getDouble();
				int count=bo.getAttribute(55).getInt();//modify by lyin 2014-01-20

				if("CreditApply".equals(sObjectType))
				{
					BizObjectManager bmC = com.amarsoft.are.jbo.JBOFactory.getFactory().getManager("jbo.app.BUSINESS_APPLY");
					bmC.createQuery("update O set EXPOSURESUM = "+com.amarsoft.are.util.DataConvert.toMoney(dBillSum).replaceAll(",","")+", BusinessSum = "+com.amarsoft.are.util.DataConvert.toMoney(dBillSum).replaceAll(",","")+" where SerialNo = '"+sObjectNo+"' ").executeUpdate();
					bmC.createQuery("update O set BillNum = "+count+" where SerialNo = '"+sObjectNo+"' ").executeUpdate();
				}
				else if("ApproveApply".equals(sObjectType))
				{
					BizObjectManager bmC = com.amarsoft.are.jbo.JBOFactory.getFactory().getManager("jbo.app.BUSINESS_APPROVE");
					bmC.createQuery("update O set EXPOSURESUM = "+com.amarsoft.are.util.DataConvert.toMoney(dBillSum).replaceAll(",","")+", BusinessSum = "+com.amarsoft.are.util.DataConvert.toMoney(dBillSum).replaceAll(",","")+" where SerialNo = '"+sObjectNo+"' ").executeUpdate();
					bmC.createQuery("update O set BillNum = "+count+" where SerialNo = '"+sObjectNo+"' ").executeUpdate();
				}
				else if("BusinessContract".equals(sObjectType))
				{
					BizObjectManager bmC = com.amarsoft.are.jbo.JBOFactory.getFactory().getManager("jbo.app.BUSINESS_CONTRACT");
					bmC.createQuery("update O set EXPOSURESUM = "+com.amarsoft.are.util.DataConvert.toMoney(dBillSum).replaceAll(",","")+", BusinessSum = "+com.amarsoft.are.util.DataConvert.toMoney(dBillSum).replaceAll(",","")+" where SerialNo = '"+sObjectNo+"' ").executeUpdate();
					bmC.createQuery("update O set BillNum = "+count+" where SerialNo = '"+sObjectNo+"' ").executeUpdate();
				}
			}
    	}catch(Exception ex)
    	{
    		ex.printStackTrace();
    		throw ex;
    	}
    }
	
	public void UpdateBusinessSum1() throws Exception
    {
		
    	//����Ʊ�������������
    	try
    	{
	    	String sObjectType = this.ObjectType;
			String sObjectNo  = this.ObjectNo;
			BizObjectManager bm = com.amarsoft.are.jbo.JBOFactory.getFactory().getManager("jbo.app.BILL_INFO");
	    	BizObjectQuery bq=bm.createQuery(" select v.sum(BI.BillSum) as v.DBillSum from jbo.app.BILL_INFO BI where BI.ObjectNo=:ObjectNo and BI.ObjectType=:ObjectType");
			bq.setParameter("ObjectType",sObjectType);
			bq.setParameter("ObjectNo",sObjectNo);
			BizObject bo = bq.getSingleResult();
			if(bo != null) 
			{
				double dBillSum = bo.getAttribute("DBillSum").getDouble();
				if("CreditApply".equals(sObjectType))
				{
					/*
					BizObjectManager bmC = com.amarsoft.are.jbo.JBOFactory.getFactory().getManager("jbo.app.BUSINESS_APPLY");
					bmC.createQuery("update O set BusinessSum = "+com.amarsoft.are.util.DataConvert.toMoney(dBillSum).replaceAll(",","")+" where SerialNo = '"+sObjectNo+"' ").executeUpdate();
					JBOTransaction tx = com.amarsoft.are.jbo.JBOFactory.getFactory().createTransaction();
					BizObject boBA = bmC.createQuery("SerialNo=:SerialNo").setParameter("SerialNo", sObjectNo).getSingleResult();
					ChangeLMTPara.changLMTBasPara(tx, boBA,sObjectType);
					tx.commit();
					*/
				}
				else if("ApproveApply".equals(sObjectType))
				{
					/*
					BizObjectManager bmC = com.amarsoft.are.jbo.JBOFactory.getFactory().getManager("jbo.app.BUSINESS_APPROVE");
					bmC.createQuery("update O set BusinessSum = "+com.amarsoft.are.util.DataConvert.toMoney(dBillSum).replaceAll(",","")+" where SerialNo = '"+sObjectNo+"' ").executeUpdate();
					try
					{
						JBOTransaction tx = com.amarsoft.are.jbo.JBOFactory.getFactory().createTransaction();
						BizObject boBA = bmC.createQuery("SerialNo=:SerialNo").setParameter("SerialNo", sObjectNo).getSingleResult();
						ChangeLMTPara.changLMTBasPara(tx, boBA,sObjectType);
						tx.commit();
					}catch(Exception ex)
					{
						ex.printStackTrace();
					}*/
				}
				else if("BusinessContract".equals(sObjectType))
				{
					/*
					BizObjectManager bmC = com.amarsoft.are.jbo.JBOFactory.getFactory().getManager("jbo.app.BUSINESS_CONTRACT");
					bmC.createQuery("update O set BusinessSum = "+com.amarsoft.are.util.DataConvert.toMoney(dBillSum).replaceAll(",","")+" where SerialNo = '"+sObjectNo+"' ").executeUpdate();
					*/
				}
				else if("BusinessPutOut".equals(sObjectType))
				{
					BizObjectManager bmBP = com.amarsoft.are.jbo.JBOFactory.getFactory().getManager("jbo.app.BUSINESS_PUTOUT");
					BizObjectQuery boqBP = bmBP.createQuery("SerialNo = :SerialNo").setParameter("SerialNo",sObjectNo);
					BizObject boBP = boqBP.getSingleResult();
					if(boBP == null) throw new Exception("δȡ����س�����Ϣ��");
					BizObjectManager bmBC = com.amarsoft.are.jbo.JBOFactory.getFactory().getManager("jbo.app.BUSINESS_CONTRACT");
					BizObjectQuery boqBC = bmBC.createQuery("SerialNo = :SerialNo").setParameter("SerialNo",boBP.getAttribute("ContractSerialNo").getString());
					BizObject boBC = boqBC.getSingleResult();
					if(boBC == null) throw new Exception("δȡ����Ӧ��ͬ��Ϣ��");
					
					double dPDGRatio = boBC.getAttribute("PDGRATIO").getDouble();//�����ѱ���
					double dPDGSum = dPDGRatio * dBillSum /1000.0;
					//boBP.setAttributeValue("BusinessSum", dBillSum); //�����Գ��˽��
					boBP.setAttributeValue("PDGSum", dPDGSum);
					bmBP.saveObject(boBP);
					//----���¹����ֽ���ѺƷ������Ϣ��   add by dffang 2011��11��30��22:15:50
//					AddPutOutInfo aoi = new AddPutOutInfo();				 
//					aoi.initRelaCashInfo(boBP, boBC,com.amarsoft.are.jbo.JBOFactory.getFactory().createTransaction());
				}
			}
    	}catch(Exception ex)
    	{
    		ex.printStackTrace();
    		throw ex;
    	}
    }
	
	/**
	 *�Ƿ����ָ�����������Ʊ��
	 * @throws JBOException 
	 */
	public String isExists() throws JBOException{
		BizObjectManager bm=JBOFactory.getFactory().getManager("jbo.app.BILL_INFO");
		BizObjectQuery q=bm.createQuery("OBJECTTYPE=:OBJECTTYPE and OBJECTNO=:OBJECTNO")
							.setParameter("OBJECTTYPE", ObjectType)
							.setParameter("OBJECTNO",ObjectNo);
		if(q.getTotalCount()>0){
			return RunJavaMethodAssistant.SUCCESS_MESSAGE;
		}else{
			return RunJavaMethodAssistant.FAIL_MESSAGE;
		}
	}
	
	/**
	 *�Ƿ������Ʊ�ݺŵ�Ʊ����Ϣ 
	 * @throws JBOException 
	 **/
	public String isExistsWithOutBillNo() throws JBOException{
		BizObjectManager bm=JBOFactory.getFactory().getManager("jbo.app.BILL_INFO");
		BizObjectQuery q=bm.createQuery("OBJECTTYPE=:OBJECTTYPE and OBJECTNO=:OBJECTNO and BillNo is null")
							.setParameter("OBJECTTYPE", ObjectType)
							.setParameter("OBJECTNO",ObjectNo);
		if(q.getTotalCount()>0){
			return RunJavaMethodAssistant.SUCCESS_MESSAGE;
		}else{
			return RunJavaMethodAssistant.FAIL_MESSAGE;
		}
	}
	
	/**
	 * У�����гжһ�Ʊ����
	 */
	public String checkBillTerm() throws JBOException{
		BizObjectManager bm=JBOFactory.getFactory().getManager("jbo.app.BILL_INFO");
		BizObjectQuery q=bm.createQuery("select v.months_between(v.to_date(O.MATURITY,'YYYY/MM/DD'),v.to_date(O.WRITEDATE,'YYYY/MM/DD')) as v.months,O.WRITEDATE,O.MATURITY from O where OBJECTTYPE=:OBJECTTYPE and OBJECTNO=:OBJECTNO ")
							.setParameter("OBJECTTYPE", ObjectType)
							.setParameter("OBJECTNO",ObjectNo);
		java.util.List<BizObject> boList = q.getResultList();
		
		BizObjectManager bmBC=JBOFactory.getFactory().getManager("jbo.app.BUSINESS_CONTRACT");
		BizObject boBC = bmBC.createQuery("SerialNo=:SerialNo").setParameter("SerialNo", this.ObjectNo).getSingleResult();
		if(boBC == null)
		{
			return "δȡ����ͬ��Ϣ��";
		}
		
		String sMainMaturity = boBC.getAttribute("MATURITY").getString();
		if(sMainMaturity == null ||"".equals(sMainMaturity))
			return "��ͬ������Ϊ�գ�";
		String sFlag = "true";
		for(BizObject bo: boList)
		{
			double dMonths = bo.getAttribute("months").getDouble();
			String sWRITEDATE = bo.getAttribute("WRITEDATE").getString();
			String sMATURITY = bo.getAttribute("MATURITY").getString();
			if(sMATURITY == null) sMATURITY = "";
			
			if(sMainMaturity.compareTo(sMATURITY) < 0)
			{
				return "Ʊ�ݵ����ղ��ܳ�����ͬ�����գ�";
			}
			
			if(Math.abs(dMonths) > 6.0 )
			{
				return "Ʊ�����޲��ܳ���6���£�";
			}
		}
		return sFlag;
	}
	
	public String checkBillSum() throws JBOException{
		String sObjectType = this.ObjectType;
		String sObjectNo  = this.ObjectNo;
		BizObjectManager bm = com.amarsoft.are.jbo.JBOFactory.getFactory().getManager("jbo.app.BILL_INFO");
    	BizObjectQuery bq=bm.createQuery(" select v.sum(BI.BillSum) as v.DBillSum from jbo.app.BILL_INFO BI where BI.ObjectNo=:ObjectNo and BI.ObjectType=:ObjectType");
		bq.setParameter("ObjectType",sObjectType);
		bq.setParameter("ObjectNo",sObjectNo); 
		BizObject bo = bq.getSingleResult();
		if(bo != null)  
		{
			double dBillSum = bo.getAttribute("DBillSum").getDouble();
			if("CreditApply".equals(sObjectType))
			{
				BizObjectManager bmC = com.amarsoft.are.jbo.JBOFactory.getFactory().getManager("jbo.app.BUSINESS_APPLY");
				BizObject bomc = bmC.createQuery("SerialNo = :SerialNo ").setParameter("SerialNo", sObjectNo).getSingleResult();
				if(bomc!= null)
				{
					double dBusinessSum = bomc.getAttribute("BusinessSum").getDouble();
					
					if(dBusinessSum != dBillSum)
					{
						return "������("+DataConvert.toMoney(dBusinessSum)+")��Ʊ���ܽ��("+DataConvert.toMoney(dBillSum)+")��ƥ�䣬��ȷ�ϣ�";
					}
				}
				
			}
			else if("ApproveApply".equals(sObjectType))
			{
				BizObjectManager bmC = com.amarsoft.are.jbo.JBOFactory.getFactory().getManager("jbo.app.BUSINESS_APPROVE");
				BizObject bomc = bmC.createQuery("SerialNo = :SerialNo ").setParameter("SerialNo", sObjectNo).getSingleResult();
				if(bomc!= null)
				{
					double dBusinessSum = bomc.getAttribute("BusinessSum").getDouble();
					
					if(dBusinessSum != dBillSum)
					{
						return "�������("+DataConvert.toMoney(dBusinessSum)+")��Ʊ���ܽ��("+DataConvert.toMoney(dBillSum)+")��ƥ�䣬��ȷ�ϣ�";
					}
				}
			}
			else if("BusinessContract".equals(sObjectType))
			{
				BizObjectManager bmC = com.amarsoft.are.jbo.JBOFactory.getFactory().getManager("jbo.app.BUSINESS_CONTRACT");
				BizObject bomc = bmC.createQuery("SerialNo = :SerialNo ").setParameter("SerialNo", sObjectNo).getSingleResult();
				if(bomc!= null)
				{
					double dBusinessSum = bomc.getAttribute("BusinessSum").getDouble();
					
					if(dBusinessSum != dBillSum)
					{
						return "��ͬ���("+DataConvert.toMoney(dBusinessSum)+")��Ʊ���ܽ��("+DataConvert.toMoney(dBillSum)+")��ƥ�䣬��ȷ�ϣ�";
					}
				}
			}
			else if("BusinessPutOut".equals(sObjectType))
			{
				BizObjectManager bmC = com.amarsoft.are.jbo.JBOFactory.getFactory().getManager("jbo.app.BUSINESS_PUTOUT");
				BizObject bomc = bmC.createQuery("SerialNo = :SerialNo ").setParameter("SerialNo", sObjectNo).getSingleResult();
				if(bomc!= null)
				{
					double dBusinessSum = bomc.getAttribute("BusinessSum").getDouble();
					
					if(dBusinessSum != dBillSum)
					{
						return "���˽��("+DataConvert.toMoney(dBusinessSum)+")��Ʊ���ܽ��("+DataConvert.toMoney(dBillSum)+")��ƥ�䣬��ȷ�ϣ�";
					}
				}
			}
		}
		
		return "true";
	}
	
	
	public String checkContractSum() throws JBOException{
		String sObjectType = this.ObjectType;
		String sObjectNo  = this.ObjectNo;
		BizObjectManager bm = com.amarsoft.are.jbo.JBOFactory.getFactory().getManager("jbo.app.BUSINESS_CONTRACT");
    	BizObjectQuery bq=bm.createQuery("SerialNo=:SerialNo").setParameter("SerialNo", sObjectNo);
		BizObject bo = bq.getSingleResult();
		if(bo != null)  
		{
			double dBusinessSum = bo.getAttribute("BusinessSum").getDouble();
			String sLmtTreeNodeID = bo.getAttribute("RELATIVETREENODEID").getString();
			BizObjectQuery bqC=bm.createQuery("RELATIVETREENODEID=:RELATIVETREENODEID").setParameter("RELATIVETREENODEID", sLmtTreeNodeID);
			if(bqC.getTotalCount() == 1)
			{
				BizObjectManager bmlmt = com.amarsoft.are.jbo.JBOFactory.getFactory().getManager("jbo.lmt.LMT_TREE_NODE");
		    	BizObjectQuery bqlmt=bmlmt.createQuery("LMTTREENODEID=:LMTTREENODEID").setParameter("LMTTREENODEID", sLmtTreeNodeID);
		    	BizObject bolmt = bqlmt.getSingleResult();
		    	if(bolmt != null)
		    	{
		    		double CURNOMSUM = bolmt.getAttribute("CURNOMSUM").getDouble();
		    		
		    		if(CURNOMSUM != dBusinessSum &&!"02".equals(bo.getAttribute("CalculateMode").getString()))
		    		{
		    			return "��ͬ��"+DataConvert.toMoney(dBusinessSum)+"��������Э���"+DataConvert.toMoney(CURNOMSUM)+"������ȷ�ϣ�";
		    		}
		    	}
			}
			
		}
		
		return "true";
	}

	public String getCnapsID() {
		return cnapsID;
	}

	public void setCnapsID(String cnapsID) {
		this.cnapsID = cnapsID;
	}
	
	
	
	public String checkCnapsID(Transaction Sqlca) throws Exception{
		String sReturn = "false";
		
		String sACCEPTOR = Sqlca.getString("select BankName from EIS_INFO where CNAPSID = '"+this.cnapsID+"' ");
		if(sACCEPTOR == null || "".equals(sACCEPTOR))
		{
			sReturn = "false@�к�δ�ҵ�����ȷ�ϣ�";
		}
		else
		{
			String sACCEPTORSAMPLE = this.cnapsID.substring(0,3);
			String sACCEPTORCITY = this.cnapsID.substring(3,7);
			String sACCEPTORPROVINCEID = Sqlca.getString("select SortNo from CODE_LIBRARY where CodeNo = 'BankCity' and ItemNo = '"+sACCEPTORCITY+"'");
			String sACCEPTORCITYNAME = Sqlca.getString("select ItemName from CODE_LIBRARY where CodeNo = 'BankCity' and ItemNo = '"+sACCEPTORCITY+"'");
			sReturn = "true@"+sACCEPTORSAMPLE+"@"+sACCEPTORCITY+"@"+sACCEPTORCITYNAME+"@"+sACCEPTORPROVINCEID+"@"+sACCEPTOR;
		}
		
		return sReturn;
	}
	
	/**
	 *����Ʊ����ʼ�գ���У�鵽�����Ƿ����ڵ�ǰ�� 
	 * @throws JBOException 
	 */
	public String updateWriteDate(JBOTransaction tx) throws JBOException{
		String sReturn=RunJavaMethodAssistant.SUCCESS_MESSAGE;
		//�Ƿ���ڵ��������ڵ�ǰ��
		BizObjectManager bm=JBOFactory.getFactory().getManager("jbo.app.BILL_INFO");
		int count=bm.createQuery("OBJECTTYPE=:OBJECTTYPE and OBJECTNO=:OBJECTNO and MATURITY<:MATURITY")
			.setParameter("OBJECTTYPE", ObjectType)
			.setParameter("OBJECTNO",ObjectNo)
			.setParameter("MATURITY", StringFunction.getToday()).getTotalCount();
		if(count>0){
			sReturn="���ڵ��������ڵ�ǰ�յ�Ʊ��!";
		}else{
			BizObjectQuery bq=bm.createQuery("update O set WRITEDATE=:WRITEDATE where OBJECTTYPE=:OBJECTTYPE and OBJECTNO=:OBJECTNO")
								.setParameter("WRITEDATE", StringFunction.getToday())
								.setParameter("OBJECTTYPE", ObjectType)
								.setParameter("OBJECTNO",ObjectNo);
			bq.executeUpdate();
		}
		return sReturn;
	}
}
