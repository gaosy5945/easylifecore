/*
 *	Author: jgao1 2009-10-26
 *	Tester:
 *	Describe: ��鼯�����Ŷ�ȷ����м��ų�Ա���������޶��Ƿ���������ܶ�
 *		                ����Ƿ��ѷ���ü��ų�Ա�ļ������Ŷ�ȣ�ĿǰALS6.5�Լ��ų�Ա����ҵ��Ʒ�ֲ�������
 *	Input Param:
 *			LineSum1:���ų�Ա �����޶�
 *			ParentLineID:���������ܶ�LineID
 *			LineID:��ǰ���ų�Ա���ID
 *			Currency:��ǰ���ų�Ա��ȱ���
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
	 	//��ü��������ܶ��LineID
		String sParentLineID = this.parentLineID;
	 	if(sParentLineID == null) sParentLineID = "";
	 	//��ü��ų�Ա��ȵ�LineID
	 	String sLineID = this.lineID;
	 	if(sLineID == null) sParentLineID = "";
	 	//���ų�Ա�ͻ�ID
	 	String sCustomerID = this.customerID;
	 	if(sCustomerID == null) sCustomerID = "";
	 	//��ü��ų�Ա��ȱ���
	 	String sCurrency = this.currency;
	 	if(sCurrency == null) sCurrency = "";
		//��õ�ǰ����ļ��ų�Ա��������޶�
		String sLineSum1 = this.lineSum1;
		if(sLineSum1==null||sLineSum1.equals("")) sLineSum1 = "0";
		//���ѵ�Ȼ�����޶��String��ת��Ϊdouble�ͣ���ǰ�����޶����ΪdSubLineSum1
		double dSubLineSum1 = DataConvert.toDouble(sLineSum1);
		//���ų�Ա�������
		int iCount=0;
		//���ų�Ա��ȱ���ת�����Ŷ�ȱ��ֺ����ֵ
		double dERateValue=0;
		//��ǰ����ļ��ų�Ա�����޶���ڼ��������ܶ�ı�־��1.false��ʾ����;2.true��ʾ����.
		boolean flag1 = false;
		//����ֵ��־��1."00":��ʾ������
		//		     2."10"����ʾ�����޶���������ܶ
		//           3."99":�ѷ���ü��ų�Ա���
		String flag3 = "00";
		
		String sSql = "";
		ASResultSet rs = null;
		
		//���������ܶ�dLineSum
		double dLineSum = 0;
		//��CL_INFO����ȡ�����������ܶ�
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
		//�޴˱�
		/*//ĿǰALS6.5ֻ���ƿͻ�ID�Ƿ��ظ�������businessType���п��ƣ��������Ҫ�������и�����
		sSql = "select count(*) from GLINE_INFO where ParentLineID = :ParentLineID and LineID <> :LineID and CustomerID=:CustomerID";
		rs = Sqlca.getASResultSet(new SqlObject(sSql).setParameter("ParentLineID", sParentLineID).setParameter("LineID", sLineID).setParameter("CustomerID", sCustomerID));
		if(rs.next()){
			iCount = rs.getInt(1);
		}
		rs.getStatement().close();
		if(iCount>0) flag3 = "99";//��ʾ���ų�Ա�Ѵ��ڷ�����Ӷ��
		//�Լ��������޶���л��ʿ���	
		dSubLineSum1=dSubLineSum1*dERateValue;
		//��������޶���������ܶ�򳬶�
		if(dSubLineSum1 > dLineSum) flag1 = true;
		
		//����������Ŷ����û��Ϊ�ó�Ա������
		if(!"99".equals(flag3)){
			//��������޶���������ܶ�
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
