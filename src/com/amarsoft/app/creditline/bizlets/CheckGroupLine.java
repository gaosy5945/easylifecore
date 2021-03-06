/*
 *	Author: jgao1 2009-10-26
 *	Tester:
 *	Describe: 检查集团授信额度分配中集团成员单笔授信限额是否大于授信总额
 *		                检查是否已分配该集团成员的集团授信额度，目前ALS6.5对集团成员授信业务品种不做控制
 *	Input Param:
 *			LineSum1:集团成员 授信限额
 *			ParentLineID:集团授信总额LineID
 *			LineID:当前集团成员额度ID
 *			Currency:当前集团成员额度币种
 *	Output Param:
 *	HistoryLog:
 *
 */

package com.amarsoft.app.creditline.bizlets;

import java.util.List;

import com.amarsoft.are.jbo.BizObject;
import com.amarsoft.are.jbo.BizObjectQuery;
import com.amarsoft.are.jbo.JBOFactory;
import com.amarsoft.are.jbo.JBOTransaction;
import com.amarsoft.are.util.DataConvert;
import com.amarsoft.awe.util.ASResultSet;
import com.amarsoft.awe.util.SqlObject;
import com.amarsoft.awe.util.Transaction;
import com.amarsoft.biz.bizlet.Bizlet;

public class CheckGroupLine {

	private String parentLineID = null;
	private String lineID = null;
	private String currency = null;
	private String customerID = null;
	private String lineSum1=null;
	public Object  checkGroupLine(JBOTransaction tx) throws Exception{
	 	//获得集团授信总额的LineID
		String sParentLineID = this.parentLineID;
	 	if(sParentLineID == null) sParentLineID = "";
	 	//获得集团成员额度的LineID
	 	String sLineID = this.lineID;
	 	if(sLineID == null) sParentLineID = "";
	 	//集团成员客户ID
	 	String sCustomerID = this.customerID;
	 	if(sCustomerID == null) sCustomerID = "";
	 	//获得集团成员额度币种
	 	String sCurrency = this.currency;
	 	if(sCurrency == null) sCurrency = "";
		//获得当前输入的集团成员额度授信限额
		String sLineSum1 = this.lineSum1;
		if(sLineSum1==null||sLineSum1.equals("")) sLineSum1 = "0";
		//并把当然授信限额从String型转化为double型，当前授信限额变量为dSubLineSum1
		double dSubLineSum1 = DataConvert.toDouble(sLineSum1);
		//集团成员额度数量
		int iCount=0;
		//集团成员额度币种转成授信额度币种后汇率值
		double dERateValue=0;
		//当前输入的集团成员授信限额大于集团授信总额的标志：1.false表示正常;2.true表示超额.
		boolean flag1 = false;
		//返回值标志：1."00":表示正常；
		//		     2."10"：表示授信限额大于授信总额；
		//           3."99":已分配该集团成员额度
		String flag3 = "00";
		
		String sSql = "";
		ASResultSet rs = null;
		
		//集团授信总额dLineSum
		double dLineSum = 0;
		//在CL_INFO表中取到集团授信总额
		BizObjectQuery query = JBOFactory.getBizObjectManager("jbo.cl.CL_INFO", tx)
		.createQuery(" select LineSum1 as v.LineSum1,getERate1('"+sCurrency+"',Currency) as v.ERateValue as ERateValue from O where LineID=:LineID")
		.setParameter("LineID", sParentLineID);
		@SuppressWarnings("unchecked")
		List<BizObject> bos = query.getResultList(false);
 
		if(bos!=null && bos.size()>0)
		{
			dLineSum = Double.parseDouble(bos.get(0).getAttribute("LineSum1").toString());
			dERateValue = Double.parseDouble(bos.get(0).getAttribute("ERateValue").toString());
		}
		rs.getStatement().close();
		//无此表
		/*//目前ALS6.5只控制客户ID是否重复，不对businessType进行控制，如果有需要，请自行更正！
		sSql = "select count(*) from GLINE_INFO where ParentLineID = :ParentLineID and LineID <> :LineID and CustomerID=:CustomerID";
		rs = Sqlca.getASResultSet(new SqlObject(sSql).setParameter("ParentLineID", sParentLineID).setParameter("LineID", sLineID).setParameter("CustomerID", sCustomerID));
		if(rs.next()){
			iCount = rs.getInt(1);
		}
		rs.getStatement().close();
		if(iCount>0) flag3 = "99";//表示集团成员已存在分配的子额度
		//对集团授信限额进行汇率控制	
		dSubLineSum1=dSubLineSum1*dERateValue;
		//如果授信限额大于授信总额，则超额
		if(dSubLineSum1 > dLineSum) flag1 = true;
		
		//如果集团授信额度中没有为该成员分配额度
		if(!"99".equals(flag3)){
			//如果授信限额大于授信总额
			if(flag1 == true){
				flag3 = "10";
			}
		}*/
		return flag3;	    
	}
	public String getParentLineID() {
		return parentLineID;
	}
	public void setParentLineID(String parentLineID) {
		this.parentLineID = parentLineID;
	}
	public String getLineID() {
		return lineID;
	}
	public void setLineID(String lineID) {
		this.lineID = lineID;
	}
	public String getCurrency() {
		return currency;
	}
	public void setCurrency(String currency) {
		this.currency = currency;
	}
	public String getCustomerID() {
		return customerID;
	}
	public void setCustomerID(String customerID) {
		this.customerID = customerID;
	}
	public String getLineSum1() {
		return lineSum1;
	}
	public void setLineSum1(String lineSum1) {
		this.lineSum1 = lineSum1;
	}
}
