package com.amarsoft.app.bizmethod;

import java.util.HashMap;
import java.util.List;

import com.amarsoft.are.jbo.BizObject;
import com.amarsoft.are.jbo.BizObjectManager;
import com.amarsoft.are.jbo.BizObjectQuery;
import com.amarsoft.are.jbo.JBOFactory;
import com.amarsoft.are.jbo.JBOTransaction;

/*
 * author 核算团队
 * description 来源于Class_Method---className='CustomerManage' ;
 * 用途：这是一个公用类，在这个类里面我们定义了不同的方法，每一个方法都是来自于Class_Method
 * */
public class CustomerManage {
	private String paras;//参数串
	private String splitStr;//分隔符参数:默认值@~@
	private String paraSplit;//参数与值的分隔：默认值@@
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
	
	/*CalculateStock 计算股东的股份合计（除当前股东）
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
		if(boq==null) throw new Exception("查询表CUSTOMER_RELATIVE错误，请重新检查！");
		String returnValue = boq.getSingleResult(false).getAttribute("sum").getString();
		return returnValue;
	}
	/*
	 * calculateInvestStock 计算所投资股东的股份合计
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
		if(boq==null) throw new Exception("查询表CUSTOMER_RELATIVE错误，请重新检查！");
		String returnValue = boq.getSingleResult(false).getAttribute("sum").getString();
		return returnValue;
	}
	
	/*检测当前月份财务报表是否已存在
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
	 * 检测财务报表状态标志位String CustomerID,String ReportDate,String ReportScope
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
