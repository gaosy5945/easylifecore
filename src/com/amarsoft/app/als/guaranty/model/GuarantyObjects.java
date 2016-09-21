package com.amarsoft.app.als.guaranty.model;

import java.sql.Connection;
import java.sql.SQLException;
import java.util.List;

import com.amarsoft.app.base.businessobject.BusinessObject;
import com.amarsoft.app.als.cl.CreditObject;


public class GuarantyObjects extends CreditObject {

	protected List<BusinessObject> arObjects = null; //����ռ����߶���Ľ��
	protected List<BusinessObject> crObjects1 = null; //��ͬռ����߶���Ľ��
	protected List<BusinessObject> grObjects = null;
	
	protected String curSerialNo="";//��ǰҵ�������ţ��ټ���ʱ�ų�����
	
	protected double amount = 0.0d; //�ܽ��
	protected double useAmount = 0.0d; //ҵ��ռ�õ����Ľ��
	protected double grAmount = 0.0d; //ѺƷ������ծȨ֮��
	
	public void setCurSerialNo(String curSerialNo) {
		this.curSerialNo = curSerialNo;
	}
	
	public double getAmount() {
		return amount;
	}

	public double getUseAmount() {
		return useAmount;
	}

	public double getGrAmount() {
		return grAmount;
	}

	public void load(Connection conn,String ObjectType,String ObjectNo) throws SQLException,Exception
	{
		if(curSerialNo == null || "".equals(curSerialNo)) curSerialNo = " ";
		String[] paras = new String[]{ObjectNo};
		String[] paras1 = new String[]{ObjectNo,curSerialNo};
		
		//���ø���߶��������
		String sql = "select sum(nvl(AR.RelativeAmount,0)) as RelativeAmount from APPLY_RELATIVE AR,BUSINESS_APPLY BA where AR.ObjectType='jbo.guaranty.GUARANTY_CONTRACT' and AR.ObjectNo=? and AR.RelativeType='05' and BA.SerialNo=AR.ApplySerialNo and BA.ApproveStatus in ('01','02') and AR.SerialNo <> ?";
		this.arObjects = this.loadDB(conn, sql, paras1);
		
		//���ø���߶���ĺ�ͬ
		sql = "select sum(nvl(CR.RelativeAmount,0)) as RelativeAmount from CONTRACT_RELATIVE CR,BUSINESS_CONTRACT BC where CR.ObjectType='jbo.guaranty.GUARANTY_CONTRACT' and CR.ObjectNo=? and CR.RelativeType='05' and BC.SerialNo=CR.ContractSerialNo and BC.ContractStatus in ('01','02','03')";
		this.crObjects1 = this.loadDB(conn, sql, paras);
		
		//ѺƷ������ծȨ֮��
		sql = "select sum(nvl(GuarantyAmount,0)) as GuarantyAmount from GUARANTY_RELATIVE where GCSerialNo=? and (Status is null or Status<>'06') ";
		this.grObjects = this.loadDB(conn, sql, paras);
		
		sql = "select SerialNo,GuarantyType,GuarantyValue,ContractNo from GUARANTY_CONTRACT where SerialNo = ?";
		List<BusinessObject> cos = this.loadDB(conn, sql, paras);
		if(cos != null && !cos.isEmpty())
			this.CreditObject = this.loadDB(conn, sql, paras).get(0);
		else
			this.CreditObject = BusinessObject.createBusinessObject();
	}
	

	public double calcBalance() throws Exception {
		double arAmount = this.arObjects.get(0).getDouble("RelativeAmount");
		double crAmount1 = this.crObjects1.get(0).getDouble("RelativeAmount");
		amount = this.CreditObject.getDouble("GuarantyValue");
		grAmount = this.grObjects.get(0).getDouble("GuarantyAmount");
		String guarantyType = this.CreditObject.getString("GuarantyType");
		this.useAmount = arAmount + crAmount1;
		
		//ռ�ý��ô��ڵ�����ծȨ֮��
		if(this.amount < this.useAmount)
		{
			this.RiskMessage.add("��߶����ͬ"+this.CreditObject.getString("ContractNo")+"���������õĽ���ѳ���������ͬ�ܽ�");
		}
		
		if(guarantyType != null && (guarantyType.startsWith("020") || guarantyType.startsWith("040")) && grAmount < useAmount)
		{
			this.RiskMessage.add("��߶����ͬ"+this.CreditObject.getString("ContractNo")+"���������õĽ���ѳ���ѺƷ������ծȨ��");
		}
		return Math.max(amount - useAmount,0d);
	}

	public void saveData(Connection conn) throws Exception{

	}

	public void load(BusinessObject creditObject) throws SQLException,
			Exception {
		
	}
}
