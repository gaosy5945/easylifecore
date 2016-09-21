package com.amarsoft.app.lending.bizlets;

import java.sql.PreparedStatement;
import java.sql.SQLException;

import com.amarsoft.app.bizmethod.BizSort;
import com.amarsoft.app.bizobject.BusinessApply;
import com.amarsoft.awe.util.Transaction;
import com.amarsoft.biz.bizlet.Bizlet;


/**
 * Author: qfang 2011-06-09
 * Tester:
 * Describe: --��������,��BUSINESS_APPLY��������
 * Input Param:
 * Output Param:
 * HistoryLog:
 * 
 * 
 * 
 */
public class AddBusinessApply extends Bizlet{
	public Object run(Transaction Sqlca) throws Exception{
		//��ȡBizSort������Ĳ���
		String objectType = (String)this.getAttribute("ObjectType");
		String serialNo = (String)this.getAttribute("SerialNo");
		//��ȡsql�������
		String inputUserID = (String)this.getAttribute("InputUserID");
		String businessType = (String)this.getAttribute("BusinessType");
		String inputDate = (String)this.getAttribute("InputDate");
		String customerName = (String)this.getAttribute("CustomerName");
		String inputOrgID = (String)this.getAttribute("InputOrgID");
		String applyType = (String)this.getAttribute("ApplyType");
		//String direction = (String)this.getAttribute("Direction");
		String contractFlag = (String)this.getAttribute("ContractFlag");
		String customerID = (String)this.getAttribute("CustomerID");
		String occurType = (String)this.getAttribute("OccurType");
		String operateType = (String)this.getAttribute("OperateType");
		String isHostBank = (String)this.getAttribute("IsHostBank");
		String sql = "";
		
		if(objectType == null) objectType = "";
		if(serialNo == null) serialNo = "";
		if(inputUserID == null) inputUserID = "";
		if(businessType == null) businessType = "";
		if(inputDate == null) inputDate = "";
		if(customerName == null) customerName = "";
		if(inputOrgID == null) inputOrgID = "";
		if(applyType == null) applyType = "";
		//if(direction == null) direction = "";
		if(contractFlag == null) contractFlag = "";
		if(customerID == null) customerID = "";
		if(occurType == null) occurType = "";
		if(operateType == null) operateType = "";
		if(isHostBank == null) isHostBank = "";
		
		//��ȡ�����¹����ò�Ʒ��������־λ
		BizSort bs = new BizSort(Sqlca,objectType,serialNo,"",businessType);
		String liquidityFlag = (bs.isLiquidity()==true ? "1":"2");
		String fixedFlag = (bs.isFixed()==true ? "1":"2");
		String projectFlag = (bs.isProject()==true ? "1":"2");
		
		sql = "insert into BUSINESS_APPLY(" +
											"CreditAggreement," +
											"InputUserID," +
											"BusinessType," +
											"IsLiquidity," +
											"IsFixed," +
											"IsProject," +
											"OperateUserID," +
											"UpdateDate," +
											"Flag5," +
											"CustomerName," +
											"OccurDate," +
											"InputOrgID," +
											"SerialNo," +
											"ApplyType," +
											//"Direction," +
											"InputDate," +
											"ContractFlag," +
											"CustomerID," +
											"OperateDate," +
											"TempSaveFlag," +
											"OccurType," +
											"OperateOrgID,"+
											"OperateType,"+
											"IsHostBank,"+
											"CycleFlag,"+
											"CreditCycle,"+
											"OtherAreaLoan,"+
											"RateFloatType,"+
											"FRCode,"+
											"IPCode "+
											")" +
															"values(?,?,?,?,?,?,?,?,?,?,?," +
																	"?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?)";
		 PreparedStatement ps = null;
		 try{
			//BUSINESS_APPLY��PreparedStatement��ֵ
			 ps = Sqlca.getConnection().prepareStatement(sql);	

			 ps.setString(1, "");
			 ps.setString(2, inputUserID);
			 ps.setString(3, businessType);
			 ps.setString(4, liquidityFlag);
			 ps.setString(5, fixedFlag);
			 ps.setString(6, projectFlag);
			 ps.setString(7, inputUserID);
			 ps.setString(8, inputDate);
			 ps.setString(9, BusinessApply.PHASEFLAG_NEWAPPLY);
			 ps.setString(10, customerName);
			 ps.setString(11,inputDate);
			 ps.setString(12, inputOrgID);
			 ps.setString(13, serialNo);
			 ps.setString(14, applyType);
			// ps.setString(15, direction);
			 ps.setString(15, inputDate);
			 ps.setString(16, contractFlag);
			 ps.setString(17, customerID);
			 ps.setString(18, inputDate);
			 ps.setString(19, BusinessApply.TEMPSAVE_YES);
			 ps.setString(20, occurType);
			 ps.setString(21, inputOrgID);
			 ps.setString(22, operateType);
			 ps.setString(23, isHostBank);
		     ps.setString(24, BusinessApply.CYCLEFLAG_NO);
			 ps.setString(25, BusinessApply.CREDITCYCLE_NO);
			 
			 ps.setString(26, BusinessApply.OTHERAREALOAN_NO);
			 ps.setString(27, BusinessApply.RATEFLOATTYPE_YES);
			 ps.setString(28, BusinessApply.FRCODE_NO);
			 ps.setString(29, BusinessApply.IPCODE_NO);
		 
			 ps.executeUpdate();//�������
			 ps.close();
			 ps = null;
		 }catch (SQLException e) {
				if (ps != null)
					ps.close();
				e.printStackTrace();
			}		
		return "SUCCESS";	
	}
}