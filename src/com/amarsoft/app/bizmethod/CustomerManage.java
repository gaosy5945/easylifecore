package com.amarsoft.app.bizmethod;

import java.util.HashMap;
import java.util.List;

import com.amarsoft.are.jbo.BizObject;
import com.amarsoft.are.jbo.BizObjectManager;
import com.amarsoft.are.jbo.BizObjectQuery;
import com.amarsoft.are.jbo.JBOFactory;
import com.amarsoft.are.jbo.JBOTransaction;

/*
 * author �����Ŷ�
 * description ��Դ��Class_Method---className='CustomerManage' ;
 * ��;������һ�������࣬��������������Ƕ����˲�ͬ�ķ�����ÿһ����������������Class_Method
 * */
public class CustomerManage {
	private String paras;//������
	private String splitStr;//�ָ�������:Ĭ��ֵ@~@
	private String paraSplit;//������ֵ�ķָ���Ĭ��ֵ@@
	public String getParas() {
		return paras;
	}
	public void setParas(String paras) {
		this.paras = paras;
	}
	public String getSplitStr() {
		return splitStr;
	}
	public void setSplitStr(String splitStr) {
		this.splitStr = splitStr;
	}
	public String getParaSplit() {
		return paraSplit;
	}
	public void setParaSplit(String paraSplit) {
		this.paraSplit = paraSplit;
	}
	
	/*CalculateStock ����ɶ��Ĺɷݺϼƣ�����ǰ�ɶ���
	 * */
	public String calculateStock(JBOTransaction tx)throws Exception{
		BizObjectManager bom = JBOFactory.getBizObjectManager("jbo.customer.CUSTOMER_RELATIVE");
		tx.join(bom);
		String sql = "select sum(InvestmentProp) as v.sum from O where CustomerID =:CustomerID and RelativeID <> :RelativeID and RelationShip like '52%'";
		HashMap<String,String> map = ParseAttirbutesTool.parseParas(paras, splitStr, paraSplit);
		if(map==null) return null;
		BizObjectQuery boq = bom.createQuery(sql)
				.setParameter("CustomerID", map.get("customerID"))
				.setParameter("RelativeID", map.get("relativeID"));
		if(boq==null) throw new Exception("��ѯ��CUSTOMER_RELATIVE���������¼�飡");
		String returnValue = boq.getSingleResult(false).getAttribute("sum").getString();
		return returnValue;
	}
	/*
	 * calculateInvestStock ������Ͷ�ʹɶ��Ĺɷݺϼ�
	 * */
	public String calculateInvestStock(JBOTransaction tx)throws Exception{
		BizObjectManager bom = JBOFactory.getBizObjectManager("jbo.customer.CUSTOMER_RELATIVE");
		tx.join(bom);
		HashMap<String,String> map = ParseAttirbutesTool.parseParas(paras, splitStr, paraSplit);
		if(map==null) return null;
		String sql = "select sum(InvestmentProp)  as v.sum from O where CustomerID =:CustomerID and RelativeID =:RelativeID and RelationShip like '02%' ";
		BizObjectQuery boq = bom.createQuery(sql)
				.setParameter("CustomerID", map.get("customerID"))
				.setParameter("RelativeID", map.get("relativeID"));
		if(boq==null) throw new Exception("��ѯ��CUSTOMER_RELATIVE���������¼�飡");
		String returnValue = boq.getSingleResult(false).getAttribute("sum").getString();
		return returnValue;
	}
	
	/*��⵱ǰ�·ݲ��񱨱��Ƿ��Ѵ���
	 * 
	 * */
	public String checkFSRecord(JBOTransaction tx)throws Exception{
		BizObjectManager bom = JBOFactory.getBizObjectManager("jbo.customer.CUSTOMER_FSRECORD");
		tx.join(bom);
		String sql = "Select count(RecordNo)  as v.num from O where CustomerID=:CustomerID and ReportDate=:ReportDate and RecordNo <> :RecordNo";
		HashMap<String, String> map = ParseAttirbutesTool.parseParas(paras, splitStr, paraSplit);
		BizObjectQuery boq = bom.createQuery(sql)
				.setParameter("CustomerID", map.get("customerID"))
				.setParameter("ReportDate", map.get("reportDate"))
				.setParameter("RecordNo", map.get("recordNo"));
		String returnValue = boq.getSingleResult(false).getAttribute("num").getString();
		return returnValue;
	}
	
	/*
	 * �����񱨱�״̬��־λString CustomerID,String ReportDate,String ReportScope
	 * 
	 * */
	public String checkFSStatus(JBOTransaction tx)throws Exception {
		BizObjectManager bom = JBOFactory.getBizObjectManager("jbo.customer.CUSTOMER_FSRECORD");
		tx.join(bom);
		HashMap<String, String> map = ParseAttirbutesTool.parseParas(paras, splitStr, paraSplit);
		String sql = "select ReportStatus from O where CustomerID=:CustomerID and ReportDate=:ReportDate  and ReportScope=:ReportScope";
		BizObjectQuery boq = bom.createQuery(sql)
				.setParameter("CustomerID", map.get("customerID"))
				.setParameter("ReportDate", map.get("reportDate"))
				.setParameter("ReportScope", map.get("reportScope"));
		@SuppressWarnings("unchecked")
		List<BizObject> bos = boq.getResultList(false);
		String reportStatus=null;
		if(bos!=null){
			BizObject bo = bos.get(0);
			reportStatus = bo.getAttribute("ReportStatus").getString();
		}
		return reportStatus;
	}
	
}
